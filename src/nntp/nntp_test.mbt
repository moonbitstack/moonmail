// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
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
impl @nntp.NntpIo for Scripted with fn write_line(self, line) -> Unit raise @nntp.NntpError {
  self.sent.push(line)
}

///|
impl @nntp.NntpIo for Scripted with fn read_line(self) -> String raise @nntp.NntpError {
  match self.inbox.pop() {
    Some(line) => line
    None => raise @nntp.NntpError::Io(msg="script ran out of replies")
  }
}

///|
test "nntp reads a group and an article" {
  let transcript : Array[String] = [
    "200 posting ok", "211 42 1 42 comp.lang.moonbit", "220 42 <m1@example.com>",
    "Subject: first", "From: a@example.com", "", "body line", "..dotted content",
    ".",
  ]
  let script = Scripted::new(transcript)
  let client = @nntp.Nntp::new(script as &@nntp.NntpIo)
  let greeting = client.greeting() catch { _ => "" }
  inspect(greeting, content="200 posting ok")
  let mut count = -1
  let mut first = -1
  let mut last = -1
  let mut name = ""
  try {
    let g = client.group("comp.lang.moonbit")
    count = g.count
    first = g.first
    last = g.last
    name = g.name
  } catch {
    _ => ()
  }
  inspect(count, content="42")
  inspect(first, content="1")
  inspect(last, content="42")
  inspect(name, content="comp.lang.moonbit")
  let article = client.article("42") catch { _ => "" }
  inspect(
    article,
    content="Subject: first\r\nFrom: a@example.com\r\n\r\nbody line\r\n.dotted content\r\n",
  )
}

///|
test "nntp posts an article with dot-stuffing" {
  let transcript : Array[String] = [
    "200 ok", "340 send it", "240 posted", "205 bye",
  ]
  let script = Scripted::new(transcript)
  let client = @nntp.Nntp::new(script as &@nntp.NntpIo)
  let _ = client.greeting() catch { _ => "" }
  client.post(@utf8.encode("Subject: x\r\n\r\n.hidden\r\n")[:]) catch {
    _ => ()
  }
  client.quit() catch {
    _ => ()
  }
  let mut stuffed = false
  for line in script.sent {
    if line == "..hidden" {
      stuffed = true
    }
  }
  inspect(stuffed, content="true")
  inspect(script.sent[0], content="POST")
  inspect(script.sent[script.sent.length() - 1], content="QUIT")
}

///|
test "nntp stat returns the message-id and date is parsed" {
  let transcript : Array[String] = [
    "200 ok", "223 0 <m9@example.com>", "111 20261030080000",
  ]
  let script = Scripted::new(transcript)
  let client = @nntp.Nntp::new(script as &@nntp.NntpIo)
  let _ = client.greeting() catch { _ => "" }
  inspect(
    client.stat("<m9@example.com>") catch {
      _ => ""
    },
    content="<m9@example.com>",
  )
  inspect(client.date() catch { _ => "" }, content="20261030080000")
}

///|
test "nntp lists capabilities" {
  let transcript : Array[String] = [
    "200 ok", "101 capability list", "VERSION 2", "POST", "READER", ".",
  ]
  let script = Scripted::new(transcript)
  let client = @nntp.Nntp::new(script as &@nntp.NntpIo)
  let _ = client.greeting() catch { _ => "" }
  let caps = client.capabilities() catch { _ => [] }
  inspect(caps.length(), content="3")
  inspect(caps[1], content="POST")
}

///|
test "nntp lists a group and reads overview rows" {
  let script = Scripted::new([
    "200 posting ok", "211 3 1 3 comp.lang.moonbit", "1", "2", "3", ".", "224 overview information follows",
    "1\tSubject one\talice@example.com", "2\tSubject two\tbob@example.com", ".",
    "225 headers follow", "1\tMessage-ID: <a@example.com>", ".",
  ])
  let client = @nntp.Nntp::new(script as &@nntp.NntpIo)
  let _ = client.greeting() catch { _ => "" }
  let numbers = client.listgroup("comp.lang.moonbit") catch { _ => [] }
  inspect(numbers.length(), content="3")
  inspect(numbers[2], content="3")
  let rows = client.over("1-3") catch { _ => [] }
  inspect(rows.length(), content="2")
  inspect(rows[0].find("Subject one") is Some(_), content="true")
  let headers = client.hdr("Message-ID", "1-3") catch { _ => [] }
  inspect(headers.length(), content="1")
  inspect(script.sent[0], content="LISTGROUP comp.lang.moonbit")
  inspect(script.sent[1], content="OVER 1-3")
  inspect(script.sent[2], content="HDR Message-ID 1-3")
}

///|
test "nntp asks what is new since a date" {
  let script = Scripted::new([
    "200 ok", "231 list of new newsgroups follows", "comp.lang.new", ".", "230 list of new articles follows",
    "<a@example.com>", ".",
  ])
  let client = @nntp.Nntp::new(script as &@nntp.NntpIo)
  let _ = client.greeting() catch { _ => "" }
  let groups = client.newgroups("261030 090000 GMT", "") catch { _ => [] }
  inspect(groups.length(), content="1")
  let articles = client.newnews("comp.lang.*", "261030 090000 GMT") catch {
    _ => []
  }
  inspect(articles.length(), content="1")
  inspect(articles[0], content="<a@example.com>")
  inspect(script.sent[0], content="NEWGROUPS 261030 090000 GMT")
  inspect(script.sent[1], content="NEWNEWS comp.lang.* 261030 090000 GMT")
}

///|
test "nntp authenticates in two steps" {
  let script = Scripted::new([
    "200 ok", "381 more authentication required", "281 authentication accepted",
  ])
  let client = @nntp.Nntp::new(script as &@nntp.NntpIo)
  let _ = client.greeting() catch { _ => "" }
  client.authinfo("alice", "secret") catch {
    _ => ()
  }
  inspect(script.sent[0], content="AUTHINFO USER alice")
  inspect(script.sent[1], content="AUTHINFO PASS secret")
}

///|
test "nntp accepts a user name alone" {
  let script = Scripted::new(["200 ok", "281 welcome"])
  let client = @nntp.Nntp::new(script as &@nntp.NntpIo)
  let _ = client.greeting() catch { _ => "" }
  client.authinfo("alice", "secret") catch {
    _ => ()
  }
  inspect(script.sent.length(), content="1")
  inspect(script.sent[0], content="AUTHINFO USER alice")
}

///|
test "nntp describes groups and asks for help" {
  let script = Scripted::new([
    "200 ok", "215 descriptions follow", "comp.lang.moonbit The MoonBit language",
    ".", "215 list of active groups", "comp.lang.moonbit 42 1 y", ".", "100 help text follows",
    "This server speaks NNTP.", ".", "202 slave ok",
  ])
  let client = @nntp.Nntp::new(script as &@nntp.NntpIo)
  let _ = client.greeting() catch { _ => "" }
  let descriptions = client.list_newsgroups() catch { _ => [] }
  inspect(descriptions.length(), content="1")
  let active = client.list_active_group("comp.lang.*") catch { _ => [] }
  inspect(active.length(), content="1")
  let help = client.help() catch { _ => [] }
  inspect(help.length(), content="1")
  client.slave() catch {
    _ => ()
  }
  inspect(script.sent[0], content="LIST NEWSGROUPS")
  inspect(script.sent[1], content="LIST ACTIVE comp.lang.*")
  inspect(script.sent[2], content="HELP")
  inspect(script.sent[3], content="SLAVE")
}
