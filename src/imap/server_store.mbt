// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// `STORE`, `SEARCH`, `COPY` and `MOVE`: the commands that change a mailbox or
/// ask it questions about its messages.

///|
fn Server::store(
  self : Server,
  tag : String,
  tokens : Array[Token],
  at : Int32,
  uid : Bool,
) -> Unit {
  guard self.state is Selected(name) else {
    self.bad(tag, text="no mailbox is open")
    return
  }
  if self.read_only {
    self.no(tag, text="the mailbox is read-only")
    return
  }
  guard name_at(tokens, at) is Some(set) else {
    self.bad(tag, text="STORE needs a message set")
    return
  }
  guard name_at(tokens, at + 1) is Some(raw) else {
    self.bad(tag, text="STORE needs an action")
    return
  }
  let upper = raw.to_upper()
  let silent = upper.has_suffix(".SILENT")
  let action = if silent {
    upper[:upper.length() - 7].to_owned()
  } else {
    upper
  }
  let flags = []
  let mut i = at + 2
  while i < tokens.length() {
    if tokens[i] is Word(word) && word != "" {
      flags.push(word)
    }
    i += 1
  }
  let mailbox = self.store.messages(name)
  let changed_sequences = sequence_set(set, mailbox, uid)
  // Every change first, so the mailbox knows its keywords, then the
  // announcement, then the replies: a keyword is only readable once the mailbox
  // has said it exists (RFC 3501 section 7.2.6).
  let changed = []
  for sequence in changed_sequences {
    changed.push(
      (sequence, self.store.set_flags(name, sequence, action, flags)),
    )
  }
  self.announce_flags(name)
  for pair in changed {
    guard pair is (sequence, Some(now)) else { continue }
    if !silent {
      self.untagged(
        sequence.to_string() + " FETCH (FLAGS (" + now.join(" ") + "))",
      )
    }
  }
  self.ok(tag, text="Store completed")
}

///|
/// `SEARCH`, over the flags, the UID space and the headers of the messages in
/// the open mailbox. A key the server does not know is refused rather than
/// answered with a guess.
fn Server::search(
  self : Server,
  tag : String,
  tokens : Array[Token],
  at : Int32,
  uid : Bool,
) -> Unit {
  guard self.state is Selected(name) else {
    self.bad(tag, text="no mailbox is open")
    return
  }
  let mailbox = self.store.messages(name)
  let keys = tokens[at:].to_owned()
  let found = []
  for i, message in mailbox {
    let cursor : Cursor = { keys, at: 0, }
    let matches = evaluate(cursor, message, Int32(i + 1)) catch {
      _ => {
        self.bad(tag, text="cannot read the search keys")
        return
      }
    }
    if matches {
      found.push(if uid { message.uid } else { Int32(i + 1) })
    }
  }
  let numbers = []
  for n in found {
    numbers.push(n.to_string())
  }
  self.untagged("SEARCH " + numbers.join(" "))
  self.ok(tag, text="Search completed")
}

///|
/// Tell the client about a keyword the mailbox has that it has not been told
/// about yet. A keyword is only readable if the mailbox has said it exists
/// (RFC 3501 section 7.2.6), and one arrives with an `APPEND`, a `COPY` or a
/// `STORE` — never only with the `SELECT` that started the session.
fn Server::announce_flags(self : Server, name : String) -> Unit {
  let union = self.store.flags(name)
  let mut grew = false
  for flag in union {
    if !self.flags_seen.contains(flag) {
      grew = true
    }
  }
  if grew {
    // A FLAGS list the client has seen may never shrink: expunging the last
    // message that carried a keyword takes it out of the mailbox, not out of
    // what the client knows, and dropping it there is a keyword dropped while
    // messages still mention it.
    for flag in self.flags_seen {
      if !union.contains(flag) {
        union.push(flag)
      }
    }
    self.flags_seen = union.copy()
    self.untagged("FLAGS (" + union.join(" ") + ")")
  }
}

///|
/// A cursor over the words of a search program.
priv struct Cursor {
  keys : Array[Token]
  mut at : Int32
}

///|
fn Cursor::word(self : Cursor) -> String? {
  guard self.at < self.keys.length() else { return None }
  self.at += 1
  match self.keys[self.at - 1] {
    Word(word) => Some(word)
    Literal(data) => Some(@utf8.decode_lossy(data[:]))
    _ => None
  }
}

///|
/// One search key, and whether the message answers it.
fn evaluate(
  cursor : Cursor,
  message : Stored,
  sequence : Int32,
) -> Bool raise Refused {
  guard cursor.word() is Some(word) else { return false }
  let key = word.to_upper()
  match key {
    "ALL" => true
    "ANSWERED" => message.flags.contains("\\Answered")
    "DELETED" => message.flags.contains("\\Deleted")
    "DRAFT" => message.flags.contains("\\Draft")
    "FLAGGED" => message.flags.contains("\\Flagged")
    "SEEN" => message.flags.contains("\\Seen")
    "UNANSWERED" => !message.flags.contains("\\Answered")
    "UNDELETED" => !message.flags.contains("\\Deleted")
    "UNDRAFT" => !message.flags.contains("\\Draft")
    "UNFLAGGED" => !message.flags.contains("\\Flagged")
    "UNSEEN" => !message.flags.contains("\\Seen")
    "NEW" => !message.flags.contains("\\Seen")
    "OLD" | "RECENT" | "UNKEYWORD" => false
    "KEYWORD" => {
      let _ = cursor.word()
      message.flags.contains(word_of(cursor, -1))
    }
    "NOT" => !evaluate(cursor, message, sequence)
    "OR" => {
      let left = evaluate(cursor, message, sequence)
      let right = evaluate(cursor, message, sequence)
      left || right
    }
    "UID" => {
      let set = cursor.word().unwrap_or("")
      covers(set, message.uid.to_int64(), 0L) ||
      covers(set, message.uid.to_int64(), message.uid.to_int64())
    }
    "HEADER" => {
      let name = cursor.word().unwrap_or("")
      let value = cursor.word().unwrap_or("")
      let head = @utf8.decode_lossy(header_of(message.body)[:])
      match field(head, name) {
        Some(text) => text.to_lower().contains(value.to_lower())
        None => false
      }
    }
    "SUBJECT" | "FROM" | "TO" | "CC" | "BCC" => {
      let value = cursor.word().unwrap_or("").to_lower()
      let head = @utf8.decode_lossy(header_of(message.body)[:])
      let name = if key == "SUBJECT" {
        "Subject"
      } else if key == "FROM" {
        "From"
      } else if key == "TO" {
        "To"
      } else if key == "CC" {
        "Cc"
      } else {
        "Bcc"
      }
      match field(head, name) {
        Some(text) => text.to_lower().contains(value)
        None => value == ""
      }
    }
    "BODY" | "TEXT" => {
      let value = cursor.word().unwrap_or("").to_lower()
      let whole = @utf8.decode_lossy(message.body[:]).to_lower()
      if value == "" {
        true
      } else {
        whole.contains(value)
      }
    }
    _ => raise Malformed("no such search key: " + key)
  }
}

///|
/// The word just read, or an empty one.
fn word_of(cursor : Cursor, _ : Int32) -> String {
  match cursor.keys.get(cursor.at - 1) {
    Some(Word(word)) => word
    _ => ""
  }
}

///|
fn Server::copy(
  self : Server,
  tag : String,
  tokens : Array[Token],
  at : Int32,
  uid : Bool,
  moving~ : Bool,
) -> Unit {
  guard self.state is Selected(name) else {
    self.bad(tag, text="no mailbox is open")
    return
  }
  guard name_at(tokens, at) is Some(set) &&
    name_at(tokens, at + 1) is Some(target) else {
    self.bad(tag, text="the command needs a set and a mailbox")
    return
  }
  guard self.store.exists(target) else {
    self.no(tag, text="[TRYCREATE] no such mailbox")
    return
  }
  let mailbox = self.store.messages(name)
  let sources = []
  let made = []
  for sequence in sequence_set(set, mailbox, uid) {
    guard at_sequence(mailbox, sequence) is Some(message) else { continue }
    match
      self.store.deliver(
        target,
        message.body[:],
        flags=message.flags,
        date=message.date,
      ) {
      Some(new_uid) => {
        sources.push(if uid { message.uid } else { sequence })
        made.push(new_uid)
      }
      None => ()
    }
  }
  if moving && !self.read_only {
    for sequence in sequence_set(set, mailbox, uid) {
      let _ = self.store.set_flags(name, sequence, "+FLAGS", ["\\Deleted"])
    }
    for n in self.store.expunge(name) {
      self.untagged(n.to_string() + " EXPUNGE")
    }
  }
  if made.length() == 0 {
    self.ok(tag, text=if moving { "Move completed" } else { "Copy completed" })
    return
  }
  let validity = match self.store.summary(target) {
    Some(summary) => summary.uidvalidity
    None => 1L
  }
  let from = []
  for n in sources {
    from.push(n.to_string())
  }
  let to = []
  for n in made {
    to.push(n.to_string())
  }
  self.ok(
    tag,
    text=if moving { "Move completed" } else { "Copy completed" },
    code="COPYUID " +
      validity.to_string() +
      " " +
      from.join(",") +
      " " +
      to.join(","),
  )
}
