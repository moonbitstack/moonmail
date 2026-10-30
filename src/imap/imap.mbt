// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// What went wrong: a `NO`/`BAD` tagged reply, the wire broke, or the server
/// spoke something the client did not expect.
pub(all) suberror ImapError {
  Server(status~ : String, text~ : String)
  Io(msg~ : String)
  Protocol(msg~ : String)
  /// The SASL mechanism refused to go on.
  Sasl(@sasl.Refused)
}

///|
/// The transport. IMAP needs more than lines: a literal arrives as a `{n}` on a
/// line followed by exactly `n` octets, and an `APPEND` sends one back.
pub(open) trait ImapIo {
  fn write_line(Self, String) -> Unit raise ImapError
  fn write_bytes(Self, BytesView) -> Unit raise ImapError
  fn read_line(Self) -> String raise ImapError
  fn read_exact(Self, Int32) -> Bytes raise ImapError
}

///|
/// What `SELECT` reports: how many messages, how many recent.
pub struct Mailbox {
  exists : Int32
  recent : Int32
}

///|
pub struct Imap {
  io : &ImapIo
  mut tag_no : Int32
  mut selected : String?
}

///|
pub fn Imap::new(io : &ImapIo) -> Imap {
  { io, tag_no: 0, selected: None, }
}

///|
/// The mailbox currently selected, if any.
pub fn Imap::selected_mailbox(self : Imap) -> String? {
  self.selected
}

///|
/// Read the greeting (`* OK ...`).
pub fn Imap::greeting(self : Imap) -> String raise ImapError {
  self.read_logical_line()
}

///|
pub fn Imap::login(
  self : Imap,
  user : String,
  secret : String,
) -> Unit raise ImapError {
  let _ = self.run_ok("LOGIN " + user + " " + secret)
}

///|
/// Ask to start TLS (RFC 2595 `STARTTLS`). The transport is the caller's to
/// upgrade; a fresh client is opened over it.
pub fn Imap::starttls(self : Imap) -> Unit raise ImapError {
  let _ = self.run_ok("STARTTLS")
}

///|
/// SASL authentication (RFC 3501 `AUTHENTICATE`). The first `+` continuation
/// takes the mechanism's first response when it has one; every other one is
/// answered with its next step. When the mechanism refuses to go on, the
/// exchange is cancelled with `*` and its refusal raised.
pub fn Imap::authenticate(
  self : Imap,
  mechanism : &@sasl.Mechanism,
) -> Unit raise ImapError {
  let tag = self.next_tag()
  self.io.write_line(tag + " AUTHENTICATE " + mechanism.name())
  let mut pending = mechanism.start()
  let mut refused = None
  let mut status = ""
  while status == "" {
    let line = self.read_logical_line()
    let view = line[:]
    if view.length() > 0 && view[0] == '+' {
      match pending {
        Some(data) => {
          pending = None
          self.io.write_line(@base64.encode(data[:]))
        }
        None =>
          self.io.write_line(
            @sasl.respond(mechanism, continuation(line)) catch {
              e => {
                refused = Some(e)
                "*"
              }
            },
          )
      }
    } else if view.length() > tag.length() &&
      starts_with(view, tag) &&
      view[tag.length()] == ' ' {
      status = line
    }
  }
  if refused is Some(e) {
    raise Sasl(e)
  }
  if !status_ok(status) {
    raise ImapError::Server(status~, text=status)
  }
  mechanism.finish() catch {
    e => raise Sasl(e)
  }
}

///|
/// The challenge on a continuation line: what follows the `+` and its space.
fn continuation(line : String) -> StringView {
  let view = line[:]
  if view.length() >= 2 && view[1] == ' ' {
    view[2:]
  } else {
    view[1:]
  }
}

///|
pub fn Imap::capability(self : Imap) -> Array[String] raise ImapError {
  let untagged = self.run_ok("CAPABILITY")
  let out : Array[String] = []
  for line in untagged {
    let fields = split_spaces(line)
    if fields.length() >= 2 && fields[1] == "CAPABILITY" {
      for i in 2..<fields.length() {
        out.push(fields[i])
      }
    }
  }
  out
}

///|
pub fn Imap::select(self : Imap, mailbox : String) -> Mailbox raise ImapError {
  let untagged = self.run_ok("SELECT " + mailbox)
  self.selected = Some(mailbox)
  mailbox_counts(untagged)
}

///|
/// Same as `SELECT` but read-only: the server must not set `\Recent`.
pub fn Imap::examine(self : Imap, mailbox : String) -> Mailbox raise ImapError {
  let untagged = self.run_ok("EXAMINE " + mailbox)
  self.selected = Some(mailbox)
  mailbox_counts(untagged)
}

///|
/// The raw `* LIST ...` lines. The name and delimiter live in the line and are
/// left to the caller, since mailbox names can be quoted or literal.
pub fn Imap::list(
  self : Imap,
  reference : String,
  pattern : String,
) -> Array[String] raise ImapError {
  self.run_ok("LIST \"" + reference + "\" \"" + pattern + "\"")
}

///|
/// The raw `* n FETCH ...` lines for a sequence set and item list.
pub fn Imap::fetch(
  self : Imap,
  sequence : String,
  items : String,
) -> Array[String] raise ImapError {
  self.run_ok("FETCH " + sequence + " " + items)
}

///|
/// The message numbers `SEARCH` matched.
pub fn Imap::search(
  self : Imap,
  criteria : String,
) -> Array[Int32] raise ImapError {
  search_numbers(self.run_ok("SEARCH " + criteria))
}

///|
/// `UID SEARCH` (RFC 3501 §6.4.8): the same criteria, but the numbers are UIDs
/// and so do not shift when other messages are expunged.
pub fn Imap::uid_search(
  self : Imap,
  criteria : String,
) -> Array[Int32] raise ImapError {
  search_numbers(self.run_ok("UID SEARCH " + criteria))
}

///|
fn search_numbers(untagged : Array[String]) -> Array[Int32] {
  let out : Array[Int32] = []
  for line in untagged {
    let fields = split_spaces(line)
    if fields.length() >= 2 && fields[1] == "SEARCH" {
      for i in 2..<fields.length() {
        out.push(parse_int(fields[i]))
      }
    }
  }
  out
}

///|
/// `FETCH`, addressed by UID. The raw `* n FETCH ...` lines are returned; each
/// carries `UID` in the list when the caller asked for it.
pub fn Imap::uid_fetch(
  self : Imap,
  uids : String,
  items : String,
) -> Array[String] raise ImapError {
  self.run_ok("UID FETCH " + uids + " " + items)
}

///|
pub fn Imap::uid_store(
  self : Imap,
  uids : String,
  item : String,
  flags : String,
) -> Unit raise ImapError {
  let _ = self.run_ok("UID STORE " + uids + " " + item + " " + flags)
}

///|
pub fn Imap::uid_copy(
  self : Imap,
  uids : String,
  mailbox : String,
) -> Unit raise ImapError {
  let _ = self.run_ok("UID COPY " + uids + " " + mailbox)
}

///|
pub fn Imap::uid_move(
  self : Imap,
  uids : String,
  mailbox : String,
) -> Unit raise ImapError {
  let _ = self.run_ok("UID MOVE " + uids + " " + mailbox)
}

///|
/// Remove the messages flagged `\Deleted`. The `* n EXPUNGE` lines come back in
/// the order the server sent them.
pub fn Imap::expunge(self : Imap) -> Array[String] raise ImapError {
  self.run_ok("EXPUNGE")
}

///|
/// `UID EXPUNGE` (RFC 4315): expunge only the UIDs named, which is what makes
/// "delete exactly what I searched for" safe.
pub fn Imap::uid_expunge(
  self : Imap,
  uids : String,
) -> Array[String] raise ImapError {
  self.run_ok("UID EXPUNGE " + uids)
}

///|
pub fn Imap::store(
  self : Imap,
  sequence : String,
  item : String,
  flags : String,
) -> Unit raise ImapError {
  let _ = self.run_ok("STORE " + sequence + " " + item + " " + flags)
}

///|
pub fn Imap::copy(
  self : Imap,
  sequence : String,
  mailbox : String,
) -> Unit raise ImapError {
  let _ = self.run_ok("COPY " + sequence + " " + mailbox)
}

///|
/// `MOVE` (RFC 6851): copy then remove, server-side.
pub fn Imap::move_to(
  self : Imap,
  sequence : String,
  mailbox : String,
) -> Unit raise ImapError {
  let _ = self.run_ok("MOVE " + sequence + " " + mailbox)
}

///|
/// Upload a message into a mailbox. The body goes as a literal after the
/// server's continuation request.
pub fn Imap::append(
  self : Imap,
  mailbox : String,
  message : BytesView,
) -> Unit raise ImapError {
  self.append_with(mailbox, [], message)
}

///|
/// `APPEND` with the flags the message should arrive carrying.
pub fn Imap::append_with(
  self : Imap,
  mailbox : String,
  flags : Array[String],
  message : BytesView,
) -> Unit raise ImapError {
  let tag = self.next_tag()
  let size = message.length()
  let mut line = tag + " APPEND " + mailbox
  if flags.length() > 0 {
    let mut list = " ("
    let mut first = true
    for flag in flags {
      if !first {
        list = list + " "
      }
      list = list + flag
      first = false
    }
    line = line + list + ")"
  }
  self.io.write_line(line + " {" + size.to_string() + "}")
  let continuation = self.io.read_line()
  if continuation.length() == 0 || continuation[0] != '+' {
    raise ImapError::Protocol(msg="expected continuation, got: " + continuation)
  }
  self.io.write_bytes(message)
  self.io.write_line("")
  let (untagged, status) = self.read_until_tagged(tag)
  let _ = untagged
  if !status_ok(status) {
    raise ImapError::Server(status~, text=status)
  }
}

///|
/// What `STATUS` reports for a mailbox. A server answers only the items it was
/// asked for, so anything not requested is zero.
pub struct Status {
  mailbox : String
  messages : Int32
  recent : Int32
  uid_next : Int32
  uid_validity : Int32
  unseen : Int32
}

///|
/// Ask about a mailbox without selecting it. `items` are the RFC 3501 names:
/// `MESSAGES`, `RECENT`, `UIDNEXT`, `UIDVALIDITY`, `UNSEEN`.
pub fn Imap::status(
  self : Imap,
  mailbox : String,
  items : Array[String],
) -> Status raise ImapError {
  let mut list = "("
  let mut first = true
  for item in items {
    if !first {
      list = list + " "
    }
    list = list + item
    first = false
  }
  let untagged = self.run_ok("STATUS " + mailbox + " " + list + ")")
  for line in untagged {
    match parse_status_line(line) {
      Some(status) => return status
      None => ()
    }
  }
  raise ImapError::Protocol(msg="no STATUS response")
}

///|
pub fn Imap::noop(self : Imap) -> Unit raise ImapError {
  let _ = self.run_ok("NOOP")
}

///|
pub fn Imap::logout(self : Imap) -> Unit raise ImapError {
  let _ = self.run_ok("LOGOUT")
  self.selected = None
}

///|
/// `CLOSE`: expunge, then leave the selected state.
pub fn Imap::close(self : Imap) -> Unit raise ImapError {
  let _ = self.run_ok("CLOSE")
  self.selected = None
}

///|
/// `UNSELECT` (RFC 3691): leave the selected state without expunging.
pub fn Imap::unselect(self : Imap) -> Unit raise ImapError {
  let _ = self.run_ok("UNSELECT")
  self.selected = None
}

///|
pub fn Imap::create_mailbox(
  self : Imap,
  mailbox : String,
) -> Unit raise ImapError {
  let _ = self.run_ok("CREATE " + mailbox)
}

///|
pub fn Imap::delete_mailbox(
  self : Imap,
  mailbox : String,
) -> Unit raise ImapError {
  let _ = self.run_ok("DELETE " + mailbox)
}

///|
pub fn Imap::rename_mailbox(
  self : Imap,
  from : String,
  to : String,
) -> Unit raise ImapError {
  let _ = self.run_ok("RENAME " + from + " " + to)
}

///|
pub fn Imap::subscribe(self : Imap, mailbox : String) -> Unit raise ImapError {
  let _ = self.run_ok("SUBSCRIBE " + mailbox)
}

///|
pub fn Imap::unsubscribe(self : Imap, mailbox : String) -> Unit raise ImapError {
  let _ = self.run_ok("UNSUBSCRIBE " + mailbox)
}

///|
/// The raw `* NAMESPACE ...` lines (RFC 2342). Which separator and prefix a
/// server uses is in the line, since servers differ.
pub fn Imap::namespaces(self : Imap) -> Array[String] raise ImapError {
  self.run_ok("NAMESPACE")
}

///|
/// Turn on an extension capability the server advertised (RFC 5161 `ENABLE`),
/// such as `CONDSTORE` or `UTF8=ACCEPT`. Returns what the server reported as
/// enabled, from its `* ENABLED` line.
pub fn Imap::enable(
  self : Imap,
  capability : String,
) -> Array[String] raise ImapError {
  let untagged = self.run_ok("ENABLE " + capability)
  let out : Array[String] = []
  for line in untagged {
    let fields = split_spaces(line)
    if fields.length() >= 2 && fields[1] == "ENABLED" {
      for i in 2..<fields.length() {
        out.push(fields[i])
      }
    }
  }
  out
}

///|
/// `IDLE` (RFC 2177) for one round: announce idling, take the responses that
/// arrive until the first one lands, then say `DONE` and read the completion.
/// The events collected are returned, so a caller can loop over this and act on
/// each new message as it arrives.
///
/// One round per call keeps the client synchronous: there is no timer here, so
/// the caller decides how often to idle rather than blocking inside the client.
pub fn Imap::idle_once(self : Imap) -> Array[String] raise ImapError {
  let tag = self.next_tag()
  self.io.write_line(tag + " IDLE")
  let continuation = self.io.read_line()
  if continuation.length() == 0 || continuation[0] != '+' {
    raise ImapError::Protocol(msg="IDLE without continuation: " + continuation)
  }
  let events : Array[String] = []
  let mut sent_done = false
  let mut done = false
  while !done {
    let line = self.io.read_line()
    if is_tagged_line(line, tag) {
      if !status_ok(line) {
        raise ImapError::Server(status=line, text=line)
      }
      done = true
    } else {
      events.push(line)
      if !sent_done {
        self.io.write_line("DONE")
        sent_done = true
      }
    }
  }
  events
}

///|
fn Imap::next_tag(self : Imap) -> String {
  self.tag_no = self.tag_no + 1
  "A" + pad3(self.tag_no)
}

///|
fn Imap::run_ok(self : Imap, command : String) -> Array[String] raise ImapError {
  let tag = self.next_tag()
  self.io.write_line(tag + " " + command)
  let (untagged, status) = self.read_until_tagged(tag)
  if !status_ok(status) {
    raise ImapError::Server(status~, text=status)
  }
  untagged
}

///|
/// Read responses until the line tagged `tag`, collecting the untagged ones.
fn Imap::read_until_tagged(
  self : Imap,
  tag : String,
) -> (Array[String], String) raise ImapError {
  let untagged : Array[String] = []
  let mut status = ""
  let mut done = false
  while !done {
    let line = self.read_logical_line()
    if is_tagged_line(line, tag) {
      status = line
      done = true
    } else if line.length() > 0 && line[0] == '+' {
      // A continuation request with no command waiting; ignore it.
    } else {
      untagged.push(line)
    }
  }
  (untagged, status)
}

///|
/// Whether a response line opens with this command's tag.
fn is_tagged_line(line : String, tag : String) -> Bool {
  let view = line[:]
  view.length() > tag.length() &&
  starts_with(view, tag) &&
  view[tag.length()] == ' '
}

///|
/// A `* STATUS "name" (MESSAGES 3 ...)` line, or `None` when the line is not one.
fn parse_status_line(line : String) -> Status? {
  match line.find("("[:]) {
    Some(start) =>
      match line.find(")"[:]) {
        Some(stop) =>
          if stop > start {
            Some(build_status(line, start + 1, stop))
          } else {
            None
          }
        None => None
      }
    None => None
  }
}

///|
fn build_status(line : String, start : Int32, stop : Int32) -> Status {
  let inner = line[start:stop].to_owned()
  let fields = split_spaces(inner)
  let mut messages = 0
  let mut recent = 0
  let mut uid_next = 0
  let mut uid_validity = 0
  let mut unseen = 0
  let mut i = 0
  while i + 1 < fields.length() {
    let name = fields[i]
    let value = parse_int(fields[i + 1])
    if name == "MESSAGES" {
      messages = value
    } else if name == "RECENT" {
      recent = value
    } else if name == "UIDNEXT" {
      uid_next = value
    } else if name == "UIDVALIDITY" {
      uid_validity = value
    } else if name == "UNSEEN" {
      unseen = value
    }
    i = i + 2
  }
  {
    mailbox: status_mailbox(line),
    messages,
    recent,
    uid_next,
    uid_validity,
    unseen,
  }
}

///|
/// The mailbox name a `STATUS` line is about, with its quotes taken off.
fn status_mailbox(line : String) -> String {
  let fields = split_spaces(line)
  let mut i = 0
  let mut out = ""
  while i < fields.length() {
    if fields[i] == "STATUS" && i + 1 < fields.length() {
      out = unquote(fields[i + 1])
      break
    }
    i = i + 1
  }
  out
}

///|
fn unquote(s : String) -> String {
  let view = s[:]
  let n = view.length()
  if n >= 2 && view[0] == '"' && view[n - 1] == '"' {
    view[1:n - 1].to_owned()
  } else {
    s
  }
}

///|
/// One logical line, with any literal that arrived in the middle of it folded
/// back in.
fn Imap::read_logical_line(self : Imap) -> String raise ImapError {
  let out = StringBuilder()
  let mut more = true
  while more {
    let line = self.io.read_line()
    out.write_string(line)
    match literal_len(line) {
      Some(n) => {
        let octets = self.io.read_exact(n)
        out.write_string(@utf8.decode_lossy(octets[:]))
      }
      None => more = false
    }
  }
  out.to_string()
}

///|
fn mailbox_counts(untagged : Array[String]) -> Mailbox {
  let mut exists = 0
  let mut recent = 0
  for line in untagged {
    let fields = split_spaces(line)
    if fields.length() >= 3 && fields[2] == "EXISTS" {
      exists = parse_int(fields[1])
    }
    if fields.length() >= 3 && fields[2] == "RECENT" {
      recent = parse_int(fields[1])
    }
  }
  { exists, recent, }
}

///|
/// The octet count of a trailing `{n}`, if the line ends in one.
fn literal_len(line : String) -> Int32? {
  let view = line[:]
  let n = view.length()
  if n == 0 || view[n - 1] != '}' {
    return None
  }
  let mut i = n - 2
  while i >= 0 && view[i] != '{' {
    i = i - 1
  }
  if i < 0 {
    return None
  }
  let mut num = 0
  let mut any = false
  let mut j = i + 1
  while j < n - 1 {
    let c = view[j]
    if c >= '0' && c <= '9' {
      num = num * 10 + (c.to_int() - '0'.to_int())
      any = true
    } else {
      return None
    }
    j = j + 1
  }
  if any {
    Some(num)
  } else {
    None
  }
}

///|
fn starts_with(s : StringView, prefix : String) -> Bool {
  s.length() >= prefix.length() && s[0:prefix.length()] == prefix[:]
}

///|
fn status_ok(status : String) -> Bool {
  let fields = split_spaces(status)
  fields.length() >= 2 && fields[1] == "OK"
}

///|
fn pad3(n : Int32) -> String {
  if n < 10 {
    "00" + n.to_string()
  } else if n < 100 {
    "0" + n.to_string()
  } else {
    n.to_string()
  }
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
fn parse_int(s : String) -> Int32 {
  let mut n = 0
  for c in s {
    if c >= '0' && c <= '9' {
      n = n * 10 + (c.to_int() - '0'.to_int())
    } else {
      break
    }
  }
  n
}
