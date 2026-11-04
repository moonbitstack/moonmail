// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// What a message carries after its header: content with the transfer
/// encoding taken off, the parts of a multipart body (their boundary is in
/// `Content-Type`), or a whole message attached as `message/rfc822`.
#derive(Eq, Debug)
pub(all) enum Body {
  Leaf(Bytes)
  Multipart(Array[Message])
  Embedded(Message)
}

///|
pub extend Body with Eq::{equal, not_equal}

///|
pub extend Body with Debug::{to_repr}

///|
/// A message, or one part of a multipart body: parts are messages too, as in
/// Python's `email`.
#derive(Eq, Debug)
pub(all) struct Message {
  headers : Headers
  body : Body
}

///|
pub extend Message with Eq::{equal, not_equal}

///|
pub extend Message with Debug::{to_repr}

///|
/// Read a message (RFC 5322, MIME as RFC 2045 and RFC 2046 lay it out): the
/// header unfolded, the body split into parts by its boundary and each leaf's
/// transfer encoding taken off. Line ends may be CRLF or LF.
///
/// What a careful reader tolerates is tolerated: a line in the header that is
/// not a field ends the header there, a missing closing boundary ends the
/// last part at the end, an unknown or broken transfer encoding leaves the
/// octets as they came. `strict` refuses each of these instead.
pub fn Message::parse(
  data : BytesView,
  strict~ : Bool = false,
) -> Message raise Refused {
  read(data, 0, strict, false)
}

///|
fn read(
  data : BytesView,
  base : Int32,
  strict : Bool,
  digest : Bool,
) -> Message raise Refused {
  let (headers, start) = read_headers(data, base, strict)
  let body = read_body(headers, data[start:], base + start, strict, digest)
  { headers, body, }
}

///|
/// The header fields, and where the body starts.
fn read_headers(
  data : BytesView,
  base : Int32,
  strict : Bool,
) -> (Headers, Int32) raise Refused {
  let fields : Array[(String, String)] = []
  let mut at = 0
  // An mbox `From ` line in front of the header is not a field.
  if data.length() >= 5 && data[0:5] == b"From "[:] {
    at = line_end(data, 0)
  }
  while at < data.length() {
    let end = line_end(data, at)
    let line = trim_eol(data[at:end])
    if line.length() == 0 {
      return ({ fields, }, end)
    }
    if (line[0] == b' ' || line[0] == b'\t') && fields.length() > 0 {
      let last = fields.length() - 1
      fields[last] = (fields[last].0, fields[last].1 + @utf8.decode_lossy(line))
      at = end
      continue
    }
    let text = @utf8.decode_lossy(line)
    match text.find(":") {
      Some(colon) if colon > 0 &&
        text[:colon]
        .trim_end()
        .iter()
        .all(c => c.to_int() > 32 && c.to_int() < 127) => {
        let name = text[:colon].trim_end().to_owned()
        let value = text[colon + 1:].trim_start(chars=" \t").to_owned()
        fields.push((name, value))
      }
      _ => {
        if strict {
          raise Header(at=base + at)
        }
        return ({ fields, }, at)
      }
    }
    at = end
  }
  ({ fields, }, data.length())
}

///|
fn read_body(
  headers : Headers,
  data : BytesView,
  base : Int32,
  strict : Bool,
  digest : Bool,
) -> Body raise Refused {
  let kind = type_of(headers, digest)
  match kind.type_() {
    "multipart" => {
      guard kind.param("boundary") is Some(boundary) && !boundary.is_empty() else {
        if strict {
          raise Boundary(at=base)
        }
        return Leaf(data.to_owned())
      }
      guard split(data, boundary, base, strict) is Some(parts) else {
        return Leaf(data.to_owned())
      }
      let digest = kind.subtype() == "digest"
      Multipart(parts.map(p => read(p.0, p.1, strict, digest)))
    }
    "message" if kind.subtype() is ("rfc822" | "global") => {
      let inner = transfer_decode(headers, data, base, strict)
      Embedded(read(inner[:], base, strict, false))
    }
    _ => Leaf(transfer_decode(headers, data, base, strict))
  }
}

///|
/// The parts between the delimiters of `boundary`, each with its offset; the
/// line break before a delimiter belongs to the delimiter (RFC 2046 section
/// 5.1.1). `None` when no delimiter is there at all.
fn split(
  data : BytesView,
  boundary : String,
  base : Int32,
  strict : Bool,
) -> Array[(BytesView, Int32)]? raise Refused {
  let dash = @utf8.encode("--" + boundary)
  let parts = []
  let mut open : Int32? = None
  let mut closed = false
  let mut at = 0
  while at < data.length() {
    let end = line_end(data, at)
    let line = trim_eol(data[at:end])
    if line.length() >= dash.length() && line[:dash.length()] == dash[:] {
      let tail = line[dash.length():]
      let close = tail.length() >= 2 && tail[0] == b'-' && tail[1] == b'-'
      let padding = tail.iter().all(b => b == b' ' || b == b'\t')
      if close || padding {
        if open is Some(start) {
          let stop = before_eol(data, at)
          parts.push(
            (data[start:if stop < start { start } else { stop }], base + start),
          )
        }
        if close {
          closed = true
          break
        }
        open = Some(end)
      }
    }
    at = end
  }
  if open is None {
    if strict {
      raise Boundary(at=base)
    }
    return None
  }
  if !closed {
    if strict {
      raise Boundary(at=base + data.length())
    }
    if open is Some(start) {
      parts.push((data[start:], base + start))
    }
  }
  Some(parts)
}

///|
/// The content of a leaf with its `Content-Transfer-Encoding` taken off.
fn transfer_decode(
  headers : Headers,
  data : BytesView,
  base : Int32,
  strict : Bool,
) -> Bytes raise Refused {
  match encoding_of(headers) {
    Some("base64") =>
      if strict {
        let text = @utf8.decode_lossy(data)
          .iter()
          .filter(c => !c.is_whitespace())
          .collect()
        @base64.decode(String::from_array(text)[:]) catch {
          _ => raise Encoding(at=base)
        }
      } else {
        @base64.decode_lossy(@utf8.decode_lossy(data)[:])
      }
    Some("quoted-printable") =>
      @qp.decode(data, strict~) catch {
        _ => raise Encoding(at=base)
      }
    None | Some("7bit" | "8bit" | "binary") => data.to_owned()
    Some(_) => {
      if strict {
        raise Encoding(at=base)
      }
      data.to_owned()
    }
  }
}

///|
/// The media type, or RFC 2045's default: `text/plain; charset=us-ascii`, or
/// `message/rfc822` inside a digest (RFC 2046 section 5.1.5).
fn type_of(headers : Headers, digest : Bool) -> @moonmime.MediaType {
  match headers.get("Content-Type") {
    Some(value) if value.contains("/") => @moonmime.media_type(value)
    _ =>
      if digest {
        { essence: "message/rfc822", params: [], }
      } else {
        { essence: "text/plain", params: [("charset", "us-ascii")], }
      }
  }
}

///|
fn encoding_of(headers : Headers) -> String? {
  headers
  .get("Content-Transfer-Encoding")
  .map(v => v.trim().to_lower().to_owned())
}

///|
/// The media type, with RFC 2045's default when the field is missing.
pub fn Message::content_type(self : Message) -> @moonmime.MediaType {
  type_of(self.headers, false)
}

///|
/// The subject, encoded words decoded.
pub fn Message::subject(self : Message) -> String? {
  self.headers.get("Subject").map(v => @moonmime.decode_words(v))
}

///|
/// `Message-ID` as written, angle brackets included.
pub fn Message::message_id(self : Message) -> String? {
  self.headers.get("Message-ID").map(v => v.trim().to_owned())
}

///|
/// The authors in `From`.
pub fn Message::from(self : Message) -> Array[Mailbox] raise Refused {
  self
  .addresses("From")
  .map(a => a.mailboxes())
  .fold(init=[], (all, m) => all + m)
}

///|
pub fn Message::to(self : Message) -> Array[Address] raise Refused {
  self.addresses("To")
}

///|
pub fn Message::cc(self : Message) -> Array[Address] raise Refused {
  self.addresses("Cc")
}

///|
pub fn Message::bcc(self : Message) -> Array[Address] raise Refused {
  self.addresses("Bcc")
}

///|
pub fn Message::reply_to(self : Message) -> Array[Address] raise Refused {
  self.addresses("Reply-To")
}

///|
/// Every address of every field named `name`.
pub fn Message::addresses(
  self : Message,
  name : StringView,
) -> Array[Address] raise Refused {
  let out = []
  for value in self.headers.all(name) {
    out.append(parse_addresses(value))
  }
  out
}

///|
/// `Date`, read as RFC 5322 writes it.
pub fn Message::date(self : Message) -> @moondate.Moment? raise Refused {
  match self.headers.get("Date") {
    Some(value) => Some(parse_date(value))
    None => None
  }
}

///|
/// The plain text body: the `text/plain` leaf a reader would show, preferring
/// the last of an alternative, decoded by its charset. UTF-8, US-ASCII and
/// ISO-8859-1 are built in; others come in `charsets`.
pub fn Message::text(
  self : Message,
  charsets? : Map[String, &@moonmime.Charset],
) -> String? raise Refused {
  self.body_text("plain", charsets)
}

///|
/// The HTML body, chosen and decoded as `text` chooses and decodes.
pub fn Message::html(
  self : Message,
  charsets? : Map[String, &@moonmime.Charset],
) -> String? raise Refused {
  self.body_text("html", charsets)
}

///|
fn Message::body_text(
  self : Message,
  subtype : String,
  charsets : Map[String, &@moonmime.Charset]?,
) -> String? raise Refused {
  guard find_body(self, subtype) is Some(part) else { return None }
  guard part.body is Leaf(data) else { return None }
  let charset = part.content_type().param("charset").unwrap_or("us-ascii")
  Some(
    @moonmime.decode_charset(name=charset, data=data[:], charsets?) catch {
      _ => raise Charset(name=charset)
    },
  )
}

///|
fn find_body(message : Message, subtype : String) -> Message? {
  let kind = message.content_type()
  match message.body {
    Leaf(_) =>
      if kind.essence == "text/" + subtype && !is_attachment(message) {
        Some(message)
      } else {
        None
      }
    Multipart(parts) =>
      match kind.subtype() {
        "alternative" => {
          for i = parts.length() - 1; i >= 0; i = i - 1 {
            if find_body(parts[i], subtype) is Some(found) {
              return Some(found)
            }
          }
          None
        }
        "related" => parts.get(0).bind(root => find_body(root, subtype))
        _ => {
          for part in parts {
            if find_body(part, subtype) is Some(found) {
              return Some(found)
            }
          }
          None
        }
      }
    Embedded(_) => None
  }
}

///|
fn is_attachment(message : Message) -> Bool {
  match message.headers.get("Content-Disposition") {
    Some(value) =>
      @moonmime.Disposition::parse(value).kind.to_lower() == "attachment"
    None => false
  }
}

///|
/// Every part that is not a body a reader would show: what is marked as an
/// attachment, what sits inline beside an HTML body, an attached message, and
/// any leaf that is not text.
pub fn Message::attachments(self : Message) -> Array[Attachment] {
  let out = []
  if self.body is Multipart(parts) {
    let bodies = [find_body(self, "plain"), find_body(self, "html")]
    for part in parts {
      collect(part, bodies, out)
    }
  } else if is_attachment(self) {
    out.push(attachment_of(self))
  }
  out
}

///|
fn collect(
  part : Message,
  bodies : Array[Message?],
  out : Array[Attachment],
) -> Unit {
  match part.body {
    Multipart(parts) =>
      for p in parts {
        collect(p, bodies, out)
      }
    Embedded(_) => out.push(attachment_of(part))
    Leaf(_) => {
      let chosen = bodies
        .iter()
        .any(b => b is Some(m) && physical_equal(m, part))
      if is_attachment(part) {
        out.push(attachment_of(part))
      } else if !chosen &&
        !(part.content_type().essence is ("text/plain" | "text/html")) {
        out.push(attachment_of(part))
      }
    }
  }
}

///|
fn attachment_of(part : Message) -> Attachment {
  let kind = part.content_type()
  let disposition = part.headers
    .get("Content-Disposition")
    .map(v => @moonmime.Disposition::parse(v))
  let written = match disposition.bind(d => d.filename()) {
    Some(n) => Some(n)
    None => kind.param("name")
  }
  let name = written.map(n => @moonmime.decode_words(n)).unwrap_or("")
  let data = match part.body {
    Leaf(bytes) => bytes
    Embedded(inner) => inner.encode(utf8=true)
    Multipart(_) => b""
  }
  {
    name,
    media_type: kind.essence,
    data,
    inline: disposition is Some(d) && d.kind.to_lower() == "inline",
    id: part.headers
    .get("Content-ID")
    .map(v => v.trim().trim_start(chars="<").trim_end(chars=">").to_owned()),
  }
}

///|
/// The message as it goes on the wire: CRLF line ends, header fields folded
/// at 78 columns. Each leaf is written in its `Content-Transfer-Encoding`; a
/// leaf whose encoding cannot carry it (8-bit octets or lines past 998 in
/// `7bit`) is written in quoted-printable if it is text and base64 otherwise,
/// with the field changed to say so, and a multipart body without a boundary
/// gets one. `utf8` writes non-ASCII header text as UTF-8 (RFC 6532);
/// otherwise it goes out as encoded words.
///
/// Reading what this writes gives the same tree back, and writing that again
/// gives the same octets.
pub fn Message::encode(self : Message, utf8~ : Bool = false) -> Bytes {
  let out = Buffer()
  write(self, out, utf8)
  out.to_bytes()
}

///|
fn write(message : Message, out : Buffer, utf8 : Bool) -> Unit {
  let overrides : Array[(String, String)] = []
  let body = Buffer()
  match message.body {
    Leaf(data) => {
      let text = message.content_type().type_() == "text"
      match encoding_of(message.headers) {
        Some("base64") => body.write_bytes(base64_lines(data))
        Some("quoted-printable") => body.write_bytes(@qp.encode(data[:]))
        Some("binary") => body.write_bytes(data)
        declared =>
          if fits(data, declared is Some("8bit")) {
            body.write_bytes(crlf(data))
          } else if text {
            overrides.push(("Content-Transfer-Encoding", "quoted-printable"))
            body.write_bytes(@qp.encode(data[:]))
          } else {
            overrides.push(("Content-Transfer-Encoding", "base64"))
            body.write_bytes(base64_lines(data))
          }
      }
    }
    Multipart(parts) => {
      let encoded = parts.map(p => p.encode(utf8~))
      let kind = message.content_type()
      let boundary = match kind.param("boundary") {
        Some(b) if kind.type_() == "multipart" && !b.is_empty() => b
        _ => {
          let fresh = boundary_of(encoded)
          let essence = if kind.type_() == "multipart" {
            kind.essence
          } else {
            "multipart/mixed"
          }
          overrides.push(
            ("Content-Type", essence + "; boundary=\"" + fresh + "\""),
          )
          fresh
        }
      }
      for part in encoded {
        body.write_bytes(@utf8.encode("--" + boundary + "\r\n"))
        body.write_bytes(part)
        body.write_bytes(b"\r\n")
      }
      body.write_bytes(@utf8.encode("--" + boundary + "--\r\n"))
    }
    Embedded(inner) => body.write_bytes(inner.encode(utf8~))
  }
  let written = []
  for field in message.headers.iter() {
    let (name, value) = field
    let value = match overrides.search_by(o => same(o.0, name)) {
      Some(i) => {
        written.push(i)
        overrides[i].1
      }
      None => value
    }
    out.write_bytes(@utf8.encode(fold(name, header_text(name, value, utf8))))
  }
  for i, field in overrides {
    if !written.contains(i) {
      out.write_bytes(@utf8.encode(fold(field.0, field.1)))
    }
  }
  out.write_bytes(b"\r\n")
  out.write_bytes(body.to_bytes())
}

///|
/// A field value as it goes out: unchanged when ASCII or under `utf8`;
/// otherwise address fields are written with encoded display names and the
/// rest as encoded words.
fn header_text(name : String, value : String, utf8 : Bool) -> String {
  if utf8 || value.iter().all(c => c.to_int() < 0x80) {
    return value
  }
  let lower = name.to_lower()
  let address_field = lower
    is ("from" | "to" | "cc" | "bcc" | "reply-to" | "sender") ||
    lower.has_prefix("resent-")
  if address_field {
    let list = parse_addresses(value) catch { _ => [] }
    if !list.is_empty() {
      return encode_addresses(list[:])
    }
  }
  @moonmime.encode_words(value, column=name.length() + 2) catch {
    _ => value
  }
}

///|
/// RFC 5321 section 4.5.3.1.6: no line of a message passes 998 octets.
let hard_line = 998

///|
/// Whether a leaf can go out as it is: ASCII unless 8-bit is declared, and no
/// line past 998 octets.
fn fits(data : Bytes, eight : Bool) -> Bool {
  let mut run = 0
  for b in data {
    if b == b'\n' || b == b'\r' {
      run = 0
    } else {
      run += 1
      if run > hard_line || (!eight && b >= 0x80) || b == 0 {
        return false
      }
    }
  }
  true
}

///|
/// Every line end made CRLF, whatever it was.
fn crlf(data : Bytes) -> Bytes {
  let out = Buffer(size_hint=data.length() + 16)
  let mut i = 0
  while i < data.length() {
    let b = data[i]
    if b == b'\r' {
      out.write_bytes(b"\r\n")
      if i + 1 < data.length() && data[i + 1] == b'\n' {
        i += 1
      }
    } else if b == b'\n' {
      out.write_bytes(b"\r\n")
    } else {
      out.write_byte(b)
    }
    i += 1
  }
  out.to_bytes()
}

///|
/// RFC 2045 section 6.8: base64 lines of at most 76 characters.
fn base64_lines(data : Bytes) -> Bytes {
  let text = @base64.encode(data[:])
  let out = StringBuilder()
  let mut at = 0
  while at < text.length() {
    let stop = if at + 76 < text.length() { at + 76 } else { text.length() }
    out.write_string(text[at:stop].to_owned())
    out.write_string("\r\n")
    at = stop
  }
  @utf8.encode(out.to_string())
}

///|
/// A boundary drawn from the parts' own octets, so writing the same parts
/// again gives the same boundary, and none of them can contain it by chance.
fn boundary_of(parts : Array[Bytes]) -> String {
  let hasher = @sha2.Hasher::new()
  for part in parts {
    hasher.write(part[:])
  }
  let digest = hasher.finish()
  let digits = "0123456789abcdef"
  let out = StringBuilder()
  out.write_string("=_")
  for b in digest[:12] {
    out.write_char(digits[b.to_int() / 16].unsafe_to_char())
    out.write_char(digits[b.to_int() % 16].unsafe_to_char())
  }
  out.to_string()
}

///|
fn line_end(data : BytesView, at : Int32) -> Int32 {
  let mut i = at
  while i < data.length() && data[i] != b'\n' {
    i += 1
  }
  if i < data.length() {
    i + 1
  } else {
    i
  }
}

///|
/// Where the line break that ends before `at` starts.
fn before_eol(data : BytesView, at : Int32) -> Int32 {
  let mut stop = at
  if stop > 0 && data[stop - 1] == b'\n' {
    stop -= 1
  }
  if stop > 0 && data[stop - 1] == b'\r' {
    stop -= 1
  }
  stop
}

///|
fn trim_eol(line : BytesView) -> BytesView {
  line[:before_eol(line, line.length())]
}
