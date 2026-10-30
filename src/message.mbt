// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// One header field: its (case-preserving) name and the value with any folding
/// already undone. The value keeps the single space that replaced each fold, so
/// `Subject: a⏎ b` and `Subject: a b` read the same afterwards.
pub struct Header {
  name : String
  value : String
}

///|
/// How a body was carried on the wire, so it can be read back and written again.
pub enum TransferEncoding {
  SevenBit
  EightBit
  Binary
  Base64
  QuotedPrintable
}

///|
/// A multipart body: the text before the first boundary, the parts in order, and
/// the text after the closing boundary. Preamble and epilogue are kept verbatim
/// because some gateways stash routing notes in them.
pub struct MultipartBody {
  preamble : String
  parts : Array[Message]
  epilogue : String
}

///|
pub enum Body {
  Leaf(Bytes)
  Multipart(MultipartBody)
}

///|
/// A parsed message. A leaf carries its transfer-decoded body; a multipart
/// carries its children. Headers are in arrival order, which is what signed
/// headers and `Received` chains depend on.
pub struct Message {
  headers : Array[Header]
  body : Body
}

///|
/// The `type/subtype` of a `Content-Type`, whether it is a multipart container,
/// and the boundary that separates its parts when it is.
pub struct ContentType {
  main : String
  is_multipart : Bool
  boundary : String?
}

///|
pub impl Show for TransferEncoding with fn output(self, logger) {
  match self {
    SevenBit => logger.write_string("7bit")
    EightBit => logger.write_string("8bit")
    Binary => logger.write_string("binary")
    Base64 => logger.write_string("base64")
    QuotedPrintable => logger.write_string("quoted-printable")
  }
}

///|
pub extend TransferEncoding with Show::{to_string, output}

///|
/// Read a message out of its bytes. Headers are unfolded and the body is split
/// into parts or transfer-decoded according to the headers that describe it.
///
/// ```mbt check
/// test {
///   let msg = @moonmail.parse(b"Subject: Hi\r\n\r\nbody")
///   inspect(msg.get_header("Subject") == Some("Hi"), content="true")
///   inspect(msg.payload() == b"body", content="true")
/// }
/// ```
pub fn parse(data : BytesView) -> Message {
  let (head, body) = head_body_split(data)
  let headers = parse_headers(head)
  build_message(headers, body)
}

///|
/// The raw, un-decoded value of the first header carrying `name` (compared
/// case-insensitively, as RFC 5322 requires).
pub fn Message::get_header(self : Message, name : StringView) -> String? {
  for h in self.headers {
    if same_ignore_case(h.name[:], name) {
      return Some(h.value)
    }
  }
  None
}

///|
/// Every value carried by headers named `name`, in order.
pub fn Message::headers_named(
  self : Message,
  name : StringView,
) -> Array[String] {
  let out : Array[String] = []
  for h in self.headers {
    if same_ignore_case(h.name[:], name) {
      out.push(h.value)
    }
  }
  out
}

///|
/// The first value of `name` with any RFC 2047 encoded words resolved to text.
pub fn Message::decoded_header(self : Message, name : StringView) -> String? {
  match self.get_header(name) {
    Some(value) => Some(@moonmime.decode_words(value[:]))
    None => None
  }
}

///|
/// The parsed `Content-Type`, defaulting to `text/plain` when the header is
/// absent (RFC 2045 §5.2) and thus to a single part carrying text.
pub fn Message::content_type(self : Message) -> ContentType {
  match self.get_header("Content-Type") {
    Some(value) => parse_content_type(value[:])
    None =>
      ContentType::{ main: "text/plain", is_multipart: false, boundary: None, }
  }
}

///|
pub fn Message::is_multipart(self : Message) -> Bool {
  match self.body {
    Multipart(_) => true
    Leaf(_) => false
  }
}

///|
/// The child messages of a multipart, empty for a leaf.
pub fn Message::parts(self : Message) -> Array[Message] {
  match self.body {
    Multipart(mp) => mp.parts
    Leaf(_) => []
  }
}

///|
/// The transfer-decoded body of a leaf, or empty bytes for a multipart (use
/// `parts` to reach the children instead).
pub fn Message::payload(self : Message) -> Bytes {
  match self.body {
    Leaf(bytes) => bytes
    Multipart(_) => Bytes::new(0)
  }
}

///|
/// Write the message back out: headers, a blank line, and the body re-encoded
/// under its declared transfer encoding. Multipart bodies are reassembled with
/// their boundary and any preamble or epilogue kept.
///
/// ```mbt check
/// test {
///   let msg = @moonmail.parse(b"Subject: Hi\r\n\r\nbody")
///   inspect(
///     @moonmail.serialize(msg) == b"Subject: Hi\r\n\r\nbody",
///     content="true",
///   )
/// }
/// ```
pub fn serialize(msg : Message) -> Bytes {
  let out = Buffer()
  for h in msg.headers {
    out.write_string_utf8(h.name)
    out.write_string_utf8(": ")
    out.write_string_utf8(h.value)
    out.write_string_utf8("\r\n")
  }
  out.write_string_utf8("\r\n")
  match msg.body {
    Leaf(payload) => {
      let te = transfer_encoding_of(msg.headers)
      out.write_bytes(encode_body(payload, te))
    }
    Multipart(mp) => {
      let ct = msg.content_type()
      let boundary = match ct.boundary {
        Some(b) => b
        None => "moonmail-boundary"
      }
      if !mp.preamble.is_empty() {
        out.write_string_utf8(mp.preamble)
        out.write_string_utf8("\r\n")
      }
      for part in mp.parts {
        out.write_string_utf8("--")
        out.write_string_utf8(boundary)
        out.write_string_utf8("\r\n")
        out.write_bytes(serialize(part))
        out.write_string_utf8("\r\n")
      }
      out.write_string_utf8("--")
      out.write_string_utf8(boundary)
      out.write_string_utf8("--\r\n")
      if !mp.epilogue.is_empty() {
        out.write_string_utf8(mp.epilogue)
      }
    }
  }
  out.to_bytes()
}

///|
fn build_message(headers : Array[Header], body : Bytes) -> Message {
  let ct = content_type_of(headers)
  if ct.is_multipart {
    match ct.boundary {
      Some(boundary) => {
        let (preamble, parts_bytes, epilogue) = split_multipart(
          body[:],
          boundary,
        )
        let parts : Array[Message] = []
        for pb in parts_bytes {
          parts.push(parse_part(pb))
        }
        { headers, body: Multipart({ preamble, parts, epilogue, }), }
      }
      None => { headers, body: Leaf(body), }
    }
  } else {
    let decoded = decode_body(body[:], transfer_encoding_of(headers))
    { headers, body: Leaf(decoded), }
  }
}

///|
fn parse_part(raw : Bytes) -> Message {
  let (head, body) = head_body_split(raw[:])
  let headers = parse_headers(head)
  build_message(headers, body)
}

///|
/// Find the first blank line in the bytes and return the header block and the
/// body that follows. A message with no blank line has headers only, and an
/// empty body.
fn head_body_split(data : BytesView) -> (Bytes, Bytes) {
  let n = data.length()
  let mut i = 0
  while i < n {
    let b = data.at(i)
    if b == b'\n' {
      return (data[0:i].to_owned(), data[i + 1:].to_owned())
    }
    if b == b'\r' && i + 1 < n && data.at(i + 1) == b'\n' {
      return (data[0:i].to_owned(), data[i + 2:].to_owned())
    }
    while i < n && data.at(i) != b'\n' {
      i = i + 1
    }
    if i < n {
      i = i + 1
    }
  }
  (data[0:n].to_owned(), Bytes::new(0))
}

///|
fn split_lines_bytes(head : BytesView) -> Array[Bytes] {
  let lines : Array[Bytes] = []
  let n = head.length()
  let mut start = 0
  let mut i = 0
  while i < n {
    let b = head.at(i)
    if b == b'\n' {
      lines.push(head[start:i].to_owned())
      i = i + 1
      start = i
    } else if b == b'\r' {
      if i + 1 < n && head.at(i + 1) == b'\n' {
        lines.push(head[start:i].to_owned())
        i = i + 2
        start = i
      } else {
        lines.push(head[start:i].to_owned())
        i = i + 1
        start = i
      }
    } else {
      i = i + 1
    }
  }
  if start < n {
    lines.push(head[start:n].to_owned())
  }
  lines
}

///|
fn parse_headers(head : BytesView) -> Array[Header] {
  let lines = split_lines_bytes(head)
  let headers : Array[Header] = []
  let mut current : Int32 = -1
  for line in lines {
    let text = @utf8.decode_lossy(line)
    if text.length() > 0 {
      let first = text.get_char(0).unwrap_or(' ')
      if first == ' ' || first == '\t' {
        if current >= 0 {
          let rest = strip_leading_wsp(text)
          let prev = headers[current]
          headers[current] = {
            name: prev.name,
            value: prev.value + " " + rest,
          }
        }
        continue
      }
    }
    match split_header(text) {
      Some((name, value)) => {
        let h = Header::{ name, value: value.trim().to_owned(), }
        headers.push(h)
        current = headers.length() - 1
      }
      None => current = -1
    }
  }
  headers
}

///|
fn split_header(text : StringView) -> (String, String)? {
  match text.find(":") {
    Some(at) => {
      let name = text[0:at].trim().to_owned()
      let value = text[at + 1:].to_owned()
      Some((name, value))
    }
    None => None
  }
}

///|
fn strip_leading_wsp(text : StringView) -> String {
  let n = text.length()
  let mut i = 0
  while i < n {
    let c = text.get_char(i).unwrap_or(' ')
    if c == ' ' || c == '\t' {
      i = i + 1
    } else {
      break
    }
  }
  text[i:].to_owned()
}

///|
/// Read a `Content-Type`. The media-type grammar — parameters, quoting and all
/// — is moonmime's, so this only keeps the two facts the tree needs: whether the
/// part is multipart, and the boundary if it is.
fn parse_content_type(value : StringView) -> ContentType {
  let media = @moonmime.media_type(value)
  let main = media.essence
  let is_multipart = main.length() >= 10 && main[0:10] == "multipart/"
  ContentType::{ main, is_multipart, boundary: media.param("boundary"), }
}

///|
fn transfer_encoding_of(headers : Array[Header]) -> TransferEncoding {
  match get_header_value(headers, "Content-Transfer-Encoding") {
    Some(value) => parse_transfer_encoding(value[:])
    None => SevenBit
  }
}

///|
fn content_type_of(headers : Array[Header]) -> ContentType {
  match get_header_value(headers, "Content-Type") {
    Some(value) => parse_content_type(value[:])
    None =>
      ContentType::{ main: "text/plain", is_multipart: false, boundary: None, }
  }
}

///|
fn get_header_value(headers : Array[Header], name : StringView) -> String? {
  for h in headers {
    if same_ignore_case(h.name[:], name) {
      return Some(h.value)
    }
  }
  None
}

///|
fn parse_transfer_encoding(value : StringView) -> TransferEncoding {
  let v = value.trim().to_owned().to_lower()
  match v {
    "base64" => Base64
    "quoted-printable" => QuotedPrintable
    "7bit" => SevenBit
    "8bit" => EightBit
    "binary" => Binary
    _ => SevenBit
  }
}

///|
fn decode_body(body : BytesView, te : TransferEncoding) -> Bytes {
  match te {
    Base64 =>
      @base64.decode(strip_whitespace(@utf8.decode_lossy(body)), padding=true) catch {
        _ => body.to_owned()
      }
    QuotedPrintable => @qp.decode(body) catch { _ => body.to_owned() }
    _ => body.to_owned()
  }
}

///|
fn strip_whitespace(s : StringView) -> String {
  let out = StringBuilder()
  for c in s {
    if c != ' ' && c != '\t' && c != '\r' && c != '\n' {
      out.write_char(c)
    }
  }
  out.to_string()
}

///|
fn encode_body(payload : BytesView, te : TransferEncoding) -> Bytes {
  match te {
    Base64 => @utf8.encode(wrap_lines(@base64.encode(payload), 76))
    QuotedPrintable => @qp.encode(payload)
    _ => payload.to_owned()
  }
}

///|
fn wrap_lines(s : StringView, width : Int32) -> String {
  let out = StringBuilder()
  let n = s.length()
  let mut col = 0
  let mut i = 0
  while i < n {
    let c = s.get_char(i).unwrap_or(' ')
    out.write_char(c)
    col = col + 1
    i = i + 1
    if col >= width && i < n {
      out.write_string("\r\n")
      col = 0
    }
  }
  out.to_string()
}

///|
/// Pull a multipart body apart at its boundary. Each returned slice is a part's
/// own bytes (its headers through its content, with the CRLF that belongs to
/// the boundary removed); preamble and epilogue are kept as text.
fn split_multipart(
  body : BytesView,
  boundary : String,
) -> (String, Array[Bytes], String) {
  let open = "--" + boundary
  let close = open + "--"
  let n = body.length()
  let mut i = 0
  let preamble = Buffer()
  let parts : Array[Bytes] = []
  let mut part = Buffer()
  let epilogue = Buffer()
  let mut state = 0
  while i < n {
    let mut j = i
    while j < n && body.at(j) != b'\n' {
      j = j + 1
    }
    let line_end = if j > i && body.at(j - 1) == b'\r' { j - 1 } else { j }
    let line = body[i:line_end]
    let term = if j < n { 1 } else { 0 }
    let line_str = @utf8.decode_lossy(line)
    if state == 0 {
      if line_str == open {
        state = 1
        part = Buffer()
      } else if line_str == close {
        state = 2
      } else {
        preamble.write_bytes(body[i:j + term])
      }
    } else if state == 1 {
      if line_str == open {
        parts.push(strip_part_terminator(part.to_bytes()))
        part = Buffer()
      } else if line_str == close {
        parts.push(strip_part_terminator(part.to_bytes()))
        part = Buffer()
        state = 2
      } else {
        part.write_bytes(body[i:j + term])
      }
    } else {
      epilogue.write_bytes(body[i:j + term])
    }
    i = j + term
  }
  (
    @utf8.decode_lossy(preamble.to_bytes()[:]),
    parts,
    @utf8.decode_lossy(epilogue.to_bytes()[:]),
  )
}

///|
fn strip_part_terminator(raw : Bytes) -> Bytes {
  let n = raw.length()
  if n >= 2 && raw.at(n - 2) == b'\r' && raw.at(n - 1) == b'\n' {
    raw[0:n - 2].to_owned()
  } else if n >= 1 && raw.at(n - 1) == b'\n' {
    raw[0:n - 1].to_owned()
  } else {
    raw
  }
}
