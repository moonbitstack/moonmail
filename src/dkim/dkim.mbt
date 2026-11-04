// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// How a header field or the body is flattened before it is hashed (RFC 6376
/// section 3.4). `Simple` keeps the octets; `Relaxed` survives what gateways
/// do to white space and header case.
#derive(Eq, Debug)
pub(all) enum Canon {
  Simple
  Relaxed
}

///|
pub extend Canon with Eq::{equal, not_equal}

///|
pub extend Canon with Debug::{to_repr}

///|
/// The signing key: RSA for `rsa-sha256`, Ed25519 for `ed25519-sha256`
/// (RFC 8463).
pub(all) enum Key {
  Rsa(@rsa.PrivateKey)
  Ed25519(@ed25519.PrivateKey)
}

///|
/// What one signature on a message comes to (RFC 6376 section 6.1, RFC 8601's
/// result names). `Fail` is a signature that was checked and did not hold;
/// `PermError` one that cannot be checked, ever; `TempError` one whose key
/// could not be fetched this time.
#derive(Eq, Debug)
pub(all) enum Verdict {
  Pass(domain~ : String, selector~ : String)
  Fail(domain~ : String, reason~ : String)
  PermError(String)
  TempError(String)
}

///|
pub extend Verdict with Eq::{equal, not_equal}

///|
pub extend Verdict with Debug::{to_repr}

///|
/// Why a message cannot be signed.
#derive(Eq, Debug)
pub(all) suberror Refused {
  /// The message has no `From`, which every signature must cover.
  Missing(String)
  /// A value that would break the signature field: a domain, selector or
  /// field name with `;`, `=` or white space in it.
  Malformed(String)
}

///|
pub extend Refused with Eq::{equal, not_equal}

///|
pub extend Refused with Debug::{to_repr}

///|
/// The fields signed when none are named: RFC 6376 section 5.4.1's list, as
/// Python's dkimpy signs it. Each one present is signed once per occurrence.
pub let signed : Array[String] = [
  "From", "Sender", "Reply-To", "Subject", "Date", "Message-ID", "To", "Cc", "MIME-Version",
  "Content-Type", "Content-Transfer-Encoding", "Content-ID", "Content-Description",
  "Resent-Date", "Resent-From", "Resent-Sender", "Resent-To", "Resent-Cc", "Resent-Message-ID",
  "In-Reply-To", "References", "List-Id", "List-Help", "List-Unsubscribe", "List-Subscribe",
  "List-Post", "List-Owner", "List-Archive",
]

///|
/// Sign a message and return the `DKIM-Signature` field to put in front of
/// it, without its CRLF.
///
/// `headers` is the `h=` list as it will be written; a name given more times
/// than the field occurs also signs its absence, so that one cannot be added
/// later. Left out, every field of `signed` that is present is signed.
/// `header_canon` and `body_canon` default to relaxed and simple, as dkimpy
/// and OpenDKIM do. `timestamp` and `expire` are `t=` and `x=`, in seconds
/// since the epoch; `length` writes `l=`, the body length signed; `identity`
/// is `i=`.
pub fn sign(
  message : BytesView,
  key : Key,
  domain~ : String,
  selector~ : String,
  headers? : Array[String],
  header_canon~ : Canon = Relaxed,
  body_canon~ : Canon = Simple,
  timestamp? : Int64,
  expire? : Int64,
  length~ : Bool = false,
  identity? : String,
) -> String raise Refused {
  for value in [domain, selector] + identity.map(i => [i]).unwrap_or([]) {
    tag_safe(value)
  }
  let (fields, body) = split(message)
  if !fields.iter().any(f => f.name.to_lower() == "from") {
    raise Missing("From")
  }
  let names = match headers {
    Some(list) => list
    None => {
      let wanted = signed.map(n => n.to_lower())
      fields.filter(f => wanted.contains(f.name.to_lower())).map(f => f.name)
    }
  }
  for name in names {
    tag_safe(name)
  }
  if !names.iter().any(n => n.to_lower() == "from") {
    raise Missing("From")
  }
  let canonical = canon_body(body, body_canon)
  let tags = [
    ("v", "1"),
    (
      "a",
      match key {
        Rsa(_) => "rsa-sha256"
        Ed25519(_) => "ed25519-sha256"
      },
    ),
    ("c", canon_name(header_canon) + "/" + canon_name(body_canon)),
    ("d", domain),
  ]
  if identity is Some(i) {
    tags.push(("i", i))
  }
  tags.push(("s", selector))
  if timestamp is Some(t) {
    tags.push(("t", t.to_string()))
  }
  if expire is Some(x) {
    tags.push(("x", x.to_string()))
  }
  if length {
    tags.push(("l", canonical.length().to_string()))
  }
  tags.push(("h", names.join(":")))
  tags.push(("bh", @base64.encode(@sha2.hash(canonical[:])[:])))
  tags.push(("b", ""))
  let field = "DKIM-Signature: " + tags.map(t => t.0 + "=" + t.1).join("; ")
  field + @base64.encode(signature(key, fields, names, field, header_canon)[:])
}

///|
/// The signature over the selected fields and the signature field itself,
/// whose `b=` is still empty.
fn signature(
  key : Key,
  fields : Array[Field],
  names : Array[String],
  field : String,
  canon : Canon,
) -> Bytes {
  let data = signed_data(fields, names, field, canon)
  match key {
    Rsa(k) => k.sign(data[:])
    // RFC 8463 section 3: Ed25519 signs the SHA-256 hash, not the data.
    Ed25519(k) => k.sign(@sha2.hash(data[:])[:])
  }
}

///|
/// What the signature covers: each field `h=` names, picked from the bottom
/// up (RFC 6376 section 5.4.2), then the signature field, canonicalized, its
/// last CRLF left off.
fn signed_data(
  fields : Array[Field],
  names : Array[String],
  signature_field : String,
  canon : Canon,
) -> Bytes {
  let used : Map[String, Int32] = Map([])
  let out = StringBuilder()
  for name in names {
    let key = name.trim().to_lower().to_owned()
    let skip = used.get(key).unwrap_or(0)
    used[key] = skip + 1
    let matching = fields.filter(f => f.name.to_lower() == key)
    let index = matching.length() - 1 - skip
    if index >= 0 {
      out.write_string(
        canon_header(matching[index].name, matching[index].raw, canon),
      )
    }
  }
  let colon = signature_field.find(":").unwrap_or(0)
  let last = canon_header(
    signature_field[:colon].to_owned(),
    signature_field,
    canon,
  )
  out.write_string(last.strip_suffix("\r\n").unwrap_or(last[:]).to_owned())
  @utf8.encode(out.to_string())
}

///|
/// Check every `DKIM-Signature` on a message, top to bottom, one verdict each.
/// `lookup` fetches the TXT record of a name such as
/// `brisbane._domainkey.example.com`: `None` when there is none, raising when
/// it could not be fetched. `now`, in seconds since the epoch, is the time an
/// `x=` expiry is judged at.
pub fn verify(
  message : BytesView,
  lookup : (String) -> String? raise,
  now~ : Int64,
) -> Array[Verdict] {
  let (fields, body) = split(message)
  fields
  .filter(f => f.name.to_lower() == "dkim-signature")
  .map(f => check(f, fields, body, lookup, now))
}

///|
fn check(
  field : Field,
  fields : Array[Field],
  body : BytesView,
  lookup : (String) -> String? raise,
  now : Int64,
) -> Verdict {
  let value = field.raw[field.raw.find(":").unwrap_or(0) + 1:].to_owned()
  guard tag_list(value) is Some(tags) else {
    return PermError("the signature's tags do not parse")
  }
  for name in ["v", "a", "b", "bh", "d", "h", "s"] {
    if !tags.contains(name) {
      return PermError("the signature has no " + name + "=")
    }
  }
  let domain = tags["d"]
  let selector = tags["s"]
  if tags["v"] != "1" {
    return PermError("v= is not 1")
  }
  let algorithm = tags["a"].to_lower()
  if !(algorithm is ("rsa-sha256" | "ed25519-sha256")) {
    return PermError("a=" + algorithm + " is not accepted")
  }
  let names = tags["h"].split(":").map(n => n.trim().to_owned()).to_array()
  if !names.iter().any(n => n.to_lower() == "from") {
    return PermError("h= does not cover From")
  }
  if tags.get("i") is Some(identity) {
    let at = identity
      .rev_find("@")
      .map(i => identity[i + 1:].to_lower().to_owned())
    guard at is Some(host) &&
      (host == domain.to_lower() || host.has_suffix("." + domain.to_lower())) else {
      return PermError("i= is not within d=")
    }
  }
  let (header_canon, body_canon) = match tags.get("c").map(c => c.to_lower()) {
    None => (Simple, Simple)
    Some(c) =>
      match c.split("/").map(p => p.trim().to_owned()).to_array() {
        ["simple"] => (Simple, Simple)
        ["relaxed"] => (Relaxed, Simple)
        [h, b] if canon_of(h) is Some(hc) && canon_of(b) is Some(bc) => (hc, bc)
        _ => return PermError("c= is not a canonicalization")
      }
  }
  let expiry = tags.get("x").map(x => number(x))
  if expiry is Some(Some(x)) {
    if tags.get("t").map(t => number(t)) is Some(Some(t)) && x < t {
      return PermError("x= is before t=")
    }
    if x < now {
      return Fail(domain~, reason="the signature expired")
    }
  }
  let mut canonical = canon_body(body, body_canon)
  if tags.get("l") is Some(l) {
    guard number(l) is Some(n) && n <= canonical.length().to_int64() else {
      return Fail(domain~, reason="l= is longer than the body")
    }
    canonical = canonical[:n.to_int()].to_owned()
  }
  let expected = @base64.decode_lossy(tags["bh"])
  if @sha2.hash(canonical[:]) != expected {
    return Fail(domain~, reason="the body hash does not match")
  }
  let name = selector + "._domainkey." + domain
  let record = lookup(name) catch {
    e =>
      return TempError(
        "the key for " + name + " could not be fetched: " + e.to_string(),
      )
  }
  guard record is Some(text) else {
    return PermError("no key is published at " + name)
  }
  guard tag_list(text) is Some(key_tags) else {
    return PermError("the key record does not parse")
  }
  let kind = key_tags.get("k").unwrap_or("rsa").to_lower()
  if (kind == "rsa") != (algorithm == "rsa-sha256") ||
    !(kind is ("rsa" | "ed25519")) {
    return PermError("the key is k=" + kind + " for a=" + algorithm)
  }
  if key_tags.get("h") is Some(hashes) &&
    !hashes.split(":").any(h => h.trim().to_lower() == "sha256") {
    return PermError("the key does not allow sha256")
  }
  if key_tags.get("s") is Some(services) &&
    !services.split(":").any(s => s.trim() is ("*" | "email")) {
    return PermError("the key is not for email")
  }
  let public = @base64.decode_lossy(key_tags.get("p").unwrap_or(""))
  if public.is_empty() {
    return PermError("the key is revoked")
  }
  let data = signed_data(fields, names, without_b(field.raw), header_canon)
  let signature = @base64.decode_lossy(tags["b"])
  let good = match kind {
    "rsa" =>
      match rsa_key(public) {
        Some(k) => k.verify(data[:], signature[:])
        None => return PermError("the RSA key does not parse")
      }
    _ => {
      let k = @ed25519.PublicKey::new(public[:]) catch {
        _ => return PermError("the Ed25519 key does not parse")
      }
      k.verify(@sha2.hash(data[:])[:], signature[:])
    }
  }
  if good {
    Pass(domain~, selector~)
  } else {
    Fail(domain~, reason="the signature does not verify")
  }
}

///|
/// An RSA public key as `p=` carries it: a SubjectPublicKeyInfo, or, as some
/// records have it, the bare RSAPublicKey.
fn rsa_key(der : Bytes) -> @rsa.PublicKey? {
  let parse = () => {
    let top = @asn1.only(der[:])
    let items = top.items()
    let key = if items.length() == 2 && items[1].tag == 0x03 {
      @asn1.only(items[1].bits().bytes[:]).items()
    } else {
      items
    }
    guard key is [n, e, ..] else { raise @asn1.Malformed("no modulus") }
    @rsa.PublicKey::new(n.value, e.value)
  }
  Some(parse()) catch {
    _ => None
  }
}

///|
/// One header field as it came: its name and its whole text, folds included,
/// without the CRLF after it.
priv struct Field {
  name : String
  raw : String
}

///|
/// The header fields and the body.
fn split(message : BytesView) -> (Array[Field], BytesView) {
  let fields = []
  let mut at = 0
  while at < message.length() {
    let mut end = at
    while end < message.length() && message[end] != b'\n' {
      end += 1
    }
    let next = if end < message.length() { end + 1 } else { end }
    let stop = if end > at && message[end - 1] == b'\r' { end - 1 } else { end }
    let line = @utf8.decode_lossy(message[at:stop])
    if line.is_empty() {
      return (fields, message[next:])
    }
    let first = line[0]
    if (first == ' ' || first == '\t') && fields.length() > 0 {
      let last = fields.length() - 1
      fields[last] = {
        name: fields[last].name,
        raw: fields[last].raw + "\r\n" + line,
      }
    } else {
      let name = match line.find(":") {
        Some(i) => line[:i].trim_end().to_owned()
        None => line
      }
      fields.push({ name, raw: line, })
    }
    at = next
  }
  (fields, message[message.length():])
}

///|
/// RFC 6376 section 3.4.1 and 3.4.2.
fn canon_header(name : String, raw : String, canon : Canon) -> String {
  match canon {
    Simple => raw + "\r\n"
    Relaxed => {
      let value = raw[raw.find(":").unwrap_or(raw.length() - 1) + 1:]
      let out = StringBuilder()
      let mut space = false
      for c in value {
        if c == '\r' || c == '\n' {
          continue
        }
        if c == ' ' || c == '\t' {
          space = true
        } else {
          if space && out.to_string().length() > 0 {
            out.write_char(' ')
          }
          space = false
          out.write_char(c)
        }
      }
      name.trim().to_lower().to_owned() + ":" + out.to_string() + "\r\n"
    }
  }
}

///|
/// RFC 6376 section 3.4.3 and 3.4.4, with every line end made CRLF first.
fn canon_body(body : BytesView, canon : Canon) -> Bytes {
  let lines = []
  let mut at = 0
  while at < body.length() {
    let mut end = at
    while end < body.length() && body[end] != b'\n' {
      end += 1
    }
    let stop = if end > at && body[end - 1] == b'\r' { end - 1 } else { end }
    lines.push(body[at:stop])
    at = end + 1
  }
  let out = Buffer()
  let kept = lines.map(line => {
    match canon {
      Simple => line.to_owned()
      Relaxed => {
        let squeezed = Buffer()
        let mut space = false
        for b in line {
          if b == b' ' || b == b'\t' {
            space = true
          } else {
            if space {
              squeezed.write_byte(b' ')
            }
            space = false
            squeezed.write_byte(b)
          }
        }
        squeezed.to_bytes()
      }
    }
  })
  let mut last = kept.length()
  while last > 0 && kept[last - 1].is_empty() {
    last -= 1
  }
  for i in 0..<last {
    out.write_bytes(kept[i])
    out.write_bytes(b"\r\n")
  }
  // An empty body is one CRLF under simple, and nothing under relaxed
  // (RFC 6376 erratum 3192).
  if last == 0 && canon is Simple {
    out.write_bytes(b"\r\n")
  }
  out.to_bytes()
}

///|
/// The signature field with the value of `b=` taken out, white space and all
/// (RFC 6376 section 3.5).
fn without_b(raw : String) -> String {
  let colon = raw.find(":").unwrap_or(0)
  let segments = raw[colon + 1:].split(";").map(s => s.to_owned()).to_array()
  let kept = segments.map(segment => {
    match segment.find("=") {
      Some(eq) if segment[:eq].trim() == "b" => segment[:eq + 1].to_owned()
      _ => segment
    }
  })
  raw[:colon + 1].to_owned() + kept.join(";")
}

///|
/// A tag list (RFC 6376 section 3.2): `name=value` pairs separated by `;`,
/// white space dropped around names and values, and inside base64 values.
fn tag_list(text : String) -> Map[String, String]? {
  let out = Map([])
  for spec in text.split(";") {
    let trimmed = spec.trim(chars=" \t\r\n")
    if trimmed.is_empty() {
      continue
    }
    guard trimmed.find("=") is Some(eq) else { return None }
    let name = trimmed[:eq].trim(chars=" \t\r\n").to_owned()
    if name.is_empty() || out.contains(name) {
      return None
    }
    let value = trimmed[eq + 1:].trim(chars=" \t\r\n")
    let squeezed = if name is ("b" | "bh" | "p") {
      value.iter().filter(c => !c.is_whitespace()).collect()
      |> String::from_array
    } else {
      value.to_owned()
    }
    out[name] = squeezed
  }
  Some(out)
}

///|
fn canon_name(canon : Canon) -> String {
  match canon {
    Simple => "simple"
    Relaxed => "relaxed"
  }
}

///|
fn canon_of(name : String) -> Canon? {
  match name {
    "simple" => Some(Simple)
    "relaxed" => Some(Relaxed)
    _ => None
  }
}

///|
fn number(text : String) -> Int64? {
  if text.is_empty() || text.length() > 18 {
    return None
  }
  let mut n = 0L
  for c in text {
    guard c >= '0' && c <= '9' else { return None }
    n = n * 10 + (c.to_int() - '0'.to_int()).to_int64()
  }
  Some(n)
}

///|
fn tag_safe(value : String) -> Unit raise Refused {
  if value.is_empty() ||
    value.iter().any(c => c == ';' || c == '=' || c.is_whitespace() || c < ' ') {
    raise Malformed(value)
  }
}
