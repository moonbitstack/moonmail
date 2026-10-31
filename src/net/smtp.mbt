// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// An SMTP or LMTP session over a socket: `@smtp.Client` with the octets
/// carried. The common steps are methods; anything else is queued on `client`
/// and carried by `run`.
pub struct Smtp {
  priv mut conn : @tcp.Conn
  priv client : @smtp.Client
}

///|
/// Connect, greet with `hello` and, under `StartTls`, start TLS and greet
/// again. `port` defaults to 465, 587 or 25 by `security`. `now`, in seconds
/// since the epoch, is when the server's certificate is judged; the system
/// clock when not given.
pub async fn Smtp::connect(
  host : String,
  security : Security,
  port? : Int32,
  hello~ : String = "localhost",
  lmtp~ : Bool = false,
  limits~ : @smtp.Limits = @smtp.limits,
  now? : Int64,
) -> Smtp {
  let port = port.unwrap_or(
    match security {
      Tls(_) => 465
      StartTls(_) => 587
      Clear => 25
    },
  )
  let session : Smtp = {
    conn: dial(host, port, security, now),
    client: @smtp.Client::new(lmtp~, limits~),
  }
  session.client.ehlo(hello)
  settle(session.run())
  if security is StartTls(config) {
    session.client.starttls()
    settle(session.run())
    session.conn = session.conn.upgrade(config, host, now?)
    session.client.ehlo(hello)
    settle(session.run())
  }
  session
}

///|
/// The state machine underneath, for commands this type does not wrap; queue
/// them there and call `run`.
pub fn Smtp::client(self : Smtp) -> @smtp.Client {
  self.client
}

///|
/// Write what is queued and read until every reply it waits for is in.
pub async fn Smtp::run(self : Smtp) -> Array[@smtp.Event] {
  let events = []
  while true {
    if self.client.next_write() is Some(data) {
      self.conn.write(data)
    }
    if self.client.pending() == 0 {
      break
    }
    guard self.conn.read_some(max_len=chunk) is Some(data) else { raise Closed }
    events.append(self.client.feed(data))
  }
  events
}

///|
/// Authenticate with SASL; a refusal from either side raises.
pub async fn Smtp::auth(self : Smtp, mechanism : &@sasl.Mechanism) -> Unit {
  self.client.auth(mechanism)
  settle(self.run())
}

///|
/// Send one message and return the recipients the server refused, with the
/// reply that refused each. A refused sender or message raises, and so does a
/// transaction with every recipient refused, as Python's `sendmail` does.
pub async fn Smtp::send(
  self : Smtp,
  from : String,
  to : Array[String],
  message : BytesView,
) -> Array[(String, @smtp.Reply)] {
  self.client.send(from, to, message)
  let refused = []
  for event in self.run() {
    match event {
      Reply(Rcpt(who) | Delivery(who), reply) if !reply.is_ok() =>
        refused.push((who, reply))
      Reply(command, reply) if !reply.is_ok() => raise Reply(command, reply)
      Sasl(why) => raise Sasl(why)
      _ => ()
    }
  }
  refused
}

///|
/// Say goodbye and close the connection.
pub async fn Smtp::quit(self : Smtp) -> Unit {
  self.client.quit()
  // A server may close as soon as it has said 221.
  let _ = self.run() catch {
    Closed => []
    e => raise e
  }
  self.conn.close()
}

///|
/// Raise on the first refusal among `events`.
fn settle(events : Array[@smtp.Event]) -> Unit raise Rejected {
  for event in events {
    match event {
      Reply(command, reply) if !reply.is_ok() => raise Reply(command, reply)
      Sasl(why) => raise Sasl(why)
      _ => ()
    }
  }
}
