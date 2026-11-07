// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// RFC 8621's method list, written out here as it is in the table of contents,
/// so the library's own list can be compared with it rather than with itself.
let rfc_methods : Array[String] = [
  "Mailbox/get", "Mailbox/changes", "Mailbox/query", "Mailbox/queryChanges", "Mailbox/set",
  "Thread/get", "Thread/changes", "Email/get", "Email/changes", "Email/query", "Email/queryChanges",
  "Email/set", "Email/copy", "Email/import", "Email/parse", "SearchSnippet/get",
  "Identity/get", "Identity/changes", "Identity/set", "EmailSubmission/get", "EmailSubmission/changes",
  "EmailSubmission/query", "EmailSubmission/queryChanges", "EmailSubmission/set",
  "VacationResponse/get", "VacationResponse/set",
]

///|
fn args_of(request : Request) -> Json {
  let document = @json.parse(request.to_string()[:]) catch { _ => Json::null() }
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
fn key(json : Json, name : String) -> Json? {
  match json {
    Json::Object(map) => map.get(name)
    _ => None
  }
}

///|
fn text_at(json : Json, name : String) -> String? {
  match key(json, name) {
    Some(Json::String(value)) => Some(value)
    _ => None
  }
}

///|
fn number_at(json : Json, name : String) -> Int32? {
  match key(json, name) {
    Some(Json::Number(value, ..)) => Some(value.to_int())
    _ => None
  }
}

///|
fn boolean_at(json : Json, name : String) -> Bool? {
  match key(json, name) {
    Some(Json::True) => Some(true)
    Some(Json::False) => Some(false)
    _ => None
  }
}

///|
fn keys(json : Json) -> Array[String] {
  match json {
    Json::Object(map) => map.keys().collect()
    _ => []
  }
}

///|
test "methods: every method RFC 8621 defines, and the echo" {
  let names = method_names()
  assert_eq(names.length(), 27)
  for name in rfc_methods {
    assert_true(names.contains(name))
  }
  assert_eq(names[names.length() - 1], "Core/echo")
}

///|
test "methods: a type names its own methods and no others" {
  assert_eq(Kind::Email.methods().length(), 8)
  assert_eq(Kind::Thread.methods(), ["Thread/get", "Thread/changes"])
  assert_eq(Kind::SearchSnippet.methods(), ["SearchSnippet/get"])
  assert_eq(Kind::VacationResponse.methods(), [
    "VacationResponse/get", "VacationResponse/set",
  ])
  // `query` is absent where a type is looked up rather than searched.
  assert_false(Kind::Thread.methods().contains("Thread/query"))
}

///|
test "methods: a call claims the capability its type needs" {
  let request = Request::new()
  ignore(request.thread_get("u-1", ["t-1"]))
  assert_eq(request.capabilities.length(), 2)
  ignore(request.vacation_response_get("u-1"))
  assert_eq(request.capabilities.length(), 3)
  assert_eq(request.capabilities[2], "urn:ietf:params:jmap:vacationresponse")
}

///|
test "get: no ids asks for every object, the type null in the document" {
  let request = Request::new()
  ignore(request.get("u-1", Kind::Mailbox))
  let args = args_of(request)
  assert_eq(key(args, "ids"), Some(Json::null()))
  assert_eq(key(args, "properties"), None)
}

///|
test "get: ids and properties are written in the order given" {
  let request = Request::new()
  ignore(
    request.get("u-1", Kind::Thread, ids=["t-2", "t-1"], properties=[
      "id", "emailIds",
    ]),
  )
  let args = args_of(request)
  assert_eq(
    key(args, "ids"),
    Some(Json::array([Json::string("t-2"), Json::string("t-1")])),
  )
  assert_eq(
    key(args, "properties"),
    Some(Json::array([Json::string("id"), Json::string("emailIds")])),
  )
}

///|
test "changes: the state string, and a bound on the answer" {
  let request = Request::new()
  ignore(
    request.changes("u-1", Kind::Email, since_state="s-1", max_changes=100),
  )
  let args = args_of(request)
  assert_eq(text_at(args, "sinceState"), Some("s-1"))
  assert_eq(number_at(args, "maxChanges"), Some(100))
}

///|
test "set: creation ids are the caller's, and each record is its own" {
  let request = Request::new()
  ignore(
    request.set(
      "u-1",
      Kind::Thread,
      create=Map([("new", object([("id", Json::string("t-1"))]))]),
      destroy=["t-2"],
      if_in_state="s-3",
    ),
  )
  let args = args_of(request)
  assert_eq(text_at(args, "ifInState"), Some("s-3"))
  assert_eq(key(args, "destroy"), Some(Json::array([Json::string("t-2")])))
  let created = match key(args, "create") {
    Some(created) => created
    None => fail("create is there")
  }
  assert_eq(keys(created).length(), 1)
  // No update was given, and JMAP writes that as null rather than leaving it
  // out, so a server can tell "nothing to update" from "the key was a typo".
  assert_eq(key(args, "update"), Some(Json::null()))
}

///|
test "query: the window, the anchor and the total" {
  let request = Request::new()
  ignore(
    request.query(
      "u-1",
      Kind::Mailbox,
      filter=any_of([subscribed(), has_any_role()]),
      sort=[
        Comparator::new(property="sortOrder"),
        Comparator::new(property="name", ascending=false),
      ],
      position=10,
      anchor="mb-3",
      anchor_offset=-2,
      limit=25,
      calculate_total=true,
    ),
  )
  let args = args_of(request)
  assert_eq(number_at(args, "position"), Some(10))
  assert_eq(text_at(args, "anchor"), Some("mb-3"))
  assert_eq(number_at(args, "anchorOffset"), Some(-2))
  assert_eq(number_at(args, "limit"), Some(25))
  assert_eq(boolean_at(args, "calculateTotal"), Some(true))
  let sorts = match key(args, "sort") {
    Some(Json::Array(sorts)) => sorts
    _ => fail("sort is an array")
  }
  assert_eq(sorts.length(), 2)
  assert_eq(text_at(sorts[0], "property"), Some("sortOrder"))
  assert_eq(boolean_at(sorts[0], "isAscending"), Some(true))
  assert_eq(boolean_at(sorts[1], "isAscending"), Some(false))
}

///|
test "query: the operator keeps its conditions in the order given" {
  let request = Request::new()
  let filter = all_of([in_mailbox("mb-in"), not_keyword("$seen")])
  ignore(request.query("u-1", Kind::Email, filter~))
  let args = args_of(request)
  let sent = match key(args, "filter") {
    Some(filter) => filter
    None => fail("the filter is there")
  }
  assert_eq(text_at(sent, "operator"), Some("AND"))
  let conditions = match key(sent, "conditions") {
    Some(Json::Array(conditions)) => conditions
    _ => fail("conditions is an array")
  }
  assert_eq(conditions.length(), 2)
  assert_eq(text_at(conditions[0], "inMailbox"), Some("mb-in"))
  assert_eq(text_at(conditions[1], "notKeyword"), Some("$seen"))
}

///|
test "queryChanges: the query state it continues, and where to stop" {
  let request = Request::new()
  ignore(
    request.query_changes(
      "u-1",
      Kind::Identity,
      since_query_state="q-1",
      up_to_id="id-9",
      max_changes=50,
      calculate_total=true,
    ),
  )
  let args = args_of(request)
  assert_eq(text_at(args, "sinceQueryState"), Some("q-1"))
  assert_eq(text_at(args, "upToId"), Some("id-9"))
  assert_eq(number_at(args, "maxChanges"), Some(50))
  assert_eq(boolean_at(args, "calculateTotal"), Some(true))
}

///|
test "copy: from one account to another, and the original left alone" {
  let request = Request::new()
  ignore(
    request.copy(
      from_account="u-0",
      account="u-1",
      kind=Kind::Email,
      create=Map([("copy", object([("id", Json::string("em-1"))]))]),
      if_from_in_state="s-1",
      on_success_destroy_original=true,
    ),
  )
  let args = args_of(request)
  assert_eq(text_at(args, "fromAccountId"), Some("u-0"))
  assert_eq(text_at(args, "accountId"), Some("u-1"))
  assert_eq(text_at(args, "ifFromInState"), Some("s-1"))
  assert_eq(boolean_at(args, "onSuccessDestroyOriginal"), Some(true))
}

///|
test "echo: the arguments come back as they went" {
  let request = Request::new()
  ignore(request.echo(object([("hello", Json::string("world"))])))
  let args = args_of(request)
  assert_eq(text_at(args, "hello"), Some("world"))
}

///|
test "mailbox: the tree flags and what happens to the mail inside" {
  let request = Request::new()
  ignore(request.mailbox_query("u-1", sort_as_tree=true, filter_as_tree=true))
  let query = args_of(request)
  assert_eq(boolean_at(query, "sortAsTree"), Some(true))
  assert_eq(boolean_at(query, "filterAsTree"), Some(true))
  let second = Request::new()
  ignore(
    second.mailbox_set("u-1", destroy=["mb-1"], on_destroy_remove_emails=true),
  )
  let args = args_of(second)
  assert_eq(boolean_at(args, "onDestroyRemoveEmails"), Some(true))
}

///|
test "mailbox: a create carries only what the client decides" {
  let request = Request::new()
  ignore(
    request.mailbox_set(
      "u-1",
      create=Map([
        (
          "folder",
          mailbox_new(name="Receipts", parent_id="mb-in", sort_order=10),
        ),
      ]),
    ),
  )
  let args = args_of(request)
  let created = match key(args, "create") {
    Some(Json::Object(created)) =>
      match created.get("folder") {
        Some(folder) => folder
        None => fail("the folder is there")
      }
    _ => fail("create is an object")
  }
  assert_eq(text_at(created, "name"), Some("Receipts"))
  assert_eq(text_at(created, "parentId"), Some("mb-in"))
  assert_eq(number_at(created, "sortOrder"), Some(10))
  assert_eq(key(created, "role"), None)
}

///|
test "email: a get names the body properties and how much text to send" {
  let request = Request::new()
  ignore(
    request.email_get(
      "u-1",
      ["em-1"],
      ["id", "subject"],
      body_properties=["partId", "blobId", "size", "type"],
      fetch_html_body_values=true,
      max_body_value_bytes=256,
    ),
  )
  let args = args_of(request)
  assert_eq(boolean_at(args, "fetchHTMLBodyValues"), Some(true))
  assert_eq(number_at(args, "maxBodyValueBytes"), Some(256))
  assert_eq(key(args, "fetchTextBodyValues"), Some(Json::null()))
  let body = match key(args, "bodyProperties") {
    Some(Json::Array(body)) => body
    _ => fail("bodyProperties is an array")
  }
  assert_eq(body.length(), 4)
}

///|
test "email: a query can collapse a thread to its newest letter" {
  let request = Request::new()
  ignore(
    request.email_query_filter(
      "u-1",
      filter=in_mailbox("mb-in"),
      collapse_threads=true,
      limit=50,
    ),
  )
  let args = args_of(request)
  assert_eq(boolean_at(args, "collapseThreads"), Some(true))
  assert_eq(number_at(args, "limit"), Some(50))
}

///|
test "email: an import names a blob and the mailboxes it joins" {
  let request = Request::new()
  ignore(
    request.email_import(
      "u-1",
      Map([
        (
          "one",
          EmailImport::new(
            blob_id="B1",
            mailbox_ids=["mb-in"],
            keywords=["$seen"],
            received_at="2013-10-13T14:12:00Z",
          ),
        ),
      ]),
    ),
  )
  let args = args_of(request)
  let emails = match key(args, "emails") {
    Some(Json::Object(emails)) => emails
    _ => fail("emails is an object")
  }
  let one = match emails.get("one") {
    Some(one) => one
    None => fail("the message is there")
  }
  assert_eq(text_at(one, "blobId"), Some("B1"))
  assert_eq(
    key(one, "mailboxIds"),
    Some(object([("mb-in", Json::boolean(true))])),
  )
  assert_eq(
    key(one, "keywords"),
    Some(object([("$seen", Json::boolean(true))])),
  )
  assert_eq(text_at(one, "receivedAt"), Some("2013-10-13T14:12:00Z"))
}

///|
test "email: a parse names blobs and asks for the body" {
  let request = Request::new()
  ignore(
    request.email_parse(
      "u-1",
      ["B1"],
      properties=["subject"],
      fetch_all_body_values=true,
    ),
  )
  let args = args_of(request)
  assert_eq(key(args, "blobIds"), Some(Json::array([Json::string("B1")])))
  assert_eq(boolean_at(args, "fetchAllBodyValues"), Some(true))
  assert_eq(key(args, "bodyProperties"), None)
}

///|
test "snippet: the filter travels with the ids it belongs to" {
  let request = Request::new()
  ignore(
    request.search_snippet_get(
      "u-1",
      ["em-1", "em-2"],
      filter=text_search("foo"),
    ),
  )
  let args = args_of(request)
  assert_eq(text_at(args, "emailIds"), None)
  assert_eq(
    key(args, "emailIds"),
    Some(Json::array([Json::string("em-1"), Json::string("em-2")])),
  )
  let filter = match key(args, "filter") {
    Some(filter) => filter
    None => fail("the filter is there")
  }
  assert_eq(text_at(filter, "text"), Some("foo"))
}

///|
test "submission: an envelope with the parameters a delivery report needs" {
  let request = Request::new()
  ignore(
    request.email_submission_set(
      "u-1",
      "id-1",
      "em-1",
      envelope=envelope(
        mail_from=address(
          "alice@example.com",
          parameters=Map([("RET", Some("HDRS"))]),
        ),
        rcpt_to=[
          address(
            "bob@example.com",
            parameters=Map([("NOTIFY", Some("SUCCESS,FAILURE"))]),
          ),
        ],
      ),
      on_success_destroy_email=true,
    ),
  )
  let args = args_of(request)
  assert_eq(boolean_at(args, "onSuccessDestroyEmail"), Some(true))
  let created = match key(args, "create") {
    Some(Json::Object(created)) =>
      match created.get("submission") {
        Some(submission) => submission
        None => fail("the submission is there")
      }
    _ => fail("create is an object")
  }
  let sent = match key(created, "envelope") {
    Some(envelope) => envelope
    None => fail("the envelope is there")
  }
  let from = match key(sent, "mailFrom") {
    Some(from) => from
    None => fail("mailFrom is there")
  }
  assert_eq(text_at(from, "email"), Some("alice@example.com"))
  let parameters = match key(from, "parameters") {
    Some(Json::Object(parameters)) => parameters
    _ => fail("parameters is an object")
  }
  assert_eq(parameters.get("RET"), Some(Json::string("HDRS")))
}

///|
test "submission: canceling is an update of undoStatus, and nothing else" {
  let request = Request::new()
  ignore(request.email_submission_cancel("u-1", "es-1"))
  let args = args_of(request)
  let update = match key(args, "update") {
    Some(Json::Object(update)) => update
    _ => fail("update is an object")
  }
  let patch = match update.get("es-1") {
    Some(Json::Object(patch)) => patch
    _ => fail("the patch is an object")
  }
  assert_eq(patch.get("undoStatus"), Some(Json::string("canceled")))
  assert_eq(patch.length(), 1)
}

///|
test "vacation: the singleton is updated, never created" {
  let request = Request::new()
  ignore(
    request.vacation_response_set(
      "u-1",
      vacation_response(
        enabled=true,
        subject="Away",
        text_body="Back on Monday.",
      ),
    ),
  )
  let args = args_of(request)
  assert_eq(key(args, "create"), Some(Json::null()))
  let update = match key(args, "update") {
    Some(Json::Object(update)) => update
    _ => fail("update is an object")
  }
  let singleton = match update.get("singleton") {
    Some(singleton) => singleton
    None => fail("the singleton is updated")
  }
  assert_eq(boolean_at(singleton, "isEnabled"), Some(true))
  assert_eq(text_at(singleton, "textBody"), Some("Back on Monday."))
}

///|
test "filters: a condition with nothing in it matches everything" {
  assert_eq(condition([]).stringify(), "{}")
}

///|
test "filters: the three operators, and nothing else" {
  assert_eq(text_at(none_of([has_attachment()]), "operator"), Some("NOT"))
  assert_eq(text_at(any_of([]), "operator"), Some("OR"))
  let one = in_mailbox_other_than(["mb-trash", "mb-spam"])
  assert_eq(
    key(one, "inMailboxOtherThan"),
    Some(Json::array([Json::string("mb-trash"), Json::string("mb-spam")])),
  )
}

///|
test "filters: a header search is a pair, the name and the value" {
  let filter = header_contains(name="Subject", value="invoice")
  assert_eq(
    key(filter, "header"),
    Some(Json::array([Json::string("Subject"), Json::string("invoice")])),
  )
}

///|
test "filters: the top level is a null parent, not a missing one" {
  assert_eq(key(child_of(None), "parentId"), Some(Json::null()))
  assert_eq(key(child_of(Some("mb-1")), "parentId"), Some(Json::string("mb-1")))
}
