// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
fn test_server(store : @imap.Store) -> @imap.Server {
  @imap.Server::new(
    store~,
    credentials=(user, password) => user == "tim" && password == "secret",
    clock=() => "06-Nov-2026 12:00:00 +0000",
  )
}

///|
/// Feed a command and take what the server wrote back.
fn said(server : @imap.Server, command : String) -> String raise {
  server.feed(@utf8.encode(command))
  match server.next_write() {
    Some(out) => @utf8.decode_lossy(out[:])
    None => ""
  }
}

///|
test "imap server logs in, opens a mailbox and refuses the wrong password" {
  let store = @imap.Store::new()
  let server = test_server(store)
  assert_eq(server.state(), @imap.NotAuthenticated)
  let refused = said(server, "a1 LOGIN tim wrong\r\n")
  assert_true(refused.contains("a1 NO"))
  assert_eq(server.state(), @imap.NotAuthenticated)
  let allowed = said(server, "a2 LOGIN tim secret\r\n")
  assert_true(allowed.contains("a2 OK"))
  assert_eq(server.state(), @imap.Authenticated)
  let listed = said(server, "a3 LIST \"\" \"*\"\r\n")
  assert_true(listed.contains("* LIST (\\HasNoChildren) \"/\" \"INBOX\""))
  assert_true(listed.contains("a3 OK"))
}

///|
test "imap server takes an append and serves the message back" {
  let store = @imap.Store::new()
  let server = test_server(store)
  let _ = said(server, "a1 LOGIN tim secret\r\n")
  let _ = said(server, "a2 SELECT INBOX\r\n")
  // A literal with the size on the line, then the octets, then the rest.
  let appended = said(server, "a3 APPEND INBOX (\\Seen) {5+}\r\nhello\r\n")
  assert_true(appended.contains("a3 OK [APPENDUID 1 1]"))
  let stat = said(server, "a4 STATUS INBOX (MESSAGES UIDNEXT UNSEEN)\r\n")
  assert_true(
    stat.contains("* STATUS \"INBOX\" (MESSAGES 1 UIDNEXT 2 UNSEEN 0)"),
  )
  let fetched = said(server, "a5 FETCH 1 (UID FLAGS RFC822.SIZE BODY[])\r\n")
  assert_true(fetched.contains("* 1 FETCH (UID 1 FLAGS (\\Seen)"))
  assert_true(fetched.contains("RFC822.SIZE 5"))
  assert_true(fetched.contains("BODY[] {5}\r\nhello"))
}

///|
test "imap server answers a literal only after the continuation" {
  let store = @imap.Store::new()
  let server = test_server(store)
  let _ = said(server, "a1 LOGIN tim secret\r\n")
  server.feed(@utf8.encode("a2 APPEND INBOX {3}\r\n"))
  let continuation = match server.next_write() {
    Some(out) => @utf8.decode_lossy(out[:])
    None => ""
  }
  assert_eq(continuation, "+ Ready for literal data\r\n")
  let done = said(server, "abc\r\n")
  assert_true(done.contains("a2 OK"))
}

///|
test "imap server expunges what was marked and reports the numbers" {
  let store = @imap.Store::new()
  let _ = store.deliver("INBOX", b"one", date="06-Nov-2026 12:00:00 +0000")
  let _ = store.deliver("INBOX", b"two", date="06-Nov-2026 12:00:00 +0000")
  let server = test_server(store)
  let _ = said(server, "a1 LOGIN tim secret\r\n")
  let _ = said(server, "a2 SELECT INBOX\r\n")
  let stored = said(server, "a3 STORE 1 +FLAGS (\\Deleted)\r\n")
  assert_true(stored.contains("* 1 FETCH (FLAGS (\\Deleted))"))
  let expunged = said(server, "a4 EXPUNGE\r\n")
  assert_true(expunged.contains("* 1 EXPUNGE"))
  assert_true(expunged.contains("a4 OK"))
  let left = said(server, "a5 STATUS INBOX (MESSAGES)\r\n")
  assert_true(left.contains("MESSAGES 1"))
}

///|
test "imap server searches by flags and by UID" {
  let store = @imap.Store::new()
  let _ = store.deliver("INBOX", b"one", date="06-Nov-2026 12:00:00 +0000")
  let _ = store.deliver(
    "INBOX",
    b"two",
    flags=["\\Seen"],
    date="06-Nov-2026 12:00:00 +0000",
  )
  let server = test_server(store)
  let _ = said(server, "a1 LOGIN tim secret\r\n")
  let _ = said(server, "a2 SELECT INBOX\r\n")
  let unseen = said(server, "a3 SEARCH UNSEEN\r\n")
  assert_true(unseen.contains("* SEARCH 1\r\n"))
  let uids = said(server, "a4 UID SEARCH SEEN\r\n")
  assert_true(uids.contains("* SEARCH 2\r\n"))
  let unknown = said(server, "a5 SEARCH ROCKET\r\n")
  assert_true(unknown.contains("a5 BAD"))
}

///|
test "imap server copies with COPYUID and moves out of the source" {
  let store = @imap.Store::new()
  let _ = store.create("Archive")
  let _ = store.deliver("INBOX", b"one", date="06-Nov-2026 12:00:00 +0000")
  let server = test_server(store)
  let _ = said(server, "a1 LOGIN tim secret\r\n")
  let _ = said(server, "a2 SELECT INBOX\r\n")
  let copied = said(server, "a3 COPY 1 Archive\r\n")
  assert_true(copied.contains("a3 OK [COPYUID 2 1 1]"))
  let moved = said(server, "a4 MOVE 1 Archive\r\n")
  assert_true(moved.contains("* 1 EXPUNGE"))
  assert_true(moved.contains("a4 OK [COPYUID 2 1 2]"))
  let left = said(server, "a5 STATUS INBOX (MESSAGES)\r\n")
  assert_true(left.contains("MESSAGES 0"))
}
