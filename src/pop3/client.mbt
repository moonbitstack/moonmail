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
/// - `line`: the longest status line, CRLF excluded; Python `poplib`'s
///   `_MAXLINE`. A line of a message is not held to it.
/// - `message`: the largest multi-line response, which is how a message
///   arrives; 150 MB, the largest message Exchange Online lets an
///   administrator allow.
#derive(Eq, Debug)
pub(all) struct Limits {
  line : Int32
  message : Int32
}

///|
pub extend Limits with Eq::{equal, not_equal}

///|
pub extend Limits with Debug::{to_repr}

///|
pub let limits : Limits = { line: 2048, message: 157286400, }

///|
pub fn Limits::new(
  line~ : Int32 = limits.line,
  message~ : Int32 = limits.message,
) -> Limits {
  { line, message, }
}

///|
/// Where the session stands (RFC 1939 section 3).
#derive(Eq, Debug)
pub(all) enum State {
  Authorization
  Transaction
  Update
}

///|
pub extend State with Eq::{equal, not_equal}

///|
pub extend State with Debug::{to_repr}

///|
/// The command a reply answers. `Greeting` is the server's opening.
#derive(Eq, Debug)
pub(all) enum Command {
  Greeting
  User(String)
  Pass
  Apop(String)
  Auth(String)
  Stls
  Capa
  Stat
  List(Int32?)
  Uidl(Int32?)
  Retr(Int32)
  Top(Int32, Int32)
  Dele(Int32)
  Rset
  Noop
  Quit
}

///|
pub extend Command with Eq::{equal, not_equal}

///|
pub extend Command with Debug::{to_repr}

///|
/// A reply, read by the shape its command gives it. `Err` is any `-ERR`;
/// `Listing` and `Uids` answer `LIST` and `UIDL` for one message or all;
/// `Content` is a message or its top, dot-unstuffed, CRLF line ends kept.
#derive(Eq, Debug)
pub(all) enum Reply {
  Greeting(text~ : String, timestamp~ : String?)
  Ok(String)
  Err(String)
  Stat(count~ : Int32, size~ : Int64)
  Listing(Array[(Int32, Int64)])
  Uids(Array[(Int32, String)])
  Content(Bytes)
  Capabilities(Array[String])
}

///|
pub extend Reply with Eq::{equal, not_equal}

///|
pub extend Reply with Debug::{to_repr}

///|
/// What `Client::feed` reports: each reply with the command it answers, or a
/// SASL mechanism refusing the server. `Sasl` during the exchange means `*`
/// has gone out to cancel it; in place of the `+OK` it means the server
/// claimed success without the proof the mechanism needs.
#derive(Eq, Debug)
pub(all) enum Event {
  Reply(Command, Reply)
  Sasl(@sasl.Refused)
}

///|
pub extend Event with Eq::{equal, not_equal}

///|
pub extend Event with Debug::{to_repr}

///|
priv struct Pending {
  command : Command
  line : Bytes
  barrier : Bool
  multiline : Bool
  mechanism : &@sasl.Mechanism?
}

///|
/// A POP3 client (RFC 1939, RFC 2449, RFC 5034, RFC 2595) with no I/O:
/// commands go into a queue, `next_write` gives the octets to send, and
/// `feed` takes what the server sent and reports each reply.
///
/// Without `PIPELINING` one command goes out at a time; with it, commands go
/// out together up to one that changes the state (`USER`, `PASS`, `APOP`,
/// `AUTH`, `STLS`, `QUIT`).
pub struct Client {
  priv limits : Limits
  priv mut data : Bytes
  priv mut at : Int32
  priv queue : Array[Pending]
  priv waiting : Array[Pending]
  priv urgent : Buffer
  priv content : Buffer
  priv mut reading : Bool
  priv mut greeted : Bool
  priv mut timestamp : String?
  priv mut state : State
  priv mut planned : State
  priv mut capabilities : Array[String]
}

///|
pub fn Client::new(limits~ : Limits = limits) -> Client {
  {
    limits,
    data: b"",
    at: 0,
    queue: [],
    waiting: [],
    urgent: Buffer(),
    content: Buffer(),
    reading: false,
    greeted: false,
    timestamp: None,
    state: Authorization,
    planned: Authorization,
    capabilities: [],
  }
}

///|
/// The session state as of the replies fed so far.
pub fn Client::state(self : Client) -> State {
  self.state
}

///|
/// The capabilities the last `CAPA` reply listed, each line as written.
pub fn Client::capabilities(self : Client) -> Array[String] {
  self.capabilities.copy()
}

///|
/// Whether the last `CAPA` reply listed `name`, the first word of a line.
pub fn Client::has(self : Client, name : String) -> Bool {
  let wanted = name.to_upper()
  self.capabilities.any(line => {
    match line.find(" ") {
      Some(i) => line[:i].to_upper() == wanted[:]
      None => line.to_upper() == wanted
    }
  })
}

///|
/// How many replies the client still expects: the greeting until it arrives,
/// and one for every command queued or sent.
pub fn Client::pending(self : Client) -> Int32 {
  (if self.greeted { 0 } else { 1 }) +
  self.queue.length() +
  self.waiting.length()
}

///|
fn Client::enqueue(
  self : Client,
  command : Command,
  line : String,
  barrier~ : Bool = false,
  multiline~ : Bool = false,
  mechanism? : &@sasl.Mechanism,
) -> Unit {
  self.queue.push({
    command,
    line: @utf8.encode(line + "\r\n"),
    barrier,
    multiline,
    mechanism,
  })
}

///|
fn Client::expect(self : Client, wanted : State) -> Unit raise Refused {
  if self.planned != wanted {
    let name = match wanted {
      Authorization => "authorization"
      Transaction => "transaction"
      Update => "update"
    }
    raise Order("only in the " + name + " state")
  }
}

///|
pub fn Client::user(self : Client, name : String) -> Unit raise Refused {
  self.expect(Authorization)
  argument(name)
  self.enqueue(User(name), "USER " + name, barrier=true)
}

///|
/// The password after `user`; on success the session enters the transaction
/// state.
pub fn Client::pass(self : Client, password : String) -> Unit raise Refused {
  self.expect(Authorization)
  argument(password)
  self.planned = Transaction
  self.enqueue(Pass, "PASS " + password, barrier=true)
}

///|
/// APOP (RFC 1939 section 7): the user name and the MD5 of the greeting's
/// timestamp and the shared secret, so the secret never crosses. Needs a
/// greeting that carried a timestamp.
pub fn Client::apop(
  self : Client,
  name : String,
  secret : String,
) -> Unit raise Refused {
  self.expect(Authorization)
  argument(name)
  guard self.timestamp is Some(stamp) else { raise Unsupported("APOP") }
  let digest = @md5.hash(@utf8.encode(stamp + secret)[:])
  self.planned = Transaction
  self.enqueue(Apop(name), "APOP " + name + " " + hex(digest[:]), barrier=true)
}

///|
/// SASL authentication (RFC 5034). The first response rides on the command
/// line, `=` when empty; each `+` challenge gets the mechanism's next step.
pub fn Client::auth(
  self : Client,
  mechanism : &@sasl.Mechanism,
) -> Unit raise Refused {
  self.expect(Authorization)
  let name = mechanism.name()
  let line = match mechanism.start() {
    None => "AUTH " + name
    Some(data) if data.is_empty() => "AUTH " + name + " ="
    Some(data) => "AUTH " + name + " " + @base64.encode(data[:])
  }
  self.planned = Transaction
  self.enqueue(Auth(name), line, barrier=true, mechanism~)
}

///|
/// Ask to start TLS (RFC 2595). After the `+OK` the caller upgrades the
/// transport; the client has then forgotten the capabilities.
pub fn Client::stls(self : Client) -> Unit raise Refused {
  self.expect(Authorization)
  if !self.capabilities.is_empty() && !self.has("STLS") {
    raise Unsupported("STLS")
  }
  self.enqueue(Stls, "STLS", barrier=true)
}

///|
/// Ask for the capabilities (RFC 2449); allowed in any state.
pub fn Client::capa(self : Client) -> Unit {
  self.enqueue(Capa, "CAPA", multiline=true)
}

///|
pub fn Client::stat(self : Client) -> Unit raise Refused {
  self.expect(Transaction)
  self.enqueue(Stat, "STAT")
}

///|
/// The size of one message, or of every message when `message` is not given.
pub fn Client::list(self : Client, message? : Int32) -> Unit raise Refused {
  self.expect(Transaction)
  match message {
    Some(n) => self.enqueue(List(Some(n)), "LIST " + n.to_string())
    None => self.enqueue(List(None), "LIST", multiline=true)
  }
}

///|
/// The unique id of one message, or of every message (RFC 1939 section 7).
pub fn Client::uidl(self : Client, message? : Int32) -> Unit raise Refused {
  self.expect(Transaction)
  match message {
    Some(n) => self.enqueue(Uidl(Some(n)), "UIDL " + n.to_string())
    None => self.enqueue(Uidl(None), "UIDL", multiline=true)
  }
}

///|
pub fn Client::retr(self : Client, message : Int32) -> Unit raise Refused {
  self.expect(Transaction)
  self.enqueue(Retr(message), "RETR " + message.to_string(), multiline=true)
}

///|
/// The header of a message and its first `lines` body lines.
pub fn Client::top(
  self : Client,
  message : Int32,
  lines : Int32,
) -> Unit raise Refused {
  self.expect(Transaction)
  self.enqueue(
    Top(message, lines),
    "TOP " + message.to_string() + " " + lines.to_string(),
    multiline=true,
  )
}

///|
pub fn Client::dele(self : Client, message : Int32) -> Unit raise Refused {
  self.expect(Transaction)
  self.enqueue(Dele(message), "DELE " + message.to_string())
}

///|
pub fn Client::rset(self : Client) -> Unit raise Refused {
  self.expect(Transaction)
  self.enqueue(Rset, "RSET")
}

///|
pub fn Client::noop(self : Client) -> Unit raise Refused {
  self.expect(Transaction)
  self.enqueue(Noop, "NOOP")
}

///|
/// End the session; in the transaction state the server then removes what
/// `dele` marked.
pub fn Client::quit(self : Client) -> Unit {
  self.enqueue(Quit, "QUIT", barrier=true)
}

///|
/// The octets to send now, if any. Nothing goes out before the greeting.
pub fn Client::next_write(self : Client) -> Bytes? {
  let out = Buffer()
  out.write_bytes(self.urgent.to_bytes())
  self.urgent.reset()
  if self.greeted {
    let pipelining = self.has("PIPELINING")
    while self.queue is [next, ..] {
      let blocked = self.waiting.length() > 0 &&
        (!pipelining || next.barrier || self.waiting.iter().any(p => p.barrier))
      if blocked {
        break
      }
      let _ = self.queue.remove(0)
      out.write_bytes(next.line)
      self.waiting.push(next)
    }
  }
  if out.is_empty() {
    None
  } else {
    Some(out.to_bytes())
  }
}

///|
/// Take octets from the server and report the replies they complete.
pub fn Client::feed(
  self : Client,
  data : BytesView,
) -> Array[Event] raise Refused {
  let joined = Buffer()
  joined.write_bytes(self.data[self.at:])
  joined.write_bytes(data)
  self.data = joined.to_bytes()
  self.at = 0
  let events = []
  while self.line() is Some(line) {
    if self.reading {
      self.content_line(line, events)
    } else {
      self.status_line(line, events)
    }
  }
  events
}

///|
/// The next line, CRLF or LF included.
///
/// The line limit is for a status line, which the protocol does bound. A line
/// of a multi-line response is message content and has no length of its own:
/// `message` bounds that instead, so a letter written as one long line — a
/// minified page, a base64 part nobody wrapped — still arrives.
fn Client::line(self : Client) -> BytesView? raise Refused {
  let mut end = self.at
  while end < self.data.length() && self.data[end] != b'\n' {
    end += 1
  }
  let got = end - self.at
  if !self.reading && got > self.limits.line + 1 {
    raise Exceeded(limit=self.limits.line, got~)
  }
  if end == self.data.length() {
    return None
  }
  let start = self.at
  self.at = end + 1
  Some(self.data[start:end + 1])
}

///|
fn Client::status_line(
  self : Client,
  raw : BytesView,
  events : Array[Event],
) -> Unit raise Refused {
  let line = @utf8.decode_lossy(trim_eol(raw))
  if !self.greeted {
    self.greeted = true
    if line.has_prefix("+OK") {
      let text = rest(line, 3)
      self.timestamp = stamp_of(text)
      events.push(Reply(Greeting, Greeting(text~, timestamp=self.timestamp)))
    } else {
      events.push(Reply(Greeting, Err(rest(line, 4))))
    }
    return
  }
  guard self.waiting is [front, ..] else {
    raise Malformed("a reply nobody asked for: " + line)
  }
  if line.has_prefix("+ ") || line == "+" {
    guard front.mechanism is Some(mechanism) else {
      raise Malformed("a continuation nobody asked for")
    }
    let answer = @sasl.respond(mechanism, rest(line, 1)) catch {
      refused => {
        events.push(Sasl(refused))
        "*"
      }
    }
    self.urgent.write_bytes(@utf8.encode(answer + "\r\n"))
    return
  }
  let ok = if line.has_prefix("+OK") {
    true
  } else if line.has_prefix("-ERR") {
    false
  } else {
    raise Malformed("a status line opens with +OK or -ERR: " + line)
  }
  if ok && front.multiline {
    self.reading = true
    self.content.reset()
    return
  }
  let _ = self.waiting.remove(0)
  let text = if ok { rest(line, 3) } else { rest(line, 4) }
  if !ok {
    self.failed(front.command)
    events.push(Reply(front.command, Err(text)))
    return
  }
  let reply : Reply = match front.command {
    Stat =>
      match words(text) {
        [count, size, ..] =>
          Stat(count=number(count).to_int(), size=number(size))
        _ => raise Malformed("STAT gives a count and a size: " + text)
      }
    List(Some(_)) =>
      match words(text) {
        [n, size, ..] => Listing([(number(n).to_int(), number(size))])
        _ => raise Malformed("LIST gives a number and a size: " + text)
      }
    Uidl(Some(_)) =>
      match words(text) {
        [n, uid, ..] => Uids([(number(n).to_int(), uid.to_owned())])
        _ => raise Malformed("UIDL gives a number and an id: " + text)
      }
    _ => Ok(text)
  }
  match front.command {
    Pass | Apop(_) | Auth(_) => {
      self.state = Transaction
      if front.mechanism is Some(mechanism) {
        mechanism.finish() catch {
          refused => {
            events.push(Sasl(refused))
            return
          }
        }
      }
    }
    Stls => {
      self.capabilities = []
      // What followed the +OK in the clear was not protected (RFC 2595
      // section 4).
      self.at = self.data.length()
    }
    Quit => self.state = Update
    _ => ()
  }
  events.push(Reply(front.command, reply))
}

///|
/// A failed login leaves the session where it was.
fn Client::failed(self : Client, command : Command) -> Unit {
  if command is (Pass | Apop(_) | Auth(_)) {
    self.planned = self.state
  }
}

///|
fn Client::content_line(
  self : Client,
  raw : BytesView,
  events : Array[Event],
) -> Unit raise Refused {
  let body = trim_eol(raw)
  if body.length() == 1 && body[0] == b'.' {
    self.reading = false
    let front = self.waiting.remove(0)
    let data = self.content.to_bytes()
    self.content.reset()
    events.push(Reply(front.command, self.multi(front.command, data)))
    return
  }
  let line = if body.length() > 0 && body[0] == b'.' { raw[1:] } else { raw }
  if self.content.length() + line.length() > self.limits.message {
    raise Exceeded(
      limit=self.limits.message,
      got=self.content.length() + line.length(),
    )
  }
  self.content.write_bytes(line)
}

///|
fn Client::multi(
  self : Client,
  command : Command,
  data : Bytes,
) -> Reply raise Refused {
  let lines = () => {
    @utf8.decode_lossy(data[:])
    .split("\n")
    .map(l => l.trim_end(chars="\r"))
    .filter(l => !l.is_empty())
    .to_array()
  }
  match command {
    Capa => {
      let list = lines().map(l => l.to_owned())
      self.capabilities = list
      Capabilities(list)
    }
    List(None) =>
      Listing(
        lines().map(l => {
          match words(l) {
            [n, size, ..] => (number(n).to_int(), number(size))
            _ => raise Malformed("a LIST line gives a number and a size")
          }
        }),
      )
    Uidl(None) =>
      Uids(
        lines().map(l => {
          match words(l) {
            [n, uid, ..] => (number(n).to_int(), uid.to_owned())
            _ => raise Malformed("a UIDL line gives a number and an id")
          }
        }),
      )
    _ => Content(data)
  }
}

///|
fn trim_eol(line : BytesView) -> BytesView {
  let mut end = line.length()
  if end > 0 && line[end - 1] == b'\n' {
    end -= 1
  }
  if end > 0 && line[end - 1] == b'\r' {
    end -= 1
  }
  line[:end]
}

///|
/// The text after a status word and the space that follows it.
fn rest(line : String, skip : Int32) -> String {
  if line.length() > skip + 1 {
    line[skip + 1:].to_owned()
  } else {
    ""
  }
}

///|
/// The `<...>` timestamp an APOP-capable greeting carries.
fn stamp_of(text : String) -> String? {
  guard text.find("<") is Some(open) && text[open:].find(">") is Some(close) else {
    None
  }
  Some(text[open:open + close + 1].to_owned())
}

///|
fn words(text : StringView) -> Array[StringView] {
  text.split(" ").filter(w => !w.is_empty()).to_array()
}

///|
fn number(text : StringView) -> Int64 raise Refused {
  if text.is_empty() || text.length() > 18 {
    raise Malformed("not a number: " + text.to_owned())
  }
  let mut n = 0L
  for c in text {
    guard c >= '0' && c <= '9' else {
      raise Malformed("not a number: " + text.to_owned())
    }
    n = n * 10 + (c.to_int() - '0'.to_int()).to_int64()
  }
  n
}

///|
/// A command argument: something, and no line break to smuggle a second
/// command in.
fn argument(text : String) -> Unit raise Refused {
  if text.is_empty() || text.iter().any(c => c < ' ' || c == '\u{7F}') {
    raise Malformed("not a command argument")
  }
}

///|
fn hex(data : BytesView) -> String {
  let digits = "0123456789abcdef"
  let out = StringBuilder()
  for b in data {
    out.write_char(digits[b.to_int() / 16].unsafe_to_char())
    out.write_char(digits[b.to_int() % 16].unsafe_to_char())
  }
  out.to_string()
}
