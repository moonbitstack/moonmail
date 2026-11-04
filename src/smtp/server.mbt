// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// What a client asks of the server that the application decides. `Rset` and
/// `Quit` are already answered and only tell the application that the
/// transaction, or the session, is over.
///
/// `Auth` carries the mechanism name in upper case and the first response, when
/// the client sent one on the command line; `Response` is the client's answer
/// to a `challenge`. `Mail` and `Rcpt` carry the path and the parameters, each
/// keyword in upper case with its value as written, `None` for a keyword with
/// no value. `Data` is the whole message, dot-unstuffed, or every `BDAT` chunk
/// joined.
#derive(Eq, Debug)
pub(all) enum Request {
  Hello(String, extended~ : Bool)
  StartTls
  Auth(String, Bytes?)
  Response(Bytes)
  Mail(String, Map[String, String?])
  Rcpt(String, Map[String, String?])
  Data(Bytes)
  Vrfy(String)
  Expn(String)
  Rset
  Quit
}

///|
pub extend Request with Eq::{equal, not_equal}

///|
pub extend Request with Debug::{to_repr}

///|
enum Phase {
  Commands
  Content
  Chunk(Int32, Bool)
  Sasl
}

///|
/// An SMTP or LMTP server with no I/O. `feed` takes the client's octets,
/// `next` hands out what the application must decide, and `next_write` gives
/// the replies to send.
///
/// The protocol's own answers it gives itself: syntax (`500`, `501`), sequence
/// (`503`), unknown parameters (`555`), lines over `limits.line`, recipients
/// over `limits.recipients` (`452`), messages over `limits.size` (`552`), the
/// `354` before the message and the replies to `NOOP`, `HELP`, `RSET`, `QUIT`
/// and the `BDAT` chunks before the last. Every request `next` returns, except
/// `Rset` and `Quit`, waits for `accept`, `reply` or `challenge`; until it gets
/// one, `next` returns `None`, so pipelined commands are taken one at a time in
/// order. Under LMTP the message is answered once per accepted recipient.
///
/// The `EHLO` reply announces `PIPELINING`, `SIZE`, `8BITMIME`, `BINARYMIME`,
/// `CHUNKING`, `SMTPUTF8`, `DSN` and `ENHANCEDSTATUSCODES`; `STARTTLS` when
/// `starttls` is set and TLS has not started; and `AUTH` with the `auth`
/// mechanisms, which, when `starttls` is set, only once TLS has started, so
/// that no password crosses in clear.
pub struct Server {
  priv name : String
  priv lmtp : Bool
  priv starttls : Bool
  priv mechanisms : Array[String]
  priv limits : Limits
  priv inbox : Inbox
  priv out : Buffer
  priv message : Buffer
  priv mut phase : Phase
  priv mut awaiting : Request?
  priv mut due : Int32
  priv mut refusal : Reply?
  priv mut overflow : Bool
  priv mut skipping : Bool
  priv mut hello : Bool
  priv mut tls : Bool
  priv mut authenticated : Bool
  priv mut mail : Bool
  priv mut binary : Bool
  priv mut utf8 : Bool
  priv mut recipients : Int32
  priv mut closed : Bool
}

///|
/// A server that calls itself `name` in its greeting and replies. `greeting`
/// follows the name on the `220` line, `ESMTP` or `LMTP` when not given.
pub fn Server::new(
  name : String,
  lmtp~ : Bool = false,
  starttls~ : Bool = false,
  auth~ : Array[String] = [],
  greeting? : String,
  limits~ : Limits = limits,
) -> Server {
  let server = {
    name,
    lmtp,
    starttls,
    mechanisms: auth.map(m => m.to_upper()),
    limits,
    inbox: Inbox::new(),
    out: Buffer(),
    message: Buffer(),
    phase: Commands,
    awaiting: None,
    due: 0,
    refusal: None,
    overflow: false,
    skipping: false,
    hello: false,
    tls: false,
    authenticated: false,
    mail: false,
    binary: false,
    utf8: false,
    recipients: 0,
    closed: false,
  }
  let text = greeting.unwrap_or(if lmtp { "LMTP" } else { "ESMTP" })
  server.send(220, name + " " + text)
  server
}

///|
/// Take octets from the client.
pub fn Server::feed(self : Server, data : BytesView) -> Unit {
  self.inbox.push(data)
}

///|
/// The replies to send now, if any.
pub fn Server::next_write(self : Server) -> Bytes? {
  if self.out.is_empty() {
    return None
  }
  let out = self.out.to_bytes()
  self.out.reset()
  Some(out)
}

///|
/// Whether the session is over: `QUIT` was answered, or a `421` sent.
pub fn Server::closed(self : Server) -> Bool {
  self.closed
}

///|
/// The next request for the application, or `None` while the octets for one
/// have not arrived or the last one is still unanswered.
pub fn Server::next(self : Server) -> Request? {
  while !self.closed && self.awaiting is None {
    match self.phase {
      Commands => {
        if self.skipping {
          if !self.inbox.skip_line() {
            return None
          }
          self.skipping = false
        }
        match self.inbox.line(self.limits.line) {
          More => return None
          Long(_, complete~) => {
            self.skipping = !complete
            self.send(500, "5.5.2 Line too long")
          }
          Got(line) =>
            if self.command(line) is Some(request) {
              return Some(request)
            }
        }
      }
      Content =>
        match self.inbox.crlf_line() {
          None => return None
          Some(line) =>
            if line == b".\r\n"[:] {
              self.phase = Commands
              if self.finish() is Some(request) {
                return Some(request)
              }
            } else {
              let stuffed = line.length() > 2 && line[0] == b'.'
              self.gather(if stuffed { line[1:] } else { line })
            }
        }
      Chunk(left, last) => {
        let piece = self.inbox.take(left)
        if self.refusal is None {
          self.gather(piece)
        }
        if piece.length() < left {
          self.phase = Chunk(left - piece.length(), last)
          return None
        }
        self.phase = Commands
        match self.refusal {
          Some(reply) => {
            self.refusal = None
            self.out.write_bytes(reply.encode())
          }
          None =>
            if self.overflow || !last {
              if self.finish_chunk(last) is Some(request) {
                return Some(request)
              }
            } else if self.finish() is Some(request) {
              return Some(request)
            }
        }
      }
      Sasl =>
        match self.inbox.line(self.limits.line) {
          More => return None
          Long(_, complete~) => {
            self.skipping = !complete
            self.phase = Commands
            self.send(500, "5.5.2 Line too long")
          }
          Got(line) =>
            if line == "*" {
              self.phase = Commands
              self.send(501, "5.0.0 Authentication cancelled")
            } else {
              let data = @base64.decode(line[:]) catch {
                _ => {
                  self.phase = Commands
                  self.send(501, "5.5.2 Cannot decode response")
                  continue
                }
              }
              return self.wait(Response(data))
            }
        }
    }
  }
  None
}

///|
/// Give the request in front its usual positive reply.
pub fn Server::accept(self : Server) -> Unit raise Refused {
  guard self.awaiting is Some(request) else {
    raise Order("no request awaits an answer")
  }
  let reply = match request {
    Hello(domain, ..) => Reply::new(250, self.name + " Hello " + domain)
    StartTls => Reply::new(220, "2.0.0 Ready to start TLS")
    Auth(_, _) | Response(_) =>
      Reply::new(235, "2.7.0 Authentication successful")
    Mail(_, _) => Reply::new(250, "2.1.0 Ok")
    Rcpt(_, _) => Reply::new(250, "2.1.5 Ok")
    Data(_) => Reply::new(250, "2.0.0 Ok: queued")
    Vrfy(_) | Expn(_) =>
      Reply::new(
        252, "2.0.0 Cannot verify, but will accept the message and try delivery",
      )
    Rset | Quit => Reply::new(250, "2.0.0 Ok")
  }
  self.answer(request, reply)
}

///|
/// Answer the request in front with `code` and `text`, its lines cut at `\n`.
/// A positive answer to `EHLO` gets the extension lines after `text`.
pub fn Server::reply(
  self : Server,
  code : Int32,
  text : String,
) -> Unit raise Refused {
  guard self.awaiting is Some(request) else {
    raise Order("no request awaits an answer")
  }
  if code < 200 || code > 599 {
    raise Malformed("a reply code is from 200 to 599")
  }
  self.answer(request, Reply::new(code, text))
}

///|
/// Send a SASL challenge (`334`) to the `Auth` or `Response` in front; the
/// client's answer comes back as `Response`.
pub fn Server::challenge(self : Server, data : BytesView) -> Unit raise Refused {
  guard self.awaiting is Some(Auth(_, _) | Response(_)) else {
    raise Order("a challenge answers Auth or Response")
  }
  self.awaiting = None
  self.phase = Sasl
  // The space stays when the challenge is empty, as RFC 4954's examples show.
  self.out.write_bytes(@utf8.encode("334 " + @base64.encode(data) + "\r\n"))
}

///|
fn Server::answer(self : Server, request : Request, reply : Reply) -> Unit {
  let mut reply = reply
  match request {
    Hello(_, extended~) =>
      if reply.is_ok() {
        self.hello = true
        self.reset()
        if extended {
          reply = { code: reply.code, lines: reply.lines + self.extensions(), }
        }
      }
    StartTls => ()
    Auth(_, _) | Response(_) => {
      self.phase = Commands
      if reply.code == 235 {
        self.authenticated = true
      }
    }
    Mail(_, params) =>
      if reply.is_ok() {
        self.mail = true
        self.binary = params.get("BODY") is Some(Some("BINARYMIME"))
        self.utf8 = params.contains("SMTPUTF8")
        self.recipients = 0
      }
    Rcpt(_, _) => if reply.is_ok() { self.recipients += 1 }
    Data(_) => {
      self.due -= 1
      if self.due > 0 {
        self.out.write_bytes(reply.encode())
        return
      }
      self.reset()
    }
    Vrfy(_) | Expn(_) | Rset | Quit => ()
  }
  self.awaiting = None
  self.out.write_bytes(reply.encode())
  if request is StartTls && reply.code == 220 {
    // RFC 3207 section 4.2: the session starts over under TLS, and octets the
    // client sent after STARTTLS were not protected, so they are dropped.
    self.tls = true
    self.hello = false
    self.authenticated = false
    self.reset()
    self.inbox.at = self.inbox.data.length()
  }
  if reply.code == 421 {
    self.closed = true
  }
}

///|
fn Server::extensions(self : Server) -> Array[String] {
  let out = [
    "PIPELINING",
    "SIZE " + self.limits.size.to_string(),
    "8BITMIME",
    "BINARYMIME",
    "CHUNKING",
    "SMTPUTF8",
    "DSN",
    "ENHANCEDSTATUSCODES",
  ]
  if self.starttls && !self.tls {
    out.push("STARTTLS")
  }
  if self.auth_offered() {
    out.push("AUTH " + self.mechanisms.join(" "))
  }
  out
}

///|
fn Server::auth_offered(self : Server) -> Bool {
  !self.mechanisms.is_empty() && (self.tls || !self.starttls)
}

///|
fn Server::send(self : Server, code : Int32, text : String) -> Unit {
  self.out.write_bytes(Reply::new(code, text).encode())
}

///|
fn Server::reset(self : Server) -> Unit {
  self.mail = false
  self.binary = false
  self.utf8 = false
  self.recipients = 0
  self.message.reset()
  self.overflow = false
}

///|
fn Server::wait(self : Server, request : Request) -> Request? {
  self.awaiting = Some(request)
  Some(request)
}

///|
/// Act on one command line: answer it, or hand it to the application.
fn Server::command(self : Server, line : String) -> Request? {
  let (verb, rest) = match line.find(" ") {
    Some(i) => (line[:i].to_upper().to_owned(), line[i + 1:])
    None => (line[:].to_upper().to_owned(), ""[:])
  }
  match verb {
    "EHLO" | "HELO" if !self.lmtp => self.hello_command(verb != "HELO", rest)
    "LHLO" if self.lmtp => self.hello_command(true, rest)
    "MAIL" => self.mail_command(rest)
    "RCPT" => self.rcpt_command(rest)
    "DATA" => {
      if !rest.trim().is_empty() {
        self.send(501, "5.5.4 DATA takes no argument")
      } else if !self.mail {
        self.send(503, "5.5.1 Need MAIL before DATA")
      } else if self.recipients == 0 {
        self.send(554, "5.5.1 No valid recipients")
      } else if self.binary {
        self.send(503, "5.5.1 BINARYMIME needs BDAT")
      } else {
        self.message.reset()
        self.overflow = false
        self.phase = Content
        self.send(354, "End data with <CR><LF>.<CR><LF>")
      }
      None
    }
    "BDAT" => {
      self.bdat_command(rest)
      None
    }
    "RSET" => {
      self.reset()
      self.send(250, "2.0.0 Ok")
      Some(Rset)
    }
    "NOOP" => {
      self.send(250, "2.0.0 Ok")
      None
    }
    "HELP" => {
      self.send(
        214, "2.0.0 Commands: EHLO HELO MAIL RCPT DATA BDAT RSET NOOP QUIT VRFY EXPN STARTTLS AUTH",
      )
      None
    }
    "QUIT" => {
      self.send(221, "2.0.0 Bye")
      self.closed = true
      Some(Quit)
    }
    "VRFY" | "EXPN" => {
      let argument = rest.trim()
      if argument.is_empty() {
        self.send(501, "5.5.4 " + verb + " needs an argument")
        return None
      }
      if verb == "VRFY" {
        self.wait(Vrfy(argument.to_owned()))
      } else {
        self.wait(Expn(argument.to_owned()))
      }
    }
    "STARTTLS" => {
      if !self.starttls {
        self.send(502, "5.5.1 STARTTLS not offered")
      } else if self.tls {
        self.send(503, "5.5.1 TLS already started")
      } else if !rest.trim().is_empty() {
        self.send(501, "5.5.4 STARTTLS takes no argument")
      } else {
        return self.wait(StartTls)
      }
      None
    }
    "AUTH" => self.auth_command(rest)
    _ => {
      self.send(500, "5.5.2 Command unrecognized")
      None
    }
  }
}

///|
fn Server::hello_command(
  self : Server,
  extended : Bool,
  rest : StringView,
) -> Request? {
  let domain = rest.trim()
  if domain.is_empty() {
    self.send(501, "5.5.4 A domain is needed")
    return None
  }
  self.reset()
  self.wait(Hello(domain.to_owned(), extended~))
}

///|
fn Server::mail_command(self : Server, rest : StringView) -> Request? {
  if !self.hello {
    self.send(503, "5.5.1 Send EHLO first")
    return None
  }
  if self.mail {
    self.send(503, "5.5.1 Nested MAIL command")
    return None
  }
  guard envelope(rest, "FROM:") is Some((from, words)) else {
    self.send(501, "5.5.4 Syntax: MAIL FROM:<address>")
    return None
  }
  guard parameters(words) is Some(params) else {
    self.send(501, "5.5.4 Malformed parameters")
    return None
  }
  for keyword, value in params {
    let valid = match (keyword, value) {
      ("SIZE", Some(n)) =>
        match number(n) {
          Some(size) if size > self.limits.size => {
            self.send(
              552, "5.3.4 Message size exceeds fixed maximum message size",
            )
            return None
          }
          Some(_) => true
          None => false
        }
      ("BODY", Some(kind)) => kind is ("7BIT" | "8BITMIME" | "BINARYMIME")
      ("SMTPUTF8", None) => true
      ("RET", Some(how)) => how is ("FULL" | "HDRS")
      ("ENVID", Some(id)) => !id.is_empty()
      ("AUTH", Some(identity)) => !identity.is_empty()
      ("SIZE" | "BODY" | "SMTPUTF8" | "RET" | "ENVID" | "AUTH", _) => false
      _ => {
        self.send(555, "5.5.4 Unsupported parameter " + keyword)
        return None
      }
    }
    if !valid {
      self.send(501, "5.5.4 Bad value for " + keyword)
      return None
    }
  }
  if !is_ascii(from) && !params.contains("SMTPUTF8") {
    self.send(553, "5.6.7 A non-ASCII address needs SMTPUTF8")
    return None
  }
  self.wait(Mail(from, params))
}

///|
fn Server::rcpt_command(self : Server, rest : StringView) -> Request? {
  if !self.mail {
    self.send(503, "5.5.1 Need MAIL before RCPT")
    return None
  }
  guard envelope(rest, "TO:") is Some((to, words)) && !to.is_empty() else {
    self.send(501, "5.1.3 Syntax: RCPT TO:<address>")
    return None
  }
  guard parameters(words) is Some(params) else {
    self.send(501, "5.5.4 Malformed parameters")
    return None
  }
  if self.recipients >= self.limits.recipients {
    self.send(452, "4.5.3 Too many recipients")
    return None
  }
  for keyword, value in params {
    let valid = match (keyword, value) {
      ("NOTIFY", Some(list)) =>
        list == "NEVER" ||
        list
        .split(",")
        .all(n => n.to_upper() is ("SUCCESS" | "FAILURE" | "DELAY"))
      ("ORCPT", Some(original)) => original.contains(";")
      ("NOTIFY" | "ORCPT", _) => false
      _ => {
        self.send(555, "5.5.4 Unsupported parameter " + keyword)
        return None
      }
    }
    if !valid {
      self.send(501, "5.5.4 Bad value for " + keyword)
      return None
    }
  }
  if !is_ascii(to) && !self.utf8 {
    self.send(553, "5.6.7 A non-ASCII address needs SMTPUTF8")
    return None
  }
  self.wait(Rcpt(to, params))
}

///|
/// `BDAT size [LAST]`: the chunk is read whatever happens to the command,
/// since its octets follow regardless, and a refusal is sent after them.
fn Server::bdat_command(self : Server, rest : StringView) -> Unit {
  let words = rest.split(" ").filter(w => !w.is_empty()).to_array()
  let (size, last) = match words {
    [n] => (number(n), false)
    [n, word] if word.to_upper() == "LAST" => (number(n), true)
    _ => (None, false)
  }
  guard size is Some(size) else {
    self.send(501, "5.5.4 Syntax: BDAT size [LAST]")
    return
  }
  self.refusal = if !self.mail {
    Some(Reply::new(503, "5.5.1 Need MAIL before BDAT"))
  } else if self.recipients == 0 {
    Some(Reply::new(554, "5.5.1 No valid recipients"))
  } else {
    None
  }
  self.phase = Chunk(size, last)
}

///|
fn Server::auth_command(self : Server, rest : StringView) -> Request? {
  if !self.auth_offered() {
    self.send(502, "5.5.1 AUTH not offered")
    return None
  }
  if self.authenticated {
    self.send(503, "5.5.1 Already authenticated")
    return None
  }
  if self.mail {
    self.send(503, "5.5.1 AUTH not allowed inside a transaction")
    return None
  }
  let words = rest.split(" ").filter(w => !w.is_empty()).to_array()
  guard words is [name, .. more] && more.length() <= 1 else {
    self.send(501, "5.5.4 Syntax: AUTH mechanism [initial-response]")
    return None
  }
  let mechanism = name.to_upper().to_owned()
  if !self.mechanisms.contains(mechanism) {
    self.send(504, "5.5.4 Unrecognized authentication type")
    return None
  }
  let initial = match more {
    [] => None
    ["="] => Some(b"")
    [text] =>
      Some(
        @base64.decode(text) catch {
          _ => {
            self.send(501, "5.5.2 Cannot decode response")
            return None
          }
        },
      )
    _ => None
  }
  self.wait(Auth(mechanism, initial))
}

///|
/// Keep message octets up to `limits.size`; past it, note the overflow and
/// keep reading to the end without storing.
fn Server::gather(self : Server, data : BytesView) -> Unit {
  if self.overflow {
    return
  }
  if self.message.length() + data.length() > self.limits.size {
    self.overflow = true
    self.message.reset()
  } else {
    self.message.write_bytes(data)
  }
}

///|
/// The message is in: refuse it if it outgrew the limit, else hand it over.
fn Server::finish(self : Server) -> Request? {
  if self.overflow {
    self.reset()
    self.send(552, "5.3.4 Message size exceeds fixed maximum message size")
    return None
  }
  self.due = if self.lmtp { self.recipients } else { 1 }
  let request = Request::Data(self.message.to_bytes())
  self.message.reset()
  self.wait(request)
}

///|
/// A chunk before the last is in, or the message outgrew the limit.
fn Server::finish_chunk(self : Server, last : Bool) -> Request? {
  if self.overflow {
    self.reset()
    self.send(552, "5.3.4 Message size exceeds fixed maximum message size")
    return None
  }
  ignore(last)
  self.send(
    250,
    "2.0.0 " + self.message.length().to_string() + " octets received",
  )
  None
}

///|
/// `FROM:<path> params` or `TO:<path> params`: the path, with any source route
/// dropped, and the parameter words. A space after the colon is tolerated.
fn envelope(text : StringView, prefix : String) -> (String, Array[StringView])? {
  guard text.length() >= prefix.length() &&
    text[:prefix.length()].to_upper() == prefix[:] else {
    return None
  }
  let rest = text[prefix.length():].trim_start()
  guard rest.has_prefix("<") && rest.find(">") is Some(close) else {
    return None
  }
  let mut path = rest[1:close]
  if path.has_prefix("@") {
    guard path.find(":") is Some(colon) else { return None }
    path = path[colon + 1:]
  }
  if path.iter().any(c => c < ' ' || c == '<') {
    return None
  }
  let words = rest[close + 1:].split(" ").filter(w => !w.is_empty()).to_array()
  Some((path.to_owned(), words))
}

///|
/// `KEYWORD` or `KEYWORD=value` words, keywords in upper case; `None` when a
/// keyword repeats or is empty.
fn parameters(words : Array[StringView]) -> Map[String, String?]? {
  let out : Map[String, String?] = Map([])
  for word in words {
    let (keyword, value) = match word.find("=") {
      Some(i) => (word[:i].to_upper().to_owned(), Some(word[i + 1:].to_owned()))
      None => (word.to_upper().to_owned(), None)
    }
    if keyword.is_empty() || out.contains(keyword) {
      return None
    }
    out[keyword] = value
  }
  Some(out)
}
