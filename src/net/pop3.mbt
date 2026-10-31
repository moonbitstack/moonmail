// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// A POP3 session over a socket: `@pop3.Client` with the octets carried. The
/// common steps are methods; anything else is queued on `client` and carried
/// by `run`.
pub struct Pop3 {
  priv mut conn : @tcp.Conn
  priv client : @pop3.Client
}

///|
/// Connect, read the greeting and the capabilities and, under `StartTls`,
/// start TLS (`STLS`) and read the capabilities again. `port` defaults to 995
/// under `Tls` and 110 otherwise; `now` is as for `Smtp::connect`.
pub async fn Pop3::connect(
  host : String,
  security : Security,
  port? : Int32,
  limits~ : @pop3.Limits = @pop3.limits,
  now? : Int64,
) -> Pop3 {
  let port = port.unwrap_or(if security is Tls(_) { 995 } else { 110 })
  let session : Pop3 = {
    conn: dial(host, port, security, now),
    client: @pop3.Client::new(limits~),
  }
  session.client.capa()
  // A server without CAPA answers -ERR, and is then taken to have no
  // extensions.
  for event in session.run() {
    if event is Reply(Greeting, Err(text)) {
      raise Err(Greeting, text)
    }
  }
  if security is StartTls(config) {
    session.client.stls()
    refuse(session.run())
    session.conn = session.conn.upgrade(config, host, now?)
    session.client.capa()
    let _ = session.run()
  }
  session
}

///|
/// The state machine underneath, for commands this type does not wrap.
pub fn Pop3::client(self : Pop3) -> @pop3.Client {
  self.client
}

///|
/// Write what is queued and read until every reply it waits for is in.
pub async fn Pop3::run(self : Pop3) -> Array[@pop3.Event] {
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
/// Log in with `USER` and `PASS`; a refusal raises.
pub async fn Pop3::login(self : Pop3, user : String, password : String) -> Unit {
  self.client.user(user)
  self.client.pass(password)
  refuse(self.run())
}

///|
/// Authenticate with SASL; a refusal from either side raises.
pub async fn Pop3::auth(self : Pop3, mechanism : &@sasl.Mechanism) -> Unit {
  self.client.auth(mechanism)
  refuse(self.run())
}

///|
/// The number and the size of every message.
pub async fn Pop3::list(self : Pop3) -> Array[(Int32, Int64)] {
  self.client.list()
  for event in self.run() {
    match event {
      Reply(_, Listing(items)) => return items
      Reply(command, Err(text)) => raise Err(command, text)
      _ => ()
    }
  }
  []
}

///|
/// One message, as the server holds it.
pub async fn Pop3::retr(self : Pop3, message : Int32) -> Bytes {
  self.client.retr(message)
  for event in self.run() {
    match event {
      Reply(_, Content(data)) => return data
      Reply(command, Err(text)) => raise Err(command, text)
      _ => ()
    }
  }
  raise Closed
}

///|
/// End the session, removing what `DELE` marked, and close the connection.
pub async fn Pop3::quit(self : Pop3) -> Unit {
  self.client.quit()
  // A server may close as soon as it has answered.
  let _ = self.run() catch {
    Closed => []
    e => raise e
  }
  self.conn.close()
}

///|
/// Raise on the first refusal among `events`.
fn refuse(events : Array[@pop3.Event]) -> Unit raise Rejected {
  for event in events {
    match event {
      Reply(command, Err(text)) => raise Err(command, text)
      Sasl(why) => raise Sasl(why)
      _ => ()
    }
  }
}
