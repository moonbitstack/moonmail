// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The session document as a server actually answers it: `apiUrl` relative to
/// the discovery URL, the mail account named in `primaryAccounts`, and URLs
/// this client would otherwise have to join itself.
let session_doc =
  #|{
  #|  "capabilities": {
  #|    "urn:ietf:params:jmap:core": { "maxSizeUpload": 50000000 },
  #|    "urn:ietf:params:jmap:mail": {}
  #|  },
  #|  "accounts": {
  #|    "u-1": {
  #|      "name": "haxxorbunny@example.com",
  #|      "isPersonal": true,
  #|      "isReadOnly": false,
  #|      "accountCapabilities": { "urn:ietf:params:jmap:mail": {} }
  #|    }
  #|  },
  #|  "primaryAccounts": { "urn:ietf:params:jmap:mail": "u-1" },
  #|  "username": "haxxorbunny@example.com",
  #|  "apiUrl": "/jmap/",
  #|  "downloadUrl": "/jmap/download/{accountId}/{blobId}/{name}?accept={type}",
  #|  "uploadUrl": "https://mail.example.com/jmap/upload/{accountId}/",
  #|  "eventSourceUrl": "/jmap/event/",
  #|  "state": "s-7"
  #|}

///|
let discovery = "https://mail.example.com/.well-known/jmap"

///|
test "session: reads the discovery document" {
  let session = Session::parse(discovery, session_doc)
  assert_eq(session.api_url, "https://mail.example.com/jmap/")
  assert_eq(session.account_id, "u-1")
  assert_eq(session.username, Some("haxxorbunny@example.com"))
  assert_eq(session.state, "s-7")
  assert_eq(
    session.upload_url,
    Some("https://mail.example.com/jmap/upload/{accountId}/"),
  )
}

///|
test "session: absolute api url stands" {
  let body =
    #|{ "apiUrl": "https://api.example.org/jmap", "accounts": { "a": {} }, "username": "u" }
  let session = Session::parse(discovery, body)
  assert_eq(session.api_url, "https://api.example.org/jmap")
  assert_eq(session.account_id, "a")
}

///|
test "url: resolves paths, directories and absolute urls" {
  assert_eq(resolve(discovery, "/jmap/"), "https://mail.example.com/jmap/")
  assert_eq(
    resolve("https://h.example.com/a/b/jmap", "c"),
    "https://h.example.com/a/b/c",
  )
  assert_eq(
    resolve(discovery, "//cdn.example.com/x"),
    "https://cdn.example.com/x",
  )
  assert_eq(
    resolve(discovery, "https://other.example/x"),
    "https://other.example/x",
  )
}

///|
test "request: builds the document a server expects" {
  let request = Request::new()
  let tag = request.mailbox_get("u-1")
  assert_eq(tag, "c0")
  let second = request.email_query("u-1", "mb-in", 25)
  assert_eq(second, "c1")
  let body = request.to_string()
  let document = @json.parse(body[:])
  let methods = match document {
    Json::Object(map) =>
      match map.get("methodCalls") {
        Some(methods) => methods
        None => fail("methodCalls is there")
      }
    _ => fail("a request document is an object")
  }
  let calls = match methods {
    Json::Array(calls) => calls
    _ => fail("methodCalls is an array")
  }
  assert_eq(calls.length(), 2)
  let query = match calls[1] {
    Json::Array(parts) => parts[1]
    _ => fail("a call is an array")
  }
  let limit = match query {
    Json::Object(map) =>
      match map.get("limit") {
        Some(limit) => limit
        None => fail("the query carries a limit")
      }
    _ => fail("arguments are an object")
  }
  assert_eq(limit, Json::number(25.0, repr="25"))
}

///|
test "response: answers are found by tag, not by position" {
  let body =
    #|{ "methodResponses": [
    #|  ["Email/query", { "ids": ["em-1", "em-2"] }, "c1"],
    #|  ["Mailbox/get", { "list": [] }, "c0"]
    #|], "sessionState": "s-8" }
  let response = Response::parse(body)
  assert_eq(response.session_state, "s-8")
  assert_eq(email_ids(response, "c1"), ["em-1", "em-2"])
  assert_eq(mailboxes(response, "c0").length(), 0)
}

///|
test "mailboxes: roles and counts" {
  let body =
    #|{ "methodResponses": [["Mailbox/get", {
    #|  "list": [
    #|    { "id": "mb-in", "name": "Inbox", "role": "inbox", "totalEmails": 128, "unreadEmails": 3 },
    #|    { "id": "mb-dr", "name": "Drafts", "role": "drafts", "totalEmails": 2, "unreadEmails": 0 }
    #|  ] }, "c0"]] }
  let parsed = mailboxes(Response::parse(body), "c0")
  assert_eq(parsed.length(), 2)
  assert_eq(parsed[0].role, Some("inbox"))
  assert_eq(parsed[0].unread, 3)
  assert_eq(parsed[1].name, "Drafts")
}

///|
test "emails: sender without a name, and the unread flag" {
  let body =
    #|{ "methodResponses": [["Email/get", {
    #|  "list": [
    #|    { "id": "em-1", "subject": "Hello", "from": [{ "name": "Haxxor Bunny", "email": "h@example.com" }],
    #|      "keywords": { "$seen": true } },
    #|    { "id": "em-2", "from": [{ "email": "noreply@example.com" }], "preview": "no subject", "keywords": {} }
    #|  ] }, "c0"]] }
  let list = emails(Response::parse(body), "c0")
  assert_eq(list[0].from, Some("Haxxor Bunny <h@example.com>"))
  assert_eq(list[0].unread, false)
  assert_eq(list[1].from, Some("noreply@example.com"))
  assert_eq(list[1].subject, "(no subject)")
  assert_eq(list[1].unread, true)
}

///|
test "error: a refused call is an error, not an empty list" {
  let body =
    #|{ "methodResponses": [
    #|  ["error", { "type": "forbidden", "description": "Authentication failed" }, "c0"]
    #|], "sessionState": "" }
  let response = Response::parse(body)
  let refusal = try {
    let _ = mailboxes(response, "c0")
    None
  } catch {
    Refused::Failed(kind~, ..) => Some(kind)
    _ => None
  }
  assert_eq(refusal, Some("forbidden"))
}

///|
test "submission: the created id comes back by its creation id" {
  let body =
    #|{ "methodResponses": [["EmailSubmission/set", {
    #|  "created": { "submission": { "id": "es-9" } }
    #|}, "c2"]] }
  assert_eq(created_id(Response::parse(body), "c2", "submission"), "es-9")
}

///|
fn document_of(request : Request) -> Json {
  @json.parse(request.to_string()[:]) catch {
    _ => Json::null()
  }
}

///|
fn using_of(request : Request) -> Array[String] {
  let document = document_of(request)
  let entries = match document {
    Json::Object(map) =>
      match map.get("using") {
        Some(Json::Array(entries)) => entries
        _ => []
      }
    _ => []
  }
  let out : Array[String] = []
  for entry in entries {
    match entry {
      Json::String(value) => out.push(value)
      _ => ()
    }
  }
  out
}

///|
fn arguments_of(request : Request) -> Json {
  let document = document_of(request)
  match document {
    Json::Object(map) =>
      match map.get("methodCalls") {
        Some(Json::Array(calls)) =>
          match calls[0] {
            Json::Array(parts) => parts[1]
            _ => Json::null()
          }
        _ => Json::null()
      }
    _ => Json::null()
  }
}

///|
test "capabilities: a read asks for mail, a send adds submission" {
  let request = Request::new()
  ignore(request.mailbox_get("u-1"))
  let read = using_of(request)
  assert_eq(read.length(), 2)
  assert_eq(read[1], "urn:ietf:params:jmap:mail")
  ignore(request.email_submission_set("u-1", "id-1", "em-1"))
  let send = using_of(request)
  assert_eq(send.length(), 3)
  assert_eq(send[2], "urn:ietf:params:jmap:submission")
}

///|
test "request-level error: a problem document keeps its type" {
  let body =
    #|{ "type": "urn:ietf:params:jmap:error:unknownCapability",
    #|  "detail": "The request used a capability this server does not have." }
  let refusal = try {
    let _ = Response::parse(body)
    None
  } catch {
    Refused::Failed(kind~, description=detail, ..) =>
      Some(kind + " / " + detail)
    _ => None
  }
  assert_eq(
    refusal,
    Some(
      "urn:ietf:params:jmap:error:unknownCapability / The request used a capability this server does not have.",
    ),
  )
}

///|
test "email: marking seen patches one keyword, not the whole map" {
  let request = Request::new()
  ignore(request.email_mark_seen("u-1", "em-1", true))
  let args = arguments_of(request)
  let patch = match args {
    Json::Object(map) =>
      match map.get("update") {
        Some(Json::Object(update)) =>
          match update.get("em-1") {
            Some(Json::Object(patch)) => patch
            _ => Map([])
          }
        _ => Map([])
      }
    _ => Map([])
  }
  assert_eq(patch.get("keywords/$seen"), Some(Json::boolean(true)))
  assert_eq(patch.length(), 1)
}

///|
test "email: moving replaces the mailbox set" {
  let request = Request::new()
  ignore(request.email_move("u-1", "em-1", "mb-ar"))
  let args = arguments_of(request)
  let boxes = match args {
    Json::Object(map) =>
      match map.get("update") {
        Some(Json::Object(update)) =>
          match update.get("em-1") {
            Some(Json::Object(patch)) => patch.get("mailboxIds")
            _ => None
          }
        _ => None
      }
    _ => None
  }
  let expected = object([("mb-ar", Json::boolean(true))])
  assert_eq(boxes, Some(expected))
}

///|
test "email: destroying names the id, it does not move it to trash" {
  let request = Request::new()
  ignore(request.email_destroy("u-1", "em-1"))
  let args = arguments_of(request)
  let destroyed = match args {
    Json::Object(map) => map.get("destroy")
    _ => None
  }
  assert_eq(destroyed, Some(Json::array([Json::string("em-1")])))
  let update = match args {
    Json::Object(map) => map.get("update")
    _ => None
  }
  assert_eq(update, None)
}
