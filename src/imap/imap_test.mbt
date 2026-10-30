// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
struct Scripted {
  lines : Array[String]
  literals : Array[String]
  sent : Array[String]
  bytes_sent : Array[String]
}

///|
fn Scripted::new(lines : Array[String], literals : Array[String]) -> Scripted {
  let l : Array[String] = []
  let ln = lines.length()
  for i in 0..<ln {
    l.push(lines[ln - 1 - i])
  }
  let lit : Array[String] = []
  let ln2 = literals.length()
  for i in 0..<ln2 {
    lit.push(literals[ln2 - 1 - i])
  }
  { lines: l, literals: lit, sent: [], bytes_sent: [], }
}

///|
impl @imap.ImapIo for Scripted with fn write_line(self, line) -> Unit raise @imap.ImapError {
  self.sent.push(line)
}

///|
impl @imap.ImapIo for Scripted with fn write_bytes(self, bytes) -> Unit raise @imap.ImapError {
  self.bytes_sent.push(@utf8.decode_lossy(bytes))
}

///|
impl @imap.ImapIo for Scripted with fn read_line(self) -> String raise @imap.ImapError {
  match self.lines.pop() {
    Some(line) => line
    None => raise @imap.ImapError::Io(msg="script ran out of lines")
  }
}

///|
impl @imap.ImapIo for Scripted with fn read_exact(self, n) -> Bytes raise @imap.ImapError {
  match self.literals.pop() {
    Some(text) => {
      let bytes = @utf8.encode(text)
      if bytes.length() != n {
        raise @imap.ImapError::Protocol(msg="literal length mismatch")
      }
      bytes
    }
    None => raise @imap.ImapError::Io(msg="script ran out of literals")
  }
}

///|
test "imap logs in, selects and searches" {
  let transcript : Array[String] = [
    "* OK [CAPABILITY IMAP4rev1] ready", "A001 OK LOGIN completed", "* 3 EXISTS",
    "* 2 RECENT", "A002 OK [READ-WRITE] SELECT completed", "* SEARCH 1 3", "A003 OK SEARCH completed",
    "* BYE logging out", "A004 OK LOGOUT completed",
  ]
  let script = Scripted::new(transcript, [])
  let client = @imap.Imap::new(script as &@imap.ImapIo)
  let greeting = client.greeting() catch { _ => "" }
  inspect(greeting.find("ready") is Some(_), content="true")
  client.login("alice", "secret") catch {
    _ => ()
  }
  let mut exists = -1
  let mut recent = -1
  try {
    let box = client.select("INBOX")
    exists = box.exists
    recent = box.recent
  } catch {
    _ => ()
  }
  inspect(exists, content="3")
  inspect(recent, content="2")
  inspect(client.selected_mailbox() == Some("INBOX"), content="true")
  let hits = client.search("ALL") catch { _ => [] }
  inspect(hits.length(), content="2")
  inspect(hits[0], content="1")
  inspect(hits[1], content="3")
  client.logout() catch {
    _ => ()
  }
  inspect(script.sent[0], content="A001 LOGIN alice secret")
  inspect(script.sent[2], content="A003 SEARCH ALL")
}

///|
test "imap lists mailboxes and folds a fetch literal" {
  let transcript : Array[String] = [
    "* OK ready", "* LIST () \"/\" \"INBOX\"", "A001 OK LIST completed", "* 1 FETCH (BODY[TEXT] {5}",
    ")", "A002 OK FETCH completed",
  ]
  let script = Scripted::new(transcript, ["hello"])
  let client = @imap.Imap::new(script as &@imap.ImapIo)
  let _ = client.greeting() catch { _ => "" }
  let boxes = client.list("", "*") catch { _ => [] }
  inspect(boxes.length(), content="1")
  inspect(boxes[0].find("INBOX") is Some(_), content="true")
  let fetched = client.fetch("1", "(BODY[TEXT])") catch { _ => [] }
  inspect(fetched.length(), content="1")
  inspect(fetched[0].find("hello") is Some(_), content="true")
}

///|
test "imap appends a message as a literal" {
  let transcript : Array[String] = [
    "* OK ready", "+ go ahead", "A001 OK APPEND completed",
  ]
  let script = Scripted::new(transcript, [])
  let client = @imap.Imap::new(script as &@imap.ImapIo)
  let _ = client.greeting() catch { _ => "" }
  client.append("Drafts", @utf8.encode("hello")[:]) catch {
    _ => ()
  }
  inspect(script.sent[0], content="A001 APPEND Drafts {5}")
  inspect(script.bytes_sent.length(), content="1")
  inspect(script.bytes_sent[0], content="hello")
}

///|
test "imap raises on a NO reply" {
  let transcript : Array[String] = [
    "* OK ready", "A001 NO [AUTHENTICATIONFAILED] bad credentials",
  ]
  let script = Scripted::new(transcript, [])
  let client = @imap.Imap::new(script as &@imap.ImapIo)
  let _ = client.greeting() catch { _ => "" }
  let raised = try {
    client.login("alice", "wrong")
    false
  } catch {
    _ => true
  }
  inspect(raised, content="true")
  inspect(client.selected_mailbox() == None, content="true")
}

///|
test "imap authenticates with sasl" {
  let script = Scripted::new(
    ["* OK ready", "+ ", "A001 OK AUTHENTICATE completed"],
    [],
  )
  let client = @imap.Imap::new(script as &@imap.ImapIo)
  let _ = client.greeting() catch { _ => "" }
  client.authenticate(@sasl.Mechanism::Plain, "tim", "tanstaaftanstaaf") catch {
    _ => ()
  }
  inspect(script.sent[0], content="A001 AUTHENTICATE PLAIN")
  inspect(script.sent[1], content="AHRpbQB0YW5zdGFhZnRhbnN0YWFm")
}

///|
test "imap asks for starttls" {
  let script = Scripted::new(["* OK ready", "A001 OK STARTTLS"], [])
  let client = @imap.Imap::new(script as &@imap.ImapIo)
  let _ = client.greeting() catch { _ => "" }
  client.starttls() catch {
    _ => ()
  }
  inspect(script.sent[0], content="A001 STARTTLS")
}

///|
test "imap copies and moves" {
  let script = Scripted::new(
    ["* OK ready", "A001 OK COPY completed", "A002 OK MOVE completed"],
    [],
  )
  let client = @imap.Imap::new(script as &@imap.ImapIo)
  let _ = client.greeting() catch { _ => "" }
  client.copy("1:3", "Archive") catch {
    _ => ()
  }
  client.move_to("4", "Trash") catch {
    _ => ()
  }
  inspect(script.sent[0], content="A001 COPY 1:3 Archive")
  inspect(script.sent[1], content="A002 MOVE 4 Trash")
}

///|
test "imap asks for mailbox status without selecting" {
  let script = Scripted::new(
    [
      "* OK ready", "* STATUS \"INBOX\" (MESSAGES 5 RECENT 0 UIDNEXT 6 UIDVALIDITY 1234 UNSEEN 2)",
      "A001 OK STATUS completed",
    ],
    [],
  )
  let client = @imap.Imap::new(script as &@imap.ImapIo)
  let _ = client.greeting() catch { _ => "" }
  let mut messages = -1
  let mut uid_next = -1
  let mut uid_validity = -1
  let mut unseen = -1
  let mut mailbox = ""
  try {
    let status = client.status("INBOX", [
      "MESSAGES", "RECENT", "UIDNEXT", "UIDVALIDITY", "UNSEEN",
    ])
    messages = status.messages
    uid_next = status.uid_next
    uid_validity = status.uid_validity
    unseen = status.unseen
    mailbox = status.mailbox
  } catch {
    _ => ()
  }
  inspect(mailbox, content="INBOX")
  inspect(messages, content="5")
  inspect(uid_next, content="6")
  inspect(uid_validity, content="1234")
  inspect(unseen, content="2")
  inspect(
    script.sent[0],
    content="A001 STATUS INBOX (MESSAGES RECENT UIDNEXT UIDVALIDITY UNSEEN)",
  )
  // STATUS must not change the selected mailbox.
  inspect(client.selected_mailbox() is None, content="true")
}

///|
test "imap searches by uid and addresses uids" {
  let script = Scripted::new(
    [
      "* OK ready", "* SEARCH 101 103 108", "A001 OK SEARCH completed", "* 1 FETCH (UID 101 FLAGS (\\Seen))",
      "A002 OK FETCH completed", "A003 OK STORE completed", "A004 OK COPY completed",
      "A005 OK MOVE completed", "A006 OK EXPUNGE completed",
    ],
    [],
  )
  let client = @imap.Imap::new(script as &@imap.ImapIo)
  let _ = client.greeting() catch { _ => "" }
  let uids = client.uid_search("UNSEEN") catch { _ => [] }
  inspect(uids.length(), content="3")
  inspect(uids[2], content="108")
  let fetched = client.uid_fetch("101", "(UID FLAGS)") catch { _ => [] }
  inspect(fetched.length(), content="1")
  client.uid_store("101", "+FLAGS", "(\\Seen)") catch {
    _ => ()
  }
  client.uid_copy("101", "Archive") catch {
    _ => ()
  }
  client.uid_move("101", "Trash") catch {
    _ => ()
  }
  let expunged = client.uid_expunge("101") catch { _ => [] }
  inspect(expunged.length(), content="0")
  inspect(script.sent[0], content="A001 UID SEARCH UNSEEN")
  inspect(script.sent[1], content="A002 UID FETCH 101 (UID FLAGS)")
  inspect(script.sent[2], content="A003 UID STORE 101 +FLAGS (\\Seen)")
  inspect(script.sent[3], content="A004 UID COPY 101 Archive")
  inspect(script.sent[4], content="A005 UID MOVE 101 Trash")
  inspect(script.sent[5], content="A006 UID EXPUNGE 101")
}

///|
test "imap idles for one round and says done" {
  let script = Scripted::new(
    [
      "* OK ready", "+ idling", "* 5 EXISTS", "* 1 RECENT", "A001 OK IDLE terminated",
    ],
    [],
  )
  let client = @imap.Imap::new(script as &@imap.ImapIo)
  let _ = client.greeting() catch { _ => "" }
  let events = client.idle_once() catch { _ => [] }
  inspect(events.length(), content="2")
  inspect(events[0], content="* 5 EXISTS")
  inspect(script.sent[0], content="A001 IDLE")
  inspect(script.sent[1], content="DONE")
}

///|
test "imap closes a mailbox and forgets the selection" {
  let script = Scripted::new(
    [
      "* OK ready", "* 3 EXISTS", "A001 OK SELECT completed", "A002 OK CLOSE completed",
      "A003 OK SELECT completed", "A004 OK UNSELECT completed",
    ],
    [],
  )
  let client = @imap.Imap::new(script as &@imap.ImapIo)
  let _ = client.greeting() catch { _ => "" }
  try {
    let _ = client.select("INBOX")
  } catch {
    _ => ()
  }
  inspect(client.selected_mailbox() is Some(_), content="true")
  client.close() catch {
    _ => ()
  }
  inspect(client.selected_mailbox() is None, content="true")
  try {
    let _ = client.select("INBOX")
  } catch {
    _ => ()
  }
  client.unselect() catch {
    _ => ()
  }
  inspect(client.selected_mailbox() is None, content="true")
  inspect(script.sent[1], content="A002 CLOSE")
  inspect(script.sent[3], content="A004 UNSELECT")
}

///|
test "imap appends with flags" {
  let message = "Subject: Hi\r\n\r\nbody"
  let size = @utf8.encode(message).length()
  let script = Scripted::new(
    ["* OK ready", "+ go ahead", "A001 OK APPEND completed"],
    [message],
  )
  let client = @imap.Imap::new(script as &@imap.ImapIo)
  let _ = client.greeting() catch { _ => "" }
  client.append_with("INBOX", ["\\Seen"], @utf8.encode(message)[:]) catch {
    _ => ()
  }
  inspect(
    script.sent[0],
    content="A001 APPEND INBOX (\\Seen) {" + size.to_string() + "}",
  )
  inspect(script.bytes_sent[0], content=message)
}

///|
test "imap manages mailboxes and enables an extension" {
  let script = Scripted::new(
    [
      "* OK ready", "A001 OK CREATE", "A002 OK DELETE", "A003 OK RENAME", "A004 OK SUBSCRIBE",
      "A005 OK UNSUBSCRIBE", "* ENABLED CONDSTORE", "A006 OK ENABLE completed",
    ],
    [],
  )
  let client = @imap.Imap::new(script as &@imap.ImapIo)
  let _ = client.greeting() catch { _ => "" }
  client.create_mailbox("Archive") catch {
    _ => ()
  }
  client.delete_mailbox("Old") catch {
    _ => ()
  }
  client.rename_mailbox("Old", "Older") catch {
    _ => ()
  }
  client.subscribe("Archive") catch {
    _ => ()
  }
  client.unsubscribe("Old") catch {
    _ => ()
  }
  let enabled = client.enable("CONDSTORE") catch { _ => [] }
  inspect(enabled.length(), content="1")
  inspect(enabled[0], content="CONDSTORE")
  inspect(script.sent[0], content="A001 CREATE Archive")
  inspect(script.sent[1], content="A002 DELETE Old")
  inspect(script.sent[2], content="A003 RENAME Old Older")
  inspect(script.sent[3], content="A004 SUBSCRIBE Archive")
  inspect(script.sent[4], content="A005 UNSUBSCRIBE Old")
  inspect(script.sent[5], content="A006 ENABLE CONDSTORE")
}
