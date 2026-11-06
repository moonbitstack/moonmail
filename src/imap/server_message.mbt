// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The commands that carry messages: `APPEND`, `FETCH`, `STORE`, `SEARCH`,
/// `COPY` and `MOVE`, and the three renderings of a message that `FETCH` asks
/// for — its envelope, its structure and the octets of a section.

///|
fn Server::append(
  self : Server,
  tag : String,
  tokens : Array[Token],
  at : Int32,
) -> Unit {
  guard self.state is (Authenticated | Selected(_)) else {
    self.bad(tag, text="log in first")
    return
  }
  guard name_at(tokens, at) is Some(name) else {
    self.bad(tag, text="APPEND needs a mailbox")
    return
  }
  guard self.store.exists(name) else {
    self.no(tag, text="[TRYCREATE] no such mailbox")
    return
  }
  let mut i = at + 1
  let flags = []
  if i < tokens.length() && tokens[i] is Open {
    i += 1
    while i < tokens.length() && !(tokens[i] is Close) {
      if tokens[i] is Word(word) {
        flags.push(word)
      }
      i += 1
    }
    i += 1
  }
  let mut date = ""
  if i < tokens.length() && tokens[i] is Word(word) {
    date = word
    i += 1
  }
  guard i < tokens.length() && tokens[i] is Literal(body) else {
    self.bad(tag, text="APPEND needs a message")
    return
  }
  let when = if date == "" { (self.clock)() } else { date }
  match self.store.deliver(name, body[:], flags~, date=when) {
    Some(uid) => {
      let validity = match self.store.summary(name) {
        Some(summary) => summary.uidvalidity
        None => 1L
      }
      self.ok(
        tag,
        text="Append completed",
        code="APPENDUID " + validity.to_string() + " " + uid.to_string(),
      )
    }
    None => self.no(tag, text="no such mailbox")
  }
}

///|
/// The message a command names, by sequence number.
fn at_sequence(mailbox : Array[Stored], sequence : Int32) -> Stored? {
  if sequence < 1 || sequence > mailbox.length() {
    return None
  }
  Some(mailbox[sequence - 1])
}

///|
fn Server::fetch(
  self : Server,
  tag : String,
  tokens : Array[Token],
  at : Int32,
  uid : Bool,
) -> Unit {
  guard self.state is Selected(name) else {
    self.bad(tag, text="no mailbox is open")
    return
  }
  guard name_at(tokens, at) is Some(set) else {
    self.bad(tag, text="FETCH needs a message set")
    return
  }
  let items = fetch_items(tokens, at + 1)
  guard items.length() > 0 else {
    self.bad(tag, text="FETCH needs data items")
    return
  }
  self.announce_flags(name)
  let mailbox = self.store.messages(name)
  let wanted = sequence_set(set, mailbox, uid)
  for sequence in wanted {
    guard at_sequence(mailbox, sequence) is Some(message) else { continue }
    let (rendered, read) = self.render_fetch(message, items, uid)
    self.untagged(sequence.to_string() + " FETCH (" + rendered + ")")
    // A `BODY[...]` without `PEEK` tells the server the message was read.
    if read && !message.flags.contains("\\Seen") {
      let _ = self.store.set_flags(name, sequence, "+FLAGS", ["\\Seen"])
    }
  }
  self.ok(tag, text="Fetch completed")
}

///|
/// The data items of a `FETCH`, with the section of a `BODY[...]` put back
/// together from the words and brackets it arrived as.
fn fetch_items(tokens : Array[Token], at : Int32) -> Array[String] {
  let items = []
  let mut i = at
  let mut current = ""
  let mut square = 0
  let mut round = 0
  while i < tokens.length() {
    match tokens[i] {
      Open => {
        if current == "" {
          i += 1
          continue
        }
        round += 1
        current = current + " ("
      }
      Close => {
        if current == "" {
          i += 1
          continue
        }
        if round > 0 {
          round -= 1
          current = current + ")"
        }
      }
      Word(word) => {
        if current == "" {
          current = word
        } else {
          current = current + " " + word
        }
        square += brackets(word)
      }
      Literal(data) => {
        let text = @utf8.decode_lossy(data[:])
        if current == "" {
          current = text
        } else {
          current = current + " " + text
        }
      }
    }
    if current != "" && square == 0 && round == 0 {
      items.push(current)
      current = ""
    }
    i += 1
  }
  if current != "" {
    items.push(current)
  }
  items
}

///|
/// How many section brackets a word opens or closes.
fn brackets(word : String) -> Int32 {
  let mut depth = 0
  for c in word {
    if c == '[' {
      depth += 1
    } else if c == ']' {
      depth -= 1
    }
  }
  depth
}

///|
/// One message's `FETCH` data, in the order the client asked for it, and
/// whether a section was fetched without `PEEK`.
fn Server::render_fetch(
  self : Server,
  message : Stored,
  items : Array[String],
  uid : Bool,
) -> (String, Bool) {
  let out = Buffer()
  let mut first = true
  let mut read = false
  let mut named_uid = false
  for item in items {
    if item.to_upper() == "UID" {
      named_uid = true
    }
  }
  for item in items {
    if !first {
      out.write_bytes(b" ")
    }
    first = false
    let upper = item.to_upper()
    if upper == "UID" {
      out.write_bytes(@utf8.encode("UID " + message.uid.to_string()))
    } else if upper == "FLAGS" {
      out.write_bytes(@utf8.encode("FLAGS (" + message.flags.join(" ") + ")"))
    } else if upper == "RFC822.SIZE" {
      out.write_bytes(
        @utf8.encode("RFC822.SIZE " + message.body.length().to_string()),
      )
    } else if upper == "INTERNALDATE" {
      let date = if message.date == "" { (self.clock)() } else { message.date }
      out.write_bytes(@utf8.encode("INTERNALDATE \"" + date + "\""))
    } else if upper == "ENVELOPE" {
      out.write_bytes(@utf8.encode("ENVELOPE " + envelope(message.body)))
    } else if upper == "BODYSTRUCTURE" {
      out.write_bytes(@utf8.encode("BODYSTRUCTURE " + structure(message.body)))
    } else if upper == "RFC822" {
      out.write_bytes(@utf8.encode("RFC822 "))
      literal_into(out, message.body)
    } else if upper == "RFC822.HEADER" {
      out.write_bytes(@utf8.encode("RFC822.HEADER "))
      literal_into(out, header_of(message.body))
    } else if upper == "RFC822.TEXT" {
      out.write_bytes(@utf8.encode("RFC822.TEXT "))
      literal_into(out, text_of(message.body))
      read = true
    } else if starts_with_section(item) {
      let (name, peek) = section_name(item)
      // The reply names the section, never the PEEK: it is how the client asked,
      // not what the message says (RFC 3501 section 6.4.5).
      let label = if peek { "BODY[" + name + "]" } else { upper }
      out.write_bytes(@utf8.encode(label + " "))
      literal_into(out, section_bytes(message.body, name))
      if !peek {
        read = true
      }
    } else {
      out.write_bytes(@utf8.encode(upper + " NIL"))
    }
  }
  // A UID command reports the UID whether the client asked for it or not.
  if uid && !named_uid {
    if !first {
      out.write_bytes(b" ")
    }
    out.write_bytes(@utf8.encode("UID " + message.uid.to_string()))
  }
  (@utf8.decode_lossy(out.to_bytes()[:]), read)
}

///|
fn literal_into(out : Buffer, data : BytesView) -> Unit {
  out.write_bytes(@utf8.encode("{" + data.length().to_string() + "}\r\n"))
  out.write_bytes(data)
}

///|
fn starts_with_section(item : String) -> Bool {
  let upper = item.to_upper()
  upper.has_prefix("BODY[") || upper.has_prefix("BODY.PEEK[")
}

///|
/// The section name without its `BODY`/`BODY.PEEK` wrapper, and whether the
/// client asked not to be told the message was read.
fn section_name(item : String) -> (String, Bool) {
  let upper = item.to_upper()
  // `BODY[` is five characters and `BODY.PEEK[` ten; the closing bracket ends
  // the section name.
  let start = if upper.has_prefix("BODY.PEEK[") { 10 } else { 5 }
  let end = if item.has_suffix("]") { item.length() - 1 } else { item.length() }
  (item[start:end].to_owned(), upper.has_prefix("BODY.PEEK["))
}

///|
/// The octets of one section of a message. A single-part message has one part,
/// so `1` is its text; a section the server does not know is empty.
fn section_bytes(body : Bytes, name : String) -> Bytes {
  let section = name[:]
  let bare = match section.find("<") {
    Some(cut) => section[:cut].to_owned()
    None => section.to_owned()
  }
  let upper = bare.to_upper()
  if upper == "" {
    body
  } else if upper == "HEADER" {
    header_of(body)
  } else if upper == "TEXT" {
    text_of(body)
  } else if upper.has_prefix("HEADER.FIELDS") {
    header_fields(body, bare)
  } else if upper == "1" || upper == "1.TEXT" {
    text_of(body)
  } else {
    b""
  }
}

///|
/// The headers of a message, ending with the blank line.
fn header_of(body : Bytes) -> Bytes {
  let (head, _) = split_message(@utf8.decode_lossy(body[:]))
  @utf8.encode(head)
}

///|
fn text_of(body : Bytes) -> Bytes {
  let (_, tail) = split_message(@utf8.decode_lossy(body[:]))
  @utf8.encode(tail)
}

///|
/// A message in its two halves: the header block with the blank line that ends
/// it, and everything after.
fn split_message(text : String) -> (String, String) {
  if text.find("\r\n\r\n") is Some(at) {
    (text[:at + 2].to_owned(), text[at + 4:].to_owned())
  } else if text.find("\n\n") is Some(at) {
    (text[:at + 1].to_owned(), text[at + 2:].to_owned())
  } else {
    (text, "")
  }
}

///|
/// `BODY[HEADER.FIELDS (...)]`: the named headers, in the order they appear,
/// with the blank line that closes them.
fn header_fields(body : Bytes, section : String) -> Bytes {
  let wanted = []
  let lower = section.to_upper()
  if lower.find("(") is Some(at) {
    let inner = section[at + 1:]
    let inner = match inner.find(")") {
      Some(end) => inner[:end].to_owned()
      None => inner.to_owned()
    }
    for word in inner.split(" ") {
      if word != "" {
        wanted.push(word.to_upper())
      }
    }
  }
  let head = @utf8.decode_lossy(header_of(body)[:])
  let out = Buffer()
  for line in head.split("\n") {
    let clean = line.trim_end(chars="\r")
    if clean == "" {
      continue
    }
    let field = match clean.find(":") {
      Some(at) => clean[:at].to_owned()
      None => clean.to_owned()
    }
    if wanted.contains(field.to_upper()) {
      out.write_bytes(@utf8.encode(clean + "\r\n"))
    }
  }
  out.write_bytes(b"\r\n")
  out.to_bytes()
}

///|
/// The envelope of a message, built from its headers (RFC 3501 section 7.4.2).
fn envelope(body : Bytes) -> String {
  let head = @utf8.decode_lossy(header_of(body)[:])
  let from = addresses(field(head, "From"))
  let sender = addresses(field(head, "Sender"))
  let reply = addresses(field(head, "Reply-To"))
  let to = addresses(field(head, "To"))
  let cc = addresses(field(head, "Cc"))
  let bcc = addresses(field(head, "Bcc"))
  "(" +
  nstring(field(head, "Date")) +
  " " +
  nstring(field(head, "Subject")) +
  " " +
  from +
  " " +
  sender +
  " " +
  reply +
  " " +
  to +
  " " +
  cc +
  " " +
  bcc +
  " " +
  nstring(field(head, "In-Reply-To")) +
  " " +
  nstring(field(head, "Message-ID")) +
  ")"
}

///|
/// A header value, its folded lines joined back into one.
fn field(head : String, name : String) -> String? {
  let wanted = name.to_upper()
  let joined = StringBuilder()
  let mut collecting = false
  for line in head.split("\n") {
    let clean = line.trim_end(chars="\r")
    if clean == "" {
      continue
    }
    if collecting && (clean.has_prefix(" ") || clean.has_prefix("\t")) {
      joined.write_string(" " + clean.trim(chars=" \t").to_owned())
      continue
    }
    collecting = false
    if clean.find(":") is Some(at) {
      if clean[:at].to_owned().to_upper() == wanted {
        collecting = true
        joined.write_string(clean[at + 1:].trim(chars=" ").to_owned())
      }
    }
  }
  let text = joined.to_string()
  if text == "" {
    None
  } else {
    Some(text)
  }
}

///|
/// An address list as the envelope wants it: a parenthesised list of
/// `(name route mailbox host)`, or NIL when there is none.
fn addresses(value : String?) -> String {
  guard value is Some(text) && text.trim(chars=" ") != "" else { return "NIL" }
  let parts = []
  for piece in text.split(",").to_array() {
    let address = piece.trim(chars=" ").to_owned()
    if address == "" {
      continue
    }
    let mut display : String? = None
    let mut rest = address
    if address.find("<") is Some(bracket) {
      display = Some(address[:bracket].to_owned().trim(chars=" \"").to_owned())
      rest = match address.find(">") {
        Some(close) => address[bracket + 1:close].to_owned()
        None => address[bracket + 1:].to_owned()
      }
    }
    let at = rest.find("@")
    let mailbox = match at {
      Some(at) => rest[:at].to_owned()
      None => rest
    }
    let host = match at {
      Some(at) => rest[at + 1:].to_owned()
      None => ""
    }
    parts.push(
      "(" +
      nstring(display) +
      " NIL " +
      nstring(Some(mailbox)) +
      " " +
      nstring(Some(host)) +
      ")",
    )
  }
  if parts.length() == 0 {
    "NIL"
  } else {
    "(" + parts.join(" ") + ")"
  }
}

///|
/// A string as IMAP writes one, or NIL.
fn nstring(text : String?) -> String {
  match text {
    Some(value) => as_quoted(value)
    None => "NIL"
  }
}

///|
/// The structure of a single-part message, which is what this server serves.
fn structure(body : Bytes) -> String {
  let head = @utf8.decode_lossy(header_of(body)[:])
  let kind = field(head, "Content-Type").unwrap_or("text/plain")
  let (main, rest) = match kind.find(";") {
    Some(at) => (kind[:at].to_owned(), kind[at + 1:].to_owned())
    None => (kind, "")
  }
  let (top, sub) = match main.find("/") {
    Some(at) => (main[:at].to_owned(), main[at + 1:].to_owned())
    None => (main, "plain")
  }
  let mut params = ""
  for piece in rest.split(";") {
    let pair = piece.trim(chars=" ").to_owned()
    if pair.find("=") is Some(at) {
      let key = pair[:at].to_owned().trim(chars=" ").to_owned().to_lower()
      let value = pair[at + 1:].to_owned().trim(chars=" \"").to_owned()
      if key == "charset" {
        params = "(\"charset\" " + as_quoted(value) + ")"
      }
    }
  }
  if params == "" {
    params = "NIL"
  }
  let text = text_of(body)
  let lines = if text.length() == 0 {
    0
  } else {
    @utf8.decode_lossy(text[:]).split("\n").count()
  }
  "(" +
  as_quoted(top.to_lower()) +
  " " +
  as_quoted(sub.to_lower()) +
  " " +
  params +
  " NIL NIL " +
  as_quoted(
    field(head, "Content-Transfer-Encoding").unwrap_or("7bit").to_lower(),
  ) +
  " " +
  text.length().to_string() +
  " " +
  lines.to_string() +
  ")"
}
