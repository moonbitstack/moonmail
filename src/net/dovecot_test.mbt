// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// Dovecot is the reference IMAP and POP3 server, and the one the CI points
/// `imaptest` at. These tests speak to it as a server and hold it to what it
/// answers, so a reply the state machines only ever guessed at shows up here.

///|
async test "imap logs in to Dovecot and lists the mailboxes" {
  guard live() is Some(l) else { return }
  let imap = @net.Imap::connect(l.host, Clear, port=l.imap)
  assert_true(imap.client().has("IMAP4rev1"))
  assert_true(imap.client().state() is NotAuthenticated)
  imap.login(account, secret)
  assert_true(imap.client().state() is Authenticated)
  let listed = imap.wait(imap.client().list("", "*"))
  assert_eq(listed.status, Ok)
  assert_true(listed.data.any(r => r is List(name~, ..) && name == "INBOX"))
  imap.logout()
  assert_true(imap.client().state() is Logout)
}

///|
async test "imap creates, renames and deletes a mailbox on Dovecot" {
  guard live() is Some(l) else { return }
  let imap = @net.Imap::connect(l.host, Clear, port=l.imap)
  imap.login(account, secret)
  let first = fresh("moonmail")
  let second = first + "-moved"
  assert_eq(imap.wait(imap.client().create(first)).status, Ok)
  guard imap.wait(imap.client().list("", first)).data is [List(name~, ..)] else {
    fail("Dovecot did not list " + first)
  }
  assert_eq(name, first)
  assert_eq(imap.wait(imap.client().subscribe(first)).status, Ok)
  assert_eq(imap.wait(imap.client().rename(first, second)).status, Ok)
  assert_eq(imap.wait(imap.client().list("", first)).data.length(), 0)
  assert_eq(imap.wait(imap.client().list("", second)).data.length(), 1)
  assert_eq(imap.wait(imap.client().unsubscribe(second)).status, Ok)
  assert_eq(imap.wait(imap.client().delete(second)).status, Ok)
  assert_eq(imap.wait(imap.client().list("", second)).data.length(), 0)
  imap.logout()
}

///|
async test "imap appends a message to Dovecot and reads the octets back" {
  guard live() is Some(l) else { return }
  let imap = @net.Imap::connect(l.host, Clear, port=l.imap)
  imap.login(account, secret)
  let box = fresh("moonmail")
  let _ = imap.wait(imap.client().create(box))
  let selected = imap.wait(imap.client().select(box))
  assert_eq(selected.status, Ok)
  assert_eq(selected.code, Some(ReadWrite))
  let message = sample("appended", "the body, in octets")
  assert_eq(imap.wait(imap.client().append(box, message)).status, Ok)
  let stat = imap.wait(
    imap.client().status(box, ["MESSAGES", "UIDNEXT", "UIDVALIDITY"]),
  )
  guard stat.data is [Status(_, items)] else { fail("no status in the reply") }
  assert_eq(items.get("MESSAGES"), Some(1L))
  assert_eq(items.get("UIDNEXT"), Some(2L))
  let fetched = imap.wait(
    imap.client().fetch("1", "(UID FLAGS RFC822.SIZE BODY.PEEK[])", uid=true),
  )
  guard fetched.data is [Fetch(n, items)] else { fail("no fetch in the reply") }
  assert_eq(n, 1L)
  assert_eq(items.get("UID"), Some(Number(1L)))
  // Dovecot marks a message just appended as recent as well as unseen.
  guard items.get("FLAGS") is Some(List(flags)) else { fail("no flags") }
  assert_false(flags.contains(Atom("\\Seen")))
  assert_eq(items.get("RFC822.SIZE"), Some(Number(message.length().to_int64())))
  assert_eq(items.get("BODY[]"), Some(Text(message)))
  // The tree a reader would build comes out of the same octets.
  guard items.get("BODY[]") is Some(Text(raw)) else { fail("no body") }
  let parsed = @moonmail.Message::parse(raw[:])
  assert_eq(parsed.subject(), Some("appended"))
  assert_true(parsed.text() is Some(body) && body.contains("the body"))
  imap.logout()
}

///|
async test "imap stores flags on Dovecot and searches by them" {
  guard live() is Some(l) else { return }
  let imap = @net.Imap::connect(l.host, Clear, port=l.imap)
  imap.login(account, secret)
  let box = fresh("moonmail")
  let _ = imap.wait(imap.client().create(box))
  let _ = imap.wait(imap.client().select(box))
  let _ = imap.wait(imap.client().append(box, sample("one", "first")))
  let _ = imap.wait(imap.client().append(box, sample("two", "second")))
  // Both arrive unseen, so a search for UNSEEN finds them both.
  guard imap.wait(imap.client().search("UNSEEN", uid=true)).data
    is [Search(found, ..)] else {
    fail("no search result")
  }
  assert_eq(found, [1L, 2L])
  assert_eq(
    imap.wait(imap.client().store("1", "+FLAGS (\\Seen)", uid=true)).status,
    Ok,
  )
  guard imap.wait(imap.client().search("SEEN", uid=true)).data
    is [Search(found, ..)] else {
    fail("no search result")
  }
  assert_eq(found, [1L])
  guard imap.wait(imap.client().fetch("1", "(FLAGS)", uid=true)).data
    is [Fetch(_, items)] else {
    fail("no fetch")
  }
  guard items.get("FLAGS") is Some(List(flags)) else { fail("no flags") }
  assert_true(flags.contains(Atom("\\Seen")))
  imap.logout()
}

///|
async test "imap copies and moves between Dovecot mailboxes" {
  guard live() is Some(l) else { return }
  let imap = @net.Imap::connect(l.host, Clear, port=l.imap)
  imap.login(account, secret)
  let from = fresh("moonmail-from")
  let to = fresh("moonmail-to")
  let _ = imap.wait(imap.client().create(from))
  let _ = imap.wait(imap.client().create(to))
  let _ = imap.wait(imap.client().select(from))
  let _ = imap.wait(imap.client().append(from, sample("copy", "body")))
  assert_eq(imap.wait(imap.client().copy("1", to, uid=true)).status, Ok)
  assert_eq(imap.wait(imap.client().move_to("1", to, uid=true)).status, Ok)
  guard imap.wait(imap.client().status(from, ["MESSAGES"])).data
    is [Status(_, items)] else {
    fail("no status")
  }
  assert_eq(items.get("MESSAGES"), Some(0L))
  guard imap.wait(imap.client().status(to, ["MESSAGES"])).data
    is [Status(_, items)] else {
    fail("no status")
  }
  assert_eq(items.get("MESSAGES"), Some(2L))
  imap.logout()
}

///|
async test "imap expunges what Dovecot was told to delete" {
  guard live() is Some(l) else { return }
  let imap = @net.Imap::connect(l.host, Clear, port=l.imap)
  imap.login(account, secret)
  let box = fresh("moonmail")
  let _ = imap.wait(imap.client().create(box))
  let _ = imap.wait(imap.client().select(box))
  let _ = imap.wait(imap.client().append(box, sample("doomed", "body")))
  let _ = imap.wait(imap.client().store("1", "+FLAGS (\\Deleted)", uid=true))
  let expunged = imap.wait(imap.client().expunge())
  assert_eq(expunged.status, Ok)
  assert_true(expunged.data.any(r => r is Expunge(1L)))
  imap.logout()
}

///|
async test "imap idles on Dovecot and hears about a new message" {
  guard live() is Some(l) else { return }
  let reader = @net.Imap::connect(l.host, Clear, port=l.imap)
  reader.login(account, secret)
  let box = fresh("moonmail")
  let _ = reader.wait(reader.client().create(box))
  let _ = reader.wait(reader.client().select(box))
  let idling = reader.client().idle()
  // The `+` that ends IDLE is taken inside `read`, and the session then stays
  // silent until the server has something to say or `done` is sent.
  let opening = reader.read()
  assert_eq(opening.length(), 0)
  let writer = @net.Imap::connect(l.host, Clear, port=l.imap)
  writer.login(account, secret)
  let _ = writer.wait(writer.client().append(box, sample("idle", "body")))
  writer.logout()
  let announced = reader.read()
  assert_true(announced.any(e => e is Data(Exists(1L))))
  reader.client().done()
  assert_eq(reader.wait(idling).status, Ok)
  reader.logout()
}

///|
async test "imap carries a message larger than one read across Dovecot" {
  guard live() is Some(l) else { return }
  let imap = @net.Imap::connect(l.host, Clear, port=l.imap)
  imap.login(account, secret)
  let box = fresh("moonmail-big")
  let _ = imap.wait(imap.client().create(box))
  let _ = imap.wait(imap.client().select(box))
  // Bigger than the 16 KiB a session reads at a time, so the literal arrives
  // in pieces and has to be put back together.
  let message = sample("large", "0123456789abcdef".repeat(20000))
  assert_true(message.length() > 300000)
  assert_eq(imap.wait(imap.client().append(box, message)).status, Ok)
  let fetched = imap.wait(
    imap.client().fetch("1", "(RFC822.SIZE BODY.PEEK[])", uid=true),
  )
  guard fetched.data is [Fetch(_, items)] else { fail("no fetch") }
  assert_eq(items.get("RFC822.SIZE"), Some(Number(message.length().to_int64())))
  guard items.get("BODY[]") is Some(Text(raw)) else { fail("no body") }
  assert_eq(raw.length(), message.length())
  assert_eq(raw, message)
  imap.logout()
}

///|
async test "imap reads the envelope and the structure Dovecot sends" {
  guard live() is Some(l) else { return }
  let imap = @net.Imap::connect(l.host, Clear, port=l.imap)
  imap.login(account, secret)
  let box = fresh("moonmail-envelope")
  let _ = imap.wait(imap.client().create(box))
  let _ = imap.wait(imap.client().select(box))
  let _ = imap.wait(imap.client().append(box, sample("envelope", "body")))
  let fetched = imap.wait(
    imap.client().fetch("1", "(ENVELOPE BODYSTRUCTURE INTERNALDATE)", uid=true),
  )
  guard fetched.data is [Fetch(_, items)] else { fail("no fetch") }
  // The envelope's fields, in the order RFC 9051 section 7.4.2 gives them.
  guard items.get("ENVELOPE") is Some(List(fields)) else { fail("no envelope") }
  assert_eq(fields.length(), 10)
  // date, subject, from, sender, reply-to, to, cc, bcc, in-reply-to, id.
  assert_true(fields[0] is Text(_))
  assert_eq(fields[1], Text(b"envelope"))
  guard fields[2] is List([List(sender)]) else {
    fail("no sender in the envelope")
  }
  // A mailbox in an envelope is name, route, mailbox, host.
  assert_eq(sender.length(), 4)
  assert_eq(sender[0], Text(b"Alice"))
  assert_eq(sender[2], Text(b"alice"))
  guard items.get("BODYSTRUCTURE") is Some(List(structure)) else {
    fail("no structure")
  }
  assert_eq(structure[0], Text(b"text"))
  assert_eq(structure[1], Text(b"plain"))
  assert_true(items.get("INTERNALDATE") is Some(_))
}

///|
async test "imap speaks TLS to Dovecot from the first octet" {
  guard live() is Some(l) else { return }
  let imap = @net.Imap::connect(l.host, Tls(client_config()), port=l.imaps)
  imap.login(account, secret)
  assert_true(imap.client().state() is Authenticated)
  assert_eq(imap.wait(imap.client().select("INBOX")).status, Ok)
  imap.logout()
}

///|
async test "imap and pop3 start TLS on Dovecot" {
  guard live() is Some(l) else { return }
  let imap = @net.Imap::connect(l.host, StartTls(client_config()), port=l.imap)
  // STARTTLS is answered in the clear and everything after it is protected;
  // the session proves it by logging in, which Dovecot refuses in the clear
  // only after it has said LOGINDISABLED.
  imap.login(account, secret)
  assert_eq(imap.wait(imap.client().select("INBOX")).status, Ok)
  imap.logout()
  let pop = @net.Pop3::connect(l.host, StartTls(client_config()), port=l.pop3)
  pop.login(account, secret)
  pop.client().stat()
  for event in pop.run() {
    assert_true(event is Reply(_, Stat(..)))
  }
  pop.quit()
}

///|
async test "pop3 speaks TLS to Dovecot from the first octet" {
  guard live() is Some(l) else { return }
  let pop = @net.Pop3::connect(l.host, Tls(client_config()), port=l.pop3s)
  pop.login(account, secret)
  let listed = pop.list()
  assert_true(listed.all(item => item.1 > 0L))
  pop.client().uidl()
  let mut uids = []
  for event in pop.run() {
    if event is Reply(_, Uids(list)) {
      uids = list
    }
  }
  assert_eq(uids.length(), listed.length())
  pop.quit()
}

///|
async test "imap searches a UTF-8 subject with a charset Dovecot accepts" {
  guard live() is Some(l) else { return }
  let imap = @net.Imap::connect(l.host, Clear, port=l.imap)
  imap.login(account, secret)
  let box = fresh("moonmail-utf8")
  let _ = imap.wait(imap.client().create(box))
  let _ = imap.wait(imap.client().select(box))
  // RFC 3501 section 6.4.4: eight-bit data cannot go in an atom, so a search
  // for it names the charset and quotes the string.
  let _ = imap.wait(
    imap.client().append(box, sample("日本語の件名", "本文")),
  )
  let _ = imap.wait(imap.client().append(box, sample("plain", "body")))
  let searched = imap.wait(
    imap
    .client()
    .search("CHARSET UTF-8 SUBJECT \"日本語の件名\"", uid=true),
  )
  assert_eq(searched.status, Ok)
  guard searched.data is [Search(found, ..)] else { fail("no search result") }
  assert_eq(found, [1L])
  imap.logout()
}

///|
async test "imap selects with CONDSTORE and stores against a mod-sequence" {
  guard live() is Some(l) else { return }
  let imap = @net.Imap::connect(l.host, Clear, port=l.imap)
  imap.login(account, secret)
  let box = fresh("moonmail-condstore")
  let _ = imap.wait(imap.client().create(box))
  let _ = imap.wait(imap.client().append(box, sample("one", "first")))
  let selected = imap.wait(imap.client().select(box, condstore=true))
  assert_eq(selected.status, Ok)
  // A mailbox opened with CONDSTORE reports its highest mod-sequence.
  let mut highest = None
  for response in selected.data {
    if response
      is @imap.Response::Condition(_, Some(@imap.Code::HighestModseq(n)), _) {
      highest = Some(n)
    }
  }
  guard highest is Some(modseq) else { fail("no HIGHESTMODSEQ") }
  assert_eq(
    imap.wait(
      imap.client().store("1", "+FLAGS (\\Seen)", unchangedsince=modseq),
    ).status,
    Ok,
  )
  // A mod-sequence from before the change no longer matches, so the store is
  // refused for that message and named in the completion's MODIFIED code.
  let stale = imap.wait(
    imap.client().store("1", "-FLAGS (\\Seen)", unchangedsince=modseq),
  )
  assert_eq(stale.status, Ok)
  assert_true(stale.code is Some(Modified(_)))
  imap.logout()
}

///|
async test "imap reports a mailbox that is not there" {
  guard live() is Some(l) else { return }
  let imap = @net.Imap::connect(l.host, Clear, port=l.imap)
  imap.login(account, secret)
  let missing = imap.wait(imap.client().select(fresh("no-such-mailbox")))
  assert_eq(missing.status, No)
  // A refused SELECT leaves the session authenticated, not selected.
  assert_true(imap.client().state() is Authenticated)
  imap.logout()
}

///|
/// `imaptest` puts its messages in INBOX before the tests run, from the mbox
/// `scripts/interop/write_mbox.py` writes; `MOONMAIL_IMAPTEST` says how many.
/// Reading them back is the one place where a reference client's traffic and
/// this one meet: every Message-ID it stamped has to come out of a header
/// fetch here.
async test "imap reads the mailbox imaptest filled" {
  guard @env.get_env_var("MOONMAIL_IMAPTEST") is Some(count) else { return }
  let expected = @string.parse_int(count)
  guard live() is Some(l) else { return }
  let imap = @net.Imap::connect(l.host, Clear, port=l.imap)
  imap.login(account, secret)
  let selected = imap.wait(imap.client().select("INBOX"))
  assert_eq(selected.status, Ok)
  // The mailbox has to hold what imaptest put there before the headers are
  // asked for.
  assert_true(selected.data.any(r => r is @imap.Response::Exists(n) && n > 0L))
  let headers = imap.wait(
    imap
    .client()
    .fetch(
      "1:*",
      "(UID BODY.PEEK[HEADER.FIELDS (MESSAGE-ID SUBJECT)])",
      uid=true,
    ),
  )
  assert_eq(headers.status, Ok)
  let stamp = "Message-ID: <imaptest."
  let mut found = 0
  for response in headers.data {
    guard response is @imap.Response::Fetch(_, items) else { continue }
    guard items.get("BODY[HEADER.FIELDS (MESSAGE-ID SUBJECT)]")
      is Some(Text(raw)) else {
      continue
    }
    if @utf8.decode_lossy(raw[:]).contains(stamp) {
      found += 1
    }
  }
  assert_true(found >= expected)
  imap.logout()
}
