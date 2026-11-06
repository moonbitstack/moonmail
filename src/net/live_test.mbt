// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// Where the reference services listen: Dovecot for IMAP and POP3, Postfix for
/// SMTP, each in the clear and under TLS, from `MOONMAIL_LIVE` written as
/// `host:imap:imaps:pop3:pop3s:smtp:smtps`. Set, every one of them has to
/// answer; a service that is not there fails the test rather than passing it
/// quietly. Unset, the live tests do nothing.
#derive(Eq, Debug)
struct Live {
  host : String
  imap : Int32
  imaps : Int32
  pop3 : Int32
  pop3s : Int32
  smtp : Int32
  smtps : Int32
}

///|
fn live() -> Live? raise {
  guard @env.get_env_var("MOONMAIL_LIVE") is Some(spec) else { return None }
  guard spec.split(":").to_array()
    is [host, imap, imaps, pop3, pop3s, smtp, smtps] else {
    fail("MOONMAIL_LIVE is host:imap:imaps:pop3:pop3s:smtp:smtps, not " + spec)
  }
  Some({
    host: host.to_owned(),
    imap: @string.parse_int(imap),
    imaps: @string.parse_int(imaps),
    pop3: @string.parse_int(pop3),
    pop3s: @string.parse_int(pop3s),
    smtp: @string.parse_int(smtp),
    smtps: @string.parse_int(smtps),
  })
}

///|
/// The account both reference services know, and the domain Postfix takes mail
/// for.
let account : String = "mailtest"

///|
let secret : String = "secret"

///|
let domain : String = "moonmail.test"

///|
/// A name no other run of the tests uses, so a mailbox one test leaves behind
/// cannot be mistaken for another's.
fn fresh(prefix : String) -> String {
  prefix + "-" + @env.now().to_string()
}

///|
/// A message with a subject and a body, as the octets a reader would get.
fn sample(subject : String, body : String) -> Bytes {
  @utf8.encode(
    "From: Alice <alice@example.com>\r\n" +
    "To: Mail Test <" +
    account +
    "@" +
    domain +
    ">\r\n" +
    "Subject: " +
    subject +
    "\r\n" +
    "Date: Fri, 06 Nov 2026 12:00:00 +0000\r\n" +
    "Message-ID: <" +
    subject.replace_all(old=" ", new=".") +
    "@example.com>\r\n" +
    "MIME-Version: 1.0\r\n" +
    "Content-Type: text/plain; charset=utf-8\r\n" +
    "\r\n" +
    body +
    "\r\n",
  )
}
