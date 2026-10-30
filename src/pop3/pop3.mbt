// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// Where the dialogue stands. A client may only send authorization commands
/// before it authenticates, and mailbox commands only after.
pub(all) enum Pop3State {
  Authorization
  Transaction
  Update
} derive(Eq)

///|
pub extend Pop3State with Eq::{not_equal, equal}

///|
/// Everything that can go wrong: the server answered `-ERR`, the wire broke, or
/// a reply did not have the shape the command needs.
pub(all) suberror Pop3Error {
  Server(msg~ : String)
  Io(msg~ : String)
  Protocol(msg~ : String)
  /// The SASL mechanism refused to go on.
  Sasl(@sasl.Refused)
}

///|
/// The transport the client talks over. A socket, a TLS stream and a scripted
/// test all implement this; the client never knows which one it has.
pub(open) trait Pop3Io {
  fn write_line(Self, String) -> Unit raise Pop3Error
  fn read_line(Self) -> String raise Pop3Error
}

///|
/// Result of `STAT`: how many messages, how many octets.
pub struct Stat {
  count : Int32
  size : Int32
}

///|
/// One row of `LIST`: a message number and its size in octets.
pub struct MessageInfo {
  number : Int32
  size : Int32
}

///|
/// One row of `UIDL`: a message number and its unique id.
pub struct UidlEntry {
  number : Int32
  uid : String
}

///|
/// A POP3 client over some transport. It holds the dialogue state so a mailbox
/// command sent before authentication is refused locally, before it reaches the
/// server.
pub struct Pop3 {
  io : &Pop3Io
  mut state : Pop3State
}

///|
pub fn Pop3::new(io : &Pop3Io) -> Pop3 {
  { io, state: Pop3State::Authorization, }
}

///|
/// The current state of the dialogue.
pub fn Pop3::state(self : Pop3) -> Pop3State {
  self.state
}

///|
/// Read the greeting the server sends when the connection opens.
pub fn Pop3::greeting(self : Pop3) -> String raise Pop3Error {
  let line = self.io.read_line()
  if !is_ok(line) {
    raise Pop3Error::Server(msg=line)
  }
  line
}

///|
pub fn Pop3::user(self : Pop3, name : String) -> Unit raise Pop3Error {
  self.require_state(Pop3State::Authorization)
  let _ = self.command("USER " + name)
}

///|
pub fn Pop3::pass(self : Pop3, secret : String) -> Unit raise Pop3Error {
  self.require_state(Pop3State::Authorization)
  let _ = self.command("PASS " + secret)
  self.state = Pop3State::Transaction
}

///|
/// Ask to start TLS (RFC 2595 `STLS`). The transport is the caller's to upgrade.
pub fn Pop3::starttls(self : Pop3) -> Unit raise Pop3Error {
  let _ = self.command("STLS")
}

///|
/// Authenticate with APOP (RFC 1939): a name and the hex MD5 of the greeting
/// timestamp and the shared secret, which the caller computes.
pub fn Pop3::apop(
  self : Pop3,
  name : String,
  digest : String,
) -> Unit raise Pop3Error {
  self.require_state(Pop3State::Authorization)
  let _ = self.command("APOP " + name + " " + digest)
  self.state = Pop3State::Transaction
}

///|
/// SASL authentication (RFC 5034): `AUTH`, the mechanism's first response on
/// the first `+` when it has one and its next step on every other, then the
/// `+OK` that moves the dialogue into the transaction state. When the mechanism
/// refuses to go on, the exchange is cancelled with `*` and its refusal raised.
pub fn Pop3::authenticate(
  self : Pop3,
  mechanism : &@sasl.Mechanism,
) -> Unit raise Pop3Error {
  self.require_state(Pop3State::Authorization)
  self.io.write_line("AUTH " + mechanism.name())
  let mut pending = mechanism.start()
  let mut refused = None
  let mut done = false
  while !done {
    let line = self.io.read_line()
    let view = line[:]
    if view.length() > 0 && view[0] == '-' {
      if refused is Some(e) {
        raise Sasl(e)
      }
      raise Pop3Error::Server(msg=line)
    } else if starts_with_ok(line) {
      done = true
    } else if view.length() > 0 && view[0] == '+' {
      match pending {
        Some(data) => {
          pending = None
          self.io.write_line(@base64.encode(data[:]))
        }
        None => {
          let challenge = if view.length() >= 2 && view[1] == ' ' {
            view[2:]
          } else {
            view[1:]
          }
          self.io.write_line(
            @sasl.respond(mechanism, challenge) catch {
              e => {
                refused = Some(e)
                "*"
              }
            },
          )
        }
      }
    } else {
      raise Pop3Error::Protocol(msg="unexpected reply: " + line)
    }
  }
  mechanism.finish() catch {
    e => raise Sasl(e)
  }
  self.state = Pop3State::Transaction
}

///|
pub fn Pop3::stat(self : Pop3) -> Stat raise Pop3Error {
  self.require_state(Pop3State::Transaction)
  let line = self.command("STAT")
  let fields = split_spaces(line)
  if fields.length() < 3 {
    raise Pop3Error::Protocol(msg="STAT reply needs a count and a size")
  }
  { count: parse_int(fields[1]), size: parse_int(fields[2]), }
}

///|
pub fn Pop3::list(self : Pop3) -> Array[MessageInfo] raise Pop3Error {
  self.require_state(Pop3State::Transaction)
  let lines = self.command_multiline("LIST")
  let out : Array[MessageInfo] = []
  for line in lines {
    let fields = split_spaces(line)
    if fields.length() >= 2 {
      out.push({ number: parse_int(fields[0]), size: parse_int(fields[1]), })
    }
  }
  out
}

///|
pub fn Pop3::list_one(self : Pop3, number : Int32) -> Int32 raise Pop3Error {
  self.require_state(Pop3State::Transaction)
  let line = self.command("LIST " + number.to_string())
  let fields = split_spaces(line)
  if fields.length() < 3 {
    raise Pop3Error::Protocol(msg="LIST n reply needs a size")
  }
  parse_int(fields[2])
}

///|
pub fn Pop3::uidl(self : Pop3) -> Array[UidlEntry] raise Pop3Error {
  self.require_state(Pop3State::Transaction)
  let lines = self.command_multiline("UIDL")
  let out : Array[UidlEntry] = []
  for line in lines {
    let fields = split_spaces(line)
    if fields.length() >= 2 {
      out.push({ number: parse_int(fields[0]), uid: fields[1], })
    }
  }
  out
}

///|
/// The unique id of a single message (`UIDL n`, RFC 1939 §5), which is the one
/// piece of state a client can compare across sessions.
pub fn Pop3::uidl_one(self : Pop3, number : Int32) -> String raise Pop3Error {
  self.require_state(Pop3State::Transaction)
  let line = self.command("UIDL " + number.to_string())
  let fields = split_spaces(line)
  if fields.length() < 3 {
    raise Pop3Error::Protocol(msg="UIDL n reply needs a unique id")
  }
  fields[2]
}

///|
/// The capability names `CAPA` reported, without their arguments: `TOP`, `UIDL`,
/// `SASL`, and so on.
pub fn Pop3::capa_names(self : Pop3) -> Array[String] raise Pop3Error {
  let lines = self.capa()
  let out : Array[String] = []
  for line in lines {
    let fields = split_spaces(line)
    if fields.length() > 0 {
      out.push(fields[0])
    }
  }
  out
}

///|
/// Fetch a whole message as octets, keeping the CRLF endings. Same dialogue as
/// `retr`, for a caller that wants bytes rather than a string.
pub fn Pop3::retr_bytes(self : Pop3, number : Int32) -> Bytes raise Pop3Error {
  self.require_state(Pop3State::Transaction)
  let lines = self.command_multiline("RETR " + number.to_string())
  let out = Buffer()
  for line in lines {
    out.write_string_utf8(line)
    out.write_string_utf8("\r\n")
  }
  out.to_bytes()
}

///|
/// `LAST` (the original RFC 1081 command, still answered by old servers): the
/// highest message number the session has seen.
pub fn Pop3::last(self : Pop3) -> Int32 raise Pop3Error {
  self.require_state(Pop3State::Transaction)
  let line = self.command("LAST")
  let fields = split_spaces(line)
  if fields.length() < 2 {
    raise Pop3Error::Protocol(msg="LAST reply needs a number")
  }
  parse_int(fields[1])
}

///|
/// Fetch a whole message. The reply is the message as it stood on the server,
/// every line ending in CRLF, already dot-unstuffed.
pub fn Pop3::retr(self : Pop3, number : Int32) -> String raise Pop3Error {
  self.require_state(Pop3State::Transaction)
  let lines = self.command_multiline("RETR " + number.to_string())
  join_lines(lines)
}

///|
/// Fetch a message's headers plus its first `lines` body lines.
pub fn Pop3::top(
  self : Pop3,
  number : Int32,
  lines : Int32,
) -> String raise Pop3Error {
  self.require_state(Pop3State::Transaction)
  let body = self.command_multiline(
    "TOP " + number.to_string() + " " + lines.to_string(),
  )
  join_lines(body)
}

///|
pub fn Pop3::dele(self : Pop3, number : Int32) -> Unit raise Pop3Error {
  self.require_state(Pop3State::Transaction)
  let _ = self.command("DELE " + number.to_string())
}

///|
pub fn Pop3::noop(self : Pop3) -> Unit raise Pop3Error {
  self.require_state(Pop3State::Transaction)
  let _ = self.command("NOOP")
}

///|
pub fn Pop3::rset(self : Pop3) -> Unit raise Pop3Error {
  self.require_state(Pop3State::Transaction)
  let _ = self.command("RSET")
}

///|
/// Ask what the server can do beyond the base protocol (`CAPA`, RFC 2449).
pub fn Pop3::capa(self : Pop3) -> Array[String] raise Pop3Error {
  self.command_multiline("CAPA")
}

///|
pub fn Pop3::quit(self : Pop3) -> Unit raise Pop3Error {
  let _ = self.command("QUIT")
  self.state = Pop3State::Update
}

///|
fn Pop3::require_state(self : Pop3, wanted : Pop3State) -> Unit raise Pop3Error {
  if self.state != wanted {
    raise Pop3Error::Protocol(msg="command not allowed in this state")
  }
}

///|
fn Pop3::command(self : Pop3, text : String) -> String raise Pop3Error {
  self.io.write_line(text)
  let line = self.io.read_line()
  if !is_ok(line) {
    raise Pop3Error::Server(msg=line)
  }
  line
}

///|
/// Send a command and read its multi-line reply, undoing dot-stuffing: a line
/// beginning with `.` on the wire carries one extra `.`, and a line of a single
/// `.` ends the reply and is not part of it.
fn Pop3::command_multiline(
  self : Pop3,
  text : String,
) -> Array[String] raise Pop3Error {
  let _ = self.command(text)
  let out : Array[String] = []
  while true {
    let line = self.io.read_line()
    if line == "." {
      break
    }
    let view = line[:]
    if view.length() > 0 && view[0] == '.' {
      out.push(line[1:].to_owned())
    } else {
      out.push(line)
    }
  }
  out
}

///|
fn starts_with_ok(line : String) -> Bool {
  let view = line[:]
  view.length() >= 3 &&
  view[0] == '+' &&
  (view[1] == 'O' || view[1] == 'o') &&
  (view[2] == 'K' || view[2] == 'k')
}

///|
fn is_ok(line : String) -> Bool {
  let view = line[:]
  view.length() > 0 && view[0] == '+'
}

///|
fn split_spaces(s : String) -> Array[String] {
  let out : Array[String] = []
  let mut cur = ""
  for c in s {
    if c == ' ' || c == '\t' {
      if cur.length() > 0 {
        out.push(cur)
        cur = ""
      }
    } else {
      cur = cur + c.to_string()
    }
  }
  if cur.length() > 0 {
    out.push(cur)
  }
  out
}

///|
fn parse_int(s : String) -> Int32 raise Pop3Error {
  let mut n = 0
  let mut any = false
  for c in s {
    if c >= '0' && c <= '9' {
      n = n * 10 + (c.to_int() - '0'.to_int())
      any = true
    } else {
      break
    }
  }
  if !any {
    raise Pop3Error::Protocol(msg="expected a number, got: " + s)
  }
  n
}

///|
fn join_lines(lines : Array[String]) -> String {
  let out = StringBuilder()
  for line in lines {
    out.write_string(line)
    out.write_string("\r\n")
  }
  out.to_string()
}
