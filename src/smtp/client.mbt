// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// What a message body is, as `BODY=` declares it (RFC 6152, RFC 3030).
#derive(Eq, Debug)
pub(all) enum Body {
  SevenBit
  EightBit
  Binary
}

///|
pub extend Body with Eq::{equal, not_equal}

///|
pub extend Body with Debug::{to_repr}

///|
/// How much of a bounced message a delivery status notification returns
/// (RFC 3461 `RET=`).
#derive(Eq, Debug)
pub(all) enum Ret {
  Full
  Headers
}

///|
pub extend Ret with Eq::{equal, not_equal}

///|
pub extend Ret with Debug::{to_repr}

///|
/// When a recipient wants a delivery status notification (RFC 3461
/// `NOTIFY=`). An empty list asks for none.
#derive(Eq, Debug)
pub(all) enum Notify {
  Success
  Failure
  Delay
}

///|
pub extend Notify with Eq::{equal, not_equal}

///|
pub extend Notify with Debug::{to_repr}

///|
/// The command a reply answers. `Greeting` is the server's opening, or a reply
/// it sent unprompted, such as a `421` before it closes. `Delivery` is one of
/// the per-recipient replies LMTP sends after the message.
#derive(Eq, Debug)
pub(all) enum Command {
  Greeting
  Hello(String)
  StartTls
  Auth(String)
  Mail(String)
  Rcpt(String)
  Data
  Bdat(Int32)
  Delivery(String)
  Rset
  Noop
  Vrfy(String)
  Expn(String)
  Help
  Quit
}

///|
pub extend Command with Eq::{equal, not_equal}

///|
pub extend Command with Debug::{to_repr}

///|
/// What `Client::feed` reports: each final reply with the command it answers,
/// or a SASL mechanism refusing the server. The intermediate `334` and `354`
/// replies are answered inside the client.
///
/// `Sasl` after a challenge means the client has sent `*` to cancel, and the
/// server's reply to that follows as `Reply(Auth(_), _)`. `Sasl` in place of a
/// `235` means the server claimed success without the proof the mechanism
/// needs, as SCRAM's signature: the session is not to be trusted.
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
/// RFC 5321 section 4.5.3.1.4: the longest command line, CRLF included, that
/// every server takes. An `AUTH` whose first response would pass it sends the
/// response after the first challenge instead (RFC 4954 section 4).
let command_line = 512

///|
/// One mail transaction as the client issued it.
struct Txn {
  utf8 : Bool
  binary : Bool
  mut recipients : Int32
  accepted : Array[String]
}

///|
/// A command queued or written, waiting for its final reply.
struct Pending {
  command : Command
  line : Bytes
  barrier : Bool
  txn : Txn?
  mechanism : &@sasl.Mechanism?
  mut initial : Bytes?
  mut body : Bytes?
  last : Bool
}

///|
enum Hello {
  Unsent
  Sent
  Done
}

///|
/// An SMTP or LMTP client with no I/O: commands go into a queue, `next_write`
/// gives the octets to send, and `feed` takes what the server sent back and
/// reports each reply.
///
/// Without `PIPELINING` one command goes out at a time; with it the client
/// sends commands in groups as RFC 2920 allows, ending a group at `EHLO`,
/// `DATA`, `AUTH`, `STARTTLS`, `NOOP`, `VRFY`, `EXPN` or `QUIT`. A command that
/// needs an extension the server did not announce, or that is out of sequence,
/// is refused when it is queued.
pub struct Client {
  priv lmtp : Bool
  priv limits : Limits
  priv inbox : Inbox
  priv queue : Array[Pending]
  priv waiting : Array[Pending]
  priv urgent : Buffer
  priv mut barrier : Bool
  priv mut greeted : Bool
  priv mut hello : Hello
  priv mut extensions : Map[String, String]
  priv mut txn : Txn?
  priv partial : Array[String]
  priv mut code : Int32
}

///|
/// A client for SMTP, or for LMTP (RFC 2033) when `lmtp` is set: `ehlo` then
/// sends `LHLO`, and the message gets one reply per accepted recipient.
pub fn Client::new(lmtp~ : Bool = false, limits~ : Limits = limits) -> Client {
  {
    lmtp,
    limits,
    inbox: Inbox::new(),
    queue: [],
    waiting: [],
    urgent: Buffer(),
    barrier: false,
    greeted: false,
    hello: Unsent,
    extensions: Map([]),
    txn: None,
    partial: [],
    code: 0,
  }
}

///|
/// The extensions the last `EHLO` reply announced: each keyword in upper case
/// and the parameters after it.
pub fn Client::extensions(self : Client) -> Map[String, String] {
  self.extensions.copy()
}

///|
/// How many responses the client still expects: the greeting until it
/// arrives, and the completion of every command queued or sent. A transport
/// reads until it is zero.
pub fn Client::pending(self : Client) -> Int32 {
  (if self.greeted { 0 } else { 1 }) +
  self.queue.length() +
  self.waiting.length()
}

///|
/// Whether the last `EHLO` reply announced the extension `name`.
pub fn Client::has(self : Client, name : String) -> Bool {
  self.extensions.contains(name.to_upper())
}

///|
fn Client::enqueue(
  self : Client,
  command : Command,
  line : String,
  barrier~ : Bool,
  payload? : BytesView,
  body? : Bytes,
  mechanism? : &@sasl.Mechanism,
  initial? : Bytes,
  last~ : Bool = false,
) -> Unit {
  let out = Buffer()
  out.write_bytes(@utf8.encode(line + "\r\n"))
  if payload is Some(data) {
    out.write_bytes(data)
  }
  self.queue.push({
    command,
    line: out.to_bytes(),
    barrier,
    txn: self.txn,
    mechanism,
    initial,
    body,
    last,
  })
}

///|
/// Greet the server and ask for its extensions (`LHLO` under LMTP). The reply
/// replaces what `extensions` reports and ends any open transaction.
pub fn Client::ehlo(self : Client, domain : String) -> Unit raise Refused {
  argument(domain)
  let verb = if self.lmtp { "LHLO " } else { "EHLO " }
  self.enqueue(Hello(domain), verb + domain, barrier=true)
  self.hello = Sent
  self.txn = None
}

///|
/// Greet the server the RFC 821 way, without extensions. LMTP has no `HELO`.
pub fn Client::helo(self : Client, domain : String) -> Unit raise Refused {
  if self.lmtp {
    raise Order("LMTP greets with LHLO")
  }
  argument(domain)
  self.enqueue(Hello(domain), "HELO " + domain, barrier=true)
  self.hello = Sent
  self.txn = None
}

///|
/// Ask to start TLS (RFC 3207). After the `220` the caller upgrades the
/// transport; the client has then forgotten the extensions and wants a fresh
/// `ehlo`.
pub fn Client::starttls(self : Client) -> Unit raise Refused {
  self.require("STARTTLS")
  self.enqueue(StartTls, "STARTTLS", barrier=true)
}

///|
/// Authenticate with SASL (RFC 4954). The mechanism's first response rides on
/// the command line, `=` when it is empty, unless the line would grow past 512
/// octets; each `334` challenge is answered with its next step.
pub fn Client::auth(
  self : Client,
  mechanism : &@sasl.Mechanism,
) -> Unit raise Refused {
  self.require("AUTH")
  let name = mechanism.name()
  let offered = self.extensions
    .get("AUTH")
    .unwrap_or("")
    .split(" ")
    .any(m => m.to_upper().to_owned() == name.to_upper())
  if !offered {
    raise Unsupported("AUTH " + name)
  }
  if self.txn is Some(_) {
    raise Order("AUTH is not allowed inside a mail transaction")
  }
  match mechanism.start() {
    None => self.enqueue(Auth(name), "AUTH " + name, barrier=true, mechanism~)
    Some(data) => {
      let encoded = if data.is_empty() { "=" } else { @base64.encode(data[:]) }
      let line = "AUTH " + name + " " + encoded
      if line.length() + 2 <= command_line {
        self.enqueue(Auth(name), line, barrier=true, mechanism~)
      } else {
        self.enqueue(
          Auth(name),
          "AUTH " + name,
          barrier=true,
          mechanism~,
          initial=data,
        )
      }
    }
  }
}

///|
/// Open a mail transaction (`MAIL FROM`). `from` is the reverse path, empty for
/// a bounce. The parameters each need the extension that defines them:
/// `size` needs `SIZE` (RFC 1870) and must not pass the size the server
/// announced; `body` needs `8BITMIME` (RFC 6152), and `BINARYMIME` with
/// `CHUNKING` for `Binary` (RFC 3030); `utf8` needs `SMTPUTF8` (RFC 6531) and
/// is what lets the addresses be non-ASCII; `ret` and `envid` need `DSN`
/// (RFC 3461); `auth` needs `AUTH` (RFC 4954 section 5).
pub fn Client::mail(
  self : Client,
  from : String,
  size? : Int32,
  body? : Body,
  utf8~ : Bool = false,
  ret? : Ret,
  envid? : String,
  auth? : String,
) -> Unit raise Refused {
  if self.hello is Unsent {
    raise Order("greet with ehlo or helo first")
  }
  if self.txn is Some(_) {
    raise Order("a transaction is open: send its message or rset")
  }
  path(from)
  if !is_ascii(from) && !utf8 {
    raise Malformed("a non-ASCII address needs utf8")
  }
  let line = StringBuilder()
  line.write_string("MAIL FROM:<" + from + ">")
  if size is Some(n) {
    self.require("SIZE")
    let announced = number(self.extensions.get("SIZE").unwrap_or("")).unwrap_or(
      0,
    )
    if announced > 0 && n > announced {
      raise Exceeded(limit=announced, got=n)
    }
    line.write_string(" SIZE=" + n.to_string())
  }
  match body {
    Some(SevenBit) => {
      self.require("8BITMIME")
      line.write_string(" BODY=7BIT")
    }
    Some(EightBit) => {
      self.require("8BITMIME")
      line.write_string(" BODY=8BITMIME")
    }
    Some(Binary) => {
      self.require("BINARYMIME")
      self.require("CHUNKING")
      line.write_string(" BODY=BINARYMIME")
    }
    None => ()
  }
  if utf8 {
    self.require("SMTPUTF8")
    line.write_string(" SMTPUTF8")
  }
  match ret {
    Some(how) => {
      self.require("DSN")
      line.write_string(
        match how {
          Full => " RET=FULL"
          Headers => " RET=HDRS"
        },
      )
    }
    None => ()
  }
  if envid is Some(id) {
    self.require("DSN")
    line.write_string(" ENVID=" + xtext(id))
  }
  if auth is Some(identity) {
    self.require("AUTH")
    let value = if identity.is_empty() { "<>" } else { xtext(identity) }
    line.write_string(" AUTH=" + value)
  }
  self.txn = Some({
    utf8,
    binary: body is Some(Binary),
    recipients: 0,
    accepted: [],
  })
  self.enqueue(Mail(from), line.to_string(), barrier=false)
}

///|
/// Name a recipient (`RCPT TO`). `notify` and `orcpt` need `DSN` (RFC 3461);
/// `orcpt` is the original recipient, written as `rfc822` or, when it is not
/// ASCII, as `utf-8` (RFC 6533).
pub fn Client::rcpt(
  self : Client,
  to : String,
  notify? : Array[Notify],
  orcpt? : String,
) -> Unit raise Refused {
  guard self.txn is Some(txn) else { raise Order("rcpt needs mail first") }
  path(to)
  if to.is_empty() {
    raise Malformed("a recipient cannot be empty")
  }
  if !is_ascii(to) && !txn.utf8 {
    raise Malformed("a non-ASCII address needs a transaction opened with utf8")
  }
  let line = StringBuilder()
  line.write_string("RCPT TO:<" + to + ">")
  if notify is Some(when) {
    self.require("DSN")
    let names = when.map(n => {
      match n {
        Success => "SUCCESS"
        Failure => "FAILURE"
        Delay => "DELAY"
      }
    })
    let value = if names.is_empty() { "NEVER" } else { names.join(",") }
    line.write_string(" NOTIFY=" + value)
  }
  if orcpt is Some(original) {
    self.require("DSN")
    if is_ascii(original) {
      line.write_string(" ORCPT=rfc822;" + xtext(original))
    } else if txn.utf8 {
      line.write_string(" ORCPT=utf-8;" + utf8_xtext(original))
    } else {
      raise Malformed(
        "a non-ASCII address needs a transaction opened with utf8",
      )
    }
  }
  txn.recipients += 1
  self.enqueue(Rcpt(to), line.to_string(), barrier=false)
}

///|
/// Send the message with `DATA`. It goes out once the server answers `354`,
/// with every line ended by CRLF, a leading dot doubled, and the closing
/// `.` line added. The transaction ends with it.
pub fn Client::data(self : Client, message : BytesView) -> Unit raise Refused {
  guard self.txn is Some(txn) && txn.recipients > 0 else {
    raise Order("data needs at least one rcpt")
  }
  if txn.binary {
    raise Order("a BINARYMIME transaction sends its body with bdat")
  }
  self.enqueue(Data, "DATA", barrier=true, body=stuff(message))
  self.txn = None
}

///|
/// Send one chunk of the message with `BDAT` (RFC 3030), exactly as given.
/// `last` ends the message and the transaction.
pub fn Client::bdat(
  self : Client,
  chunk : BytesView,
  last~ : Bool = false,
) -> Unit raise Refused {
  self.require("CHUNKING")
  guard self.txn is Some(txn) && txn.recipients > 0 else {
    raise Order("bdat needs at least one rcpt")
  }
  let line = "BDAT " +
    chunk.length().to_string() +
    (if last { " LAST" } else { "" })
  self.enqueue(Bdat(chunk.length()), line, barrier=false, payload=chunk, last~)
  if last {
    self.txn = None
  }
}

///|
/// Queue a whole transaction: `MAIL`, a `RCPT` for each recipient and `DATA`.
/// The parameters follow the announced extensions: `SIZE` when the server
/// takes it, `BODY=8BITMIME` when the message holds 8-bit octets, `SMTPUTF8`
/// when an address is not ASCII. The `EHLO` reply must be in.
pub fn Client::send(
  self : Client,
  from : String,
  to : Array[String],
  message : BytesView,
) -> Unit raise Refused {
  guard self.hello is Done else {
    raise Order("the EHLO reply has not arrived")
  }
  if to.is_empty() {
    raise Malformed("send needs at least one recipient")
  }
  let utf8 = !is_ascii(from) || to.any(t => !is_ascii(t))
  if utf8 && !self.has("SMTPUTF8") {
    raise Unsupported("SMTPUTF8")
  }
  let eight = message.iter().any(b => b >= 0x80)
  let body = if eight && self.has("8BITMIME") {
    Some(EightBit)
  } else if eight && !utf8 {
    raise Unsupported("8BITMIME")
  } else {
    None
  }
  let size = if self.has("SIZE") { Some(message.length()) } else { None }
  self.mail(from, size?, body?, utf8~)
  for recipient in to {
    self.rcpt(recipient)
  }
  self.data(message)
}

///|
/// End the open transaction (`RSET`).
pub fn Client::rset(self : Client) -> Unit {
  self.enqueue(Rset, "RSET", barrier=false)
  self.txn = None
}

///|
pub fn Client::noop(self : Client) -> Unit {
  self.enqueue(Noop, "NOOP", barrier=true)
}

///|
/// Ask whether `who` is a user or mailbox here (`VRFY`).
pub fn Client::vrfy(self : Client, who : String) -> Unit raise Refused {
  argument(who)
  self.enqueue(Vrfy(who), "VRFY " + who, barrier=true)
}

///|
/// Ask for the members of the mailing list `list` (`EXPN`).
pub fn Client::expn(self : Client, list : String) -> Unit raise Refused {
  argument(list)
  self.enqueue(Expn(list), "EXPN " + list, barrier=true)
}

///|
pub fn Client::help(self : Client, topic? : String) -> Unit raise Refused {
  match topic {
    Some(word) => {
      argument(word)
      self.enqueue(Help, "HELP " + word, barrier=false)
    }
    None => self.enqueue(Help, "HELP", barrier=false)
  }
}

///|
pub fn Client::quit(self : Client) -> Unit {
  self.enqueue(Quit, "QUIT", barrier=true)
}

///|
/// The octets to send now, if any: continuations the last reply called for,
/// then as many queued commands as pipelining allows. Nothing goes out before
/// the server's greeting.
pub fn Client::next_write(self : Client) -> Bytes? {
  let out = Buffer()
  out.write_bytes(self.urgent.to_bytes())
  self.urgent.reset()
  if self.greeted {
    let pipelining = self.has("PIPELINING")
    while self.queue.length() > 0 {
      if self.waiting.length() > 0 && (self.barrier || !pipelining) {
        break
      }
      let next = self.queue.remove(0)
      out.write_bytes(next.line)
      self.waiting.push(next)
      self.barrier = next.barrier
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
  self.inbox.push(data)
  let events = []
  while true {
    match self.inbox.line(self.limits.line) {
      More => break
      Long(got, ..) => raise Exceeded(limit=self.limits.line, got~)
      Got(line) =>
        if self.reply_line(line) is Some(reply) {
          self.dispatch(reply, events)
        }
    }
  }
  events
}

///|
/// Add one reply line; a whole reply once its last line is in.
fn Client::reply_line(self : Client, line : String) -> Reply? raise Refused {
  if line.length() < 3 {
    raise Malformed("a reply line needs a code: " + line)
  }
  guard number(line[:3]) is Some(code) && code >= 200 && code < 600 else {
    raise Malformed("a reply code is three digits from 200 to 599: " + line)
  }
  let more = line.length() > 3 && line[3] == '-'
  if line.length() > 3 && line[3] != ' ' && !more {
    raise Malformed("a reply code is followed by a space or a hyphen: " + line)
  }
  if self.partial.length() > 0 && self.code != code {
    raise Malformed("a multi-line reply changed its code")
  }
  self.partial.push(if line.length() > 4 { line[4:].to_owned() } else { "" })
  self.code = code
  if more {
    return None
  }
  let reply = { code, lines: self.partial.copy(), }
  self.partial.clear()
  Some(reply)
}

///|
fn Client::dispatch(
  self : Client,
  reply : Reply,
  events : Array[Event],
) -> Unit {
  if !self.greeted {
    self.greeted = true
    events.push(Reply(Greeting, reply))
    return
  }
  guard self.waiting is [front, ..] else {
    events.push(Reply(Greeting, reply))
    return
  }
  match front.command {
    Auth(_) if reply.code == 334 => {
      let answer = match front.initial {
        Some(data) => {
          front.initial = None
          @base64.encode(data[:])
        }
        None =>
          @sasl.respond(front.mechanism.unwrap(), reply.text()) catch {
            refused => {
              events.push(Sasl(refused))
              "*"
            }
          }
      }
      self.urgent.write_bytes(@utf8.encode(answer + "\r\n"))
      return
    }
    Data if reply.code == 354 =>
      if front.body is Some(body) {
        front.body = None
        self.urgent.write_bytes(body)
        return
      }
    _ => ()
  }
  let _ = self.waiting.remove(0)
  let mut command = front.command
  match front.command {
    Hello(_) =>
      if reply.is_ok() {
        self.hello = Done
        // A HELO reply announces nothing.
        self.extensions = if front.line[0] == b'H' {
          Map([])
        } else {
          announced(reply)
        }
      } else {
        self.hello = Unsent
      }
    StartTls =>
      if reply.code == 220 {
        self.hello = Unsent
        self.extensions = Map([])
        self.txn = None
        // What followed the 220 in the clear was not protected; TLS starts
        // from nothing (RFC 3207 section 4.2).
        self.inbox.at = self.inbox.data.length()
      }
    Auth(_) =>
      if reply.code == 235 {
        front.mechanism.unwrap().finish() catch {
          refused => {
            events.push(Sasl(refused))
            return
          }
        }
      }
    Mail(_) =>
      if !reply.is_ok() && self.txn is Some(open) && front.txn is Some(mine) {
        if physical_equal(open, mine) {
          self.txn = None
        }
      }
    Rcpt(to) =>
      if reply.is_ok() && front.txn is Some(txn) {
        txn.accepted.push(to)
      }
    Data =>
      if front.body is Some(_) {
        if !reply.is_ok() && self.txn is None {
          self.txn = front.txn
        }
      } else {
        command = self.deliveries(front, command)
      }
    Bdat(_) => if front.last { command = self.deliveries(front, command) }
    _ => ()
  }
  events.push(Reply(command, reply))
}

///|
/// Under LMTP the reply after the message is the first of one per accepted
/// recipient: name it for that recipient, and expect the others next.
fn Client::deliveries(
  self : Client,
  front : Pending,
  command : Command,
) -> Command {
  guard self.lmtp && front.txn is Some(txn) && txn.accepted is [first, .. rest] else {
    return command
  }
  for i = rest.length() - 1; i >= 0; i = i - 1 {
    self.waiting.insert(0, {
      command: Delivery(rest[i]),
      line: b"",
      barrier: true,
      txn: None,
      mechanism: None,
      initial: None,
      body: None,
      last: false,
    })
  }
  Delivery(first)
}

///|
fn Client::require(self : Client, name : String) -> Unit raise Refused {
  guard self.hello is Done else {
    raise Order("the EHLO reply has not arrived")
  }
  if !self.has(name) {
    raise Unsupported(name)
  }
}

///|
/// The extensions an `EHLO` reply announces, one per line after the first. An
/// old server's `AUTH=` line counts as `AUTH`.
fn announced(reply : Reply) -> Map[String, String] {
  let out = Map([])
  for line in reply.lines[1:] {
    let (keyword, params) = match line.find(" ") {
      Some(i) => (line[:i].to_upper(), line[i + 1:].to_owned())
      None => (line[:].to_upper(), "")
    }
    let keyword = keyword.to_owned()
    if keyword.has_prefix("AUTH=") {
      if !out.contains("AUTH") {
        out["AUTH"] = keyword[5:].to_owned() +
          (if params.is_empty() { "" } else { " " + params })
      }
    } else {
      out[keyword] = params
    }
  }
  out
}

///|
/// The message as `DATA` carries it: every line ended by CRLF whatever ended
/// it, a dot doubled at the start of a line, and the `.` line that closes it.
fn stuff(message : BytesView) -> Bytes {
  let out = Buffer(size_hint=message.length() + 16)
  let mut start = true
  let mut i = 0
  while i < message.length() {
    let b = message[i]
    if start && b == b'.' {
      out.write_byte(b'.')
    }
    if b == b'\r' {
      out.write_bytes(b"\r\n")
      start = true
      if i + 1 < message.length() && message[i + 1] == b'\n' {
        i += 1
      }
    } else if b == b'\n' {
      out.write_bytes(b"\r\n")
      start = true
    } else {
      out.write_byte(b)
      start = false
    }
    i += 1
  }
  if !start {
    out.write_bytes(b"\r\n")
  }
  out.write_bytes(b".\r\n")
  out.to_bytes()
}

///|
/// A command argument: something, and no line break or control character to
/// smuggle a second command in.
fn argument(text : String) -> Unit raise Refused {
  if text.is_empty() || text.iter().any(c => c < ' ' || c == '\u{7F}') {
    raise Malformed("not a command argument: " + text)
  }
}

///|
/// A path for `MAIL` or `RCPT`: no angle bracket and no control character.
fn path(address : String) -> Unit raise Refused {
  if address.iter().any(c => c < ' ' || c == '\u{7F}' || c == '<' || c == '>') {
    raise Malformed("not an address: " + address)
  }
}

///|
/// A decimal count, digits only.
fn number(text : StringView) -> Int32? {
  if text.is_empty() || text.length() > 10 {
    return None
  }
  let mut n = 0L
  for c in text {
    guard c >= '0' && c <= '9' else { return None }
    n = n * 10 + (c.to_int() - '0'.to_int()).to_int64()
  }
  if n > 0x7FFFFFFFL {
    None
  } else {
    Some(n.to_int())
  }
}
