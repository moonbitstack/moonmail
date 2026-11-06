// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// What the session does with one command: the tag, the verb, and the arguments
/// as words, literals and brackets. The mailboxes come from `Server`'s store.
fn Server::run(self : Server, tokens : Array[Token]) -> Unit {
  guard tokens.length() > 0 else { return }
  let first = match tokens[0] {
    Word(word) => word
    _ => return
  }
  if first.to_upper() == "DONE" {
    if self.idle {
      self.idle = false
      // The completion of the IDLE that DONE ends is the tagged OK the client
      // is still waiting for; its tag was remembered by the IDLE branch.
      self.done(self.last_idle, "OK", text="Idle completed")
    } else {
      self.bad("*", text="DONE without IDLE")
    }
    return
  }
  guard tokens.length() > 1 else {
    self.bad(first, text="a command needs a verb")
    return
  }
  let tag = first
  let mut at = 1
  let mut verb = match tokens[at] {
    Word(word) => word.to_upper()
    _ => ""
  }
  if verb == "" {
    self.bad(tag, text="expected a verb")
    return
  }
  at += 1
  let uid = verb == "UID"
  if uid {
    guard tokens.length() > at else {
      self.bad(tag, text="UID needs a command")
      return
    }
    verb = match tokens[at] {
      Word(word) => word.to_upper()
      _ => ""
    }
    at += 1
  }
  match verb {
    "CAPABILITY" => {
      self.untagged("CAPABILITY " + self.capabilities.join(" "))
      self.ok(tag, text="Capability completed")
    }
    "NOOP" => self.ok(tag, text="Noop completed")
    "LOGOUT" => {
      self.untagged("BYE Logging out")
      self.ok(tag, text="Logout completed")
      self.state = Logout
    }
    "ID" => {
      self.untagged("ID (\"name\" \"moonmail\" \"version\" \"0.1\")")
      self.ok(tag, text="ID completed")
    }
    "ENABLE" => {
      self.untagged("ENABLED")
      self.ok(tag, text="Enable completed")
    }
    "NAMESPACE" => {
      self.untagged("NAMESPACE ((\"\" \"/\")) NIL NIL")
      self.ok(tag, text="Namespace completed")
    }
    "LOGIN" => self.login(tag, tokens, at)
    "AUTHENTICATE" => self.authenticate(tag, tokens, at)
    "LIST" => self.list(tag, tokens, at, subscribed=false)
    "LSUB" => self.list(tag, tokens, at, subscribed=true)
    "STATUS" => self.status(tag, tokens, at)
    "SELECT" => self.open_box(tag, tokens, at, read_only=false)
    "EXAMINE" => self.open_box(tag, tokens, at, read_only=true)
    "CREATE" => self.create(tag, tokens, at)
    "DELETE" => self.delete(tag, tokens, at)
    "RENAME" => self.rename(tag, tokens, at)
    "SUBSCRIBE" => self.subscribe(tag, tokens, at, on=true)
    "UNSUBSCRIBE" => self.subscribe(tag, tokens, at, on=false)
    "APPEND" => self.append(tag, tokens, at)
    "CHECK" => self.ok(tag, text="Check completed")
    "CLOSE" => self.close(tag)
    "UNSELECT" => self.unselect(tag)
    "EXPUNGE" => self.expunge(tag)
    "SEARCH" => self.search(tag, tokens, at, uid)
    "FETCH" => self.fetch(tag, tokens, at, uid)
    "STORE" => self.store(tag, tokens, at, uid)
    "COPY" => self.copy(tag, tokens, at, uid, moving=false)
    "MOVE" => self.copy(tag, tokens, at, uid, moving=true)
    "IDLE" =>
      if self.state is Authenticated || self.state is Selected(_) {
        self.last_idle = tag
        self.idle = true
        self.out.write_bytes(@utf8.encode("+ idling\r\n"))
      } else {
        self.bad(tag, text="IDLE needs an authenticated session")
      }
    _ => self.bad(tag, text="unknown command " + verb)
  }
}

///|
/// A mailbox name from a word or a literal.
fn name_at(tokens : Array[Token], at : Int32) -> String? {
  guard at < tokens.length() else { return None }
  match tokens[at] {
    Word(word) => Some(word)
    Literal(data) => Some(@utf8.decode_lossy(data[:]))
    _ => None
  }
}

///|
/// The message set a command names, as sequence numbers (or UIDs), for the
/// mailbox that is open.
fn sequence_set(
  set : String,
  mailbox : Array[Stored],
  uid : Bool,
) -> Array[Int32] {
  let found = []
  if uid {
    for message in mailbox {
      if covers(set, message.uid.to_int64(), highest_uid(mailbox)) {
        found.push(message.uid)
      }
    }
  } else {
    for i, _ in mailbox {
      let n = Int32(i + 1)
      if covers(set, n.to_int64(), mailbox.length().to_int64()) {
        found.push(n)
      }
    }
  }
  found
}

///|
fn highest_uid(mailbox : Array[Stored]) -> Int64 {
  let mut top = 0L
  for message in mailbox {
    if message.uid.to_int64() > top {
      top = message.uid.to_int64()
    }
  }
  top
}

///|
/// Whether a `set` such as `1:3,7,*` names `n`.
fn covers(set : String, n : Int64, top : Int64) -> Bool {
  for part in set.split(",").to_array() {
    let piece = part.trim(chars=" ")
    if piece == "" {
      continue
    }
    match piece.split(":").to_array() {
      [one] => if bound(one, top) == Some(n) { return true }
      [low, high] => {
        let a = bound(low, top)
        let b = bound(high, top)
        match (a, b) {
          (Some(a), Some(b)) =>
            if n >= (if a < b { a } else { b }) &&
              n <= (if a < b { b } else { a }) {
              return true
            }
          _ => ()
        }
      }
      _ => ()
    }
  }
  false
}

///|
/// A number or `*`, which is the highest number there is.
fn bound(text : StringView, top : Int64) -> Int64? {
  if text == "*" {
    return Some(top)
  }
  let mut n = 0L
  let mut digits = 0
  for c in text {
    if c < '0' || c > '9' {
      return None
    }
    n = n * 10 + (c.to_int().to_int64() - '0'.to_int().to_int64())
    digits += 1
  }
  if digits == 0 {
    None
  } else {
    Some(n)
  }
}
