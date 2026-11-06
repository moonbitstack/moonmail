// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// POP3 against Dovecot: the states and the replies RFC 1939 and RFC 2449 name,
/// taken from a server rather than from a script.

///|
/// A subject no other run uses.
fn marked(kind : String) -> String {
  "moonmail " + kind + " " + @env.now().to_string()
}

///|
/// The number of messages in the maildrop, as STAT reports it.
async fn counted(pop : @net.Pop3) -> Int32 {
  pop.client().stat()
  let mut count = 0
  for event in pop.run() {
    if event is Reply(_, Stat(count=n, ..)) {
      count = n
    }
  }
  count
}

///|
/// The number of the message whose Subject is `subject`, if Dovecot holds it.
async fn numbered(pop : @net.Pop3, subject : String) -> Int32? {
  for item in pop.list() {
    if @utf8.decode_lossy(pop.retr(item.0)[:]).contains("Subject: " + subject) {
      return Some(item.0)
    }
  }
  None
}

///|
async test "pop3 deletes a message and restores it before leaving" {
  guard live() is Some(l) else { return }
  let subject = marked("rset")
  let smtp = @net.Smtp::connect(l.host, Clear, port=l.smtp, hello="client.test")
  let _ = smtp.send(
    "alice@example.com",
    [account + "@" + domain],
    sample(subject, "deleted and restored"),
  )
  smtp.quit()
  let pop = @net.Pop3::connect(l.host, Clear, port=l.pop3)
  pop.login(account, secret)
  guard numbered(pop, subject) is Some(message) else {
    fail(subject + " never arrived")
  }
  let before = counted(pop)
  pop.client().dele(message)
  for event in pop.run() {
    assert_true(event is Reply(_, Ok(_)))
  }
  // MARKED means gone from STAT for this session only.
  assert_eq(counted(pop), before - 1)
  pop.client().rset()
  for event in pop.run() {
    assert_true(event is Reply(_, Ok(_)))
  }
  assert_eq(counted(pop), before)
  // A session that leaves after DELE takes the message with it.
  pop.client().dele(message)
  for event in pop.run() {
    assert_true(event is Reply(_, Ok(_)))
  }
  pop.quit()
  let after = @net.Pop3::connect(l.host, Clear, port=l.pop3)
  after.login(account, secret)
  assert_true(numbered(after, subject) is None)
  after.quit()
}

///|
async test "pop3 takes a message larger than one read off Dovecot" {
  guard live() is Some(l) else { return }
  let subject = marked("bulk")
  let body = "0123456789abcdef".repeat(20000)
  let smtp = @net.Smtp::connect(l.host, Clear, port=l.smtp, hello="client.test")
  let _ = smtp.send(
    "alice@example.com",
    [account + "@" + domain],
    sample(subject, body),
  )
  smtp.quit()
  let pop = @net.Pop3::connect(l.host, Clear, port=l.pop3)
  pop.login(account, secret)
  let mut found = None
  for _ in 0..<40 {
    for item in pop.list() {
      let message = pop.retr(item.0)
      if @utf8.decode_lossy(message[:]).contains("Subject: " + subject) {
        found = Some((item.1, message))
        break
      }
    }
    if found is Some(_) {
      break
    }
    @async.sleep(250)
  }
  guard found is Some((size, message)) else { fail(subject + " never arrived") }
  // The octets are what was sent, dot-unstuffed, and the size LIST gave is the
  // size RETR handed over.
  assert_eq(message.length().to_int64(), size)
  assert_true(message.length() > 300000)
  assert_true(@utf8.decode_lossy(message[:]).contains(body))
  pop.quit()
}

///|
async test "pop3 authenticates with SASL on Dovecot" {
  guard live() is Some(l) else { return }
  let pop = @net.Pop3::connect(l.host, Clear, port=l.pop3)
  assert_true(pop.client().has("SASL"))
  pop.auth(@sasl.Plain::new(account, secret))
  assert_true(pop.list().length() > 0)
  pop.quit()
}
