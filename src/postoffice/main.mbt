// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// A local post office for the writing desk: it serves `docs/` and answers the
/// call a page cannot make itself, because a page has no socket.
///
///     moon run src/postoffice
///     open http://127.0.0.1:12000/desk.html
///
/// The MIME is written by the page with moonmail's builder. This side only
/// opens the connection and says the right things on it, through
/// `@moonmail/net` — the same state machines the library publishes.
async fn main {
  let addr = @socket.Addr::parse("127.0.0.1:12000")
  let server = @http.Server::Server(addr)
  println("post office on http://127.0.0.1:12000/desk.html")
  server.run_forever(async fn(request, body, conn) {
    route(request, body, conn)
  })
}

///|
/// Serve one request: JSON for the API paths, a file for everything else, so
/// the page and the scripts it imports come from the same root as the API it
/// calls.
async fn route(
  request : @http.Request,
  body : &@io.Reader,
  conn : @http.ServerConnection,
) -> Unit {
  let path = request.path
  match request.meth {
    @http.RequestMethod::Get =>
      if path == "/health" {
        respond_json(conn, 200, "{\"ok\":true}")
      } else if path == "/debug/roots" {
        respond_json(conn, 200, "{\"roots\":" + roots_count().to_string() + "}")
      } else if path == "/" {
        respond_file(conn, "/desk.html")
      } else {
        respond_file(conn, path)
      }
    @http.RequestMethod::Post =>
      if path == "/send" {
        handle_send(conn, body)
      } else if path == "/receive" {
        handle_receive(conn, body)
      } else {
        respond_json(conn, 404, "{\"ok\":false,\"error\":\"no such endpoint\"}")
      }
    @http.RequestMethod::Options =>
      // A page on https:// talking to 127.0.0.1 is cross-origin, and JSON is
      // not a content type a browser sends without asking first. Without this
      // the page's own health check — a plain GET — passes while every send
      // fails with a bare "Failed to fetch", which reads like a broken server.
      respond_preflight(conn)
    _ => respond_json(conn, 405, "{\"ok\":false,\"error\":\"only GET, POST and OPTIONS\"}")
  }
}

///|
/// The answer to a CORS preflight. The published page is served from
/// `moonbitstack.github.io` and the office listens on loopback, so every call
/// the page makes is cross-origin.
async fn respond_preflight(conn : @http.ServerConnection) -> Unit {
  let headers : Map[@http.CaseInsensitiveString, String] = Map([
    (@http.CaseInsensitiveString("access-control-allow-origin"), "*"),
    (@http.CaseInsensitiveString("access-control-allow-methods"), "GET, POST, OPTIONS"),
    (@http.CaseInsensitiveString("access-control-allow-headers"), "content-type"),
    // Chrome asks a public page to declare itself before it may reach the local
    // network; answering here keeps that from being refused later.
    (@http.CaseInsensitiveString("access-control-allow-private-network"), "true"),
    (@http.CaseInsensitiveString("access-control-max-age"), "600"),
  ])
  conn.send_response(204, "No Content", extra_headers=headers)
  conn.end_response()
}

///|
async fn respond_json(conn : @http.ServerConnection, status : Int, text : String) -> Unit {
  let headers : Map[@http.CaseInsensitiveString, String] = Map([
    (@http.CaseInsensitiveString("content-type"), "application/json; charset=utf-8"),
    (@http.CaseInsensitiveString("access-control-allow-origin"), "*"),
    (@http.CaseInsensitiveString("cache-control"), "no-store"),
  ])
  conn.send_response(status, "OK", extra_headers=headers)
  conn.write_string(text)
  conn.end_response()
}

///|
async fn respond_file(conn : @http.ServerConnection, path : String) -> Unit {
  let clean = if path.contains("..") || path.contains("\\") {
    "/desk.html"
  } else {
    path
  }
  match read_file("docs" + clean) {
    Some(bytes) => {
      let headers : Map[@http.CaseInsensitiveString, String] = Map([
        (@http.CaseInsensitiveString("content-type"), media_type(clean)),
        (@http.CaseInsensitiveString("cache-control"), "no-store"),
      ])
      conn.send_response(200, "OK", extra_headers=headers)
      conn.write(bytes[:])
      conn.end_response()
    }
    None => respond_json(conn, 404, "{\"ok\":false,\"error\":\"not found\"}")
  }
}

///|
async fn read_file(path : String) -> Bytes? {
  try {
    Some(@fs.read_file(path).binary())
  } catch {
    _ => None
  }
}

///|
fn media_type(path : String) -> String {
  if path.has_suffix(".html") {
    "text/html; charset=utf-8"
  } else if path.has_suffix(".js") {
    "text/javascript; charset=utf-8"
  } else if path.has_suffix(".jpg") || path.has_suffix(".jpeg") {
    "image/jpeg"
  } else if path.has_suffix(".png") {
    "image/png"
  } else if path.has_suffix(".css") {
    "text/css; charset=utf-8"
  } else if path.has_suffix(".pem") {
    "text/plain; charset=utf-8"
  } else {
    "application/octet-stream"
  }
}

///|
/// `{"host":…,"port":587,"security":"STARTTLS","username":…,"password":…,
/// "from":…,"to":"a@b, c@d","cc":…,"bcc":…,"message":"<base64 MIME>"}` in, the
/// conversation out.
async fn handle_send(conn : @http.ServerConnection, body : &@io.Reader) -> Unit {
  let text = match body_text(body) {
    Some(text) => text
    None => {
      respond_json(conn, 400, "{\"ok\":false,\"error\":\"the body could not be read\"}")
      return
    }
  }
  let payload = match parsed(text) {
    Some(json) => json
    None => {
      respond_json(conn, 400, "{\"ok\":false,\"error\":\"the body was not JSON\"}")
      return
    }
  }
  let host = field(payload, "host")
  let username = field(payload, "username")
  let password = field(payload, "password")
  let from = field(payload, "from")
  let raw = field(payload, "message")
  if host == "" || username == "" || password == "" || from == "" || raw == "" {
    respond_json(
      conn,
      400,
      "{\"ok\":false,\"error\":\"host, username, password, from and message are required\"}",
    )
    return
  }
  let recipients = split(field(payload, "to")) + split(field(payload, "cc")) + split(field(payload, "bcc"))
  if recipients.is_empty() {
    respond_json(conn, 400, "{\"ok\":false,\"error\":\"a letter needs a recipient\"}")
    return
  }
  let message = match decoded(raw) {
    Some(bytes) => bytes
    None => {
      respond_json(conn, 400, "{\"ok\":false,\"error\":\"the message was not base64\"}")
      return
    }
  }
  let security = security_of(field(payload, "security"))
  let port = int_field(payload, "port", 587)
  if !(trust_store()) && secured(security) {
    refuse(conn, no_trust_store())
    return
  }
  let smtp = try {
    @net.Smtp::connect(host, security, port=port)
  } catch {
    @net.Rejected::Reply(_, reply) =>
      {
        refuse(conn, "greeting: " + reply.code.to_string() + " " + reply.text())
        return
      }
    @io.ReaderClosed | @net.Rejected::Closed => {
      refuse(conn, closed_before_greeting(host, port, security))
      return
    }
    error => {
      refuse(conn, "could not open " + host + ":" + port.to_string() + " — " + error.to_string())
      return
    }
  }
  try {
    smtp.auth(@sasl.Plain::new(username, password))
    let refused = smtp.send(from, recipients, message[:])
    smtp.quit()
    // `send` answers with the recipients the server turned down, which is an
    // empty list when it took them all. The transcript the page draws is the
    // conversation, so it is written here from what was said.
    let transcript : Array[Json] = []
    transcript.push(spoken("C", "MAIL FROM:<" + from + ">"))
    for who in recipients {
      transcript.push(spoken("C", "RCPT TO:<" + who + ">"))
    }
    transcript.push(spoken("C", "DATA (" + message.length().to_string() + " bytes)"))
    if refused.is_empty() {
      transcript.push(spoken("S", "250 2.0.0 accepted for " + recipients.length().to_string() + " recipient(s)"))
    } else {
      for pair in refused {
        transcript.push(
          spoken("S", pair.1.code.to_string() + " " + pair.1.text() + " — " + pair.0),
        )
      }
    }
    respond_json(
      conn,
      200,
      Json::object(
        Map([("ok", Json::boolean(true)), ("transcript", Json::array(transcript))]),
      ).stringify(),
    )
  } catch {
    @net.Rejected::Sasl(_) => refuse(conn, "the server refused the username or password")
    @net.Rejected::Reply(_, reply) =>
      refuse(conn, "the server answered " + reply.code.to_string() + " " + reply.text())
    @net.Rejected::Done(_, _, text) => refuse(conn, text)
    @net.Rejected::Err(_, text) => refuse(conn, text)
    @net.Rejected::Closed => refuse(conn, "the server closed the connection")
    error => refuse(conn, error.to_string())
  }
}

///|
fn secured(security : @net.Security) -> Bool {
  match security {
    @net.Security::Clear => false
    _ => true
  }
}

///|
fn no_trust_store() -> String {
  "no trust store to verify the server with. Point MOONMAIL_CA at a PEM bundle, " +
  "or run this from the repository root, where docs/cacert.pem lives."
}

///|
/// A connection that ends before the greeting is what a refused TLS handshake
/// looks like from here, and the reason is worth naming: this client speaks
/// TLS 1.3, and a server that offers only 1.2 hangs up rather than say so.
/// Staying silent would send the reader off to check a password that was never
/// sent.
fn closed_before_greeting(host : String, port : Int, security : @net.Security) -> String {
  let at = host + ":" + port.to_string()
  match security {
    @net.Security::Clear => at + " closed the connection before the greeting."
    _ =>
      at + " closed the connection during the TLS handshake. This client speaks TLS 1.3, " +
      "and a server that offers only 1.2 hangs up instead of explaining. Personal QQ Mail " +
      "is one of those; 163, 126, Tencent Exmail, Aliyun and Fastmail offer 1.3 and work."
  }
}

///|
fn spoken(dir : String, text : String) -> Json {
  Json::object(Map([("dir", Json::string(dir)), ("text", Json::string(text))]))
}

///|
fn decoded(text : String) -> Bytes? {
  try {
    Some(@base64.decode(text))
  } catch {
    _ => None
  }
}

///|
/// A conversation that broke says why, in the same shape as a success, so the
/// page can print it under the form instead of guessing.
async fn refuse(conn : @http.ServerConnection, why : String) -> Unit {
  respond_json(
    conn,
    200,
    Json::object(
      Map([("ok", Json::boolean(false)), ("error", Json::string(why))]),
    ).stringify(),
  )
}

///|
/// Reading a mailbox is the other half of the same job; it is not wired yet,
/// and says so rather than pretending the inbox is empty.
///|
/// Read the newest few letters over IMAP. The page also offers POP3; until
/// that is written the answer says so instead of returning an empty mailbox,
/// because an empty mailbox is a lie a reader cannot tell from the truth.
async fn handle_receive(conn : @http.ServerConnection, body : &@io.Reader) -> Unit {
  let text = match body_text(body) {
    Some(text) => text
    None => {
      respond_json(conn, 400, "{\"ok\":false,\"error\":\"the body could not be read\"}")
      return
    }
  }
  let payload = match parsed(text) {
    Some(json) => json
    None => {
      respond_json(conn, 400, "{\"ok\":false,\"error\":\"the body was not JSON\"}")
      return
    }
  }
  let protocol = field(payload, "protocol")
  let host = field(payload, "host")
  let username = field(payload, "username")
  let password = field(payload, "password")
  if host == "" || username == "" || password == "" {
    respond_json(
      conn,
      400,
      "{\"ok\":false,\"error\":\"host, username and password are required\"}",
    )
    return
  }
  if protocol != "" && protocol != "IMAP" {
    refuse(conn, "reading over " + protocol + " is not wired yet; IMAP is")
    return
  }
  let security = security_of(field(payload, "security"))
  let fallback = match security {
    @net.Security::Tls(_) => 993
    _ => 143
  }
  let port = int_field(payload, "port", fallback)
  if !(trust_store()) && secured(security) {
    refuse(conn, no_trust_store())
    return
  }
  let at = match field(payload, "mailbox") {
    "" => "INBOX"
    name => name
  }
  let imap = try {
    @net.Imap::connect(host, security, port=port)
  } catch {
    @io.ReaderClosed | @net.Rejected::Closed => {
      refuse(conn, closed_before_greeting(host, port, security))
      return
    }
    error => {
      refuse(conn, "could not open " + host + ":" + port.to_string() + " — " + error.to_string())
      return
    }
  }
  try {
    imap.login(username, password)
    // 163 and 126 answer every SELECT with "Unsafe Login" until the client has
    // said who it is (RFC 2971). A server that never advertised ID is left
    // alone: sending a command nobody claimed to know is how a session hangs.
    if imap.client().has("ID") {
      let introduced = imap.client().id([
        ("name", "moonmail"),
        ("version", "0.1"),
        ("vendor", "moonbitstack"),
      ])
      ignore(imap.wait(introduced))
    }
    let selected = imap.wait(imap.client().select(at))
    match selected.status {
      @imap.Status::Ok => ()
      _ => {
        refuse(conn, at + ": " + selected.text)
        return
      }
    }
    // The newest ten by sequence number, asked for by range: a mailbox is read
    // from the top, and a large one should not cost a fetch per letter.
    let found = imap.wait(imap.client().search("ALL"))
    let seqs : Array[Int64] = []
    for response in found.data {
      match response {
        @imap.Response::Search(ids, ..) =>
          for id in ids {
            seqs.push(id)
          }
        _ => ()
      }
    }
    let rows : Array[Json] = []
    let total = seqs.length()
    if total > 0 {
      let first = if total > 10 { total - 10 } else { 0 }
      let range = seqs[first].to_string() + ":" + seqs[total - 1].to_string()
      let fetched = imap.wait(imap.client().fetch(range, "(FLAGS BODY.PEEK[])"))
      for response in fetched.data {
        match response {
          @imap.Response::Fetch(_, items) => rows.push(describe(items))
          _ => ()
        }
      }
    }
    imap.logout()
    let newest_first : Array[Json] = []
    for i = rows.length() - 1; i >= 0; i = i - 1 {
      newest_first.push(rows[i])
    }
    respond_json(
      conn,
      200,
      Json::object(
        Map([("ok", Json::boolean(true)), ("messages", Json::array(newest_first))]),
      ).stringify(),
    )
  } catch {
    @net.Rejected::Sasl(_) => refuse(conn, "the server refused that username or password")
    @net.Rejected::Done(_, _, why) => refuse(conn, why)
    @net.Rejected::Err(_, why) => refuse(conn, why)
    @net.Rejected::Reply(_, reply) =>
      refuse(conn, reply.code.to_string() + " " + reply.text())
    @io.ReaderClosed | @net.Rejected::Closed =>
      refuse(conn, "the connection closed mid-conversation")
    error => refuse(conn, "could not read " + at + ": " + error.to_string())
  }
}

///|
/// One row of the mailbox list. The letter is read by `@moonmail`, not by a
/// regex over the headers, so a folded Subject or a quoted-printable body comes
/// out the way the sender wrote it.
fn describe(items : Map[String, @imap.Value]) -> Json {
  let seen = seen_of(items)
  let parsed = match full_message(items) {
    Some(bytes) => read_message(bytes)
    None => None
  }
  let who = match parsed {
    Some(message) => sender_of(message)
    None => "unknown sender"
  }
  let subject = match parsed {
    Some(message) => message.subject().unwrap_or("(no subject)")
    None => "(unreadable letter)"
  }
  let when = match parsed {
    Some(message) => date_of(message)
    None => ""
  }
  let preview = match parsed {
    Some(message) => body_of(message)
    None => ""
  }
  Json::object(
    Map([
      ("from", Json::string(who)),
      ("subject", Json::string(subject)),
      ("date", Json::string(when)),
      ("preview", Json::string(preview)),
      ("unread", Json::boolean(!seen)),
    ]),
  )
}

///|
/// The whole message, as `BODY[]` hands it over. The key can come back as
/// `BODY[]` or `BODY[]<0>` depending on whether the server split the literal.
fn full_message(items : Map[String, @imap.Value]) -> Bytes? {
  for pair in items {
    if pair.0.has_prefix("BODY[]") {
      match pair.1 {
        @imap.Value::Text(bytes) => return Some(bytes)
        _ => ()
      }
    }
  }
  None
}

///|
fn read_message(bytes : Bytes) -> @moonmail.Message? {
  try {
    Some(@moonmail.Message::parse(bytes[:]))
  } catch {
    _ => None
  }
}

///|
fn sender_of(message : @moonmail.Message) -> String {
  try {
    let boxes = message.from()
    if boxes.is_empty() {
      "unknown sender"
    } else {
      match boxes[0].name {
        Some(name) => readable_name(name)
        None => boxes[0].address
      }
    }
  } catch {
    _ => "unknown sender"
  }
}

///|
/// A display name can arrive as an RFC 2047 encoded word — `=?utf-8?B?...?=` —
/// and the address parser keeps it that way, while `Subject` comes back
/// decoded. One of the two has to be fixed at the edge, and a mailbox row is
/// the edge.
fn readable_name(name : String) -> String {
  if name.contains("=?") {
    @moonmime.decode_words(name)
  } else {
    name
  }
}

///|
/// The date the letter carries, cut to minutes: a mailbox list does not need
/// seconds, and a full ISO string pushes the subject off the row.
fn date_of(message : @moonmail.Message) -> String {
  let stamp = try {
    match message.date() {
      Some(moment) => moment.isoformat()
      None => ""
    }
  } catch {
    _ => ""
  }
  if stamp.length() >= 16 && stamp.length() > 11 {
    stamp[:10].to_owned() + " " + stamp[11:16].to_owned()
  } else {
    stamp
  }
}

///|
fn body_of(message : @moonmail.Message) -> String {
  let text = try {
    message.text().unwrap_or("")
  } catch {
    _ => ""
  }
  flatten(text, 160)
}

///|
/// One line, at most `limit` characters: the list shows a preview, and a body
/// with paragraphs in it should not push the next letter off the panel.
fn flatten(text : String, limit : Int) -> String {
  let cut = if text.length() > limit { text[:limit].to_owned() } else { text }
  let mut out = ""
  for piece in cut.split("\n") {
    let line = piece.trim()
    if line != "" {
      out = if out == "" { line.to_owned() } else { out + " " + line.to_owned() }
    }
  }
  out
}

///|
/// `\Seen` is a flag, not a keyword, so it is matched exactly and case
/// sensitively: a mailbox that reports `\seen` is not a mailbox that agreed.
fn seen_of(items : Map[String, @imap.Value]) -> Bool {
  match items.get("FLAGS") {
    Some(@imap.Value::List(flags)) => {
      let mut found = false
      for flag in flags {
        match flag {
          @imap.Value::Atom(name) =>
            if name == "\\Seen" {
              found = true
            }
          _ => ()
        }
      }
      found
    }
    _ => false
  }
}

///|
async fn body_text(body : &@io.Reader) -> String? {
  try {
    Some(body.read_all().text())
  } catch {
    _ => None
  }
}

///|
fn parsed(text : String) -> Json? {
  try {
    Some(@json.parse(text[:]))
  } catch {
    _ => None
  }
}

///|
fn field(json : Json, name : String) -> String {
  match json {
    Json::Object(map) =>
      match map.get(name) {
        Some(Json::String(value)) => value
        _ => ""
      }
    _ => ""
  }
}

///|
fn int_field(json : Json, name : String, fallback : Int) -> Int {
  match json {
    Json::Object(map) =>
      match map.get(name) {
        Some(Json::Number(value, ..)) => value.to_int()
        _ => fallback
      }
    _ => fallback
  }
}

///|
fn split(text : String) -> Array[String] {
  let out : Array[String] = []
  for part in text.split(",") {
    let item = part.trim().to_owned()
    if item != "" {
      out.push(item)
    }
  }
  out
}

///|
/// `STARTTLS`, `TLS` and `None`. Anything else is treated as STARTTLS, which
/// is what port 587 wants.
async fn security_of(name : String) -> @net.Security {
  match name {
    "TLS" => @net.Security::Tls(tls_client())
    "None" => @net.Security::Clear
    _ => @net.Security::StartTls(tls_client())
  }
}

///|
/// Whether a trust store could be read at all.
///
/// A TLS connection with no roots fails on the first handshake with
/// `unknown_ca`, which reads like the server is at fault. It is not: the bundle
/// was not there, usually because the program was started from a directory that
/// is not the repository root. Better to say so than to let the reader hunt a
/// certificate problem that does not exist.
async fn trust_store() -> Bool {
  let named = @env.get_env_var("MOONMAIL_CA")
  let path = match named {
    Some(path) => path
    None => "docs/cacert.pem"
  }
  let bundle = match read_file(path) {
    Some(bytes) => @utf8.decode_lossy(bytes[:])
    None => ""
  }
  if bundle == "" {
    return false
  }
  try {
    @x509.Roots::pem(bundle).length() > 0
  } catch {
    _ => false
  }
}

///|
/// The roots to trust. `MOONMAIL_CA` names a PEM bundle; without it the bundle
/// that ships beside the page is used, so a fresh clone can reach a real
/// server without assembling a trust store first.
async fn tls_client() -> @tls.Client {
  let named = @env.get_env_var("MOONMAIL_CA")
  let path = match named {
    Some(path) => path
    None => "docs/cacert.pem"
  }
  let bundle = match read_file(path) {
    Some(bytes) => @utf8.decode_lossy(bytes[:])
    None => ""
  }
  let roots = try {
    @x509.Roots::pem(bundle)
  } catch {
    _ => @x509.Roots::new()
  }
  @tls.Client::new(roots)
}

///|
/// How many certificates the bundled trust store holds, for the debug path: a
/// zero here means every TLS connection will fail and the bundle is the reason.
async fn roots_count() -> Int {
  let bundle = match read_file("docs/cacert.pem") {
    Some(bytes) => @utf8.decode_lossy(bytes[:])
    None => ""
  }
  try {
    @x509.Roots::pem(bundle).length()
  } catch {
    _ => -1
  }
}
