// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The IMAP server this library builds, over a socket: `MOONMAIL_IMAP_SERVER`
/// holds `host:port` where `src/examples/imap-server` is listening, and the
/// client in `@moonmail/net` talks to it. The same server is what imaptest is
/// pointed at in CI, so these tests are the readable half of that run.

///|
fn imap_server() -> (String, Int32)? raise {
  guard @env.get_env_var("MOONMAIL_IMAP_SERVER") is Some(spec) else {
    return None
  }
  guard spec.split(":").to_array() is [host, port] else {
    fail("MOONMAIL_IMAP_SERVER is host:port, not " + spec)
  }
  Some((host.to_owned(), @string.parse_int(port)))
}

///|
/// A subject no other run uses.
fn server_mark(kind : String) -> String {
  "server " + kind + " " + @env.now().to_string()
}

///|
async test "imap client runs a whole session against this library's server" {
  guard imap_server() is Some((host, port)) else { return }
  let imap = @net.Imap::connect(host, Clear, port~)
  assert_true(imap.client().has("IMAP4rev1"))
  imap.login("tim", "secret")
  assert_true(imap.client().state() is Authenticated)
  let box = server_mark("box")
  assert_eq(imap.wait(imap.client().create(box)).status, Ok)
  let listed = imap.wait(imap.client().list("", "*"))
  assert_true(listed.data.any(r => r is List(name~, ..) && name == box))
  let selected = imap.wait(imap.client().select(box))
  assert_eq(selected.status, Ok)
  assert_eq(selected.code, Some(ReadWrite))
  let message = sample(server_mark("appended"), "the body, in octets")
  assert_eq(
    imap.wait(imap.client().append(box, message, flags=["\\Flagged"])).status,
    Ok,
  )
  let fetched = imap.wait(
    imap.client().fetch("1", "(UID FLAGS RFC822.SIZE BODY.PEEK[])", uid=true),
  )
  guard fetched.data is [Fetch(_, items)] else { fail("no fetch") }
  assert_eq(items.get("UID"), Some(Number(1L)))
  assert_eq(items.get("RFC822.SIZE"), Some(Number(message.length().to_int64())))
  guard items.get("BODY[]") is Some(Text(raw)) else { fail("no body") }
  assert_eq(raw, message)
  guard items.get("FLAGS") is Some(List(flags)) else { fail("no flags") }
  assert_true(flags.contains(Atom("\\Flagged")))
  // The tree a reader would build comes out of the same octets.
  let parsed = @moonmail.Message::parse(raw[:])
  assert_true(parsed.subject() is Some(subject) && subject.has_prefix("server"))
  imap.logout()
}

///|
async test "imap client searches, stores and expunges on this server" {
  guard imap_server() is Some((host, port)) else { return }
  let imap = @net.Imap::connect(host, Clear, port~)
  imap.login("tim", "secret")
  let box = server_mark("search")
  let _ = imap.wait(imap.client().create(box))
  let _ = imap.wait(imap.client().select(box))
  let _ = imap.wait(
    imap.client().append(box, sample(server_mark("one"), "first")),
  )
  let _ = imap.wait(
    imap.client().append(box, sample(server_mark("two"), "second")),
  )
  guard imap.wait(imap.client().search("UNSEEN", uid=true)).data
    is [Search(found, ..)] else {
    fail("no search result")
  }
  assert_eq(found.length(), 2)
  assert_eq(
    imap.wait(imap.client().store("1", "+FLAGS (\\Seen)", uid=true)).status,
    Ok,
  )
  guard imap.wait(imap.client().search("SEEN", uid=true)).data
    is [Search(found, ..)] else {
    fail("no search result")
  }
  assert_eq(found, [1L])
  let _ = imap.wait(imap.client().store("1", "+FLAGS (\\Deleted)", uid=true))
  let expunged = imap.wait(imap.client().expunge())
  assert_eq(expunged.status, Ok)
  assert_true(expunged.data.any(r => r is Expunge(1L)))
  let after = imap.wait(imap.client().status(box, ["MESSAGES"]))
  guard after.data is [Status(_, items)] else { fail("no status") }
  assert_eq(items.get("MESSAGES"), Some(1L))
  imap.logout()
}

///|
async test "imap client copies between mailboxes on this server" {
  guard imap_server() is Some((host, port)) else { return }
  let imap = @net.Imap::connect(host, Clear, port~)
  imap.login("tim", "secret")
  let from = server_mark("from")
  let _ = imap.wait(imap.client().create(from))
  let _ = imap.wait(imap.client().select(from))
  let _ = imap.wait(
    imap.client().append(from, sample(server_mark("copy"), "body")),
  )
  let copied = imap.wait(imap.client().copy("1", "Archive", uid=true))
  assert_eq(copied.status, Ok)
  assert_true(copied.code is Some(@imap.Code::CopyUid(_, _, _)))
  let moved = imap.wait(imap.client().move_to("1", "Archive", uid=true))
  assert_eq(moved.status, Ok)
  let left = imap.wait(imap.client().status(from, ["MESSAGES"]))
  guard left.data is [Status(_, items)] else { fail("no status") }
  assert_eq(items.get("MESSAGES"), Some(0L))
  imap.logout()
}

///|
async test "two sessions on this server see each other's mail" {
  guard imap_server() is Some((host, port)) else { return }
  let writer = @net.Imap::connect(host, Clear, port~)
  writer.login("tim", "secret")
  let box = server_mark("shared")
  let _ = writer.wait(writer.client().create(box))
  let reader = @net.Imap::connect(host, Clear, port~)
  reader.login("tim", "secret")
  let _ = writer.wait(
    writer.client().append(box, sample(server_mark("shared"), "body")),
  )
  let opened = reader.wait(reader.client().select(box))
  assert_eq(opened.status, Ok)
  assert_true(opened.data.any(r => r is Exists(1L)))
  writer.logout()
  reader.logout()
}

///|
async test "this server refuses the wrong password and a mailbox that is not there" {
  guard imap_server() is Some((host, port)) else { return }
  let imap = @net.Imap::connect(host, Clear, port~)
  let refused = try {
    imap.login("tim", "wrong")
    false
  } catch {
    @net.Done(No, _, _) => true
    e => raise e
  }
  assert_true(refused)
  imap.login("tim", "secret")
  let missing = imap.wait(imap.client().select(server_mark("no-such-box")))
  assert_eq(missing.status, No)
  imap.logout()
}
