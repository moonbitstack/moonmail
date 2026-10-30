// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
struct Scripted {
  status : Int32
  response : String
  sent_url : Array[String]
  sent_body : Array[String]
}

///|
impl @jmap.JmapIo for Scripted with fn post(self, url, headers, body) -> (
  Int32,
  Bytes,
) raise @jmap.JmapError {
  let _ = headers
  self.sent_url.push(url)
  self.sent_body.push(@utf8.decode_lossy(body))
  (self.status, @utf8.encode(self.response))
}

///|
test "jmap parses a session resource" {
  let text = "{\"apiUrl\":\"https://api.example.com/jmap/\",\"sessionState\":\"ss1\",\"accounts\":{\"acct1\":{\"name\":\"alice@example.com\"}},\"primaryAccounts\":{\"urn:ietf:params:jmap:mail\":\"acct1\"}}"
  let mut api_url = ""
  let mut state = ""
  let mut accounts = 0
  let mut primary = ""
  try {
    let session = @jmap.parse_session(text)
    api_url = session.api_url
    state = session.state
    accounts = session.accounts.length()
    primary = match session.primary_mail {
      Some(value) => value
      None => ""
    }
  } catch {
    _ => ()
  }
  inspect(api_url, content="https://api.example.com/jmap/")
  inspect(state, content="ss1")
  inspect(accounts, content="1")
  inspect(primary, content="acct1")
}

///|
test "jmap builds a request body" {
  let request = @jmap.Request::mail([
    @jmap.mailbox_get("acct1", "c1"),
    @jmap.email_get("acct1", ["e1", "e2"], "c2"),
  ])
  let text = @jmap.dumps_request(request)
  inspect(text.find("\"using\"") is Some(_), content="true")
  inspect(text.find("methodCalls") is Some(_), content="true")
  inspect(text.find("Mailbox/get") is Some(_), content="true")
  inspect(text.find("Email/get") is Some(_), content="true")
  inspect(text.find("acct1") is Some(_), content="true")
}

///|
test "jmap parses method responses" {
  let text = "{\"methodResponses\":[[\"Mailbox/get\",{\"accountId\":\"a\",\"list\":[{\"id\":\"m1\",\"name\":\"Inbox\"}],\"state\":\"s1\"},\"c1\"]],\"sessionState\":\"ss1\"}"
  let mut name = ""
  let mut call_id = ""
  let mut session_state = ""
  let mut list_len = 0
  try {
    let body = @jmap.parse_response(text)
    name = body.responses[0].name
    call_id = body.responses[0].call_id
    session_state = body.session_state
    if body.responses[0].arguments is Object(fields) {
      match fields.get("list") {
        Some(value) => if value is Array(items) { list_len = items.length() }
        None => ()
      }
    }
  } catch {
    _ => ()
  }
  inspect(name, content="Mailbox/get")
  inspect(call_id, content="c1")
  inspect(session_state, content="ss1")
  inspect(list_len, content="1")
}

///|
test "jmap client posts the request and parses the reply" {
  let script : Scripted = {
    status: 200,
    response: "{\"methodResponses\":[[\"Mailbox/get\",{\"list\":[]},\"c1\"]],\"sessionState\":\"ss1\"}",
    sent_url: [],
    sent_body: [],
  }
  let client = @jmap.Client::new(
    script as &@jmap.JmapIo,
    "https://api.example.com/jmap/",
    [("Authorization", "Bearer token")],
  )
  let mut reply_name = ""
  try {
    let body = client.send(
      @jmap.Request::mail([@jmap.mailbox_get("acct1", "c1")]),
    )
    reply_name = body.responses[0].name
  } catch {
    _ => ()
  }
  inspect(script.sent_url[0], content="https://api.example.com/jmap/")
  inspect(script.sent_body[0].find("Mailbox/get") is Some(_), content="true")
  inspect(reply_name, content="Mailbox/get")
}

///|
test "jmap client raises on a non-2xx status" {
  let script : Scripted = {
    status: 401,
    response: "{\"type\":\"about:blank\"}",
    sent_url: [],
    sent_body: [],
  }
  let client = @jmap.Client::new(
    script as &@jmap.JmapIo,
    "https://api.example.com/jmap/",
    [],
  )
  let raised = try {
    let _ = client.send(@jmap.Request::mail([@jmap.mailbox_get("acct1", "c1")]))
    false
  } catch {
    _ => true
  }
  inspect(raised, content="true")
}

///|
test "jmap builds an email set with a draft" {
  let email_set = @jmap.email_set("acct1", "c1")
  email_set.create(
    "draft1",
    @jmap.email_draft(
      "Drafts",
      "alice@example.com",
      ["bob@example.com"],
      "Hello",
      "Body text",
    ),
  )
  email_set.update(
    "M1",
    @jmap.object_of([
      ("keywords", @jmap.object_of([("$seen", Json::boolean(true))])),
    ]),
  )
  email_set.destroy("M2")
  let call = email_set.to_call()
  inspect(call.name, content="Email/set")
  let text = @jmap.dumps_request(@jmap.Request::mail([call]))
  inspect(text.find("Email/set") is Some(_), content="true")
  inspect(text.find("draft1") is Some(_), content="true")
  inspect(text.find("$draft") is Some(_), content="true")
  inspect(text.find("Drafts") is Some(_), content="true")
  inspect(text.find("Body text") is Some(_), content="true")
  inspect(text.find("text/plain") is Some(_), content="true")
  inspect(text.find("destroy") is Some(_), content="true")
}

///|
test "jmap parses a set response" {
  let text = "{\"methodResponses\":[[\"Email/set\",{\"created\":{\"draft1\":{\"id\":\"M100\"}},\"updated\":{\"M1\":null},\"destroyed\":[\"M2\"],\"notCreated\":{\"draft2\":{\"type\":\"invalidProperties\",\"description\":\"bad subject\"}},\"notUpdated\":{\"M9\":{\"type\":\"notFound\"}}},\"c1\"]],\"sessionState\":\"s1\"}"
  let mut created_id = ""
  let mut updated = 0
  let mut destroyed = ""
  let mut refusal = ""
  let mut not_updated = ""
  try {
    let body = @jmap.parse_response(text)
    let set = @jmap.parse_set_response(body.responses[0].arguments)
    created_id = match set.created.get("draft1") {
      Some(value) => value
      None => ""
    }
    updated = set.updated.length()
    destroyed = if set.destroyed.length() > 0 { set.destroyed[0] } else { "" }
    refusal = match set.not_created.get("draft2") {
      Some(value) => value
      None => ""
    }
    not_updated = match set.not_updated.get("M9") {
      Some(value) => value
      None => ""
    }
  } catch {
    _ => ()
  }
  inspect(created_id, content="M100")
  inspect(updated, content="1")
  inspect(destroyed, content="M2")
  // The description wins over the type when the server sent both.
  inspect(refusal, content="bad subject")
  // With no description the type stands in for the reason.
  inspect(not_updated, content="notFound")
}

///|
test "jmap reads a get list and a query result" {
  let text = "{\"methodResponses\":[[\"Mailbox/get\",{\"list\":[{\"id\":\"m1\",\"name\":\"Inbox\"},{\"id\":\"m2\",\"name\":\"Sent\"}],\"state\":\"s1\"},\"c1\"],[\"Email/query\",{\"accountId\":\"a\",\"ids\":[\"e2\",\"e1\"],\"total\":2},\"c2\"]],\"sessionState\":\"s1\"}"
  let mut list_len = 0
  let mut ids = 0
  let mut first_id = ""
  try {
    let body = @jmap.parse_response(text)
    let list = @jmap.get_list(body.responses[0].arguments)
    list_len = list.length()
    let query = @jmap.query_ids(body.responses[1].arguments)
    ids = query.length()
    first_id = if query.length() > 0 { query[0] } else { "" }
  } catch {
    _ => ()
  }
  inspect(list_len, content="2")
  inspect(ids, content="2")
  inspect(first_id, content="e2")
}

///|
test "jmap builds an email submission" {
  let submission = @jmap.email_submission("i1", "M100", "alice@example.com", [
    "bob@example.com", "carol@example.com",
  ])
  let set = @jmap.email_submission_set("acct1", "c1")
  set.create("sub1", submission)
  let text = @jmap.dumps_request(@jmap.Request::mail([set.to_call()]))
  inspect(text.find("EmailSubmission/set") is Some(_), content="true")
  inspect(text.find("identityId") is Some(_), content="true")
  inspect(text.find("i1") is Some(_), content="true")
  inspect(text.find("mailFrom") is Some(_), content="true")
  inspect(text.find("rcptTo") is Some(_), content="true")
  inspect(text.find("carol@example.com") is Some(_), content="true")
}

///|
test "jmap asks for identities and threads" {
  let request = @jmap.Request::mail([
    @jmap.identity_get("acct1", "c1"),
    @jmap.thread_get("acct1", ["t1", "t2"], "c2"),
  ])
  let text = @jmap.dumps_request(request)
  inspect(text.find("Identity/get") is Some(_), content="true")
  inspect(text.find("Thread/get") is Some(_), content="true")
  inspect(text.find("t2") is Some(_), content="true")
}
