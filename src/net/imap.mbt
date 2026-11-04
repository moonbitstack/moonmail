// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// An IMAP session over a socket: `@imap.Client` with the octets carried.
/// Queue a command on `client` and `wait` for its tag:
///
/// ```moonbit nocheck
/// let reply = imap.wait(imap.client().select("INBOX"))
/// ```
pub struct Imap {
  priv mut conn : @tcp.Conn
  priv client : @imap.Client
}

///|
/// What came back for one command: the untagged responses that arrived while
/// it ran, and its completion.
#derive(Eq, Debug)
pub(all) struct Reply {
  data : Array[@imap.Response]
  status : @imap.Status
  code : @imap.Code?
  text : String
}

///|
pub extend Reply with Eq::{equal, not_equal}

///|
pub extend Reply with Debug::{to_repr}

///|
/// Connect, read the greeting and the capabilities and, under `StartTls`,
/// start TLS and read the capabilities again. `port` defaults to 993 under
/// `Tls` and 143 otherwise; `now` is as for `Smtp::connect`.
pub async fn Imap::connect(
  host : String,
  security : Security,
  port? : Int32,
  limits~ : @imap.Limits = @imap.limits,
  now? : Int64,
) -> Imap {
  let port = port.unwrap_or(if security is Tls(_) { 993 } else { 143 })
  let session : Imap = {
    conn: dial(host, port, security, now),
    client: @imap.Client::new(limits~),
  }
  for event in session.run() {
    if event is Data(Condition("BYE", _, text)) {
      raise Done(No, None, text)
    }
  }
  if session.client.capabilities().is_empty() {
    let _ = session.check(session.client.capability())
  }
  if security is StartTls(config) {
    let _ = session.check(session.client.starttls())
    session.conn = session.conn.upgrade(config, host, now?)
    let _ = session.check(session.client.capability())
  }
  session
}

///|
/// The state machine underneath; queue commands there and `wait` for them.
pub fn Imap::client(self : Imap) -> @imap.Client {
  self.client
}

///|
/// Write what is queued and read until every response it waits for is in.
pub async fn Imap::run(self : Imap) -> Array[@imap.Event] {
  let events = []
  while true {
    if self.client.next_write() is Some(data) {
      self.conn.write(data)
    }
    if self.client.pending() == 0 {
      break
    }
    events.append(self.read())
  }
  events
}

///|
/// Write what is queued and read once: the events that arrived. During
/// `idle` this is how the updates are taken as they come.
pub async fn Imap::read(self : Imap) -> Array[@imap.Event] {
  if self.client.next_write() is Some(data) {
    self.conn.write(data)
  }
  guard self.conn.read_some(max_len=chunk) is Some(data) else { raise Closed }
  self.client.feed(data)
}

///|
/// Run until the command tagged `tag` completes, and return what came back
/// for it.
pub async fn Imap::wait(self : Imap, tag : Int32) -> Reply {
  let data = []
  while true {
    if self.client.next_write() is Some(out) {
      self.conn.write(out)
    }
    for event in self.read() {
      match event {
        Data(response) => data.push(response)
        Done(n, status, code, text) if n == tag =>
          return { data, status, code, text, }
        Done(_, _, _, _) => ()
        Sasl(why) => raise Sasl(why)
      }
    }
  }
  abort("unreachable")
}

///|
/// `wait`, raising unless the completion is `OK`.
async fn Imap::check(self : Imap, tag : Int32) -> Reply {
  let reply = self.wait(tag)
  guard reply.status is Ok else {
    raise Done(reply.status, reply.code, reply.text)
  }
  reply
}

///|
/// Log in with a user name and password; a refusal raises.
pub async fn Imap::login(self : Imap, user : String, password : String) -> Unit {
  let _ = self.check(self.client.login(user, password))
}

///|
/// Authenticate with SASL; a refusal from either side raises.
pub async fn Imap::authenticate(
  self : Imap,
  mechanism : &@sasl.Mechanism,
) -> Unit {
  let _ = self.check(self.client.authenticate(mechanism))
}

///|
/// Log out and close the connection.
pub async fn Imap::logout(self : Imap) -> Unit {
  let tag = self.client.logout()
  // A server may close as soon as it has said BYE.
  let _ = self.wait(tag) catch {
    Closed => { data: [], status: Ok, code: None, text: "", }
    e => raise e
  }
  self.conn.close()
}
