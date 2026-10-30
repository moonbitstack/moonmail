// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
pub(all) suberror JmapError {
  Transport(msg~ : String)
  Http(status~ : Int32, body~ : String)
  Json(msg~ : String)
  Protocol(msg~ : String)
}

///|
/// The HTTP POST the client needs: a URL, headers and a body, answered by a
/// status and a body. A socket, a test double and the moonfetch adapter all
/// implement this.
pub(open) trait JmapIo {
  fn post(Self, String, Array[(String, String)], Bytes) -> (Int32, Bytes) raise JmapError
}

///|
/// One account the session exposes.
pub struct Account {
  id : String
  name : String
}

///|
/// The session resource: where the API lives, what accounts exist, and which
/// one the mail capability should use by default.
pub struct Session {
  api_url : String
  state : String
  accounts : Array[Account]
  primary_mail : String?
}

///|
/// One `methodCalls` entry: a method name, its arguments, and the id that ties
/// the response back to it.
pub struct MethodCall {
  name : String
  arguments : Json
  call_id : String
}

///|
pub struct Request {
  capabilities : Array[String]
  calls : Array[MethodCall]
}

///|
/// One `methodResponses` entry.
pub struct MethodResponse {
  name : String
  arguments : Json
  call_id : String
}

///|
pub struct ResponseBody {
  responses : Array[MethodResponse]
  session_state : String
}

///|
/// A JMAP client over some transport.
pub struct Client {
  io : &JmapIo
  api_url : String
  headers : Array[(String, String)]
}

///|
priv struct Field {
  key : String
  value : Json
}

///|
fn obj(fields : Array[Field]) -> Json {
  let map : Map[String, Json] = Map([])
  for f in fields {
    map.set(f.key, f.value)
  }
  Json::object(map)
}

///|
fn or_empty(value : String?) -> String {
  match value {
    Some(s) => s
    None => ""
  }
}

///|
fn string_of(json : Json) -> String {
  if json is String(s) {
    s
  } else {
    ""
  }
}

///|
fn decode(text : StringView) -> Json raise JmapError {
  @moonjson.loads(text, @moonjson.strict) catch {
    _ => raise JmapError::Json(msg="invalid JSON")
  }
}

///|
fn encode(json : Json) -> String {
  @moonjson.dumps(json)
}

///|
fn field(json : Json, key : String) -> Json? {
  if json is Object(map) {
    map.get(key)
  } else {
    None
  }
}

///|
fn string_field(json : Json, key : String) -> String? {
  match field(json, key) {
    Some(value) => if value is String(s) { Some(s) } else { None }
    None => None
  }
}

///|
fn array_field(json : Json, key : String) -> Array[Json] {
  match field(json, key) {
    Some(value) => if value is Array(items) { items } else { [] }
    None => []
  }
}

///|
/// Read the session resource. `apiUrl` is where the method calls go, and the
/// mail capability's primary account is the default `accountId`.
pub fn parse_session(text : StringView) -> Session raise JmapError {
  let json = decode(text)
  let accounts : Array[Account] = []
  match field(json, "accounts") {
    Some(value) =>
      if value is Object(map) {
        for id, account in map.iter2() {
          accounts.push({ id, name: or_empty(string_field(account, "name")), })
        }
      }
    None => ()
  }
  let primary = match field(json, "primaryAccounts") {
    Some(value) =>
      if value is Object(map) {
        map.get("urn:ietf:params:jmap:mail")
      } else {
        None
      }
    None => None
  }
  let primary_mail = match primary {
    Some(value) => if value is String(s) { Some(s) } else { None }
    None => None
  }
  {
    api_url: or_empty(string_field(json, "apiUrl")),
    state: or_empty(string_field(json, "sessionState")),
    accounts,
    primary_mail,
  }
}

///|
/// Build the JSON body of an API request.
pub fn request_json(request : Request) -> Json {
  let caps : Array[Json] = []
  for name in request.capabilities {
    caps.push(Json::string(name))
  }
  let calls : Array[Json] = []
  for entry in request.calls {
    let parts : Array[Json] = [
      Json::string(entry.name),
      entry.arguments,
      Json::string(entry.call_id),
    ]
    calls.push(Json::array(parts))
  }
  obj([
    { key: "using", value: Json::array(caps), },
    { key: "methodCalls", value: Json::array(calls), },
  ])
}

///|
/// The request as the wire carries it, for inspection and for tests.
pub fn dumps_request(request : Request) -> String {
  encode(request_json(request))
}

///|
/// Parse a `methodResponses` body. Each entry is `[name, arguments, callId]`.
pub fn parse_response(text : StringView) -> ResponseBody raise JmapError {
  let json = decode(text)
  let responses : Array[MethodResponse] = []
  for item in array_field(json, "methodResponses") {
    if item is Array(parts) {
      if parts.length() >= 3 {
        responses.push({
          name: string_of(parts[0]),
          arguments: parts[1],
          call_id: string_of(parts[2]),
        })
      }
    }
  }
  { responses, session_state: or_empty(string_field(json, "sessionState")), }
}

///|
pub fn Client::new(
  io : &JmapIo,
  api_url : String,
  headers : Array[(String, String)],
) -> Client {
  { io, api_url, headers, }
}

///|
pub fn Client::api_url(self : Client) -> String {
  self.api_url
}

///|
/// POST a request and parse the response. A non-2xx status is an `Http` error.
pub fn Client::send(
  self : Client,
  request : Request,
) -> ResponseBody raise JmapError {
  let body = encode(request_json(request))
  let (status, response) = self.io.post(
    self.api_url,
    self.headers,
    @utf8.encode(body),
  )
  if status < 200 || status >= 300 {
    raise JmapError::Http(status~, body=@utf8.decode_lossy(response[:]))
  }
  parse_response(@utf8.decode_lossy(response[:]))
}

///|
pub fn MethodCall::new(
  name : String,
  arguments : Json,
  call_id : String,
) -> MethodCall {
  { name, arguments, call_id, }
}

///|
pub fn Request::new(
  capabilities : Array[String],
  calls : Array[MethodCall],
) -> Request {
  { capabilities, calls, }
}

///|
/// A request that declares the core and mail capabilities, which is what every
/// mail method needs.
pub fn Request::mail(calls : Array[MethodCall]) -> Request {
  {
    capabilities: ["urn:ietf:params:jmap:core", "urn:ietf:params:jmap:mail"],
    calls,
  }
}

///|
pub fn mailbox_get(account_id : String, call_id : String) -> MethodCall {
  {
    name: "Mailbox/get",
    arguments: obj([{ key: "accountId", value: Json::string(account_id), }]),
    call_id,
  }
}

///|
pub fn email_query(
  account_id : String,
  filter : Json,
  call_id : String,
) -> MethodCall {
  {
    name: "Email/query",
    arguments: obj([
      { key: "accountId", value: Json::string(account_id), },
      { key: "filter", value: filter, },
    ]),
    call_id,
  }
}

///|
pub fn email_get(
  account_id : String,
  ids : Array[String],
  call_id : String,
) -> MethodCall {
  let list : Array[Json] = []
  for id in ids {
    list.push(Json::string(id))
  }
  {
    name: "Email/get",
    arguments: obj([
      { key: "accountId", value: Json::string(account_id), },
      { key: "ids", value: Json::array(list), },
    ]),
    call_id,
  }
}

///|
/// Build a JSON object from key/value pairs, for the parts of a JMAP body the
/// typed builders below do not cover.
pub fn object_of(pairs : Array[(String, Json)]) -> Json {
  let map : Map[String, Json] = Map([])
  for pair in pairs {
    map.set(pair.0, pair.1)
  }
  Json::object(map)
}

///|
/// A JSON array of strings.
pub fn strings(values : Array[String]) -> Json {
  let out : Array[Json] = []
  for value in values {
    out.push(Json::string(value))
  }
  Json::array(out)
}

///|
/// A `*/set` call being assembled (RFC 8620 §5.3). `Email/set`, `Mailbox/set`
/// and `EmailSubmission/set` all share this shape: creations keyed by a
/// client-chosen id, patches keyed by server id, and ids to destroy.
pub struct SetRequest {
  method_name : String
  account_id : String
  call_id : String
  create : Array[(String, Json)]
  update : Array[(String, Json)]
  destroy : Array[String]
}

///|
pub fn SetRequest::new(
  method_name : String,
  account_id : String,
  call_id : String,
) -> SetRequest {
  { method_name, account_id, call_id, create: [], update: [], destroy: [], }
}

///|
/// Add a creation. The key is the client's `creationId`; the server answers
/// with the real id under the same key.
pub fn SetRequest::create(
  self : SetRequest,
  creation_id : String,
  value : Json,
) -> Unit {
  self.create.push((creation_id, value))
}

///|
/// Add a patch to an existing object. Only the properties named in `patch`
/// change.
pub fn SetRequest::update(self : SetRequest, id : String, patch : Json) -> Unit {
  self.update.push((id, patch))
}

///|
/// Add an id to destroy.
pub fn SetRequest::destroy(self : SetRequest, id : String) -> Unit {
  self.destroy.push(id)
}

///|
/// The method call this request describes. Empty sections are left out, since a
/// server reads an absent `create` and an empty one the same way.
pub fn SetRequest::to_call(self : SetRequest) -> MethodCall {
  let fields : Array[(String, Json)] = [
    ("accountId", Json::string(self.account_id)),
  ]
  if self.create.length() > 0 {
    fields.push(("create", object_of(self.create)))
  }
  if self.update.length() > 0 {
    fields.push(("update", object_of(self.update)))
  }
  if self.destroy.length() > 0 {
    fields.push(("destroy", strings(self.destroy)))
  }
  MethodCall::new(self.method_name, object_of(fields), self.call_id)
}

///|
/// `Email/set`, the call that creates, patches and destroys messages.
pub fn email_set(account_id : String, call_id : String) -> SetRequest {
  SetRequest::new("Email/set", account_id, call_id)
}

///|
/// `Mailbox/set`, for creating and renaming mailboxes.
pub fn mailbox_set(account_id : String, call_id : String) -> SetRequest {
  SetRequest::new("Mailbox/set", account_id, call_id)
}

///|
/// `EmailSubmission/set`, which asks the server to actually send a stored email.
pub fn email_submission_set(
  account_id : String,
  call_id : String,
) -> SetRequest {
  SetRequest::new("EmailSubmission/set", account_id, call_id)
}

///|
/// A draft email as `Email/set` wants it: the addresses, a subject, one
/// `text/plain` body part, and `$draft` in the keywords so the server files it
/// as unfinished.
pub fn email_draft(
  drafts_mailbox : String,
  from : String,
  to : Array[String],
  subject : String,
  text : String,
) -> Json {
  let from_list : Array[Json] = [object_of([("email", Json::string(from))])]
  let to_list : Array[Json] = []
  for address in to {
    to_list.push(object_of([("email", Json::string(address))]))
  }
  let parts : Array[Json] = [
    object_of([
      ("partId", Json::string("body")),
      ("type", Json::string("text/plain")),
    ]),
  ]
  object_of([
    ("from", Json::array(from_list)),
    ("to", Json::array(to_list)),
    ("subject", Json::string(subject)),
    ("keywords", object_of([("$draft", Json::boolean(true))])),
    ("mailboxIds", object_of([(drafts_mailbox, Json::boolean(true))])),
    (
      "bodyValues",
      object_of([("body", object_of([("value", Json::string(text))]))]),
    ),
    ("textBody", Json::array(parts)),
  ])
}

///|
/// An `EmailSubmission` (RFC 8621 §7): which identity sends it, which stored
/// email to send, and the envelope the server should use.
pub fn email_submission(
  identity_id : String,
  email_id : String,
  envelope_from : String,
  rcpt_to : Array[String],
) -> Json {
  let recipients : Array[Json] = []
  for address in rcpt_to {
    recipients.push(object_of([("email", Json::string(address))]))
  }
  object_of([
    ("identityId", Json::string(identity_id)),
    ("emailId", Json::string(email_id)),
    (
      "envelope",
      object_of([
        ("mailFrom", object_of([("email", Json::string(envelope_from))])),
        ("rcptTo", Json::array(recipients)),
      ]),
    ),
  ])
}

///|
/// `Identity/get`: the names and addresses an account may send as.
pub fn identity_get(account_id : String, call_id : String) -> MethodCall {
  {
    name: "Identity/get",
    arguments: object_of([("accountId", Json::string(account_id))]),
    call_id,
  }
}

///|
/// `Thread/get`: the message ids that make up each conversation.
pub fn thread_get(
  account_id : String,
  ids : Array[String],
  call_id : String,
) -> MethodCall {
  {
    name: "Thread/get",
    arguments: object_of([
      ("accountId", Json::string(account_id)),
      ("ids", strings(ids)),
    ]),
    call_id,
  }
}

///|
/// What a `*/set` call did (RFC 8620 §5.3): the ids the server gave the objects
/// it created, the ids it updated or destroyed, and the ones it refused with a
/// reason.
pub struct SetResponse {
  created : Map[String, String]
  updated : Array[String]
  destroyed : Array[String]
  not_created : Map[String, String]
  not_updated : Map[String, String]
  not_destroyed : Map[String, String]
}

///|
pub fn parse_set_response(arguments : Json) -> SetResponse {
  let created : Map[String, String] = Map([])
  let updated : Array[String] = []
  let destroyed : Array[String] = []
  let not_created : Map[String, String] = Map([])
  let not_updated : Map[String, String] = Map([])
  let not_destroyed : Map[String, String] = Map([])
  match field(arguments, "created") {
    Some(value) =>
      if value is Object(map) {
        for key, object in map.iter2() {
          created.set(key, or_empty(string_field(object, "id")))
        }
      }
    None => ()
  }
  match field(arguments, "updated") {
    Some(value) =>
      if value is Object(map) {
        for key, _patch in map.iter2() {
          updated.push(key)
        }
      }
    None => ()
  }
  for id in array_field(arguments, "destroyed") {
    destroyed.push(string_of(id))
  }
  fill_reasons(arguments, "notCreated", not_created)
  fill_reasons(arguments, "notUpdated", not_updated)
  fill_reasons(arguments, "notDestroyed", not_destroyed)
  { created, updated, destroyed, not_created, not_updated, not_destroyed, }
}

///|
fn fill_reasons(
  arguments : Json,
  key : String,
  into : Map[String, String],
) -> Unit {
  match field(arguments, key) {
    Some(value) =>
      if value is Object(map) {
        for id, error in map.iter2() {
          into.set(id, reason_of(error))
        }
      }
    None => ()
  }
}

///|
/// Why a set operation was refused: the description when the server gave one,
/// else its `type`.
fn reason_of(error : Json) -> String {
  match string_field(error, "description") {
    Some(text) => text
    None => or_empty(string_field(error, "type"))
  }
}

///|
/// The `list` an `X/get` response carries: one JSON object per object returned.
pub fn get_list(arguments : Json) -> Array[Json] {
  array_field(arguments, "list")
}

///|
/// The ids an `X/query` response carries, in the order the server ranked them.
pub fn query_ids(arguments : Json) -> Array[String] {
  let out : Array[String] = []
  for item in array_field(arguments, "ids") {
    out.push(string_of(item))
  }
  out
}
