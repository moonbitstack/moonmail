// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The IMAP server of `@moonmail/imap` over a socket, for the conformance run
/// that points imaptest at it:
///
///     moon run src/examples/imap-server -- 1144
///
/// One account, tim with the password secret, and mailboxes in memory: the
/// point is the protocol, not the storage. Every connection gets a session;
/// the store behind them is shared, and one session's APPEND is the next one's
/// FETCH.

///|
/// The account the server knows.
fn known(user : String, password : String) -> Bool {
  user == "tim" && password == "secret"
}

///|
/// `INTERNALDATE` for a message that arrived without one, in the format IMAP
/// writes.
fn clock() -> String {
  @moondate.Moment::of_epoch(@env.now().reinterpret_as_int64() / 1000L).strftime(
    "%d-%b-%Y %H:%M:%S +0000",
  )
}

///|
async fn serve(store : @imap.Store, conn : @tcp.Conn) -> Unit {
  let server = @imap.Server::new(store~, credentials=known, clock~)
  conn.write(
    @utf8.encode(
      "* OK [CAPABILITY " + @imap.supported.join(" ") + "] ready\r\n",
    ),
  )
  while true {
    guard conn.read_some(max_len=16384) is Some(data) else { break }
    server.feed(data) catch {
      _ => break
    }
    while server.next_write() is Some(out) {
      conn.write(out)
    }
    if server.state() is @imap.Logout {
      break
    }
  }
  conn.close()
}

///|
async fn main {
  // `-- <port> <host>`: a port to listen on and an address to bind. The address
  // is loopback unless a run has to be reached from another machine, as a
  // conformance tool in a container would.
  let args = @env.args()
  let port = if args.length() > 1 { @string.parse_int(args[1]) } else { 1144 }
  let host = if args.length() > 2 { args[2] } else { "127.0.0.1" }
  let store = @imap.Store::new()
  let _ = store.create("Archive")
  let listener = @tcp.listen(host~, port~)
  println(
    "imap-server listening on " +
    host +
    ":" +
    listener.addr().port().to_string(),
  )
  listener.serve((conn, _addr) => serve(store, conn))
}
