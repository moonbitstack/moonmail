// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// Run the client against the server until neither has anything to send.
fn converse(
  client : @smtp.Client,
  server : @smtp.Server,
  decide : (@smtp.Request) -> Unit raise @smtp.Refused,
) -> Array[@smtp.Event] raise @smtp.Refused {
  let events = []
  let mut moved = true
  while moved {
    moved = false
    if server.next_write() is Some(data) {
      events.append(client.feed(data))
      moved = true
    }
    if client.next_write() is Some(data) {
      server.feed(data)
      moved = true
    }
    while server.next() is Some(request) {
      decide(request)
      moved = true
    }
  }
  events
}

///|
test "smtp client and server carry a message end to end" {
  let server = @smtp.Server::new("mx.example", auth=["PLAIN"])
  let client = @smtp.Client::new()
  let mut stored = b""
  let decide = (request : @smtp.Request) => {
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
        stored = message
        server.accept()
      }
      Rset | Quit => ()
      _ => server.accept()
    }
  }
  client.ehlo("c.example")
  let _ = converse(client, server, decide)
  client.auth(@sasl.Plain::new("tim", "secret"))
  client.send(
    "a@example.com",
    ["b@example.com", "nobody@example.com"],
    b".dot\nline",
  )
  client.quit()
  let events = converse(client, server, decide)
  let codes = events.map(event => {
    match event {
      Reply(_, reply) => reply.code
      Sasl(_) => 0
    }
  })
  assert_eq(codes, [235, 250, 250, 550, 250, 221])
  inspect(@utf8.decode_lossy(stored[:]), content=".dot\r\nline\r\n")
  inspect(server.closed(), content="true")
}

///|
test "lmtp client and server agree on the deliveries" {
  let server = @smtp.Server::new("lmtp.example", lmtp=true)
  let client = @smtp.Client::new(lmtp=true)
  let decide = (request : @smtp.Request) => {
    match request {
      Data(_) => {
        server.accept()
        server.reply(452, "4.2.2 Mailbox full")
      }
      Rset | Quit => ()
      _ => server.accept()
    }
  }
  client.ehlo("c.example")
  let _ = converse(client, server, decide)
  client.send("a@example.com", ["b@example.com", "c@example.com"], b"hi")
  let events = converse(client, server, decide)
  assert_eq(events[3:].to_owned(), [
    Reply(Delivery("b@example.com"), @smtp.Reply::new(250, "2.0.0 Ok: queued")),
    Reply(
      Delivery("c@example.com"),
      @smtp.Reply::new(452, "4.2.2 Mailbox full"),
    ),
  ])
}

///|
test "smtp client and server chunk a binary message" {
  let server = @smtp.Server::new("mx.example")
  let client = @smtp.Client::new()
  let mut stored = b""
  let decide = (request : @smtp.Request) => {
    match request {
      Data(message) => {
        stored = message
        server.accept()
      }
      Rset | Quit => ()
      _ => server.accept()
    }
  }
  client.ehlo("c.example")
  let _ = converse(client, server, decide)
  client.mail("a@example.com", body=Binary, size=5)
  client.rcpt("b@example.com")
  client.bdat(b"\x00\x01\r\n"[:])
  client.bdat(b"."[:], last=true)
  let events = converse(client, server, decide)
  inspect(events.length(), content="4")
  assert_eq(stored, b"\x00\x01\r\n.")
}
