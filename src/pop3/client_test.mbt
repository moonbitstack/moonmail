// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
fn wire(data : Bytes?) -> String {
  match data {
    Some(bytes) => @utf8.decode_lossy(bytes[:])
    None => "(nothing)"
  }
}

///|
fn crlf(text : String) -> Bytes {
  @utf8.encode(text + "\r\n")
}

///|
fn[T] refusal(f : () -> T raise @pop3.Refused) -> @pop3.Refused? {
  try {
    let _ = f()
    None
  } catch {
    e => Some(e)
  }
}

///|
/// A client past the RFC 1939 greeting.
fn greeted() -> @pop3.Client raise @pop3.Refused {
  let client = @pop3.Client::new()
  let _ = client.feed(
    crlf("+OK POP3 server ready <1896.697170952@dbc.mtview.ca.us>"),
  )
  client
}

///|
/// A client in the transaction state, after USER and PASS.
fn logged_in() -> @pop3.Client raise @pop3.Refused {
  let client = greeted()
  client.user("mrose")
  let _ = client.next_write()
  let _ = client.feed(crlf("+OK mrose is a real hoopy frood"))
  client.pass("secret")
  let _ = client.next_write()
  let _ = client.feed(crlf("+OK maildrop has 2 messages (320 octets)"))
  client
}

///|
test "pop3 reads the greeting and its timestamp" {
  let client = @pop3.Client::new()
  client.capa()
  inspect(wire(client.next_write()), content="(nothing)")
  let events = client.feed(
    crlf("+OK POP3 server ready <1896.697170952@dbc.mtview.ca.us>"),
  )
  assert_eq(events, [
    Reply(
      Greeting,
      Greeting(
        text="POP3 server ready <1896.697170952@dbc.mtview.ca.us>",
        timestamp=Some("<1896.697170952@dbc.mtview.ca.us>"),
      ),
    ),
  ])
  inspect(wire(client.next_write()), content="CAPA\r\n")
  let refused = @pop3.Client::new()
  assert_eq(refused.feed(crlf("-ERR go away")), [
    Reply(Greeting, Err("go away")),
  ])
}

///|
test "pop3 apop matches RFC 1939" {
  let client = greeted()
  client.apop("mrose", "tanstaaf")
  inspect(
    wire(client.next_write()),
    content="APOP mrose c4c9334bac560ecc979e58001b3e22fb\r\n",
  )
  let plain = @pop3.Client::new()
  let _ = plain.feed(crlf("+OK ready"))
  assert_eq(
    refusal(() => plain.apop("mrose", "tanstaaf")),
    Some(Unsupported("APOP")),
  )
}

///|
test "pop3 logs in and tracks the state" {
  let client = greeted()
  assert_eq(
    refusal(() => client.stat()),
    Some(Order("only in the transaction state")),
  )
  client.user("mrose")
  inspect(wire(client.next_write()), content="USER mrose\r\n")
  let _ = client.feed(crlf("+OK"))
  client.pass("wrong")
  let _ = client.next_write()
  let events = client.feed(crlf("-ERR invalid password"))
  assert_eq(events, [Reply(Pass, Err("invalid password"))])
  assert_eq(client.state(), Authorization)
  client.pass("secret")
  let _ = client.next_write()
  let _ = client.feed(crlf("+OK maildrop locked"))
  assert_eq(client.state(), Transaction)
  assert_eq(
    refusal(() => client.user("again")),
    Some(Order("only in the authorization state")),
  )
}

///|
test "pop3 reads the transaction replies" {
  let client = logged_in()
  client.stat()
  let _ = client.next_write()
  assert_eq(client.feed(crlf("+OK 2 320")), [
    Reply(Stat, Stat(count=2, size=320)),
  ])
  client.list()
  let _ = client.next_write()
  assert_eq(
    client.feed(crlf("+OK 2 messages (320 octets)\r\n1 120\r\n2 200\r\n.")),
    [Reply(List(None), Listing([(1, 120), (2, 200)]))],
  )
  client.list(message=2)
  let _ = client.next_write()
  assert_eq(client.feed(crlf("+OK 2 200")), [
    Reply(List(Some(2)), Listing([(2, 200)])),
  ])
  client.uidl()
  let _ = client.next_write()
  assert_eq(
    client.feed(
      crlf("+OK\r\n1 whqtswO00WBw418f9t5JxYwZ\r\n2 QhdPYR:00WBw1Ph7x7\r\n."),
    ),
    [
      Reply(
        Uidl(None),
        Uids([(1, "whqtswO00WBw418f9t5JxYwZ"), (2, "QhdPYR:00WBw1Ph7x7")]),
      ),
    ],
  )
  client.retr(9)
  let _ = client.next_write()
  assert_eq(client.feed(crlf("-ERR no such message")), [
    Reply(Retr(9), Err("no such message")),
  ])
  client.dele(1)
  client.rset()
  client.noop()
  client.quit()
  inspect(wire(client.next_write()), content="DELE 1\r\n")
  let _ = client.feed(crlf("+OK message 1 deleted"))
  inspect(wire(client.next_write()), content="RSET\r\n")
  let _ = client.feed(crlf("+OK"))
  let _ = client.next_write()
  let _ = client.feed(crlf("+OK"))
  let _ = client.next_write()
  let events = client.feed(crlf("+OK dewey POP3 server signing off"))
  assert_eq(events, [Reply(Quit, Ok("dewey POP3 server signing off"))])
  assert_eq(client.state(), Update)
}

///|
test "pop3 unstuffs a message and keeps its octets" {
  let client = logged_in()
  client.retr(1)
  client.top(1, 0)
  let _ = client.next_write()
  let events = client.feed(
    b"+OK 120 octets\r\nSubject: one\r\n\r\n..dot\r\n\xC3\xA4\n.\r\n",
  )
  assert_eq(events, [
    Reply(Retr(1), Content(b"Subject: one\r\n\r\n.dot\r\n\xC3\xA4\n")),
  ])
  inspect(wire(client.next_write()), content="TOP 1 0\r\n")
  let top = client.feed(crlf("+OK\r\nSubject: one\r\n\r\n."))
  assert_eq(top, [Reply(Top(1, 0), Content(b"Subject: one\r\n\r\n"))])
}

///|
test "pop3 waits for a message that arrives in pieces" {
  let client = logged_in()
  client.retr(1)
  let _ = client.next_write()
  inspect(client.feed(b"+OK\r\nSubject: o"[:]).length(), content="0")
  inspect(client.feed(b"ne\r\n."[:]).length(), content="0")
  assert_eq(client.feed(b"\r\n"[:]), [
    Reply(Retr(1), Content(b"Subject: one\r\n")),
  ])
}

///|
test "pop3 pipelines only when the server says so" {
  let lone = logged_in()
  lone.stat()
  lone.list(message=1)
  inspect(wire(lone.next_write()), content="STAT\r\n")
  let fast = greeted()
  fast.capa()
  let _ = fast.next_write()
  let _ = fast.feed(crlf("+OK\r\nPIPELINING\r\nUIDL\r\n."))
  inspect(fast.has("pipelining"), content="true")
  fast.user("mrose")
  fast.pass("secret")
  inspect(wire(fast.next_write()), content="USER mrose\r\n")
  let _ = fast.feed(crlf("+OK"))
  inspect(wire(fast.next_write()), content="PASS secret\r\n")
  let _ = fast.feed(crlf("+OK"))
  fast.stat()
  fast.list(message=1)
  fast.uidl(message=1)
  inspect(wire(fast.next_write()), content="STAT\r\nLIST 1\r\nUIDL 1\r\n")
}

///|
test "pop3 authenticates with sasl" {
  let client = greeted()
  client.auth(@sasl.Plain::new("tim", "tanstaaftanstaaf"))
  inspect(
    wire(client.next_write()),
    content="AUTH PLAIN AHRpbQB0YW5zdGFhZnRhbnN0YWFm\r\n",
  )
  let _ = client.feed(crlf("+OK maildrop locked"))
  assert_eq(client.state(), Transaction)
  let login = greeted()
  login.auth(@sasl.Login::new("tim", "secret"))
  inspect(wire(login.next_write()), content="AUTH LOGIN\r\n")
  let _ = login.feed(crlf("+ VXNlcm5hbWU6"))
  inspect(wire(login.next_write()), content="dGlt\r\n")
  let _ = login.feed(crlf("+ !!"))
  inspect(wire(login.next_write()), content="*\r\n")
  let events = login.feed(crlf("-ERR cancelled"))
  assert_eq(events, [Reply(Auth("LOGIN"), Err("cancelled"))])
  assert_eq(login.state(), Authorization)
}

///|
test "pop3 refuses a scram success without the server's proof" {
  let client = greeted()
  client.auth(
    @sasl.ScramSha256::new("user", "pencil", nonce="rOprNGfwEbeRWgbNEkqO"),
  )
  let _ = client.next_write()
  let _ = client.feed(
    crlf(
      "+ cj1yT3ByTkdmd0ViZVJXZ2JORWtxTyVodllEcFdVYTJSYVRDQWZ1eEZJbGopaE5sRiRrMCxzPVcyMlphSjBTTlk3c29Fc1VFamI2Z1E9PSxpPTQwOTY=",
    ),
  )
  let _ = client.next_write()
  assert_eq(client.feed(crlf("+OK")), [Sasl(Signature)])
}

///|
test "pop3 starts tls and drops what followed in the clear" {
  let client = greeted()
  client.capa()
  let _ = client.next_write()
  let _ = client.feed(crlf("+OK\r\nUIDL\r\n."))
  assert_eq(refusal(() => client.stls()), Some(Unsupported("STLS")))
  let secure = greeted()
  secure.stls()
  inspect(wire(secure.next_write()), content="STLS\r\n")
  let events = secure.feed(crlf("+OK begin TLS\r\n+OK injected"))
  assert_eq(events, [Reply(Stls, Ok("begin TLS"))])
}

///|
test "pop3 refuses malformed and oversized replies" {
  assert_eq(
    refusal(() => greeted().feed(crlf("+OK nobody asked"))),
    Some(Malformed("a reply nobody asked for: +OK nobody asked")),
  )
  let client = logged_in()
  client.stat()
  let _ = client.next_write()
  assert_eq(
    refusal(() => client.feed(crlf("OK 2 320"))),
    Some(Malformed("a status line opens with +OK or -ERR: OK 2 320")),
  )
  let small = @pop3.Client::new(limits=@pop3.Limits::new(line=8))
  assert_eq(
    refusal(() => small.feed(crlf("+OK 0123456789"))),
    Some(Exceeded(limit=8, got=15)),
  )
  let tight = @pop3.Client::new(limits=@pop3.Limits::new(message=4))
  let _ = tight.feed(crlf("+OK"))
  tight.capa()
  let _ = tight.next_write()
  assert_eq(
    refusal(() => tight.feed(crlf("+OK\r\nUIDL\r\nTOP\r\n."))),
    Some(Exceeded(limit=4, got=6)),
  )
}
