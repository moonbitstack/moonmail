// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// How a header or body is flattened before it is hashed. `simple` keeps the
/// octets as they arrived; `relaxed` lowercases header names, unfolds, and
/// collapses whitespace, which is what survives a gateway rewriting line ends.
pub(all) enum Canon {
  Simple
  Relaxed
} derive(Eq)

///|
pub extend Canon with Eq::{not_equal, equal}

///|
pub(all) suberror DkimError {
  MissingSignature
  Malformed(msg~ : String)
}

///|
/// What goes into a signature: the domain and selector a receiver fetches the
/// key under, the headers to cover, and the canonicalization of each half.
pub struct SignOptions {
  domain : String
  selector : String
  headers : Array[String]
  header_canon : Canon
  body_canon : Canon
}

///|
pub fn SignOptions::new(
  domain~ : String,
  selector~ : String,
  headers~ : Array[String],
  header_canon~ : Canon = Canon::Relaxed,
  body_canon~ : Canon = Canon::Relaxed,
) -> SignOptions {
  { domain, selector, headers, header_canon, body_canon, }
}

///|
fn canon_name(c : Canon) -> String {
  match c {
    Canon::Simple => "simple"
    Canon::Relaxed => "relaxed"
  }
}

///|
fn is_wsp_byte(b : Byte) -> Bool {
  let n = b.to_int()
  n == 32 || n == 9
}

///|
/// Split a message at the blank line that ends its header block. A message with
/// no blank line has headers only and an empty body.
fn split_message(msg : BytesView) -> (BytesView, BytesView) {
  let n = msg.length()
  let mut i = 0
  while i < n {
    let mut j = i
    while j < n && msg.at(j) != b'\n' {
      j = j + 1
    }
    if j >= n {
      break
    }
    let line_end = if j > i && msg.at(j - 1) == b'\r' { j - 1 } else { j }
    if line_end == i {
      return (msg[0:i], msg[j + 1:])
    }
    i = j + 1
  }
  (msg, msg[n:])
}

///|
/// The header block as lines without their terminators. Empty lines are dropped;
/// a header block does not contain one.
fn split_lines(head : BytesView) -> Array[String] {
  let out : Array[String] = []
  let n = head.length()
  let mut start = 0
  let mut i = 0
  while i < n {
    if head.at(i) == b'\n' {
      let mut end = i
      if end > start && head.at(end - 1) == b'\r' {
        end = end - 1
      }
      if end > start {
        out.push(@utf8.decode_lossy(head[start:end]))
      }
      i = i + 1
      start = i
    } else {
      i = i + 1
    }
  }
  if start < n {
    out.push(@utf8.decode_lossy(head[start:n]))
  }
  out
}

///|
/// One header as it appeared: the name, and the whole text through any folded
/// continuation lines, without the final CRLF.
priv struct RawHeader {
  name : String
  raw : String
}

///|
fn parse_raw_headers(head : BytesView) -> Array[RawHeader] {
  let lines = split_lines(head)
  let out : Array[RawHeader] = []
  let mut idx = -1
  for line in lines {
    let view = line[:]
    let folded = view.length() > 0 && (view[0] == ' ' || view[0] == '\t')
    if folded && idx >= 0 {
      let prev = out[idx]
      out[idx] = { name: prev.name, raw: prev.raw + "\r\n" + line, }
    } else {
      let name = match line.find(":") {
        Some(at) => line[0:at].trim().to_owned()
        None => line
      }
      out.push({ name, raw: line, })
      idx = out.length() - 1
    }
  }
  out
}

///|
/// Relaxed value: unfold CRLF+WSP, collapse every WSP run to one space, and drop
/// leading and trailing WSP.
fn relax_value(v : StringView) -> String {
  let out = StringBuilder()
  let mut pending_wsp = false
  let mut started = false
  for c in v {
    if c == ' ' || c == '\t' {
      if started {
        pending_wsp = true
      }
    } else if c == '\r' || c == '\n' {
      // An unfolding break: the CRLF goes, the WSP after it stays.
    } else {
      if pending_wsp {
        out.write_char(' ')
        pending_wsp = false
      }
      out.write_char(c)
      started = true
    }
  }
  out.to_string()
}

///|
fn canon_header(h : RawHeader, mode : Canon) -> String {
  match mode {
    Canon::Simple => h.raw + "\r\n"
    Canon::Relaxed => {
      let raw = h.raw[:]
      let colon = raw.find(":")
      match colon {
        Some(at) => {
          let name = raw[0:at].trim().to_owned().to_lower()
          let value = relax_value(raw[at + 1:])
          name + ":" + value + "\r\n"
        }
        None => h.raw + "\r\n"
      }
    }
  }
}

///|
/// Canonicalize a single header field given its name and its raw text (folding
/// included, no final CRLF). `simple` returns the field unchanged; `relaxed`
/// lowercases the name and rebuilds the value. Exposed so callers can check the
/// transform the signature applies.
pub fn canonicalize_header(name : String, raw : String, mode : Canon) -> String {
  canon_header({ name, raw, }, mode)
}

///|
/// The body as an array of lines (without their terminators).
fn split_body_lines(body : BytesView) -> Array[BytesView] {
  let out : Array[BytesView] = []
  let n = body.length()
  let mut start = 0
  let mut i = 0
  while i < n {
    if body.at(i) == b'\n' {
      let mut end = i
      if end > start && body.at(end - 1) == b'\r' {
        end = end - 1
      }
      out.push(body[start:end])
      i = i + 1
      start = i
    } else {
      i = i + 1
    }
  }
  if start < n {
    out.push(body[start:n])
  }
  out
}

///|
/// One relaxed body line: WSP runs to a single space, trailing WSP gone.
fn relax_line(line : BytesView) -> Bytes {
  let out = Buffer()
  let mut pending_wsp = false
  for b in line {
    if is_wsp_byte(b) {
      pending_wsp = true
    } else {
      if pending_wsp {
        out.write_byte(32)
        pending_wsp = false
      }
      out.write_byte(b)
    }
  }
  out.to_bytes()
}

///|
/// Body canonicalization: flatten to lines, normalize each, drop trailing empty
/// lines, and end with a single CRLF (empty stays empty).
pub fn canon_body(body : BytesView, mode : Canon) -> Bytes {
  let lines = split_body_lines(body)
  let processed : Array[Bytes] = []
  for line in lines {
    processed.push(
      match mode {
        Canon::Simple => line.to_owned()
        Canon::Relaxed => relax_line(line)
      },
    )
  }
  let mut end = processed.length()
  while end > 0 && processed[end - 1].length() == 0 {
    end = end - 1
  }
  if end == 0 {
    return Bytes::new(0)
  }
  let out = Buffer()
  for i in 0..<end {
    out.write_bytes(processed[i][:])
    out.write_string_utf8("\r\n")
  }
  out.to_bytes()
}

///|
/// The `bh=` value: base64 of SHA-256 over the canonical body.
pub fn body_hash(body : BytesView, mode : Canon) -> String {
  let canon = canon_body(body, mode)
  let digest = @sha2.hash(canon[:], kind=@sha2.Kind::Sha256)
  @base64.encode(digest[:])
}

///|
/// `nth`th header with `name`, matched case-insensitively.
fn nth_header(
  headers : Array[RawHeader],
  name : String,
  nth : Int32,
) -> RawHeader? {
  let mut seen = 0
  for h in headers {
    if same_ignore_case(h.name[:], name[:]) {
      if seen == nth {
        return Some(h)
      }
      seen = seen + 1
    }
  }
  None
}

///|
/// Build the bytes a signature signs: each chosen header canonicalized in the
/// order `h=` lists it, then the DKIM-Signature header itself (with `b=` empty).
fn signing_input(
  headers : Array[RawHeader],
  names : Array[String],
  header_canon : Canon,
  sig_header_raw : String,
) -> Bytes {
  let out = Buffer()
  let lower : Array[String] = []
  for name in names {
    lower.push(name.to_lower())
  }
  for index, name in lower.iter2() {
    let mut nth = 0
    for j in 0..<index {
      if lower[j] == name {
        nth = nth + 1
      }
    }
    match nth_header(headers, name, nth) {
      Some(h) => out.write_string_utf8(canon_header(h, header_canon))
      None => ()
    }
  }
  let sig = { name: "DKIM-Signature", raw: sig_header_raw, }
  out.write_string_utf8(canon_header(sig, header_canon))
  out.to_bytes()
}

///|
fn build_value(options : SignOptions, bh : String, b : String) -> String {
  let names = StringBuilder()
  for index, name in options.headers.iter2() {
    if index > 0 {
      names.write_char(':')
    }
    names.write_string(name.to_lower())
  }
  "v=1; a=rsa-sha256; c=" +
  canon_name(options.header_canon) +
  "/" +
  canon_name(options.body_canon) +
  "; d=" +
  options.domain +
  "; s=" +
  options.selector +
  "; h=" +
  names.to_string() +
  "; bh=" +
  bh +
  "; b=" +
  b
}

///|
/// Sign a message, returning the `DKIM-Signature` header value (tags, no field
/// name). The key must be RSA with SHA-256 and PKCS#1 v1.5.
pub fn sign(
  msg : BytesView,
  key : @rsa.PrivateKey,
  options : SignOptions,
) -> String {
  let (head, body) = split_message(msg)
  let headers = parse_raw_headers(head)
  let bh = body_hash(body, options.body_canon)
  let unsigned_raw = "DKIM-Signature: " + build_value(options, bh, "")
  let input = signing_input(
    headers,
    options.headers,
    options.header_canon,
    unsigned_raw,
  )
  let b = @base64.encode(key.sign(input[:])[:])
  build_value(options, bh, b)
}

///|
/// One `k=v` of a signature header.
priv struct Tag {
  key : String
  value : String
}

///|
fn split_on(s : StringView, sep : Char) -> Array[String] {
  let out : Array[String] = []
  let mut cur = ""
  for c in s {
    if c == sep {
      out.push(cur)
      cur = ""
    } else {
      cur = cur + c.to_string()
    }
  }
  out.push(cur)
  out
}

///|
/// The tag list, after unfolding the CRLF that folding put inside it.
fn parse_tags(value : String) -> Array[Tag] {
  let unfolded = StringBuilder()
  for c in value {
    if c != '\r' && c != '\n' {
      unfolded.write_char(c)
    }
  }
  let out : Array[Tag] = []
  for part in split_on(unfolded.to_string()[:], ';') {
    let s = part.trim()
    if s.is_empty() {
      continue
    }
    let eq = s.find("=")
    for at in eq.iter() {
      let k = s[0:at].trim().to_owned().to_lower()
      let v = s[at + 1:].trim().to_owned()
      out.push({ key: k, value: v, })
    }
  }
  out
}

///|
fn tag_value(tags : Array[Tag], key : String) -> String? {
  for t in tags {
    if t.key == key {
      return Some(t.value)
    }
  }
  None
}

///|
/// Remove whitespace from a tag value. A signature's long `b=` is usually
/// folded across lines, and unfolding leaves the folding WSP behind.
fn strip_ws(s : String) -> String {
  let out = StringBuilder()
  for c in s {
    if c != ' ' && c != '\t' && c != '\r' && c != '\n' {
      out.write_char(c)
    }
  }
  out.to_string()
}

///|
fn same_ignore_case(a : StringView, b : StringView) -> Bool {
  a.equal_ignore_ascii_case(b)
}

///|
/// Remove the signature's own `b=` value, leaving `b=` empty: that is the form
/// the signer hashed.
fn strip_b(raw : String) -> String {
  let view = raw[:]
  let n = view.length()
  let mut idx = -1
  let mut i = 0
  while i + 1 < n {
    if view[i] == 'b' && view[i + 1] == '=' {
      let mut ok = true
      if i > 0 {
        let mut k = i - 1
        while k >= 0 &&
              (
                view[k] == ' ' ||
                view[k] == '\t' ||
                view[k] == '\r' ||
                view[k] == '\n'
              ) {
          k = k - 1
        }
        if k >= 0 && view[k] != ';' {
          ok = false
        }
      }
      if ok {
        idx = i
        break
      }
    }
    i = i + 1
  }
  if idx < 0 {
    return raw
  }
  let mut end = idx + 2
  while end < n && view[end] != ';' {
    end = end + 1
  }
  raw[0:idx + 2].to_owned() + raw[end:].to_owned()
}

///|
/// Verify the first DKIM-Signature header of a message against `key`. The caller
/// is expected to have fetched the key for the message's `d=`/`s=` already.
pub fn verify(msg : BytesView, key : @rsa.PublicKey) -> Bool {
  let (head, body) = split_message(msg)
  let headers = parse_raw_headers(head)
  let mut sig : RawHeader? = None
  for h in headers {
    if same_ignore_case(h.name[:], "DKIM-Signature") {
      sig = Some(h)
    }
  }
  let sig = match sig {
    Some(s) => s
    None => return false
  }
  let colon = sig.raw.find(":")
  let value = match colon {
    Some(at) => sig.raw[at + 1:].to_owned()
    None => return false
  }
  let tags = parse_tags(value)
  let bh = match tag_value(tags, "bh") {
    Some(v) => strip_ws(v)
    None => return false
  }
  let b = match tag_value(tags, "b") {
    Some(v) => strip_ws(v)
    None => return false
  }
  let h = match tag_value(tags, "h") {
    Some(v) => strip_ws(v)
    None => return false
  }
  let c = strip_ws(tag_value(tags, "c").unwrap_or("simple/simple"))
  let parts = split_on(c[:], '/')
  let hc = if parts.length() > 0 && parts[0] == "relaxed" {
    Canon::Relaxed
  } else {
    Canon::Simple
  }
  let bc = if parts.length() > 1 && parts[1] == "relaxed" {
    Canon::Relaxed
  } else {
    Canon::Simple
  }
  let computed = body_hash(body, bc)
  if computed != bh {
    return false
  }
  let names = split_on(h[:], ':')
  let stripped = strip_b(sig.raw)
  let input = signing_input(headers, names, hc, stripped)
  let sig_bytes = Some(@base64.decode(b[:], padding=true)) catch { _ => None }
  match sig_bytes {
    Some(bytes) => key.verify(input[:], bytes[:])
    None => false
  }
}
