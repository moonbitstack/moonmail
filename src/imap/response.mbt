// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// What a session cannot go on with: a response that does not parse, one over
/// its limit, a command asked for in the wrong state, or one that needs a
/// capability the server did not announce.
#derive(Eq, Debug)
pub(all) suberror Refused {
  Malformed(String)
  Exceeded(limit~ : Int32, got~ : Int32)
  Order(String)
  Unsupported(String)
}

///|
pub extend Refused with Eq::{equal, not_equal}

///|
pub extend Refused with Debug::{to_repr}

///|
/// How much a client takes from the server.
///
/// - `line`: the longest response line, CRLF and literals excluded; Python
///   `imaplib`'s `_MAXLINE`.
/// - `literal`: the largest literal, which is how messages arrive; 150 MB,
///   the largest message Exchange Online lets an administrator allow.
#derive(Eq, Debug)
pub(all) struct Limits {
  line : Int32
  literal : Int32
}

///|
pub extend Limits with Eq::{equal, not_equal}

///|
pub extend Limits with Debug::{to_repr}

///|
pub let limits : Limits = { line: 1000000, literal: 157286400, }

///|
pub fn Limits::new(
  line~ : Int32 = limits.line,
  literal~ : Int32 = limits.literal,
) -> Limits {
  { line, literal, }
}

///|
/// A piece of a response, as RFC 9051's grammar builds them: `NIL`, a number,
/// an atom, a string (quoted or literal, as octets), or a parenthesised list.
/// A fetch key such as `BODY[HEADER.FIELDS (DATE)]<0>` is one atom.
///
/// A literal8 (RFC 3516) is `Text` too: it is octets that are not necessarily
/// text, but they are carried exactly as they arrived, and `text()` is what
/// asks for an interpretation rather than `Text` being one.
#derive(Eq, Debug)
pub(all) enum Value {
  Nil
  Number(Int64)
  Atom(String)
  Text(Bytes)
  List(Array[Value])
}

///|
pub extend Value with Eq::{equal, not_equal}

///|
pub extend Value with Debug::{to_repr}

///|
/// The value as text: a string's octets as UTF-8, an atom or number as
/// written; `None` for `NIL` and lists.
pub fn Value::text(self : Value) -> String? {
  match self {
    Text(data) => Some(@utf8.decode_lossy(data[:]))
    Atom(atom) => Some(atom)
    Number(n) => Some(n.to_string())
    Nil | List(_) => None
  }
}

///|
/// The value as a number, when it is one.
pub fn Value::number(self : Value) -> Int64? {
  match self {
    Number(n) => Some(n)
    _ => None
  }
}

///|
/// The value as a list; `NIL` reads as an empty one.
pub fn Value::list(self : Value) -> Array[Value]? {
  match self {
    List(items) => Some(items)
    Nil => Some([])
    _ => None
  }
}

///|
/// How a tagged command completed.
#derive(Eq, Debug)
pub(all) enum Status {
  Ok
  No
  Bad
}

///|
pub extend Status with Eq::{equal, not_equal}

///|
pub extend Status with Debug::{to_repr}

///|
/// A response code, the bracketed part of a status response (RFC 9051
/// section 7.1, RFC 4315, RFC 7162). One this package does not know comes as
/// `Other` with its name and the text after it.
#derive(Eq, Debug)
pub(all) enum Code {
  Alert
  Capability(Array[String])
  PermanentFlags(Array[String])
  ReadOnly
  ReadWrite
  TryCreate
  UidNext(Int64)
  UidValidity(Int64)
  HighestModseq(Int64)
  NoModseq
  Modified(String)
  AppendUid(Int64, String)
  CopyUid(Int64, String, String)
  Closed
  Other(String, String?)
}

///|
pub extend Code with Eq::{equal, not_equal}

///|
pub extend Code with Debug::{to_repr}

///|
/// Which mailboxes a listing covers: `LIST` returns every one the pattern
/// matches, `LSUB` only those the user subscribed to (RFC 9051 section 6.3.9).
/// The replies have the same shape, so the two are one value carrying the
/// command that asked for it rather than one value losing the difference.
#derive(Eq, Debug)
pub(all) enum Listing {
  All
  Subscribed
}

///|
pub extend Listing with Eq::{equal, not_equal}

///|
pub extend Listing with Debug::{to_repr}

///|
/// An untagged response (RFC 9051 section 7). `Condition` is an untagged
/// `OK`, `NO`, `BAD`, `PREAUTH` or `BYE`. A `Fetch` maps each data item's name,
/// in upper case and as written for `BODY[...]`, to its value. A response this
/// package does not know comes as `Other`, its name and its values.
///
/// `List` is both a `LIST` and an `LSUB`, told apart by `listing`. Its
/// `extended` is the return data of a LIST-EXTENDED reply (RFC 5258), the
/// `(childinfo (subscribed))` after the name, as a flat list of names and
/// values; empty when the reply carries none.
#derive(Eq, Debug)
pub(all) enum Response {
  Condition(String, Code?, String)
  Capability(Array[String])
  Enabled(Array[String])
  Flags(Array[String])
  Exists(Int64)
  Expunge(Int64)
  List(
    listing~ : Listing,
    flags~ : Array[String],
    delimiter~ : String?,
    name~ : String,
    extended~ : Array[Value]
  )
  Status(String, Map[String, Int64])
  Esearch(tag~ : String?, uid~ : Bool, items~ : Map[String, Value])
  Search(Array[Int64], modseq~ : Int64?)
  Fetch(Int64, Map[String, Value])
  Namespace(Value, Value, Value)
  Other(String, Array[Value])
}

///|
pub extend Response with Eq::{equal, not_equal}

///|
pub extend Response with Debug::{to_repr}

///|
/// One response as it arrived, before decoding: untagged, a continuation
/// request, or the completion of a tagged command.
priv enum Raw {
  Untagged(Response)
  Continue(String)
  Tagged(String, Status, Code?, String)
}

///|
/// Where the response that starts at `start` ends, once all of it is in: past
/// the CRLF of its last line, its literals included.
fn complete(
  data : Bytes,
  start : Int32,
  limits : Limits,
) -> Int32? raise Refused {
  let mut at = start
  while true {
    let mut end = at
    while end < data.length() && data[end] != b'\n' {
      end += 1
    }
    if end - at > limits.line {
      raise Exceeded(limit=limits.line, got=end - at)
    }
    if end == data.length() {
      return None
    }
    match literal_size(data[at:end]) {
      Some(n) => {
        if n > limits.literal {
          raise Exceeded(limit=limits.literal, got=n)
        }
        if end + 1 + n > data.length() {
          return None
        }
        at = end + 1 + n
      }
      None => return Some(end + 1)
    }
  }
  None
}

///|
/// The size a line announces with a closing `{n}`, CR or not.
fn literal_size(line : BytesView) -> Int32? {
  let mut end = line.length()
  if end > 0 && line[end - 1] == b'\r' {
    end -= 1
  }
  guard end > 2 && line[end - 1] == b'}' else { None }
  let mut i = end - 2
  let mut n = 0L
  let mut digits = 0
  while i >= 0 && line[i] >= b'0' && line[i] <= b'9' {
    i -= 1
    digits += 1
  }
  guard digits > 0 && digits <= 10 && i >= 0 && line[i] == b'{' else { None }
  for j in (i + 1)..<(end - 1) {
    n = n * 10 + (line[j] - b'0').to_int64()
  }
  if n > 0x7FFFFFFFL {
    None
  } else {
    Some(n.to_int())
  }
}

///|
/// A cursor over one complete response.
priv struct Scan {
  data : BytesView
  mut at : Int32
}

///|
fn Scan::peek(self : Scan) -> Byte? {
  if self.at < self.data.length() {
    Some(self.data[self.at])
  } else {
    None
  }
}

///|
fn Scan::eat(self : Scan, b : Byte) -> Bool {
  if self.peek() == Some(b) {
    self.at += 1
    true
  } else {
    false
  }
}

///|
fn Scan::space(self : Scan) -> Unit raise Refused {
  if !self.eat(b' ') {
    raise Malformed("expected a space at " + self.at.to_string())
  }
}

///|
/// Whether the line has ended: CRLF, a bare LF, or nothing left.
fn Scan::at_end(self : Scan) -> Bool {
  match self.peek() {
    None | Some(b'\r') | Some(b'\n') => true
    _ => false
  }
}

///|
/// The rest of the line, as text.
fn Scan::rest(self : Scan) -> String {
  let start = self.at
  while !self.at_end() {
    self.at += 1
  }
  @utf8.decode_lossy(self.data[start:self.at])
}

///|
/// An atom, a bracketed section and a `<partial>` included, so that
/// `BODY[HEADER.FIELDS (DATE)]<0>` is one word.
fn Scan::atom(self : Scan) -> String raise Refused {
  let start = self.at
  while self.peek() is Some(b) {
    if b == b'[' {
      let mut depth = 0
      while self.peek() is Some(c) {
        self.at += 1
        if c == b'[' {
          depth += 1
        } else if c == b']' {
          depth -= 1
          if depth == 0 {
            break
          }
        } else if c == b'\r' || c == b'\n' {
          raise Malformed("an unclosed [ in an atom")
        }
      }
      continue
    }
    if b == b' ' ||
      b == b'(' ||
      b == b')' ||
      b == b'{' ||
      b == b'"' ||
      b == b'\r' ||
      b == b'\n' ||
      b == b']' ||
      b < b' ' {
      break
    }
    self.at += 1
  }
  if self.at == start {
    raise Malformed("expected an atom at " + start.to_string())
  }
  @utf8.decode_lossy(self.data[start:self.at])
}

///|
fn Scan::value(self : Scan) -> Value raise Refused {
  match self.peek() {
    Some(b'(') => {
      self.at += 1
      let items = []
      while !self.eat(b')') {
        if items.length() > 0 && !self.eat(b' ') {
          // A list may follow the one before it with no space between them, as
          // a thread's do: `(1 (2 4)(3))`.
          guard self.peek() is Some(b'(') else {
            raise Malformed("expected a space at " + self.at.to_string())
          }
        }
        if self.eat(b')') {
          break
        }
        items.push(self.value())
      }
      List(items)
    }
    Some(b'"') => {
      self.at += 1
      let out = Buffer()
      while true {
        match self.peek() {
          None | Some(b'\r') | Some(b'\n') =>
            raise Malformed("an unclosed quoted string")
          Some(b'"') => {
            self.at += 1
            break
          }
          Some(b'\\') => {
            self.at += 1
            guard self.peek() is Some(c) else {
              raise Malformed("an unclosed quoted string")
            }
            out.write_byte(c)
            self.at += 1
          }
          Some(c) => {
            out.write_byte(c)
            self.at += 1
          }
        }
      }
      Text(out.to_bytes())
    }
    Some(b'{') | Some(b'~') => {
      let _ = self.eat(b'~')
      let start = self.at
      while self.peek() is Some(c) && c != b'\n' {
        self.at += 1
      }
      guard literal_size(self.data[start:self.at]) is Some(n) &&
        self.eat(b'\n') &&
        self.at + n <= self.data.length() else {
        raise Malformed("a malformed literal at " + start.to_string())
      }
      let data = self.data[self.at:self.at + n].to_owned()
      self.at += n
      Text(data)
    }
    _ => {
      let atom = self.atom()
      if atom.to_upper() == "NIL" {
        Nil
      } else if number(atom) is Some(n) {
        Number(n)
      } else {
        Atom(atom)
      }
    }
  }
}

///|
/// Values to the end of the line. RFC 5256 writes a thread's lists one after
/// another with no space between them — `* THREAD (2)(3)` — so a value that is
/// a list may follow the one before it directly.
fn Scan::values(self : Scan) -> Array[Value] raise Refused {
  let out = []
  while !self.at_end() {
    if !self.eat(b' ') {
      guard self.peek() is Some(b'(') else { break }
    }
    if self.at_end() {
      break
    }
    out.push(self.value())
  }
  out
}

///|
/// A status response's optional `[code]`, and its text.
fn Scan::condition(self : Scan) -> (Code?, String) raise Refused {
  if !self.eat(b' ') {
    return (None, "")
  }
  let code = if self.eat(b'[') {
    let name = self.atom().to_upper()
    let start = self.at
    let mut depth = 0
    while self.peek() is Some(c) && !(c == b']' && depth == 0) {
      if c == b'\r' || c == b'\n' {
        raise Malformed("an unclosed response code")
      }
      if c == b'(' {
        depth += 1
      } else if c == b')' {
        depth -= 1
      }
      self.at += 1
    }
    let args = @utf8.decode_lossy(self.data[start:self.at]).trim().to_owned()
    let _ = self.eat(b']')
    let _ = self.eat(b' ')
    Some(code_of(name, args))
  } else {
    None
  }
  (code, self.rest())
}

///|
fn code_of(name : String, args : String) -> Code {
  let words = args.split(" ").filter(w => !w.is_empty()).to_array()
  let flags = () => {
    args
    .trim(chars="()")
    .split(" ")
    .filter(w => !w.is_empty())
    .map(w => w.to_owned())
    .to_array()
  }
  match (name, words) {
    ("ALERT", []) => Alert
    ("CAPABILITY", _) => Capability(words.map(w => w.to_owned()))
    ("PERMANENTFLAGS", _) => PermanentFlags(flags())
    ("READ-ONLY", []) => ReadOnly
    ("READ-WRITE", []) => ReadWrite
    ("TRYCREATE", []) => TryCreate
    ("UIDNEXT", [n]) if number(n) is Some(v) => UidNext(v)
    ("UIDVALIDITY", [n]) if number(n) is Some(v) => UidValidity(v)
    ("HIGHESTMODSEQ", [n]) if number(n) is Some(v) => HighestModseq(v)
    ("NOMODSEQ", []) => NoModseq
    ("MODIFIED", [set]) => Modified(set.to_owned())
    ("APPENDUID", [v, uids]) if number(v) is Some(validity) =>
      AppendUid(validity, uids.to_owned())
    ("COPYUID", [v, from, to]) if number(v) is Some(validity) =>
      CopyUid(validity, from.to_owned(), to.to_owned())
    ("CLOSED", []) => Closed
    _ => Other(name, if args.is_empty() { None } else { Some(args) })
  }
}

///|
/// Read one complete response.
fn parse(data : BytesView) -> Raw raise Refused {
  let scan = { data, at: 0, }
  if scan.eat(b'+') {
    let _ = scan.eat(b' ')
    return Continue(scan.rest())
  }
  if scan.eat(b'*') {
    scan.space()
    return Untagged(untagged(scan))
  }
  let tag = scan.atom()
  scan.space()
  let status = match scan.atom().to_upper() {
    "OK" => Ok
    "NO" => No
    "BAD" => Bad
    word =>
      raise Malformed("a tagged response ends in OK, NO or BAD, not " + word)
  }
  let (code, text) = scan.condition()
  Tagged(tag, status, code, text)
}

///|
fn untagged(scan : Scan) -> Response raise Refused {
  let first = scan.atom()
  if number(first) is Some(n) {
    scan.space()
    let kind = scan.atom().to_upper()
    return match kind {
      "EXISTS" => Exists(n)
      "EXPUNGE" => Expunge(n)
      "FETCH" => {
        scan.space()
        guard scan.value() is List(items) && items.length() % 2 == 0 else {
          raise Malformed("FETCH data is a list of names and values")
        }
        let out = Map([])
        for i = 0; i < items.length(); i = i + 2 {
          guard items[i] is Atom(key) else {
            raise Malformed("a FETCH data item needs a name")
          }
          out[key.to_upper()] = items[i + 1]
        }
        Fetch(n, out)
      }
      _ => Other(kind, [Number(n)] + scan.values())
    }
  }
  let name = first.to_upper()
  match name {
    "OK" | "NO" | "BAD" | "PREAUTH" | "BYE" => {
      let (code, text) = scan.condition()
      Condition(name, code, text)
    }
    "CAPABILITY" => Capability(words(scan.values()))
    "ENABLED" => Enabled(words(scan.values()))
    "FLAGS" => {
      scan.space()
      Flags(words(scan.value().list().unwrap_or([])))
    }
    "LIST" | "LSUB" => {
      scan.space()
      let flags = words(scan.value().list().unwrap_or([]))
      scan.space()
      let delimiter = scan.value().text()
      scan.space()
      guard scan.value().text() is Some(mailbox) else {
        raise Malformed("LIST needs a mailbox name")
      }
      // Whatever follows the name is the return data of LIST-EXTENDED
      // (RFC 5258 section 3.1): a parenthesised list of `name value` pairs,
      // kept flat, the way a FETCH's items are.
      let tail = scan.values()
      let extended = match tail {
        [List(items)] => items
        _ => tail
      }
      List(
        listing=if name == "LSUB" { Subscribed } else { All },
        flags~,
        delimiter~,
        name=mailbox,
        extended~,
      )
    }
    "STATUS" => {
      scan.space()
      guard scan.value().text() is Some(mailbox) else {
        raise Malformed("STATUS needs a mailbox name")
      }
      scan.space()
      let items = scan.value().list().unwrap_or([])
      let out = Map([])
      for i = 0; i + 1 < items.length(); i = i + 2 {
        if items[i] is Atom(key) && items[i + 1] is Number(v) {
          out[key.to_upper()] = v
        }
      }
      Status(mailbox, out)
    }
    "SEARCH" => {
      let numbers = []
      let mut modseq = None
      for value in scan.values() {
        match value {
          Number(n) => numbers.push(n)
          List([Atom(word), Number(m)]) if word.to_upper() == "MODSEQ" =>
            modseq = Some(m)
          _ => raise Malformed("SEARCH returns numbers")
        }
      }
      Search(numbers, modseq~)
    }
    "ESEARCH" => {
      let values = scan.values()
      let mut tag = None
      let mut i = 0
      if values is [List([Atom(word), Text(t)]), ..] && word.to_upper() == "TAG" {
        tag = Some(@utf8.decode_lossy(t[:]))
        i = 1
      }
      let mut uid = false
      if i < values.length() &&
        values[i] is Atom(word) &&
        word.to_upper() == "UID" {
        uid = true
        i += 1
      }
      let items = Map([])
      while i + 1 < values.length() {
        if values[i] is Atom(key) {
          items[key.to_upper()] = values[i + 1]
        }
        i += 2
      }
      Esearch(tag~, uid~, items~)
    }
    "NAMESPACE" =>
      match scan.values() {
        [personal, others, shared] => Namespace(personal, others, shared)
        _ => raise Malformed("NAMESPACE has three parts")
      }
    _ => Other(name, scan.values())
  }
}

///|
fn words(values : Array[Value]) -> Array[String] {
  values.filter_map(v => v.text())
}

///|
/// A non-negative decimal number, digits only.
fn number(text : StringView) -> Int64? {
  if text.is_empty() || text.length() > 19 {
    return None
  }
  let mut n = 0L
  for c in text {
    guard c >= '0' && c <= '9' else { return None }
    n = n * 10 + (c.to_int() - '0'.to_int()).to_int64()
  }
  Some(n)
}
