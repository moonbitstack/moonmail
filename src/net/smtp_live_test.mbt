// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// SMTP against Postfix: the extensions it announces, the replies it gives, and
/// the octets that come out the other side in Dovecot's maildrop. The chain is
/// Postfix on 2525, local(8), the Maildir, then Dovecot's IMAP, so every octet
/// asserted on has been through both servers.

///|
/// The message Dovecot holds under `subject`, or nothing if it never arrived.
async fn took(subject : String) -> String? {
  guard live() is Some(l) else { return None }
  let imap = @net.Imap::connect(l.host, Clear, port=l.imap)
  imap.login(account, secret)
  let _ = imap.wait(imap.client().select("INBOX"))
  let criteria = "HEADER SUBJECT \"" + subject + "\""
  let mut body = None
  for _ in 0..<40 {
    match imap.wait(imap.client().search(criteria, uid=true)).data {
      [Search([uid, ..], ..)] => {
        let fetched = imap.wait(
          imap.client().fetch(uid.to_string(), "(BODY.PEEK[])", uid=true),
        )
        if fetched.data is [Fetch(_, items)] &&
          items.get("BODY[]") is Some(Text(raw)) {
          body = Some(@utf8.decode_lossy(raw[:]))
          break
        }
        @async.sleep(250)
      }
      _ => @async.sleep(250)
    }
  }
  imap.logout()
  body
}

///|
async test "smtp reads the extensions Postfix announces" {
  guard live() is Some(l) else { return }
  let smtp = @net.Smtp::connect(l.host, Clear, port=l.smtp, hello="client.test")
  let extensions = smtp.client().extensions()
  // What a modern Postfix offers, read out of the EHLO reply line by line.
  assert_true(smtp.client().has("PIPELINING"))
  assert_true(smtp.client().has("SIZE"))
  assert_true(smtp.client().has("8BITMIME"))
  assert_true(smtp.client().has("ENHANCEDSTATUSCODES"))
  assert_true(smtp.client().has("STARTTLS"))
  guard extensions.get("SIZE") is Some(size) else { fail("SIZE has no value") }
  // Postfix caps a message at 10 MB unless told otherwise; whatever it says is
  // a number.
  assert_true(@string.parse_int(size) > 0)
  smtp.quit()
}

///|
async test "smtp carries a body whose lines begin with a dot" {
  guard live() is Some(l) else { return }
  let subject = "moonmail dots " + @env.now().to_string()
  let body = ".a line that starts with a dot\r\n..\r\n.\r\nafter the stuffing\r\n"
  let message = @utf8.encode(
    "From: alice@example.com\r\nTo: " +
    account +
    "@" +
    domain +
    "\r\nSubject: " +
    subject +
    "\r\n\r\n" +
    body,
  )
  let smtp = @net.Smtp::connect(l.host, Clear, port=l.smtp, hello="client.test")
  let refused = smtp.send(
    "alice@example.com",
    [account + "@" + domain],
    message,
  )
  assert_eq(refused.length(), 0)
  smtp.quit()
  guard took(subject) is Some(delivered) else {
    fail(subject + " never arrived")
  }
  // A line of one dot ends the DATA; the message body is exactly what was
  // written, dot-unstuffed on the way in.
  assert_true(delivered.contains(".a line that starts with a dot\r\n"))
  assert_true(delivered.contains("..\r\n"))
  assert_true(delivered.contains("after the stuffing\r\n"))
}

///|
async test "smtp delivers eight-bit content through Postfix" {
  guard live() is Some(l) else { return }
  let subject = "moonmail 8bit " + @env.now().to_string()
  let message = @utf8.encode(
    "From: alice@example.com\r\nTo: " +
    account +
    "@" +
    domain +
    "\r\nSubject: " +
    subject +
    "\r\nContent-Type: text/plain; charset=utf-8\r\n" +
    "Content-Transfer-Encoding: 8bit\r\n\r\n" +
    "naïve café — 日本語\r\n",
  )
  let smtp = @net.Smtp::connect(l.host, Clear, port=l.smtp, hello="client.test")
  let refused = smtp.send(
    "alice@example.com",
    [account + "@" + domain],
    message,
  )
  assert_eq(refused.length(), 0)
  smtp.quit()
  guard took(subject) is Some(delivered) else {
    fail(subject + " never arrived")
  }
  assert_true(delivered.contains("naïve café — 日本語"))
}

///|
async test "smtp reports the recipient Postfix refuses and sends the rest" {
  guard live() is Some(l) else { return }
  let subject = "moonmail refused " + @env.now().to_string()
  let smtp = @net.Smtp::connect(l.host, Clear, port=l.smtp, hello="client.test")
  let refused = smtp.send(
    "alice@example.com",
    ["ghost@" + domain, account + "@" + domain],
    sample(subject, "one recipient was refused"),
  )
  assert_eq(refused.length(), 1)
  guard refused is [(who, reply)] else {
    fail("the wrong recipients were refused")
  }
  assert_eq(who, "ghost@" + domain)
  assert_eq(reply.code, 550)
  // RFC 3463's enhanced code says which kind of failure it was.
  assert_eq(reply.status(), Some("5.1.1"))
  smtp.quit()
  // The recipient that was accepted still got the message.
  assert_true(took(subject) is Some(_))
}
