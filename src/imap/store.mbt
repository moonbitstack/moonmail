// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The mailboxes a `Server` serves, in memory: names, messages, flags, modifiable
/// by one session and seen by the next. A server built on this is a reference
/// for conformance and for tests, not a mail store — nothing outlives the
/// process, and no message is indexed or written to disk.
///
/// A `Store` is shared by reference: `Map` and `Array` inside it are the same
/// objects in every session's copy, so one session's `APPEND` is the next
/// session's `FETCH`.
pub struct Store {
  priv boxes : Map[String, Box]
  priv mut next_validity : Int64
}

///|
/// One mailbox: its UID space and the messages in it.
priv struct Box {
  uidvalidity : Int64
  uidnext : Ref[Int32]
  messages : Array[Stored]
  subscribed : Ref[Bool]
}

///|
/// One message as the server keeps it.
pub(all) struct Stored {
  uid : Int32
  mut flags : Array[String]
  date : String
  body : Bytes
}

///|
/// What a mailbox reports about itself without being opened.
pub(all) struct Summary {
  messages : Int32
  recent : Int32
  unseen : Int32
  uidnext : Int32
  uidvalidity : Int64
}

///|
pub fn Store::new() -> Store {
  let store : Store = { boxes: Map([]), next_validity: 1L, }
  let _ = store.create("INBOX")
  store
}

///|
/// The mailbox names, INBOX first and the rest in the order they were made.
pub fn Store::names(self : Store) -> Array[String] {
  let names = self.boxes.keys().collect()
  let sorted = []
  for name in names {
    if name == "INBOX" {
      sorted.push(name)
    }
  }
  for name in names {
    if name != "INBOX" {
      sorted.push(name)
    }
  }
  sorted
}

///|
pub fn Store::exists(self : Store, name : String) -> Bool {
  self.boxes.contains(name)
}

///|
pub fn Store::create(self : Store, name : String) -> Bool {
  if name == "" || self.boxes.contains(name) {
    return false
  }
  let box : Box = {
    uidvalidity: self.next_validity,
    uidnext: Ref(1),
    messages: [],
    subscribed: Ref(false),
  }
  self.next_validity += 1
  self.boxes[name] = box
  true
}

///|
pub fn Store::remove(self : Store, name : String) -> Bool {
  if name == "INBOX" || !self.boxes.contains(name) {
    return false
  }
  self.boxes.remove(name)
  true
}

///|
pub fn Store::rename(self : Store, from : String, to : String) -> Bool {
  if from == "INBOX" || !self.boxes.contains(from) || self.boxes.contains(to) {
    return false
  }
  guard self.boxes.get(from) is Some(box) else { return false }
  self.boxes.remove(from)
  self.boxes[to] = box
  true
}

///|
pub fn Store::subscribe(self : Store, name : String) -> Bool {
  guard self.boxes.get(name) is Some(box) else { return false }
  box.subscribed.val = true
  true
}

///|
pub fn Store::unsubscribe(self : Store, name : String) -> Bool {
  guard self.boxes.get(name) is Some(box) else { return false }
  box.subscribed.val = false
  true
}

///|
pub fn Store::subscribed(self : Store, name : String) -> Bool {
  match self.boxes.get(name) {
    Some(box) => box.subscribed.val
    None => false
  }
}

///|
/// What `STATUS` and `SELECT` report, or nothing when the mailbox is not there.
pub fn Store::summary(self : Store, name : String) -> Summary? {
  guard self.boxes.get(name) is Some(box) else { return None }
  let mut unseen = 0
  for message in box.messages {
    if !message.flags.contains("\\Seen") {
      unseen += 1
    }
  }
  Some({
    messages: box.messages.length(),
    recent: 0,
    unseen,
    uidnext: box.uidnext.val,
    uidvalidity: box.uidvalidity,
  })
}

///|
/// Every flag the messages of a mailbox carry, the five system flags first:
/// what `* FLAGS` reports, so that a keyword a client made reads as one the
/// mailbox knows.
pub fn Store::flags(self : Store, name : String) -> Array[String] {
  let all = ["\\Answered", "\\Flagged", "\\Deleted", "\\Seen", "\\Draft"]
  guard self.boxes.get(name) is Some(box) else { return all }
  for message in box.messages {
    for flag in message.flags {
      if !all.contains(flag) {
        all.push(flag)
      }
    }
  }
  all
}

///|
/// The messages of a mailbox by sequence number, 1 based.
pub fn Store::messages(self : Store, name : String) -> Array[Stored] {
  match self.boxes.get(name) {
    Some(box) => box.messages.copy()
    None => []
  }
}

///|
/// Put a message at the end of a mailbox and return its UID, or nothing when
/// the mailbox is not there.
pub fn Store::deliver(
  self : Store,
  name : String,
  body : BytesView,
  flags~ : Array[String] = [],
  date~ : String = "",
) -> Int32? {
  guard self.boxes.get(name) is Some(box) else { return None }
  let uid = box.uidnext.val
  box.uidnext.val = uid + 1
  box.messages.push({ uid, flags: flags.copy(), date, body: body.to_owned(), })
  Some(uid)
}

///|
/// The UID the next message will get, without taking it.
pub fn Store::uidnext(self : Store, name : String) -> Int32 {
  match self.boxes.get(name) {
    Some(box) => box.uidnext.val
    None => 1
  }
}

///|
/// Empty a mailbox, as deleting its contents would.
pub fn Store::clear(self : Store, name : String) -> Unit {
  if self.boxes.get(name) is Some(box) {
    box.messages.clear()
  }
}

///|
/// Set flags on one message, by sequence number. `action` is as IMAP writes it:
/// `+FLAGS`, `-FLAGS`, `FLAGS`.
pub fn Store::set_flags(
  self : Store,
  name : String,
  sequence : Int32,
  action : String,
  flags : Array[String],
) -> Array[String]? {
  guard self.boxes.get(name) is Some(box) else { return None }
  guard sequence >= 1 && sequence <= box.messages.length() else { return None }
  let message = box.messages[sequence - 1]
  match action {
    "+FLAGS" =>
      for flag in flags {
        if !message.flags.contains(flag) {
          message.flags.push(flag)
        }
      }
    "-FLAGS" => message.flags = message.flags.filter(f => !flags.contains(f))
    _ => message.flags = flags.copy()
  }
  Some(message.flags.copy())
}

///|
/// Take the messages marked `\Deleted` out and return the sequence numbers they
/// had, in the order they were removed.
pub fn Store::expunge(self : Store, name : String) -> Array[Int32] {
  guard self.boxes.get(name) is Some(box) else { return [] }
  let gone = []
  let kept = []
  for i, message in box.messages {
    if message.flags.contains("\\Deleted") {
      gone.push(Int32(i + 1))
    } else {
      kept.push(message)
    }
  }
  // The sequence numbers a session hears about count down with the mailbox, so
  // they are issued from the highest.
  box.messages.clear()
  for message in kept {
    box.messages.push(message)
  }
  let issued = []
  let mut shift = 0
  for n in gone {
    issued.push(n - shift)
    shift += 1
  }
  issued
}
