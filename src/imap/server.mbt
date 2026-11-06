// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// An IMAP4rev1 server (RFC 3501) with no I/O, serving the mailboxes of a
/// `Store`: octets in through `feed`, octets out through `next_write`.
///
/// The protocol's own answers it gives itself — syntax (`BAD`), sequence
/// (`BAD`), a mailbox that is not there (`NO`), the untagged responses a
/// `SELECT` owes, the `+` before a literal. The mailboxes live in memory and
/// die with the process, which is what makes this a reference server for
/// conformance runs rather than a mail server to deploy.
pub struct Server {
  priv store : Store
  priv credentials : (String, String) -> Bool
  priv clock : () -> String
  priv limits : Limits
  priv capabilities : Array[String]
  priv mut data : Bytes
  priv mut at : Int32
  priv out : Buffer
  priv mut state : State
  priv mut read_only : Bool
  priv mut tokens : Array[Token]
  priv mut want : Int32?
  priv mut idle : Bool
  priv mut last_idle : String
  priv mut flags_seen : Array[String]
}

///|
/// One word of a command: an atom or a quoted string, a literal, or the two
/// brackets that group `BODY[HEADER.FIELDS (DATE)]`.
priv enum Token {
  Word(String)
  Literal(Bytes)
  Open
  Close
}

///|
/// What the server announces in its greeting and to `CAPABILITY`.
pub let supported : Array[String] = [
  "IMAP4rev1", "AUTH=PLAIN", "ENABLE", "ID", "IDLE", "LITERAL+", "MOVE", "NAMESPACE",
  "SASL-IR", "UIDPLUS", "UNSELECT",
]

///|
/// `Server::new(store=..., credentials=...)`, where `credentials` says whether
/// a user name and password are the pair it knows, and `clock` gives
/// `INTERNALDATE` for a message that arrived without one, in IMAP's own format:
/// `"06-Nov-2026 12:00:00 +0000"`.
pub fn Server::new(
  store~ : Store,
  credentials~ : (String, String) -> Bool,
  clock~ : () -> String,
  limits~ : Limits = limits,
) -> Server {
  {
    store,
    credentials,
    clock,
    limits,
    capabilities: supported.copy(),
    data: b"",
    at: 0,
    out: Buffer(),
    state: NotAuthenticated,
    read_only: false,
    tokens: [],
    want: None,
    idle: false,
    last_idle: "",
    flags_seen: [],
  }
}

///|
/// The state the session is in.
pub fn Server::state(self : Server) -> State {
  self.state
}

///|
/// Take the client's octets and answer them: what the session has to send is
/// then in `next_write`.
pub fn Server::feed(self : Server, data : BytesView) -> Unit raise Refused {
  let joined = Buffer()
  joined.write_bytes(self.data[self.at:])
  joined.write_bytes(data)
  self.data = joined.to_bytes()
  self.at = 0
  while true {
    match self.want {
      Some(n) => {
        if self.data.length() - self.at < n {
          return
        }
        self.tokens.push(Literal(self.data[self.at:self.at + n].to_owned()))
        self.at += n
        self.want = None
        continue
      }
      None => ()
    }
    let mut end = self.at
    while end < self.data.length() && self.data[end] != b'\n' {
      end += 1
    }
    if end == self.data.length() {
      return
    }
    if end - self.at > self.limits.line {
      raise Exceeded(limit=self.limits.line, got=end - self.at)
    }
    let mut line = self.data[self.at:end]
    self.at = end + 1
    if line.length() > 0 && line[line.length() - 1] == b'\r' {
      line = line[:line.length() - 1]
    }
    // A line that ends in `{n}` promises n octets after it; the rest of the
    // command resumes on the line after those.
    if wants_literal(line) is Some(size) {
      let plus = has_plus(line)
      let mut cut = line.length() - 1
      while cut >= 0 && line[cut] != b'{' {
        cut -= 1
      }
      if cut > 0 {
        self.words(line[:cut])
      }
      if !plus {
        // The client waits for this before it sends the octets (RFC 3501
        // section 4.3); a client that announced LITERAL+ does not.
        self.out.write_bytes(@utf8.encode("+ Ready for literal data\r\n"))
      }
      if size == 0 {
        self.tokens.push(Literal(b""))
      } else {
        self.want = Some(size)
      }
      continue
    }
    self.words(line)
    let tokens = self.tokens
    self.tokens = []
    self.run(tokens)
  }
}

///|
/// The reply octets due, if any.
pub fn Server::next_write(self : Server) -> Bytes? {
  if self.out.is_empty() {
    None
  } else {
    let out = self.out.to_bytes()
    self.out.reset()
    Some(out)
  }
}

///|
/// Whether the literal marker on this line carries a `+`, which tells the server
/// the octets follow without waiting.
fn has_plus(line : BytesView) -> Bool {
  let end = line.length()
  guard end > 2 && line[end - 1] == b'}' else { false }
  let mut i = end - 2
  while i >= 0 && line[i] >= b'0' && line[i] <= b'9' {
    i -= 1
  }
  i >= 0 && line[i] == b'+'
}

///|
/// Whether a line promises a literal and, if so, how many octets.
fn wants_literal(line : BytesView) -> Int32? {
  let end = line.length()
  guard end > 2 && line[end - 1] == b'}' else { None }
  let mut i = end - 2
  if i >= 0 && line[i] == b'+' {
    i -= 1
  }
  let mut n = 0L
  let mut count = 0
  while i >= 0 && line[i] >= b'0' && line[i] <= b'9' {
    i -= 1
    count += 1
  }
  guard count > 0 && count <= 9 && i >= 0 && line[i] == b'{' else { None }
  for j in (i + 1)..<(end - 1) {
    if line[j] >= b'0' && line[j] <= b'9' {
      n = n * 10 + (line[j] - b'0').to_int64()
    }
  }
  if n > 0x7FFFFFFFL {
    None
  } else {
    Some(n.to_int())
  }
}

///|
/// Split a piece of a command line into words, quoted strings and brackets.
fn Server::words(self : Server, line : BytesView) -> Unit {
  let mut i = 0
  let view = line
  while i < view.length() {
    let c = view[i]
    if c == b' ' {
      i += 1
      continue
    }
    if c == b'(' {
      self.tokens.push(Open)
      i += 1
      continue
    }
    if c == b')' {
      self.tokens.push(Close)
      i += 1
      continue
    }
    if c == b'"' {
      i += 1
      let word = Buffer()
      while i < view.length() && view[i] != b'"' {
        if view[i] == b'\\' && i + 1 < view.length() {
          i += 1
        }
        word.write_byte(view[i])
        i += 1
      }
      i += 1
      self.tokens.push(Word(@utf8.decode_lossy(word.to_bytes()[:])))
      continue
    }
    let start = i
    while i < view.length() &&
          view[i] != b' ' &&
          view[i] != b'(' &&
          view[i] != b')' {
      i += 1
    }
    self.tokens.push(Word(@utf8.decode_lossy(view[start:i])))
  }
}

///|
/// Write one untagged line.
fn Server::untagged(self : Server, text : String) -> Unit {
  self.out.write_bytes(@utf8.encode("* " + text + "\r\n"))
}

///|
/// Write a tagged completion.
fn Server::done(
  self : Server,
  tag : String,
  status : String,
  code~ : String = "",
  text~ : String = "",
) -> Unit {
  let mut line = tag + " " + status
  if code != "" {
    line = line + " [" + code + "]"
  }
  if text != "" {
    line = line + " " + text
  }
  self.out.write_bytes(@utf8.encode(line + "\r\n"))
}

///|
fn Server::ok(
  self : Server,
  tag : String,
  text~ : String = "",
  code~ : String = "",
) -> Unit {
  self.done(tag, "OK", code~, text~)
}

///|
fn Server::no(self : Server, tag : String, text~ : String = "") -> Unit {
  self.done(tag, "NO", text~)
}

///|
fn Server::bad(self : Server, tag : String, text~ : String = "") -> Unit {
  self.done(tag, "BAD", text~)
}
