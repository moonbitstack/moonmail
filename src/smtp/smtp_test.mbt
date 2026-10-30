// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
struct Scripted {
  inbox : Array[String]
  sent : Array[String]
  bytes_sent : Array[String]
}

///|
fn Scripted::new(lines : Array[String]) -> Scripted {
  let inbox : Array[String] = []
  let n = lines.length()
  for i in 0..<n {
    inbox.push(lines[n - 1 - i])
  }
  { inbox, sent: [], bytes_sent: [], }
}

///|
impl @smtp.SmtpIo for Scripted with fn write_line(self, line) -> Unit raise @smtp.SmtpError {
  self.sent.push(line)
}

///|
impl @smtp.SmtpIo for Scripted with fn write_bytes(self, bytes) -> Unit raise @smtp.SmtpError {
  self.bytes_sent.push(@utf8.decode_lossy(bytes))
}

///|
impl @smtp.SmtpIo for Scripted with fn read_line(self) -> String raise @smtp.SmtpError {
  match self.inbox.pop() {
    Some(line) => line
    None => raise @smtp.SmtpError::Io(msg="script ran out of replies")
  }
}

///|
test "smtp delivers a message and dot-stuffs" {
  let transcript : Array[String] = [
    "220 relay ready", "250-relay greets you", "250-SIZE 10240000", "250-8BITMIME",
    "250 HELP", "250 sender ok", "250 recipient ok", "250 recipient ok", "354 go ahead",
    "250 queued as ABC123", "221 bye",
  ]
  let script = Scripted::new(transcript)
  let client = @smtp.Smtp::new(script as &@smtp.SmtpIo)
  let greeting = client.greeting() catch { _ => "" }
  inspect(greeting, content="220 relay ready")
  let caps = client.ehlo("client.example") catch { _ => [] }
  inspect(caps.length(), content="3")
  inspect(caps[0], content="SIZE 10240000")
  client.mail_from("alice@example.com") catch {
    _ => ()
  }
  client.rcpt_to("bob@example.com") catch {
    _ => ()
  }
  client.rcpt_to("carol@example.com") catch {
    _ => ()
  }
  let body = @utf8.encode("Subject: Hi\r\n\r\n.hidden line\r\n")
  let replies = client.data(body[:]) catch { _ => [] }
  inspect(replies.length(), content="1")
  inspect(replies[0].code, content="250")
  client.quit() catch {
    _ => ()
  }
  // The dotted body line must have been sent with an extra dot.
  let mut stuffed = false
  for line in script.sent {
    if line == "..hidden line" {
      stuffed = true
    }
  }
  inspect(stuffed, content="true")
  inspect(script.sent[0], content="EHLO client.example")
  inspect(script.sent[script.sent.length() - 1], content="QUIT")
}

///|
test "lmtp reads one final reply per recipient" {
  let transcript : Array[String] = [
    "220 lmtp ready", "250 lmtp greets", "250 sender ok", "250 rcpt ok", "250 rcpt ok",
    "354 go ahead", "250 2.1.5 delivered", "550 5.1.1 no such user", "221 bye",
  ]
  let script = Scripted::new(transcript)
  let client = @smtp.Smtp::lmtp(script as &@smtp.SmtpIo)
  let _ = client.greeting() catch { _ => "" }
  let _ = client.ehlo("client.example") catch { _ => [] }
  client.mail_from("alice@example.com") catch {
    _ => ()
  }
  client.rcpt_to("bob@example.com") catch {
    _ => ()
  }
  client.rcpt_to("carol@example.com") catch {
    _ => ()
  }
  let replies = client.data(@utf8.encode("body\r\n")[:]) catch { _ => [] }
  inspect(replies.length(), content="2")
  inspect(replies[0].code, content="250")
  inspect(replies[1].code, content="550")
}

///|
test "smtp raises on a rejected sender" {
  let transcript : Array[String] = ["220 ready", "250 ok", "550 no such sender"]
  let script = Scripted::new(transcript)
  let client = @smtp.Smtp::new(script as &@smtp.SmtpIo)
  let _ = client.greeting() catch { _ => "" }
  let _ = client.ehlo("c") catch { _ => [] }
  let raised = try {
    client.mail_from("nobody@example.com")
    false
  } catch {
    _ => true
  }
  inspect(raised, content="true")
}

///|
test "smtp refuses rcpt before mail and sends nothing" {
  let script = Scripted::new(["220 ready", "250 ok"])
  let client = @smtp.Smtp::new(script as &@smtp.SmtpIo)
  let _ = client.greeting() catch { _ => "" }
  let _ = client.ehlo("c") catch { _ => [] }
  let raised = try {
    client.rcpt_to("bob@example.com")
    false
  } catch {
    _ => true
  }
  inspect(raised, content="true")
  // Only EHLO went out; the local check stopped RCPT.
  inspect(script.sent.length(), content="1")
}

///|
test "smtp authenticates with plain in one line" {
  let script = Scripted::new([
    "220 ready", "250 ok", "235 authentication successful",
  ])
  let client = @smtp.Smtp::esmtp(script as &@smtp.SmtpIo)
  let _ = client.greeting() catch { _ => "" }
  let _ = client.ehlo("c") catch { _ => [] }
  client.authenticate(@sasl.Mechanism::Plain, "tim", "tanstaaftanstaaf") catch {
    _ => ()
  }
  inspect(script.sent[1], content="AUTH PLAIN AHRpbQB0YW5zdGFhZnRhbnN0YWFm")
}

///|
test "smtp authenticates with login over two steps" {
  let script = Scripted::new([
    "220 ready", "250 ok", "334 VXNlcm5hbWU6", "334 UGFzc3dvcmQ6", "235 ok",
  ])
  let client = @smtp.Smtp::esmtp(script as &@smtp.SmtpIo)
  let _ = client.greeting() catch { _ => "" }
  let _ = client.ehlo("c") catch { _ => [] }
  client.authenticate(@sasl.Mechanism::Login, "tim", "tanstaaftanstaaf") catch {
    _ => ()
  }
  inspect(script.sent[1], content="AUTH LOGIN")
  inspect(script.sent[2], content="dGlt")
  inspect(script.sent[3], content="dGFuc3RhYWZ0YW5zdGFhZg==")
}

///|
test "smtp asks for starttls" {
  let script = Scripted::new(["220 ready", "250 ok", "220 go ahead"])
  let client = @smtp.Smtp::esmtp(script as &@smtp.SmtpIo)
  let _ = client.greeting() catch { _ => "" }
  let _ = client.ehlo("c") catch { _ => [] }
  client.starttls() catch {
    _ => ()
  }
  inspect(script.sent[1], content="STARTTLS")
}

///|
test "smtp mail from carries esmtp parameters" {
  let script = Scripted::new(["220 ready", "250 ok", "250 sender ok"])
  let client = @smtp.Smtp::esmtp(script as &@smtp.SmtpIo)
  let _ = client.greeting() catch { _ => "" }
  let _ = client.ehlo("c") catch { _ => [] }
  client.mail_from_with("a@example.com", ["SIZE=123", "BODY=8BITMIME"]) catch {
    _ => ()
  }
  inspect(
    script.sent[1],
    content="MAIL FROM:<a@example.com> SIZE=123 BODY=8BITMIME",
  )
}

///|
test "smtp chunks a message with bdat" {
  let first = "Subject: Hi\r\n"
  let second = "\r\nbody"
  let first_len = @utf8.encode(first).length()
  let second_len = @utf8.encode(second).length()
  let script = Scripted::new([
    "220 ready", "250 ok", "250 sender ok", "250 rcpt ok", "250 2.0.0 chunk ok",
    "250 2.0.0 accepted",
  ])
  let client = @smtp.Smtp::esmtp(script as &@smtp.SmtpIo)
  let _ = client.greeting() catch { _ => "" }
  let _ = client.ehlo("c") catch { _ => [] }
  client.mail_from_with("a@example.com", ["SIZE=19"]) catch {
    _ => ()
  }
  client.rcpt_to("b@example.com") catch {
    _ => ()
  }
  let first_replies = client.bdat(@utf8.encode(first)[:], false) catch {
    _ => []
  }
  inspect(first_replies.length(), content="1")
  let last_replies = client.bdat(@utf8.encode(second)[:], true) catch {
    _ => []
  }
  inspect(last_replies.length(), content="1")
  inspect(last_replies[0].is_ok(), content="true")
  inspect(script.sent[3], content="BDAT " + first_len.to_string())
  inspect(script.sent[4], content="BDAT " + second_len.to_string() + " LAST")
  // BDAT carries raw octets: no dot-stuffing and no trailing dot line.
  inspect(script.bytes_sent[0], content=first)
  inspect(script.bytes_sent[1], content=second)
  let mut dots = 0
  for line in script.sent {
    if line == "." {
      dots = dots + 1
    }
  }
  inspect(dots, content="0")
}

///|
test "lmtp answers the last bdat chunk per recipient" {
  let script = Scripted::new([
    "220 lmtp ready", "250 lmtp greets", "250 sender ok", "250 rcpt ok", "250 rcpt ok",
    "250 2.1.5 delivered", "550 5.1.1 no such user",
  ])
  let client = @smtp.Smtp::lmtp(script as &@smtp.SmtpIo)
  let _ = client.greeting() catch { _ => "" }
  let _ = client.ehlo("c") catch { _ => [] }
  client.mail_from("a@example.com") catch {
    _ => ()
  }
  client.rcpt_to("b@example.com") catch {
    _ => ()
  }
  client.rcpt_to("c@example.com") catch {
    _ => ()
  }
  let replies = client.bdat(@utf8.encode("body\r\n")[:], true) catch { _ => [] }
  inspect(replies.length(), content="2")
  inspect(replies[0].code, content="250")
  inspect(replies[1].code, content="550")
  inspect(replies[1].enhanced_status(), content="5.1.1")
}

///|
test "smtp sends dsn parameters on rcpt" {
  let script = Scripted::new([
    "220 ready", "250 ok", "250 sender ok", "250 rcpt ok",
  ])
  let client = @smtp.Smtp::esmtp(script as &@smtp.SmtpIo)
  let _ = client.greeting() catch { _ => "" }
  let _ = client.ehlo("c") catch { _ => [] }
  client.mail_from_with("a@example.com", ["RET=HDRS", "ENVID=abc"]) catch {
    _ => ()
  }
  client.rcpt_to_with("b@example.com", [
    "NOTIFY=SUCCESS,FAILURE", "ORCPT=rfc822;b@example.com",
  ]) catch {
    _ => ()
  }
  inspect(
    script.sent[1],
    content="MAIL FROM:<a@example.com> RET=HDRS ENVID=abc",
  )
  inspect(
    script.sent[2],
    content="RCPT TO:<b@example.com> NOTIFY=SUCCESS,FAILURE ORCPT=rfc822;b@example.com",
  )
}

///|
test "smtp verifies, expands and asks for help" {
  let script = Scripted::new([
    "220 ready", "250 ok", "252 2.1.5 cannot verify", "250-<alice@example.com>",
    "250-<bob@example.com>", "250 done", "214-2.0.0 commands", "214 end",
  ])
  let client = @smtp.Smtp::esmtp(script as &@smtp.SmtpIo)
  let _ = client.greeting() catch { _ => "" }
  let _ = client.ehlo("c") catch { _ => [] }
  let mut verify_code = 0
  try {
    let reply = client.vrfy("b@example.com")
    verify_code = reply.code
  } catch {
    _ => ()
  }
  inspect(verify_code, content="252")
  let members = client.expn("staff") catch { _ => [] }
  inspect(members.length(), content="3")
  inspect(members[0], content="<alice@example.com>")
  let help = client.help("") catch { _ => [] }
  inspect(help.length(), content="2")
  inspect(help[0], content="2.0.0 commands")
  inspect(script.sent[1], content="VRFY b@example.com")
  inspect(script.sent[2], content="EXPN staff")
  inspect(script.sent[3], content="HELP")
}

///|
test "smtp reads an enhanced status code off the reply" {
  let script = Scripted::new([
    "220 ready", "250 ok", "250 sender ok", "250 rcpt ok", "354 go ahead", "250 2.0.0 queued as 4XY",
  ])
  let client = @smtp.Smtp::esmtp(script as &@smtp.SmtpIo)
  let _ = client.greeting() catch { _ => "" }
  let _ = client.ehlo("c") catch { _ => [] }
  let replies = client.send(
    "a@example.com",
    ["b@example.com"],
    @utf8.encode("body\r\n")[:],
  ) catch {
    _ => []
  }
  inspect(replies.length(), content="1")
  inspect(replies[0].enhanced_status(), content="2.0.0")
  inspect(replies[0].is_ok(), content="true")
}
