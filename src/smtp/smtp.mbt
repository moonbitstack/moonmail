// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// What went wrong: the relay answered outside the code the command needs, the
/// wire broke, or the client was asked to do something out of order.
pub(all) suberror SmtpError {
  Server(code~ : Int32, text~ : String)
  Io(msg~ : String)
  Protocol(msg~ : String)
  /// The SASL mechanism refused to go on.
  Sasl(@sasl.Refused)
}

///|
/// The transport the client talks over. A socket, a TLS stream and a scripted
/// test all implement this; the client never knows which one it has.
pub(open) trait SmtpIo {
  fn write_line(Self, String) -> Unit raise SmtpError
  fn write_bytes(Self, BytesView) -> Unit raise SmtpError
  fn read_line(Self) -> String raise SmtpError
}

///|
/// A reply is one code and the text lines that carried it; a multi-line reply
/// uses `250-` for the continuations and `250 ` for the last.
pub struct Reply {
  code : Int32
  lines : Array[String]
}

///|
/// An SMTP client. `new` speaks SMTP; `lmtp` speaks LMTP, which differs only in
/// that the final reply after `DATA` is per recipient.
pub struct Smtp {
  io : &SmtpIo
  lmtp : Bool
  mut greeted : Bool
  mut mail_set : Bool
  mut recipients : Int32
}

///|
pub fn Smtp::new(io : &SmtpIo) -> Smtp {
  { io, lmtp: false, greeted: false, mail_set: false, recipients: 0, }
}

///|
/// An ESMTP client: the same type as SMTP, named for the dialogue it opens with
/// `ehlo`. `new` also accepts `ehlo`; this constructor just says the intent.
pub fn Smtp::esmtp(io : &SmtpIo) -> Smtp {
  { io, lmtp: false, greeted: false, mail_set: false, recipients: 0, }
}

///|
pub fn Smtp::lmtp(io : &SmtpIo) -> Smtp {
  { io, lmtp: true, greeted: false, mail_set: false, recipients: 0, }
}

///|
/// Ask to start TLS (RFC 3207). The client expects `220`; the transport must
/// then be upgraded by the caller, and a fresh client opened over it.
pub fn Smtp::starttls(self : Smtp) -> Unit raise SmtpError {
  let _ = self.expect("STARTTLS", 220)
}

///|
/// Authenticate with SASL (RFC 4954). A first response rides on the command
/// line, `=` when it is empty; each `334` is answered with the mechanism's next
/// step. When the mechanism refuses to go on, the exchange is cancelled with `*`
/// and its refusal raised.
pub fn Smtp::authenticate(
  self : Smtp,
  mechanism : &@sasl.Mechanism,
) -> Unit raise SmtpError {
  self.require_greeted()
  let line = match mechanism.start() {
    None => "AUTH " + mechanism.name()
    Some(data) if data.is_empty() => "AUTH " + mechanism.name() + " ="
    Some(data) => "AUTH " + mechanism.name() + " " + @base64.encode(data[:])
  }
  self.io.write_line(line)
  let mut reply = self.read_reply()
  while reply.code == 334 {
    let answer = @sasl.respond(mechanism, strip_code(last_line(reply))) catch {
      refused => {
        self.io.write_line("*")
        let _ = self.read_reply()
        raise Sasl(refused)
      }
    }
    self.io.write_line(answer)
    reply = self.read_reply()
  }
  if reply.code != 235 {
    raise SmtpError::Server(code=reply.code, text=last_line(reply))
  }
  mechanism.finish() catch {
    refused => raise Sasl(refused)
  }
}

///|
/// Whether a reply is a success (`2yz`).
pub fn Reply::is_ok(self : Reply) -> Bool {
  is_2xx(self.code)
}

///|
/// The RFC 3463 enhanced status code an ESMTP reply carries, such as `2.1.5`,
/// or `""` when the reply has none.
pub fn Reply::enhanced_status(self : Reply) -> String {
  let text = strip_code(last_line(self))
  let mut out = ""
  let mut dots = 0
  for c in text {
    if c >= '0' && c <= '9' {
      out = out + c.to_string()
    } else if c == '.' && dots < 2 {
      out = out + "."
      dots = dots + 1
    } else {
      break
    }
  }
  if dots == 2 {
    out
  } else {
    ""
  }
}

///|
fn is_2xx(code : Int32) -> Bool {
  code / 100 == 2
}

///|
fn last_line(reply : Reply) -> String {
  if reply.lines.length() == 0 {
    ""
  } else {
    reply.lines[reply.lines.length() - 1]
  }
}

///|
/// Read one reply, following multi-line continuations until a line whose fourth
/// character is a space (or that has no fourth character).
fn Smtp::read_reply(self : Smtp) -> Reply raise SmtpError {
  let lines : Array[String] = []
  let mut code = 0
  while true {
    let line = self.io.read_line()
    if line.length() < 3 {
      raise SmtpError::Protocol(msg="short reply: " + line)
    }
    code = parse_code(line[:])
    lines.push(line)
    let view = line[:]
    if view.length() >= 4 && view[3] == '-' {
      continue
    }
    break
  }
  { code, lines, }
}

///|
fn Smtp::expect(
  self : Smtp,
  text : String,
  want : Int32,
) -> Reply raise SmtpError {
  self.io.write_line(text)
  let reply = self.read_reply()
  if reply.code != want {
    raise SmtpError::Server(code=reply.code, text=last_line(reply))
  }
  reply
}

///|
fn Smtp::expect_2xx(self : Smtp, text : String) -> Reply raise SmtpError {
  self.io.write_line(text)
  let reply = self.read_reply()
  if !is_2xx(reply.code) {
    raise SmtpError::Server(code=reply.code, text=last_line(reply))
  }
  reply
}

///|
/// Read the greeting the relay sends when the connection opens.
pub fn Smtp::greeting(self : Smtp) -> String raise SmtpError {
  let reply = self.read_reply()
  if reply.code != 220 {
    raise SmtpError::Server(code=reply.code, text=last_line(reply))
  }
  last_line(reply)
}

///|
/// Say hello, extended form, and return the capabilities the relay volunteered
/// (the text after each `250-`).
pub fn Smtp::ehlo(
  self : Smtp,
  domain : String,
) -> Array[String] raise SmtpError {
  let reply = self.expect("EHLO " + domain, 250)
  self.greeted = true
  let out : Array[String] = []
  let mut first = true
  for line in reply.lines {
    if first {
      first = false
      continue
    }
    out.push(strip_code(line))
  }
  out
}

///|
/// Say hello, the original form, for a relay too old for `EHLO`.
pub fn Smtp::helo(self : Smtp, domain : String) -> Unit raise SmtpError {
  let _ = self.expect("HELO " + domain, 250)
  self.greeted = true
}

///|
/// Start a transaction with an envelope sender (`null` for a bounce).
pub fn Smtp::mail_from(self : Smtp, address : String) -> Unit raise SmtpError {
  self.mail_from_with(address, [])
}

///|
/// `MAIL FROM` with ESMTP parameters such as `SIZE=...` or `BODY=8BITMIME`.
pub fn Smtp::mail_from_with(
  self : Smtp,
  address : String,
  parameters : Array[String],
) -> Unit raise SmtpError {
  self.require_greeted()
  let mut line = "MAIL FROM:<" + address + ">"
  for parameter in parameters {
    line = line + " " + parameter
  }
  let _ = self.expect_2xx(line)
  self.mail_set = true
  self.recipients = 0
}

///|
pub fn Smtp::rcpt_to(self : Smtp, address : String) -> Unit raise SmtpError {
  if !self.mail_set {
    raise SmtpError::Protocol(msg="RCPT before MAIL")
  }
  let _ = self.expect_2xx("RCPT TO:<" + address + ">")
  self.recipients = self.recipients + 1
}

///|
/// Send the body. The reply is one element for SMTP and one per accepted
/// recipient for LMTP.
pub fn Smtp::data(
  self : Smtp,
  body : BytesView,
) -> Array[Reply] raise SmtpError {
  if !self.mail_set || self.recipients == 0 {
    raise SmtpError::Protocol(msg="DATA without sender and recipients")
  }
  let _ = self.expect("DATA", 354)
  for line in body_lines(body) {
    self.io.write_line(dot_stuff(line))
  }
  self.io.write_line(".")
  let out : Array[Reply] = []
  let count = if self.lmtp { self.recipients } else { 1 }
  for _i in 0..<count {
    out.push(self.read_reply())
  }
  if !is_2xx(out[0].code) {
    raise SmtpError::Server(code=out[0].code, text=last_line(out[0]))
  }
  self.mail_set = false
  self.recipients = 0
  out
}

///|
/// `RCPT TO` with ESMTP parameters, which is how DSN asks for delivery status
/// (`NOTIFY=SUCCESS,FAILURE`) and names the original recipient (`ORCPT=...`).
pub fn Smtp::rcpt_to_with(
  self : Smtp,
  address : String,
  parameters : Array[String],
) -> Unit raise SmtpError {
  if !self.mail_set {
    raise SmtpError::Protocol(msg="RCPT before MAIL")
  }
  let mut line = "RCPT TO:<" + address + ">"
  for parameter in parameters {
    line = line + " " + parameter
  }
  let _ = self.expect_2xx(line)
  self.recipients = self.recipients + 1
}

///|
/// `BDAT` (RFC 3030 CHUNKING): send a chunk as raw octets, with neither
/// dot-stuffing nor a terminating dot. The last chunk carries `LAST`, and only
/// then does the transaction close. With LMTP the last chunk answers once per
/// recipient, so the replies are returned as a list.
pub fn Smtp::bdat(
  self : Smtp,
  chunk : BytesView,
  last : Bool,
) -> Array[Reply] raise SmtpError {
  if !self.mail_set || self.recipients == 0 {
    raise SmtpError::Protocol(msg="BDAT without sender and recipients")
  }
  let size = chunk.length()
  let verb = if last {
    "BDAT " + size.to_string() + " LAST"
  } else {
    "BDAT " + size.to_string()
  }
  self.io.write_line(verb)
  self.io.write_bytes(chunk)
  let count = if last && self.lmtp { self.recipients } else { 1 }
  let out : Array[Reply] = []
  for _i in 0..<count {
    out.push(self.read_reply())
  }
  if !is_2xx(out[0].code) {
    raise SmtpError::Server(code=out[0].code, text=last_line(out[0]))
  }
  if last {
    self.mail_set = false
    self.recipients = 0
  }
  out
}

///|
/// `VRFY` (RFC 5321 §3.5): ask the relay whether an address exists. Many relays
/// answer `252` ("cannot verify, will try") rather than `250`, and a few refuse
/// outright with `502`.
pub fn Smtp::vrfy(self : Smtp, address : String) -> Reply raise SmtpError {
  self.require_greeted()
  self.io.write_line("VRFY " + address)
  let reply = self.read_reply()
  if reply.code == 502 || reply.code == 550 {
    raise SmtpError::Server(code=reply.code, text=last_line(reply))
  }
  reply
}

///|
/// `EXPN`: expand a mailing list into its members.
pub fn Smtp::expn(self : Smtp, list : String) -> Array[String] raise SmtpError {
  self.require_greeted()
  self.io.write_line("EXPN " + list)
  let reply = self.read_reply()
  if !is_2xx(reply.code) {
    raise SmtpError::Server(code=reply.code, text=last_line(reply))
  }
  let out : Array[String] = []
  for line in reply.lines {
    out.push(strip_code(line))
  }
  out
}

///|
/// `HELP`: whatever the relay is willing to say about itself.
pub fn Smtp::help(self : Smtp, topic : String) -> Array[String] raise SmtpError {
  self.require_greeted()
  let text = if topic.is_empty() { "HELP" } else { "HELP " + topic }
  self.io.write_line(text)
  let reply = self.read_reply()
  if !is_2xx(reply.code) {
    raise SmtpError::Server(code=reply.code, text=last_line(reply))
  }
  let out : Array[String] = []
  for line in reply.lines {
    out.push(strip_code(line))
  }
  out
}

///|
/// Envelope sender, recipients, then body, in one call.
pub fn Smtp::send(
  self : Smtp,
  from : String,
  to : Array[String],
  body : BytesView,
) -> Array[Reply] raise SmtpError {
  self.mail_from(from)
  for address in to {
    self.rcpt_to(address)
  }
  self.data(body)
}

///|
pub fn Smtp::rset(self : Smtp) -> Unit raise SmtpError {
  let _ = self.expect_2xx("RSET")
  self.mail_set = false
  self.recipients = 0
}

///|
pub fn Smtp::noop(self : Smtp) -> Unit raise SmtpError {
  let _ = self.expect_2xx("NOOP")
}

///|
pub fn Smtp::quit(self : Smtp) -> Unit raise SmtpError {
  let _ = self.expect("QUIT", 221)
}

///|
fn Smtp::require_greeted(self : Smtp) -> Unit raise SmtpError {
  if !self.greeted {
    raise SmtpError::Protocol(msg="EHLO/HELO first")
  }
}

///|
fn parse_code(line : StringView) -> Int32 {
  let mut n = 0
  let mut i = 0
  while i < 3 && i < line.length() {
    let c = line[i]
    if c >= '0' && c <= '9' {
      n = n * 10 + (c.to_int() - '0'.to_int())
    }
    i = i + 1
  }
  n
}

///|
/// The capability text of a reply line, without its `250-`/`250 ` prefix.
fn strip_code(line : String) -> String {
  let view = line[:]
  if view.length() <= 4 {
    ""
  } else {
    view[4:].to_owned().trim().to_owned()
  }
}

///|
/// Prefix a leading dot, which is how a line whose content begins with `.` is
/// told apart from the end-of-data marker.
fn dot_stuff(line : String) -> String {
  let view = line[:]
  if view.length() > 0 && view[0] == '.' {
    "." + line
  } else {
    line
  }
}

///|
fn body_lines(body : BytesView) -> Array[String] {
  let out : Array[String] = []
  let n = body.length()
  let mut start = 0
  let mut i = 0
  while i < n {
    if body.at(i) == b'\n' {
      let mut end = i
      if end > start && body.at(end - 1) == b'\r' {
        end = end - 1
      }
      out.push(@utf8.decode_lossy(body[start:end]))
      i = i + 1
      start = i
    } else {
      i = i + 1
    }
  }
  if start < n {
    out.push(@utf8.decode_lossy(body[start:n]))
  }
  out
}
