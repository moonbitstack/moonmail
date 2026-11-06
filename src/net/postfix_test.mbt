// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// Postfix takes the message and hands it to local(8), which writes the Maildir
/// Dovecot serves. A test both sends and reads, so the octets are followed the
/// whole way: our SMTP client in, our IMAP and POP3 clients out.

///|
/// A subject no other run uses, so a test finds its own message among whatever
/// else the mailbox holds.
fn marker(kind : String) -> String {
  "moonmail " + kind + " " + @env.now().to_string()
}

///|
/// Whether Dovecot serves a message with that subject yet: local(8) writes the
/// Maildir a moment after Postfix has said 250, so the search is retried rather
/// than raced.
async fn delivered(subject : String) -> Bool {
  guard live() is Some(l) else { return false }
  let imap = @net.Imap::connect(l.host, Clear, port=l.imap)
  imap.login(account, secret)
  let _ = imap.wait(imap.client().select("INBOX"))
  let criteria = "HEADER SUBJECT \"" + subject + "\""
  let mut found = false
  for _ in 0..<40 {
    match imap.wait(imap.client().search(criteria, uid=true)).data {
      [Search(list, ..)] if list.length() > 0 => {
        found = true
        break
      }
      _ => @async.sleep(250)
    }
  }
  imap.logout()
  found
}

///|
async test "smtp sends to Postfix and imap reads the message back" {
  guard live() is Some(l) else { return }
  let subject = marker("postfix-imap")
  let message = sample(subject, "delivered by Postfix")
  let smtp = @net.Smtp::connect(l.host, Clear, port=l.smtp, hello="client.test")
  assert_true(smtp.client().has("SIZE"))
  assert_true(smtp.client().has("8BITMIME"))
  let refused = smtp.send(
    "alice@example.com",
    [account + "@" + domain],
    message,
  )
  assert_eq(refused.length(), 0)
  smtp.quit()
  let imap = @net.Imap::connect(l.host, Clear, port=l.imap)
  imap.login(account, secret)
  let _ = imap.wait(imap.client().select("INBOX"))
  // local(8) writes the Maildir a moment after the 250, so the search is
  // retried rather than raced.
  let criteria = "HEADER SUBJECT \"" + subject + "\""
  let mut found = None
  for _ in 0..<40 {
    match imap.wait(imap.client().search(criteria, uid=true)).data {
      [Search([uid, ..], ..)] => {
        found = Some(uid)
        break
      }
      _ => @async.sleep(250)
    }
  }
  guard found is Some(uid) else { fail(subject + " never arrived") }
  let fetched = imap.wait(
    imap.client().fetch(uid.to_string(), "(UID BODY.PEEK[])", uid=true),
  )
  guard fetched.data is [Fetch(_, items)] else { fail("no fetch") }
  guard items.get("BODY[]") is Some(Text(raw)) else { fail("no body") }
  let text = @utf8.decode_lossy(raw[:])
  // What we sent is in what came back, and so is the server's own trace.
  assert_true(text.contains("Subject: " + subject))
  assert_true(text.contains("delivered by Postfix"))
  assert_true(text.contains("Received:"))
  let parsed = @moonmail.Message::parse(raw[:])
  assert_eq(parsed.subject(), Some(subject))
  guard parsed.from() is [mailbox] else { fail("no sender") }
  assert_eq(mailbox.address, "alice@example.com")
  imap.logout()
}

///|
async test "smtp sends to Postfix and pop3 takes the message off Dovecot" {
  guard live() is Some(l) else { return }
  let subject = marker("postfix-pop3")
  let smtp = @net.Smtp::connect(l.host, Clear, port=l.smtp, hello="client.test")
  let refused = smtp.send(
    "alice@example.com",
    [account + "@" + domain],
    sample(subject, "read by POP3"),
  )
  assert_eq(refused.length(), 0)
  smtp.quit()
  let pop = @net.Pop3::connect(l.host, Clear, port=l.pop3)
  assert_true(pop.client().has("UIDL"))
  assert_true(pop.client().has("TOP"))
  pop.login(account, secret)
  let mut found = None
  for _ in 0..<40 {
    let listed = pop.list()
    for item in listed {
      let body = pop.retr(item.0)
      if @utf8.decode_lossy(body[:]).contains("Subject: " + subject) {
        found = Some((item.0, item.1, body))
        break
      }
    }
    if found is Some(_) {
      break
    }
    @async.sleep(250)
  }
  guard found is Some((message, size, body)) else {
    fail(subject + " never arrived")
  }
  // The size LIST reports is the size RETR hands back.
  assert_eq(body.length().to_int64(), size)
  // UIDL names every message, and names it the same way twice.
  pop.client().uidl()
  let mut uids = []
  for event in pop.run() {
    if event is Reply(_, Uids(list)) {
      uids = list
    }
  }
  assert_eq(uids.length(), pop.list().length())
  assert_true(uids.all(pair => pair.1.length() > 0))
  // TOP gives the headers and as many lines of the body as asked for, not the
  // whole message.
  pop.client().top(message, 0)
  let mut top = b""
  for event in pop.run() {
    if event is Reply(_, Content(data)) {
      top = data
    }
  }
  assert_true(@utf8.decode_lossy(top[:]).contains("Subject: " + subject))
  assert_true(top.length() < body.length())
  pop.quit()
}

///|
async test "smtp starts TLS with Postfix and the message still arrives" {
  guard live() is Some(l) else { return }
  let subject = marker("postfix-starttls")
  let smtp = @net.Smtp::connect(
    l.host,
    StartTls(client_config()),
    port=l.smtp,
    hello="client.test",
  )
  // After STARTTLS the extensions are read again, under the protection.
  assert_false(smtp.client().has("STARTTLS"))
  let refused = smtp.send(
    "alice@example.com",
    [account + "@" + domain],
    sample(subject, "under STARTTLS"),
  )
  assert_eq(refused.length(), 0)
  smtp.quit()
  assert_true(delivered(subject))
}

///|
async test "smtp speaks TLS to Postfix from the first octet" {
  guard live() is Some(l) else { return }
  let subject = marker("postfix-tls")
  let smtp = @net.Smtp::connect(
    l.host,
    Tls(client_config()),
    port=l.smtps,
    hello="client.test",
  )
  let refused = smtp.send(
    "alice@example.com",
    [account + "@" + domain],
    sample(subject, "under implicit TLS"),
  )
  assert_eq(refused.length(), 0)
  smtp.quit()
  assert_true(delivered(subject))
}
