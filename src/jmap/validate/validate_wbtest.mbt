// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The mailbox object of RFC 8621 section 2.6, as the specification prints it.
let rfc_mailbox =
  #|{
  #|  "id": "MB23cfa8094c0f41e6",
  #|  "name": "Inbox",
  #|  "parentId": null,
  #|  "role": "inbox",
  #|  "sortOrder": 10,
  #|  "totalEmails": 16307,
  #|  "unreadEmails": 13905,
  #|  "totalThreads": 5833,
  #|  "unreadThreads": 5128,
  #|  "myRights": {
  #|    "mayAddItems": true,
  #|    "mayRename": false,
  #|    "maySubmit": true,
  #|    "mayDelete": false,
  #|    "maySetKeywords": true,
  #|    "mayRemoveItems": true,
  #|    "mayCreateChild": true,
  #|    "maySetSeen": true,
  #|    "mayReadItems": true
  #|  },
  #|  "isSubscribed": true
  #|}

///|
/// The email object of RFC 8621 section 4.2.1, which is a subset of the
/// properties: this is what a request for these eight properties returns.
let rfc_email =
  #|{
  #|  "id": "f123u457",
  #|  "threadId": "ef1314a",
  #|  "mailboxIds": { "f123": true },
  #|  "from": [{ "name": "Joe Bloggs", "email": "joe@example.com" }],
  #|  "subject": "Dinner on Thursday?",
  #|  "receivedAt": "2013-10-13T14:12:00Z",
  #|  "header:List-POST:asURLs": ["mailto:partytime@lists.example.com"],
  #|  "htmlBody": [
  #|    { "partId": "1", "blobId": "B841623871", "size": 283331, "type": "text/html" },
  #|    { "partId": "2", "blobId": "B319437193", "size": 10343, "type": "text/plain" }
  #|  ],
  #|  "bodyValues": {
  #|    "1": { "isEncodingProblem": false, "isTruncated": true, "value": "<html><body><p>Hello ..." },
  #|    "2": { "isEncodingProblem": false, "isTruncated": false, "value": "a list footer" }
  #|  }
  #|}

///|
/// The identity of RFC 8621 section 6.4.
let rfc_identity =
  #|{
  #|  "id": "XD-3301-222-11_22AAz",
  #|  "name": "Joe Bloggs",
  #|  "email": "joe@example.com",
  #|  "replyTo": null,
  #|  "bcc": [{ "name": null, "email": "joe+archive@example.com" }],
  #|  "textSignature": "-- \nJoe Bloggs\nMaster of Email",
  #|  "htmlSignature": "<div><b>Joe Bloggs</b></div>",
  #|  "mayDelete": false
  #|}

///|
/// The submission of RFC 8621 section 7.5.1, whose envelope carries two
/// parameters that are null because they take no value.
let rfc_submission =
  #|{
  #|  "id": "ES-3bab7f9a-623e-4acf-99a5-2e67facb02a0",
  #|  "identityId": "I64588216",
  #|  "emailId": "M7f6ed5bcfd7e2604d1753f6c",
  #|  "threadId": "T-1",
  #|  "envelope": {
  #|    "mailFrom": { "email": "john@example.com", "parameters": null },
  #|    "rcptTo": [{ "email": "jane@example.com", "parameters": null }]
  #|  },
  #|  "sendAt": "2018-09-01T12:00:00Z",
  #|  "undoStatus": "final",
  #|  "deliveryStatus": {
  #|    "jane@example.com": {
  #|      "smtpReply": "250 2.0.0 Ok",
  #|      "delivered": "yes",
  #|      "displayed": "unknown"
  #|    }
  #|  },
  #|  "dsnBlobIds": [],
  #|  "mdnBlobIds": []
  #|}

///|
fn parsed(text : String) -> Json {
  @json.parse(text[:]) catch {
    _ => Json::null()
  }
}

///|
test "validate: the objects RFC 8621 prints are valid" {
  assert_true(valid("Mailbox", parsed(rfc_mailbox)) catch { _ => false })
  assert_true(valid("Email", parsed(rfc_email)) catch { _ => false })
  assert_true(valid("Identity", parsed(rfc_identity)) catch { _ => false })
  assert_true(
    valid("EmailSubmission", parsed(rfc_submission)) catch {
      _ => false
    },
  )
}

///|
test "validate: a property of the wrong type is named" {
  let broken_text =
    #|{ "id": "MB1", "name": "Inbox", "totalEmails": "16307" }
  let broken = parsed(broken_text)
  assert_false(valid("Mailbox", broken) catch { _ => true })
  let faults = faults("Mailbox", broken) catch { _ => [] }
  assert_true(
    faults.any(fn(fault) {
      fault.schema_at.contains("totalEmails") ||
      fault.at.contains("totalEmails")
    }),
  )
}

///|
test "validate: a nested part is checked where it is" {
  let broken_text =
    #|{ "id": "em-1", "bodyStructure": { "size": "big", "type": "text/plain" } }
  let broken = parsed(broken_text)
  assert_false(valid("Email", broken) catch { _ => true })
}

///|
test "validate: a property the object does not have is allowed through" {
  // RFC 8621 leaves the header forms open: `header:Subject:asText` is a property
  // of the Email object that no table can list.
  let header_text =
    #|{ "id": "em-1", "header:Subject:asText": "Hello", "x-vendor-extra": 1 }
  let with_header = parsed(header_text)
  assert_true(valid("Email", with_header) catch { _ => false })
}

///|
test "validate: a name no object goes by is refused" {
  let refusal = try {
    let _ = valid("EMail", parsed(rfc_email))
    None
  } catch {
    Refused::Unknown(name~) => Some(name)
    _ => None
  }
  assert_eq(refusal, Some("EMail"))
}

///|
test "validate: the schema names the object and its types" {
  let schema = schema("Mailbox") catch { _ => fail("a schema") }
  assert_eq(schema_string(schema, "title"), Some("Mailbox"))
  let properties = match schema {
    Json::Object(map) => map.get("properties")
    _ => None
  }
  let mailbox = match properties {
    Some(Json::Object(mailbox)) => mailbox
    _ => fail("properties is an object")
  }
  assert_true(mailbox.contains("totalEmails"))
  assert_true(mailbox.contains("myRights"))
}

///|
fn schema_string(schema : Json, name : String) -> String? {
  match schema {
    Json::Object(map) =>
      match map.get(name) {
        Some(Json::String(value)) => Some(value)
        _ => None
      }
    _ => None
  }
}

///|
test "validate: the whole vocabulary comes back as one document" {
  let all = all_objects()
  match all {
    Json::Object(models) => assert_eq(models.length(), 18)
    _ => fail("the document is an object")
  }
}
