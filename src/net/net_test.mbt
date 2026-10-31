// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
fn server_config() -> @tls.Server raise {
  @tls.Server::new(@x509.pems(cert), @x509.PrivateKey::pem(key))
}

///|
fn client_config() -> @tls.Client raise {
  @tls.Client::new(@x509.Roots::new(certs=@x509.pems(root)[:]))
}

///|
/// Run `body` with the port of a listener serving `handler`, then stop it.
async fn with_server(
  handler : async (@tcp.Conn, @socket.Addr) -> Unit,
  body : async (Int32) -> Unit,
  tls? : @tls.Server,
) -> Unit {
  @async.with_timeout(60000, () => {
    @async.with_task_group(g => {
      let listener = @tcp.listen(port=0, tls?)
      let server = g.spawn(() => listener.serve(handler))
      body(listener.addr().port())
      server.cancel()
    })
  })
}

///|
/// A relay made of the package's own server state machine: it takes PLAIN
/// for tim, refuses recipients named nobody, and keeps each message.
fn relay(
  stored : Array[Bytes],
  starttls~ : Bool = false,
) -> async (@tcp.Conn, @socket.Addr) -> Unit {
  async fn(conn : @tcp.Conn, _ : @socket.Addr) {
    let server = @smtp.Server::new("mx.test", starttls~, auth=["PLAIN"])
    let mut conn = conn
    while !server.closed() {
      while server.next() is Some(request) {
        match request {
          Auth("PLAIN", Some(data)) =>
            if data == b"\x00tim\x00secret" {
              server.accept()
            } else {
              server.reply(535, "5.7.8 Bad credentials")
            }
          Rcpt(to, _) if to.has_prefix("nobody") =>
            server.reply(550, "5.1.1 No such user")
          Data(message) => {
            stored.push(message)
            server.accept()
          }
          StartTls => {
            server.accept()
            conn.write(server.next_write().unwrap())
            conn = conn.secure(server_config())
          }
          Rset | Quit => ()
          _ => server.accept()
        }
      }
      if server.next_write() is Some(out) {
        conn.write(out)
      }
      if server.closed() {
        break
      }
      guard conn.read_some(max_len=16384) is Some(data) else { break }
      server.feed(data)
    }
  }
}

///|
async test "net sends a message in the clear and reports the refused" {
  let stored = []
  with_server(relay(stored), port => {
    let smtp = @net.Smtp::connect(
      "127.0.0.1",
      Clear,
      port~,
      hello="client.test",
    )
    smtp.auth(@sasl.Plain::new("tim", "secret"))
    let refused = smtp.send(
      "a@example.com",
      ["b@example.com", "nobody@example.com"],
      b"Subject: hi\r\n\r\n.body\r\n",
    )
    assert_eq(refused.map(r => r.0), ["nobody@example.com"])
    smtp.quit()
  })
  assert_eq(stored, [b"Subject: hi\r\n\r\n.body\r\n"])
}

///|
async test "net starts TLS before anything else" {
  let stored = []
  with_server(relay(stored, starttls=true), port => {
    let smtp = @net.Smtp::connect("localhost", StartTls(client_config()), port~)
    assert_true(smtp.client().has("AUTH"))
    smtp.auth(@sasl.Plain::new("tim", "secret"))
    let _ = smtp.send("a@example.com", ["b@example.com"], b"hi\r\n")
    smtp.quit()
  })
  assert_eq(stored.length(), 1)
}

///|
async test "net refuses a server that does not offer STARTTLS" {
  with_server(relay([]), port => {
    let refused = try {
      let _ = @net.Smtp::connect("localhost", StartTls(client_config()), port~)
      false
    } catch {
      @smtp.Unsupported("STARTTLS") => true
      e => raise e
    }
    assert_true(refused)
  })
}

///|
async test "net speaks TLS from the first octet" {
  let stored = []
  with_server(relay(stored), tls=server_config(), port => {
    let smtp = @net.Smtp::connect("localhost", Tls(client_config()), port~)
    let _ = smtp.send("a@example.com", ["b@example.com"], b"hi\r\n")
    smtp.quit()
  })
  assert_eq(stored.length(), 1)
}

///|
async test "net raises when the server refuses the credentials" {
  with_server(relay([]), port => {
    let smtp = @net.Smtp::connect("127.0.0.1", Clear, port~)
    let refused = try {
      smtp.auth(@sasl.Plain::new("tim", "wrong"))
      None
    } catch {
      @net.Reply(Auth(_), reply) => Some(reply.code)
      e => raise e
    }
    assert_eq(refused, Some(535))
    smtp.quit()
  })
}

///|
/// An IMAP server that answers each command from a table, by its verb.
async fn imap_script(conn : @tcp.Conn, _ : @socket.Addr) -> Unit {
  conn.write("* OK [CAPABILITY IMAP4rev2 AUTH=PLAIN] ready\r\n")
  while conn.read_until("\r\n") is Some(line) {
    let words = line.split(" ").to_array()
    let tag = words[0].to_owned()
    let answer = match words[1].to_upper() {
      "LOGIN" => tag + " OK done\r\n"
      "SELECT" =>
        "* 3 EXISTS\r\n* OK [UIDVALIDITY 9] valid\r\n" +
        tag +
        " OK [READ-WRITE] done\r\n"
      "FETCH" =>
        "* 1 FETCH (FLAGS (\\Seen) BODY[] {5}\r\nhello)\r\n" +
        tag +
        " OK done\r\n"
      "LOGOUT" => "* BYE bye\r\n" + tag + " OK done\r\n"
      _ => tag + " BAD unknown\r\n"
    }
    conn.write(answer)
  }
}

///|
async test "net runs an IMAP session" {
  with_server(imap_script, port => {
    let imap = @net.Imap::connect("127.0.0.1", Clear, port~)
    assert_true(imap.client().has("IMAP4rev2"))
    imap.login("tim", "secret")
    let selected = imap.wait(imap.client().select("INBOX"))
    assert_eq(selected.status, Ok)
    assert_eq(selected.code, Some(ReadWrite))
    assert_eq(selected.data[0], Exists(3))
    let fetched = imap.wait(imap.client().fetch("1", "(FLAGS BODY[])"))
    guard fetched.data is [Fetch(1, items)] else { fail("no fetch") }
    assert_eq(items.get("BODY[]"), Some(Text(b"hello")))
    imap.logout()
    assert_eq(imap.client().state(), Logout)
  })
}

///|
/// A POP3 server that answers each command from a table, by its verb.
async fn pop3_script(conn : @tcp.Conn, _ : @socket.Addr) -> Unit {
  conn.write("+OK ready <1.2@test>\r\n")
  while conn.read_until("\r\n") is Some(line) {
    let answer = match line.split(" ").to_array()[0].to_upper() {
      "CAPA" => "+OK\r\nUSER\r\nUIDL\r\n.\r\n"
      "USER" => "+OK\r\n"
      "PASS" => if line == "PASS secret" { "+OK in\r\n" } else { "-ERR no\r\n" }
      "LIST" => "+OK\r\n1 7\r\n.\r\n"
      "RETR" => "+OK\r\n..hello\r\n.\r\n"
      "QUIT" => "+OK bye\r\n"
      _ => "-ERR unknown\r\n"
    }
    conn.write(answer)
  }
}

///|
async test "net runs a POP3 session" {
  with_server(pop3_script, port => {
    let pop = @net.Pop3::connect("127.0.0.1", Clear, port~)
    assert_true(pop.client().has("UIDL"))
    let refused = try {
      pop.login("tim", "wrong")
      false
    } catch {
      @net.Err(Pass, _) => true
      e => raise e
    }
    assert_true(refused)
    pop.login("tim", "secret")
    assert_eq(pop.list(), [(1, 7)])
    assert_eq(pop.retr(1), b".hello\r\n")
    pop.quit()
  })
}
