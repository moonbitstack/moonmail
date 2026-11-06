// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The commands that name a mailbox or the session itself: logging in, listing,
/// asking about, opening and making mailboxes.

///|
fn Server::login(
  self : Server,
  tag : String,
  tokens : Array[Token],
  at : Int32,
) -> Unit {
  guard self.state is NotAuthenticated else {
    self.bad(tag, text="already authenticated")
    return
  }
  guard name_at(tokens, at) is Some(user) &&
    name_at(tokens, at + 1) is Some(password) else {
    self.bad(tag, text="LOGIN needs a user name and a password")
    return
  }
  if (self.credentials)(user, password) {
    self.state = Authenticated
    self.untagged(
      "OK [CAPABILITY " + self.capabilities.join(" ") + "] Logged in",
    )
    self.ok(tag, text="Log in completed")
  } else {
    self.no(tag, text="Authentication failed")
  }
}

///|
fn Server::authenticate(
  self : Server,
  tag : String,
  tokens : Array[Token],
  at : Int32,
) -> Unit {
  guard self.state is NotAuthenticated else {
    self.bad(tag, text="already authenticated")
    return
  }
  guard name_at(tokens, at) is Some(mechanism) else {
    self.bad(tag, text="AUTHENTICATE needs a mechanism")
    return
  }
  if mechanism.to_upper() != "PLAIN" {
    self.no(tag, text="no such mechanism")
    return
  }
  let encoded = match tokens.get(at + 1) {
    Some(Word(word)) => word
    _ => ""
  }
  let answer = if encoded != "" && encoded != "=" {
    @base64.decode(encoded) catch {
      _ => b""
    }
  } else {
    // Nothing on the command line: the client answers a continuation.
    self.out.write_bytes(@utf8.encode("+ \r\n"))
    b""
  }
  // authzid, authcid, password, each ended by a NUL; the authzid may be empty.
  guard split_nul(answer) is [_, user, password] else {
    self.bad(tag, text="malformed PLAIN response")
    return
  }
  let user = @utf8.decode_lossy(user[:])
  let password = @utf8.decode_lossy(password[:])
  if (self.credentials)(user, password) {
    self.state = Authenticated
    self.ok(tag, text="Authentication successful")
  } else {
    self.no(tag, text="Authentication failed")
  }
}

///|
fn Server::list(
  self : Server,
  tag : String,
  tokens : Array[Token],
  at : Int32,
  subscribed~ : Bool,
) -> Unit {
  guard self.state is (Authenticated | Selected(_)) else {
    self.bad(tag, text="log in first")
    return
  }
  guard name_at(tokens, at) is Some(reference) &&
    name_at(tokens, at + 1) is Some(pattern) else {
    self.bad(tag, text="LIST needs a reference and a pattern")
    return
  }
  let full = reference + pattern
  for name in self.store.names() {
    if subscribed && !self.store.subscribed(name) {
      continue
    }
    if !matches(full, name) {
      continue
    }
    self.untagged("LIST (\\HasNoChildren) \"/\" " + as_quoted(name))
  }
  self.ok(
    tag,
    text=if subscribed { "LSUB completed" } else { "List completed" },
  )
}

///|
/// An IMAP mailbox pattern: `*` matches anything, `%` anything but the
/// hierarchy delimiter.
fn matches(pattern : String, name : String) -> Bool {
  let p = pattern[:]
  let n = name[:]
  let mut pi = 0
  let mut ni = 0
  let mut star = -1
  let mut mark = 0
  while ni < n.length() {
    if pi < p.length() && (p[pi] == n[ni] || p[pi] == '*' || p[pi] == '%') {
      if p[pi] == '*' || p[pi] == '%' {
        star = pi
        mark = ni
        pi += 1
        continue
      }
      pi += 1
      ni += 1
      continue
    }
    if star >= 0 {
      pi = star + 1
      mark += 1
      ni = mark
      continue
    }
    return false
  }
  while pi < p.length() && (p[pi] == '*' || p[pi] == '%') {
    pi += 1
  }
  pi == p.length()
}

///|
fn Server::status(
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
    self.bad(tag, text="STATUS needs a mailbox")
    return
  }
  guard self.store.summary(name) is Some(summary) else {
    self.no(tag, text="no such mailbox")
    return
  }
  let items = item_words(tokens, at + 1)
  let parts = []
  for item in items {
    match item.to_upper() {
      "MESSAGES" => parts.push("MESSAGES " + summary.messages.to_string())
      "RECENT" => parts.push("RECENT " + summary.recent.to_string())
      "UNSEEN" => parts.push("UNSEEN " + summary.unseen.to_string())
      "UIDNEXT" => parts.push("UIDNEXT " + summary.uidnext.to_string())
      "UIDVALIDITY" =>
        parts.push("UIDVALIDITY " + summary.uidvalidity.to_string())
      _ => ()
    }
  }
  self.untagged("STATUS " + as_quoted(name) + " (" + parts.join(" ") + ")")
  self.ok(tag, text="Status completed")
}

///|
/// The words inside the parentheses that follow position `at`, as a list.
fn item_words(tokens : Array[Token], at : Int32) -> Array[String] {
  let items = []
  let mut i = at
  // The brackets arrive as tokens of their own; the words between them are the
  // items, and a single item may come without brackets at all.
  while i < tokens.length() {
    match tokens[i] {
      Word(word) => items.push(word)
      _ => ()
    }
    i += 1
  }
  items
}

///|
fn Server::open_box(
  self : Server,
  tag : String,
  tokens : Array[Token],
  at : Int32,
  read_only~ : Bool,
) -> Unit {
  guard self.state is (Authenticated | Selected(_)) else {
    self.bad(tag, text="log in first")
    return
  }
  guard name_at(tokens, at) is Some(name) else {
    self.bad(tag, text="SELECT needs a mailbox")
    return
  }
  guard self.store.summary(name) is Some(summary) else {
    self.no(tag, text="no such mailbox")
    return
  }
  self.state = Selected(name)
  self.read_only = read_only
  let flags = self.store.flags(name)
  self.flags_seen = flags.copy()
  self.untagged("FLAGS (" + flags.join(" ") + ")")
  self.untagged(summary.messages.to_string() + " EXISTS")
  self.untagged(summary.recent.to_string() + " RECENT")
  self.untagged(
    "OK [UIDVALIDITY " + summary.uidvalidity.to_string() + "] UIDs valid",
  )
  self.untagged(
    "OK [UIDNEXT " + summary.uidnext.to_string() + "] Predicted next UID",
  )
  self.untagged(
    "OK [PERMANENTFLAGS (\\Answered \\Flagged \\Deleted \\Seen \\Draft \\*)] Flags permitted",
  )
  let code = if read_only { "READ-ONLY" } else { "READ-WRITE" }
  self.ok(tag, text="Select completed", code~)
}

///|
fn Server::create(
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
    self.bad(tag, text="CREATE needs a mailbox")
    return
  }
  if self.store.create(name) {
    self.ok(tag, text="Create completed")
  } else {
    self.no(tag, text="cannot create that mailbox")
  }
}

///|
fn Server::delete(
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
    self.bad(tag, text="DELETE needs a mailbox")
    return
  }
  if self.store.remove(name) {
    self.ok(tag, text="Delete completed")
  } else {
    self.no(tag, text="cannot delete that mailbox")
  }
}

///|
fn Server::rename(
  self : Server,
  tag : String,
  tokens : Array[Token],
  at : Int32,
) -> Unit {
  guard self.state is (Authenticated | Selected(_)) else {
    self.bad(tag, text="log in first")
    return
  }
  guard name_at(tokens, at) is Some(from) && name_at(tokens, at + 1) is Some(to) else {
    self.bad(tag, text="RENAME needs two mailboxes")
    return
  }
  if self.store.rename(from, to) {
    self.ok(tag, text="Rename completed")
  } else {
    self.no(tag, text="cannot rename that mailbox")
  }
}

///|
fn Server::subscribe(
  self : Server,
  tag : String,
  tokens : Array[Token],
  at : Int32,
  on~ : Bool,
) -> Unit {
  guard self.state is (Authenticated | Selected(_)) else {
    self.bad(tag, text="log in first")
    return
  }
  guard name_at(tokens, at) is Some(name) else {
    self.bad(tag, text="a mailbox is needed")
    return
  }
  let changed = if on {
    self.store.subscribe(name)
  } else {
    self.store.unsubscribe(name)
  }
  if changed {
    self.ok(
      tag,
      text=if on { "Subscribe completed" } else { "Unsubscribe completed" },
    )
  } else {
    self.no(tag, text="no such mailbox")
  }
}

///|
/// `CLOSE`: expunge what is marked and go back to authenticated.
fn Server::close(self : Server, tag : String) -> Unit {
  guard self.state is Selected(name) else {
    self.bad(tag, text="no mailbox is open")
    return
  }
  if !self.read_only {
    let _ = self.store.expunge(name)
  }
  self.state = Authenticated
  self.ok(tag, text="Close completed")
}

///|
fn Server::unselect(self : Server, tag : String) -> Unit {
  guard self.state is Selected(_) else {
    self.bad(tag, text="no mailbox is open")
    return
  }
  self.state = Authenticated
  self.ok(tag, text="Unselect completed")
}

///|
fn Server::expunge(self : Server, tag : String) -> Unit {
  guard self.state is Selected(name) else {
    self.bad(tag, text="no mailbox is open")
    return
  }
  if self.read_only {
    self.no(tag, text="the mailbox is read-only")
    return
  }
  // The numbers go out from the highest down, each already adjusted for the
  // messages below it having gone.
  let gone = self.store.expunge(name)
  for i in 0..<gone.length() {
    self.untagged(gone[i].to_string() + " EXPUNGE")
  }
  self.ok(tag, text="Expunge completed")
}

///|
/// The pieces of a PLAIN response, which NUL separates.
fn split_nul(data : Bytes) -> Array[Bytes] {
  let parts = []
  let start = Buffer()
  for b in data {
    if b == b'\x00' {
      parts.push(start.to_bytes())
      start.reset()
    } else {
      start.write_byte(b)
    }
  }
  parts.push(start.to_bytes())
  parts
}

///|
/// A name as IMAP writes it when it has to be quoted.
fn as_quoted(name : String) -> String {
  let escaped = name
    .replace_all(old="\\", new="\\\\")
    .replace_all(old="\"", new="\\\"")
  "\"" + escaped + "\""
}
