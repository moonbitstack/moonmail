// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
pub(all) suberror NntpError {
  Server(code~ : Int32, text~ : String)
  Io(msg~ : String)
  Protocol(msg~ : String)
}

///|
pub(open) trait NntpIo {
  fn write_line(Self, String) -> Unit raise NntpError
  fn read_line(Self) -> String raise NntpError
}

///|
/// A reply is one code and the text lines that carried it.
pub struct Reply {
  code : Int32
  lines : Array[String]
}

///|
/// The current group, as `GROUP` reports it: how many articles, and the range.
pub struct Group {
  count : Int32
  first : Int32
  last : Int32
  name : String
}

///|
pub struct Nntp {
  io : &NntpIo
  mut posting : Bool
}

///|
pub fn Nntp::new(io : &NntpIo) -> Nntp {
  { io, posting: false, }
}

///|
/// Read the greeting. A `200` means posting is allowed, `201` that it is not.
pub fn Nntp::greeting(self : Nntp) -> String raise NntpError {
  let reply = self.read_status()
  if reply.code != 200 && reply.code != 201 {
    raise NntpError::Server(code=reply.code, text=last(reply))
  }
  self.posting = reply.code == 200
  last(reply)
}

///|
pub fn Nntp::capabilities(self : Nntp) -> Array[String] raise NntpError {
  let _ = self.expect("CAPABILITIES", 101)
  self.read_multiline()
}

///|
pub fn Nntp::mode_reader(self : Nntp) -> Unit raise NntpError {
  let reply = self.expect("MODE READER", 200)
  self.posting = reply.code == 200
}

///|
pub fn Nntp::date(self : Nntp) -> String raise NntpError {
  let reply = self.expect("DATE", 111)
  last_field(last(reply))
}

///|
pub fn Nntp::group(self : Nntp, name : String) -> Group raise NntpError {
  let reply = self.expect("GROUP " + name, 211)
  let fields = split_spaces(last(reply))
  if fields.length() < 5 {
    raise NntpError::Protocol(msg="GROUP reply needs count, range and name")
  }
  {
    count: parse_int(fields[1]),
    first: parse_int(fields[2]),
    last: parse_int(fields[3]),
    name: fields[4],
  }
}

///|
/// Fetch an article by number or message-id; the text is returned line by line
/// with CRLF endings, already dot-unstuffed.
pub fn Nntp::article(self : Nntp, target : String) -> String raise NntpError {
  let _ = self.expect("ARTICLE " + target, 220)
  join_lines(self.read_multiline())
}

///|
pub fn Nntp::head(self : Nntp, target : String) -> String raise NntpError {
  let _ = self.expect("HEAD " + target, 221)
  join_lines(self.read_multiline())
}

///|
pub fn Nntp::body(self : Nntp, target : String) -> String raise NntpError {
  let _ = self.expect("BODY " + target, 222)
  join_lines(self.read_multiline())
}

///|
/// Ask the server for an article's message-id without transferring it.
pub fn Nntp::stat(self : Nntp, target : String) -> String raise NntpError {
  let reply = self.expect("STAT " + target, 223)
  last_field(last(reply))
}

///|
pub fn Nntp::post(self : Nntp, article : BytesView) -> Unit raise NntpError {
  let _ = self.expect("POST", 340)
  for line in body_lines(article) {
    self.io.write_line(dot_stuff(line))
  }
  self.io.write_line(".")
  let reply = self.read_status()
  if reply.code == 441 {
    raise NntpError::Server(code=reply.code, text=last(reply))
  }
}

///|
pub fn Nntp::ihave(
  self : Nntp,
  message_id : String,
  article : BytesView,
) -> Unit raise NntpError {
  let _ = self.expect("IHAVE " + message_id, 335)
  for line in body_lines(article) {
    self.io.write_line(dot_stuff(line))
  }
  self.io.write_line(".")
  let reply = self.read_status()
  if reply.code == 435 || reply.code == 436 || reply.code == 437 {
    raise NntpError::Server(code=reply.code, text=last(reply))
  }
}

///|
pub fn Nntp::list_active(self : Nntp) -> Array[String] raise NntpError {
  let _ = self.expect("LIST ACTIVE", 215)
  self.read_multiline()
}

///|
/// `LIST ACTIVE` narrowed to a wildmat: the groups that match, with their high
/// and low article numbers and posting status.
pub fn Nntp::list_active_group(
  self : Nntp,
  pattern : String,
) -> Array[String] raise NntpError {
  let _ = self.expect("LIST ACTIVE " + pattern, 215)
  self.read_multiline()
}

///|
/// `LIST NEWSGROUPS`: the one-line description of each group.
pub fn Nntp::list_newsgroups(self : Nntp) -> Array[String] raise NntpError {
  let _ = self.expect("LIST NEWSGROUPS", 215)
  self.read_multiline()
}

///|
/// `LISTGROUP` (RFC 3977 §6.1.2): select a group and list its article numbers,
/// which is cheaper than `GROUP` plus a `STAT` per article.
pub fn Nntp::listgroup(
  self : Nntp,
  name : String,
) -> Array[String] raise NntpError {
  let _ = self.expect("LISTGROUP " + name, 211)
  self.read_multiline()
}

///|
/// `OVER` (RFC 3977 §8.3): the overview fields of each article in a range, one
/// tab-separated row each — number, subject, from, date, message-id, and so on.
pub fn Nntp::over(self : Nntp, range : String) -> Array[String] raise NntpError {
  let _ = self.expect("OVER " + range, 224)
  self.read_multiline()
}

///|
/// `HDR`: one header field of each article in a range.
pub fn Nntp::hdr(
  self : Nntp,
  field : String,
  range : String,
) -> Array[String] raise NntpError {
  let _ = self.expect("HDR " + field + " " + range, 225)
  self.read_multiline()
}

///|
/// `NEWGROUPS` (RFC 3977 §7.3): groups created since a date. `date` is the
/// `yymmdd hhmmss` form the command takes, `GMT` added by the caller when the
/// time is UTC.
pub fn Nntp::newgroups(
  self : Nntp,
  date : String,
  distributions : String,
) -> Array[String] raise NntpError {
  let text = if distributions.is_empty() {
    "NEWGROUPS " + date
  } else {
    "NEWGROUPS " + date + " <" + distributions + ">"
  }
  let _ = self.expect(text, 231)
  self.read_multiline()
}

///|
/// `NEWNEWS` (RFC 3977 §7.4): the message-ids posted to matching groups since a
/// date.
pub fn Nntp::newnews(
  self : Nntp,
  groups : String,
  date : String,
) -> Array[String] raise NntpError {
  let _ = self.expect("NEWNEWS " + groups + " " + date, 230)
  self.read_multiline()
}

///|
/// `AUTHINFO` (RFC 4643): the user name, then the password if the server asks
/// for it. A server that accepts the name alone stops at `281`.
pub fn Nntp::authinfo(
  self : Nntp,
  user : String,
  secret : String,
) -> Unit raise NntpError {
  self.io.write_line("AUTHINFO USER " + user)
  let reply = self.read_status()
  if reply.code == 281 {
    return
  }
  if reply.code != 381 {
    raise NntpError::Server(code=reply.code, text=last(reply))
  }
  let _ = self.expect("AUTHINFO PASS " + secret, 281)
}

///|
/// `HELP`: whatever the server is willing to say about its commands.
pub fn Nntp::help(self : Nntp) -> Array[String] raise NntpError {
  let _ = self.expect("HELP", 100)
  self.read_multiline()
}

///|
/// `SLAVE`: tell the server this is an automated peer, so it stops asking for
/// human-paced behaviour.
pub fn Nntp::slave(self : Nntp) -> Unit raise NntpError {
  let _ = self.expect("SLAVE", 202)
}

///|
pub fn Nntp::quit(self : Nntp) -> Unit raise NntpError {
  let _ = self.expect("QUIT", 205)
}

///|
fn Nntp::read_status(self : Nntp) -> Reply raise NntpError {
  let line = self.io.read_line()
  if line.length() < 3 {
    raise NntpError::Protocol(msg="short reply: " + line)
  }
  { code: parse_code(line[:]), lines: [line], }
}

///|
fn Nntp::expect(
  self : Nntp,
  text : String,
  want : Int32,
) -> Reply raise NntpError {
  self.io.write_line(text)
  let reply = self.read_status()
  if reply.code != want {
    raise NntpError::Server(code=reply.code, text=last(reply))
  }
  reply
}

///|
fn Nntp::read_multiline(self : Nntp) -> Array[String] raise NntpError {
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
fn last(reply : Reply) -> String {
  if reply.lines.length() == 0 {
    ""
  } else {
    reply.lines[reply.lines.length() - 1]
  }
}

///|
fn last_field(line : String) -> String {
  let fields = split_spaces(line)
  if fields.length() == 0 {
    ""
  } else {
    fields[fields.length() - 1]
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
fn parse_int(s : String) -> Int32 raise NntpError {
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
    raise NntpError::Protocol(msg="expected a number, got: " + s)
  }
  n
}

///|
fn dot_stuff(line : String) -> String {
  let view = line[:]
  if view.length() > 0 && view[0] == '.' {
    "." + line
  } else {
    line
  }
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
