// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// A fake server: hands out recorded reply lines in order and keeps every
/// command the client writes, so a test can replay a real transcript.
struct Scripted {
  inbox : Array[String]
  sent : Array[String]
}

///|
fn Scripted::new(lines : Array[String]) -> Scripted {
  let inbox : Array[String] = []
  let n = lines.length()
  for i in 0..<n {
    inbox.push(lines[n - 1 - i])
  }
  { inbox, sent: [], }
}

///|
impl @pop3.Pop3Io for Scripted with fn write_line(self, line) -> Unit raise @pop3.Pop3Error {
  self.sent.push(line)
}

///|
impl @pop3.Pop3Io for Scripted with fn read_line(self) -> String raise @pop3.Pop3Error {
  match self.inbox.pop() {
    Some(line) => line
    None => raise @pop3.Pop3Error::Io(msg="the script ran out of replies")
  }
}

///|
test "pop3 replays a recorded session" {
  let transcript : Array[String] = [
    "+OK POP3 server ready <1896.1234@example.com>", "+OK password required", "+OK mailbox locked and ready",
    "+OK 2 320", "+OK 2 messages (320 octets)", "1 120", "2 200", ".", "+OK 120 octets",
    "From: alice@example.com", "Subject: Hello", "", "..dotted line stays dotted after unstuffing",
    "body line", ".",
  ]
  let script = Scripted::new(transcript)
  let client = @pop3.Pop3::new(script as &@pop3.Pop3Io)
  inspect(client.state() == @pop3.Pop3State::Authorization, content="true")
  let mut greeting = ""
  try {
    greeting = client.greeting()
  } catch {
    _ => ()
  }
  inspect(greeting[0:3].to_owned(), content="+OK")
  client.user("alice") catch {
    _ => ()
  }
  client.pass("secret") catch {
    _ => ()
  }
  inspect(client.state() == @pop3.Pop3State::Transaction, content="true")
  let mut count = -1
  let mut size = -1
  try {
    let s = client.stat()
    count = s.count
    size = s.size
  } catch {
    _ => ()
  }
  inspect(count, content="2")
  inspect(size, content="320")
  let mut list : Array[@pop3.MessageInfo] = []
  try {
    list = client.list()
  } catch {
    _ => ()
  }
  inspect(list.length(), content="2")
  inspect(list[0].number, content="1")
  inspect(list[0].size, content="120")
  inspect(list[1].number, content="2")
  inspect(list[1].size, content="200")
  let mut msg = ""
  try {
    msg = client.retr(1)
  } catch {
    _ => ()
  }
  inspect(
    msg,
    content="From: alice@example.com\r\nSubject: Hello\r\n\r\n.dotted line stays dotted after unstuffing\r\nbody line\r\n",
  )
  inspect(script.sent.length(), content="5")
  inspect(script.sent[0], content="USER alice")
  inspect(script.sent[1], content="PASS secret")
  inspect(script.sent[2], content="STAT")
  inspect(script.sent[3], content="LIST")
  inspect(script.sent[4], content="RETR 1")
}

///|
test "pop3 refuses a mailbox command before authentication" {
  let script = Scripted::new(["+OK ready"])
  let client = @pop3.Pop3::new(script as &@pop3.Pop3Io)
  let _ = client.greeting() catch { _ => "" }
  let raised = try {
    let _ = client.stat()
    false
  } catch {
    _ => true
  }
  inspect(raised, content="true")
  // The refusal is local: no command went out on the wire.
  inspect(script.sent.length(), content="0")
}

///|
test "pop3 surfaces an -ERR reply and keeps its state" {
  let script = Scripted::new(["+OK ready", "+OK", "-ERR invalid password"])
  let client = @pop3.Pop3::new(script as &@pop3.Pop3Io)
  let _ = client.greeting() catch { _ => "" }
  let _ = client.user("bob") catch { _ => () }
  let raised = try {
    client.pass("wrong")
    false
  } catch {
    _ => true
  }
  inspect(raised, content="true")
  inspect(client.state() == @pop3.Pop3State::Authorization, content="true")
}

///|
test "pop3 reads uidl and top, then leaves for the update state on quit" {
  let transcript : Array[String] = [
    "+OK ready", "+OK", "+OK", "+OK uid listing", "1 abc", "2 def", ".", "+OK top follows",
    "Subject: one", ".", "+OK bye",
  ]
  let script = Scripted::new(transcript)
  let client = @pop3.Pop3::new(script as &@pop3.Pop3Io)
  let _ = client.greeting() catch { _ => "" }
  let _ = client.user("u") catch { _ => () }
  let _ = client.pass("p") catch { _ => () }
  let mut uids = 0
  let mut first = ""
  try {
    let entries = client.uidl()
    uids = entries.length()
    first = entries[0].uid
  } catch {
    _ => ()
  }
  let mut top = ""
  try {
    top = client.top(1, 0)
  } catch {
    _ => ()
  }
  let _ = client.quit() catch { _ => () }
  inspect(uids, content="2")
  inspect(first, content="abc")
  inspect(top, content="Subject: one\r\n")
  inspect(client.state() == @pop3.Pop3State::Update, content="true")
  inspect(script.sent[script.sent.length() - 1], content="QUIT")
}

///|
test "pop3 authenticates with sasl" {
  let script = Scripted::new(["+OK ready", "+ ", "+OK maildrop locked"])
  let client = @pop3.Pop3::new(script as &@pop3.Pop3Io)
  let _ = client.greeting() catch { _ => "" }
  client.authenticate(@sasl.Mechanism::Plain, "tim", "tanstaaftanstaaf") catch {
    _ => ()
  }
  inspect(script.sent[0], content="AUTH PLAIN")
  inspect(script.sent[1], content="AHRpbQB0YW5zdGFhZnRhbnN0YWFm")
  inspect(client.state() == @pop3.Pop3State::Transaction, content="true")
}

///|
test "pop3 asks for stls" {
  let script = Scripted::new(["+OK ready", "+OK begin tls"])
  let client = @pop3.Pop3::new(script as &@pop3.Pop3Io)
  let _ = client.greeting() catch { _ => "" }
  client.starttls() catch {
    _ => ()
  }
  inspect(script.sent[0], content="STLS")
}

///|
test "pop3 authenticates with apop" {
  let script = Scripted::new(["+OK ready", "+OK maildrop locked"])
  let client = @pop3.Pop3::new(script as &@pop3.Pop3Io)
  let _ = client.greeting() catch { _ => "" }
  client.apop("alice", "0123456789abcdef0123456789abcdef") catch {
    _ => ()
  }
  inspect(script.sent[0], content="APOP alice 0123456789abcdef0123456789abcdef")
  inspect(client.state() == @pop3.Pop3State::Transaction, content="true")
}

///|
test "pop3 reads one size, one uid and the last number" {
  let script = Scripted::new([
    "+OK ready", "+OK password required", "+OK logged in", "+OK 2 320", "+OK 2 200",
    "+OK 3",
  ])
  let client = @pop3.Pop3::new(script as &@pop3.Pop3Io)
  let _ = client.greeting() catch { _ => "" }
  client.user("alice") catch {
    _ => ()
  }
  client.pass("secret") catch {
    _ => ()
  }
  let size = client.list_one(2) catch { _ => -1 }
  let uid = client.uidl_one(2) catch { _ => "" }
  let last = client.last() catch { _ => -1 }
  inspect(size, content="320")
  inspect(uid, content="200")
  inspect(last, content="3")
  inspect(script.sent[2], content="LIST 2")
  inspect(script.sent[3], content="UIDL 2")
  inspect(script.sent[4], content="LAST")
}

///|
test "pop3 reports capability names" {
  let script = Scripted::new([
    "+OK ready", "+OK capability list follows", "TOP", "UIDL", "SASL PLAIN LOGIN",
    "IMPLEMENTATION example", ".",
  ])
  let client = @pop3.Pop3::new(script as &@pop3.Pop3Io)
  let _ = client.greeting() catch { _ => "" }
  let names = client.capa_names() catch { _ => [] }
  inspect(names.length(), content="4")
  inspect(names[0], content="TOP")
  inspect(names[2], content="SASL")
  inspect(names[3], content="IMPLEMENTATION")
}

///|
test "pop3 fetches a message as octets" {
  let script = Scripted::new([
    "+OK ready", "+OK password required", "+OK logged in", "+OK 20 octets", "line one",
    "line two", ".",
  ])
  let client = @pop3.Pop3::new(script as &@pop3.Pop3Io)
  let _ = client.greeting() catch { _ => "" }
  client.user("alice") catch {
    _ => ()
  }
  client.pass("secret") catch {
    _ => ()
  }
  let bytes = client.retr_bytes(1) catch { _ => b"" }
  // The octets keep their CRLF endings and pick up nothing else.
  inspect(bytes == b"line one\r\nline two\r\n", content="true")
  inspect(bytes.length(), content="20")
  inspect(script.sent[2], content="RETR 1")
}

///|
test "pop3 top with zero lines returns only the headers" {
  let script = Scripted::new([
    "+OK ready", "+OK password required", "+OK logged in", "+OK top follows", "From: alice@example.com",
    "Subject: Hello", ".",
  ])
  let client = @pop3.Pop3::new(script as &@pop3.Pop3Io)
  let _ = client.greeting() catch { _ => "" }
  client.user("alice") catch {
    _ => ()
  }
  client.pass("secret") catch {
    _ => ()
  }
  let head = client.top(1, 0) catch { _ => "" }
  inspect(head, content="From: alice@example.com\r\nSubject: Hello\r\n")
  inspect(script.sent[2], content="TOP 1 0")
}
