// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// Where the session stands (RFC 9051 section 3).
pub(all) enum State {
  NotAuthenticated
  Authenticated
  Selected(String)
  Logout
} derive(Eq, Debug)

///|
pub extend State with Eq::{equal, not_equal}

///|
pub extend State with Debug::{to_repr}

///|
/// What `Client::feed` reports: an untagged response, the completion of the
/// command with that tag number, or a SASL mechanism refusing the server.
///
/// `Sasl` during the exchange means the client has sent `*` to cancel, and the
/// tagged `BAD` that answers it follows. `Sasl` in place of the tagged `OK`
/// means the server claimed success without the proof the mechanism needs:
/// the session is not to be trusted.
pub(all) enum Event {
  Data(Response)
  Done(Int32, Status, Code?, String)
  Sasl(@sasl.Refused)
} derive(Eq, Debug)

///|
pub extend Event with Eq::{equal, not_equal}

///|
pub extend Event with Debug::{to_repr}

///|
/// What a command's completion does to the session.
priv enum Effect {
  Plain
  Login
  Select(String)
  Deselect
  StartTls
  Idle
  Logout
}

///|
/// A command queued or written, waiting for its completion.
priv struct Pending {
  tag : Int32
  head : Bytes
  mut tail : Bytes?
  effect : Effect
  pipeline : Bool
  mechanism : &@sasl.Mechanism?
  mut initial : Bytes?
}

///|
/// An IMAP4rev2 client (RFC 9051) with no I/O, which also speaks to IMAP4rev1
/// servers (RFC 3501): commands go into a queue and each returns its tag
/// number, `next_write` gives the octets to send, and `feed` takes what the
/// server sent and reports each response.
///
/// UID commands and the read-only `CAPABILITY`, `LIST`, `STATUS` and
/// `NAMESPACE` go out together; any other command waits until those before it
/// are complete, so sequence numbers never shift under a pipelined command
/// (RFC 9051 section 5.5). A literal goes without waiting for the server when
/// it announced `LITERAL+`, or `LITERAL-` or IMAP4rev2 and the literal is at
/// most 4096 octets (RFC 7888).
///
/// Mailbox names are UTF-8. Toward a server that announced neither `IMAP4rev2`
/// nor an enabled `UTF8=ACCEPT`, they are written, and read back from `LIST`
/// and `STATUS`, in modified UTF-7 (RFC 3501 section 5.1.3).
pub struct Client {
  priv limits : Limits
  priv mut buffer : Bytes
  priv mut at : Int32
  priv queue : Array[Pending]
  priv waiting : Array[Pending]
  priv urgent : Buffer
  priv mut next_tag : Int32
  priv mut greeted : Bool
  priv mut state : State
  priv mut planned : State
  priv mut capabilities : Array[String]
  priv mut utf8 : Bool
  priv mut idling : Int32?
}

///|
pub fn Client::new(limits~ : Limits = limits) -> Client {
  {
    limits,
    buffer: b"",
    at: 0,
    queue: [],
    waiting: [],
    urgent: Buffer(),
    next_tag: 1,
    greeted: false,
    state: NotAuthenticated,
    planned: NotAuthenticated,
    capabilities: [],
    utf8: false,
    idling: None,
  }
}

///|
/// The capabilities the server announced last, in upper case.
pub fn Client::capabilities(self : Client) -> Array[String] {
  self.capabilities.copy()
}

///|
/// Whether the server announced `name`.
pub fn Client::has(self : Client, name : String) -> Bool {
  self.capabilities.contains(name.to_upper())
}

///|
/// The session state as of the responses fed so far.
pub fn Client::state(self : Client) -> State {
  self.state
}

///|
fn Client::rev2(self : Client) -> Bool {
  self.has("IMAP4rev2")
}

///|
fn Client::enqueue(
  self : Client,
  command : String,
  effect~ : Effect = Plain,
  pipeline~ : Bool = false,
  literal? : BytesView,
  after~ : String = "",
  mechanism? : &@sasl.Mechanism,
  initial? : Bytes,
) -> Int32 {
  let tag = self.next_tag
  self.next_tag += 1
  let head = Buffer()
  head.write_bytes(@utf8.encode(tag_of(tag) + " " + command))
  let mut tail = None
  match literal {
    None => head.write_bytes(b"\r\n")
    Some(data) => {
      let rest = Buffer()
      rest.write_bytes(data)
      rest.write_bytes(@utf8.encode(after + "\r\n"))
      let quick = self.has("LITERAL+") ||
        ((self.has("LITERAL-") || self.rev2()) && data.length() <= 4096)
      if quick {
        head.write_bytes(
          @utf8.encode(" {" + data.length().to_string() + "+}\r\n"),
        )
        head.write_bytes(rest.to_bytes())
      } else {
        head.write_bytes(
          @utf8.encode(" {" + data.length().to_string() + "}\r\n"),
        )
        tail = Some(rest.to_bytes())
      }
    }
  }
  self.queue.push({
    tag,
    head: head.to_bytes(),
    tail,
    effect,
    pipeline,
    mechanism,
    initial,
  })
  tag
}

///|
fn Client::expect(self : Client, allowed : Array[String]) -> Unit raise Refused {
  let now = match self.planned {
    NotAuthenticated => "not authenticated"
    Authenticated => "authenticated"
    Selected(_) => "selected"
    Logout => "logout"
  }
  if !allowed.contains(now) {
    raise Order("not allowed in the " + now + " state")
  }
}

///|
fn Client::needs(self : Client, name : String) -> Unit raise Refused {
  if !self.rev2() && !self.has(name) {
    raise Unsupported(name)
  }
}

///|
fn Client::name(self : Client, mailbox : String) -> String raise Refused {
  if self.utf8 || self.rev2() {
    quoted(mailbox)
  } else {
    quoted(encode_utf7(mailbox))
  }
}

///|
pub fn Client::capability(self : Client) -> Int32 {
  self.enqueue("CAPABILITY", pipeline=true)
}

///|
pub fn Client::noop(self : Client) -> Int32 {
  self.enqueue("NOOP")
}

///|
pub fn Client::logout(self : Client) -> Int32 {
  self.planned = Logout
  self.enqueue("LOGOUT", effect=Logout)
}

///|
/// Ask to start TLS. After the `OK` the caller upgrades the transport; the
/// client has then forgotten the capabilities and wants a fresh `capability`.
pub fn Client::starttls(self : Client) -> Int32 raise Refused {
  self.expect(["not authenticated"])
  if !self.has("STARTTLS") {
    raise Unsupported("STARTTLS")
  }
  self.enqueue("STARTTLS", effect=StartTls)
}

///|
pub fn Client::login(
  self : Client,
  user : String,
  password : String,
) -> Int32 raise Refused {
  self.expect(["not authenticated"])
  if self.has("LOGINDISABLED") {
    raise Unsupported("LOGIN")
  }
  self.planned = Authenticated
  self.enqueue("LOGIN " + quoted(user) + " " + quoted(password), effect=Login)
}

///|
/// SASL authentication. The first response rides on the command line when the
/// server takes it there (`SASL-IR`, RFC 4959, part of IMAP4rev2), else it
/// answers the first `+`; every other `+` gets the mechanism's next step.
pub fn Client::authenticate(
  self : Client,
  mechanism : &@sasl.Mechanism,
) -> Int32 raise Refused {
  self.expect(["not authenticated"])
  let name = mechanism.name()
  if !self.has("AUTH=" + name) {
    raise Unsupported("AUTH=" + name)
  }
  self.planned = Authenticated
  let command = "AUTHENTICATE " + name
  match mechanism.start() {
    Some(data) if self.rev2() || self.has("SASL-IR") => {
      let encoded = if data.is_empty() { "=" } else { @base64.encode(data[:]) }
      self.enqueue(command + " " + encoded, effect=Login, mechanism~)
    }
    first => self.enqueue(command, effect=Login, mechanism~, initial?=first)
  }
}

///|
/// Turn on extensions (RFC 5161), such as `UTF8=ACCEPT` or `CONDSTORE`.
pub fn Client::enable(
  self : Client,
  extensions : Array[String],
) -> Int32 raise Refused {
  self.expect(["authenticated"])
  self.needs("ENABLE")
  self.enqueue("ENABLE " + extensions.join(" "))
}

///|
/// Open a mailbox read-write. `condstore` asks for mod-sequences on it
/// (RFC 7162).
pub fn Client::select(
  self : Client,
  mailbox : String,
  condstore~ : Bool = false,
) -> Int32 raise Refused {
  self.open("SELECT", mailbox, condstore)
}

///|
/// Open a mailbox read-only.
pub fn Client::examine(
  self : Client,
  mailbox : String,
  condstore~ : Bool = false,
) -> Int32 raise Refused {
  self.open("EXAMINE", mailbox, condstore)
}

///|
fn Client::open(
  self : Client,
  verb : String,
  mailbox : String,
  condstore : Bool,
) -> Int32 raise Refused {
  self.expect(["authenticated", "selected"])
  let mut command = verb + " " + self.name(mailbox)
  if condstore {
    if !self.has("CONDSTORE") {
      raise Unsupported("CONDSTORE")
    }
    command = command + " (CONDSTORE)"
  }
  self.planned = Selected(mailbox)
  self.enqueue(command, effect=Select(mailbox))
}

///|
pub fn Client::create(self : Client, mailbox : String) -> Int32 raise Refused {
  self.expect(["authenticated", "selected"])
  self.enqueue("CREATE " + self.name(mailbox))
}

///|
pub fn Client::delete(self : Client, mailbox : String) -> Int32 raise Refused {
  self.expect(["authenticated", "selected"])
  self.enqueue("DELETE " + self.name(mailbox))
}

///|
pub fn Client::rename(
  self : Client,
  from : String,
  to : String,
) -> Int32 raise Refused {
  self.expect(["authenticated", "selected"])
  self.enqueue("RENAME " + self.name(from) + " " + self.name(to))
}

///|
pub fn Client::subscribe(
  self : Client,
  mailbox : String,
) -> Int32 raise Refused {
  self.expect(["authenticated", "selected"])
  self.enqueue("SUBSCRIBE " + self.name(mailbox))
}

///|
pub fn Client::unsubscribe(
  self : Client,
  mailbox : String,
) -> Int32 raise Refused {
  self.expect(["authenticated", "selected"])
  self.enqueue("UNSUBSCRIBE " + self.name(mailbox))
}

///|
/// List the mailboxes under `reference` that match `pattern`, where `*`
/// matches anything and `%` anything but the hierarchy delimiter.
pub fn Client::list(
  self : Client,
  reference : String,
  pattern : String,
) -> Int32 raise Refused {
  self.expect(["authenticated", "selected"])
  self.enqueue(
    "LIST " + self.name(reference) + " " + self.name(pattern),
    pipeline=true,
  )
}

///|
pub fn Client::namespaces(self : Client) -> Int32 raise Refused {
  self.expect(["authenticated", "selected"])
  self.needs("NAMESPACE")
  self.enqueue("NAMESPACE", pipeline=true)
}

///|
/// Ask about a mailbox without opening it, as `items` such as `MESSAGES`,
/// `UIDNEXT`, `UNSEEN` or `HIGHESTMODSEQ` name.
pub fn Client::status(
  self : Client,
  mailbox : String,
  items : Array[String],
) -> Int32 raise Refused {
  self.expect(["authenticated", "selected"])
  self.enqueue(
    "STATUS " + self.name(mailbox) + " (" + items.join(" ") + ")",
    pipeline=true,
  )
}

///|
/// Add a message to a mailbox. `flags` such as `\Seen` are set on it; `date`
/// is its internal date as IMAP writes one, `"17-Jul-1996 02:44:25 -0700"`.
pub fn Client::append(
  self : Client,
  mailbox : String,
  message : BytesView,
  flags? : Array[String],
  date? : String,
) -> Int32 raise Refused {
  self.expect(["authenticated", "selected"])
  let command = StringBuilder()
  command.write_string("APPEND " + self.name(mailbox))
  if flags is Some(list) {
    command.write_string(" (" + list.join(" ") + ")")
  }
  if date is Some(when) {
    command.write_string(" " + quoted(when))
  }
  self.enqueue(command.to_string(), literal=message)
}

///|
/// Wait for the server to report changes as they happen (RFC 2177); they come
/// as `Data` until `done`.
pub fn Client::idle(self : Client) -> Int32 raise Refused {
  self.expect(["authenticated", "selected"])
  self.needs("IDLE")
  if self.idling is Some(_) {
    raise Order("already idling")
  }
  let tag = self.enqueue("IDLE", effect=Idle)
  self.idling = Some(tag)
  tag
}

///|
/// End `idle`; its completion then follows.
pub fn Client::done(self : Client) -> Unit raise Refused {
  guard self.idling is Some(_) else { raise Order("not idling") }
  self.idling = None
  self.urgent.write_bytes(b"DONE\r\n")
}

///|
/// Close the mailbox, expunging what is marked `\Deleted`.
pub fn Client::close(self : Client) -> Int32 raise Refused {
  self.expect(["selected"])
  self.planned = Authenticated
  self.enqueue("CLOSE", effect=Deselect)
}

///|
/// Close the mailbox without expunging (RFC 3691, part of IMAP4rev2).
pub fn Client::unselect(self : Client) -> Int32 raise Refused {
  self.expect(["selected"])
  self.needs("UNSELECT")
  self.planned = Authenticated
  self.enqueue("UNSELECT", effect=Deselect)
}

///|
pub fn Client::expunge(self : Client) -> Int32 raise Refused {
  self.expect(["selected"])
  self.enqueue("EXPUNGE")
}

///|
/// Expunge only the messages in the UID set (RFC 4315, part of IMAP4rev2).
pub fn Client::uid_expunge(self : Client, set : String) -> Int32 raise Refused {
  self.expect(["selected"])
  self.needs("UIDPLUS")
  self.enqueue("UID EXPUNGE " + set, pipeline=true)
}

///|
/// Search with `criteria` as IMAP writes them, `UNSEEN SINCE 1-Jan-2026`.
pub fn Client::search(
  self : Client,
  criteria : String,
  uid~ : Bool = false,
) -> Int32 raise Refused {
  self.expect(["selected"])
  self.enqueue(prefix(uid) + "SEARCH " + criteria, pipeline=uid)
}

///|
/// Fetch `items`, as IMAP writes them, `(FLAGS BODY.PEEK[])`, for the
/// messages in `set`. `changedsince` keeps only those whose mod-sequence is
/// higher (RFC 7162).
pub fn Client::fetch(
  self : Client,
  set : String,
  items : String,
  uid~ : Bool = false,
  changedsince? : Int64,
) -> Int32 raise Refused {
  self.expect(["selected"])
  let modifier = match changedsince {
    Some(n) => {
      if !self.has("CONDSTORE") {
        raise Unsupported("CONDSTORE")
      }
      " (CHANGEDSINCE " + n.to_string() + ")"
    }
    None => ""
  }
  self.enqueue(
    prefix(uid) + "FETCH " + set + " " + items + modifier,
    pipeline=uid,
  )
}

///|
/// Change flags: `action` is as IMAP writes it, `+FLAGS (\Seen)`.
/// `unchangedsince` makes the change conditional on the mod-sequence
/// (RFC 7162); the messages that failed it come back in a `Modified` code.
pub fn Client::store(
  self : Client,
  set : String,
  action : String,
  uid~ : Bool = false,
  unchangedsince? : Int64,
) -> Int32 raise Refused {
  self.expect(["selected"])
  let modifier = match unchangedsince {
    Some(n) => {
      if !self.has("CONDSTORE") {
        raise Unsupported("CONDSTORE")
      }
      " (UNCHANGEDSINCE " + n.to_string() + ")"
    }
    None => ""
  }
  self.enqueue(
    prefix(uid) + "STORE " + set + modifier + " " + action,
    pipeline=uid,
  )
}

///|
pub fn Client::copy(
  self : Client,
  set : String,
  mailbox : String,
  uid~ : Bool = false,
) -> Int32 raise Refused {
  self.expect(["selected"])
  self.enqueue(
    prefix(uid) + "COPY " + set + " " + self.name(mailbox),
    pipeline=uid,
  )
}

///|
/// Move messages (RFC 6851, part of IMAP4rev2).
pub fn Client::move_to(
  self : Client,
  set : String,
  mailbox : String,
  uid~ : Bool = false,
) -> Int32 raise Refused {
  self.expect(["selected"])
  self.needs("MOVE")
  self.enqueue(
    prefix(uid) + "MOVE " + set + " " + self.name(mailbox),
    pipeline=uid,
  )
}

///|
/// The octets to send now, if any. Nothing goes out before the greeting.
pub fn Client::next_write(self : Client) -> Bytes? {
  let out = Buffer()
  out.write_bytes(self.urgent.to_bytes())
  self.urgent.reset()
  if self.greeted {
    while self.queue is [next, ..] {
      let blocked = self.waiting.length() > 0 &&
        (!next.pipeline || self.waiting.iter().any(p => !p.pipeline))
      if blocked {
        break
      }
      let _ = self.queue.remove(0)
      out.write_bytes(next.head)
      self.waiting.push(next)
    }
  }
  if out.is_empty() {
    None
  } else {
    Some(out.to_bytes())
  }
}

///|
/// Take octets from the server and report the responses they complete.
pub fn Client::feed(
  self : Client,
  data : BytesView,
) -> Array[Event] raise Refused {
  let joined = Buffer()
  joined.write_bytes(self.buffer[self.at:])
  joined.write_bytes(data)
  self.buffer = joined.to_bytes()
  self.at = 0
  let events = []
  while complete(self.buffer, self.at, self.limits) is Some(end) {
    let raw = parse(self.buffer[self.at:end])
    self.at = end
    self.dispatch(raw, events)
  }
  events
}

///|
fn Client::dispatch(
  self : Client,
  raw : Raw,
  events : Array[Event],
) -> Unit raise Refused {
  match raw {
    Untagged(response) => {
      if !self.greeted {
        self.greeted = true
        if response is Condition("PREAUTH", _, _) {
          self.state = Authenticated
          self.planned = Authenticated
        }
      }
      self.learn(response)
      events.push(Data(self.decoded(response)))
    }
    Continue(text) => {
      guard self.waiting
        .iter()
        .find_first(p => {
          p.tail is Some(_) || p.mechanism is Some(_) || p.effect is Idle
        })
        is Some(front) else {
        raise Malformed("a continuation nobody asked for")
      }
      match front.tail {
        Some(rest) => {
          front.tail = None
          self.urgent.write_bytes(rest)
          return
        }
        None => ()
      }
      match (front.mechanism, front.initial) {
        (Some(_), Some(data)) => {
          front.initial = None
          self.urgent.write_bytes(
            @utf8.encode(@base64.encode(data[:]) + "\r\n"),
          )
        }
        (Some(mechanism), None) => {
          let answer = @sasl.respond(mechanism, text) catch {
            refused => {
              events.push(Sasl(refused))
              "*"
            }
          }
          self.urgent.write_bytes(@utf8.encode(answer + "\r\n"))
        }
        (None, _) => ()
      }
    }
    Tagged(tag, status, code, text) => {
      guard tag_number(tag) is Some(n) &&
        self.waiting.search_by(p => p.tag == n) is Some(i) else {
        raise Malformed("a completion for a tag nobody sent: " + tag)
      }
      let front = self.waiting.remove(i)
      if code is Some(Capability(list)) {
        self.capabilities = list.map(c => c.to_upper())
      }
      match front.effect {
        Login =>
          if status is Ok {
            self.state = Authenticated
            if front.mechanism is Some(mechanism) {
              mechanism.finish() catch {
                refused => {
                  events.push(Sasl(refused))
                  return
                }
              }
            }
          } else {
            self.planned = NotAuthenticated
          }
        Select(mailbox) =>
          if status is Ok {
            self.state = Selected(mailbox)
          } else {
            self.state = Authenticated
            self.planned = Authenticated
          }
        Deselect => if status is Ok { self.state = Authenticated }
        StartTls => if status is Ok { self.capabilities = [] }
        Idle => self.idling = None
        Logout => self.state = Logout
        Plain => ()
      }
      events.push(Done(n, status, code, text))
    }
  }
}

///|
/// Keep what an untagged response says about the server.
fn Client::learn(self : Client, response : Response) -> Unit {
  match response {
    Capability(list) => self.capabilities = list.map(c => c.to_upper())
    Condition(_, Some(Capability(list)), _) =>
      self.capabilities = list.map(c => c.to_upper())
    Condition("BYE", _, _) => {
      self.state = Logout
      self.planned = Logout
    }
    Enabled(list) =>
      if list.any(e => e.to_upper() == "UTF8=ACCEPT") {
        self.utf8 = true
      }
    _ => ()
  }
}

///|
/// Mailbox names in modified UTF-7 read back as UTF-8.
fn Client::decoded(self : Client, response : Response) -> Response {
  if self.utf8 || self.rev2() {
    return response
  }
  match response {
    List(flags~, delimiter~, name~) =>
      List(flags~, delimiter~, name=decode_utf7(name))
    Status(name, items) => Status(decode_utf7(name), items)
    other => other
  }
}

///|
fn prefix(uid : Bool) -> String {
  if uid {
    "UID "
  } else {
    ""
  }
}

///|
fn tag_of(n : Int32) -> String {
  let digits = n.to_string()
  "A" +
  "0".repeat(if digits.length() < 4 { 4 - digits.length() } else { 0 }) +
  digits
}

///|
fn tag_number(tag : String) -> Int32? {
  guard tag.has_prefix("A") && number(tag[1:]) is Some(n) && n <= 0x7FFFFFFFL else {
    None
  }
  Some(n.to_int())
}

///|
/// A quoted string; CR and LF cannot be in one.
fn quoted(text : String) -> String raise Refused {
  if text.iter().any(c => c == '\r' || c == '\n' || c == '\u{0}') {
    raise Malformed("a line break or NUL cannot be quoted: " + text)
  }
  "\"" +
  text.replace_all(old="\\", new="\\\\").replace_all(old="\"", new="\\\"") +
  "\""
}
