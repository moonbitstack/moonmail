// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The properties RFC 8621 gives each object, written out here the way the
/// specification lists them, so the description can be compared with it rather
/// than with itself.
let rfc_properties : Array[(String, Array[String])] = [
  (
    "Mailbox",
    [
      "id", "name", "parentId", "role", "sortOrder", "totalEmails", "unreadEmails",
      "totalThreads", "unreadThreads", "myRights", "isSubscribed",
    ],
  ),
  (
    "MailboxRights",
    [
      "mayReadItems", "mayAddItems", "mayRemoveItems", "maySetSeen", "maySetKeywords",
      "mayCreateChild", "mayRename", "mayDelete", "maySubmit",
    ],
  ),
  ("Thread", ["id", "emailIds"]),
  (
    "Email",
    [
      "id", "blobId", "threadId", "mailboxIds", "keywords", "size", "receivedAt",
      "messageId", "inReplyTo", "references", "sender", "from", "to", "cc", "bcc",
      "replyTo", "subject", "sentAt", "hasAttachment", "preview", "headers", "bodyStructure",
      "bodyValues", "textBody", "htmlBody", "attachments",
    ],
  ),
  ("EmailAddress", ["name", "email"]),
  ("EmailAddressGroup", ["name", "addresses"]),
  (
    "EmailBodyPart",
    [
      "partId", "blobId", "size", "headers", "name", "type", "charset", "disposition",
      "cid", "language", "location", "subParts",
    ],
  ),
  ("EmailBodyValue", ["value", "isEncodingProblem", "isTruncated"]),
  ("EmailHeader", ["name", "value"]),
  ("SearchSnippet", ["emailId", "subject", "preview"]),
  (
    "Identity",
    [
      "id", "name", "email", "replyTo", "bcc", "textSignature", "htmlSignature",
      "mayDelete",
    ],
  ),
  ("Address", ["email", "parameters"]),
  ("Envelope", ["mailFrom", "rcptTo"]),
  ("DeliveryStatus", ["smtpReply", "delivered", "displayed"]),
  (
    "EmailSubmission",
    [
      "id", "identityId", "emailId", "threadId", "envelope", "sendAt", "undoStatus",
      "deliveryStatus", "dsnBlobIds", "mdnBlobIds",
    ],
  ),
  (
    "VacationResponse",
    ["id", "isEnabled", "fromDate", "toDate", "subject", "textBody", "htmlBody"],
  ),
]

///|
test "models: every object has the properties RFC 8621 gives it" {
  for entry in rfc_properties {
    let name = entry.0
    let described = properties(name)
    for property in entry.1 {
      if !described.contains(property) {
        fail(name + " has no property " + property)
      }
    }
    assert_eq(described.length(), entry.1.length())
  }
}

///|
test "models: a name RFC 8621 does not define has no description" {
  assert_true(model("Nope") is None)
  assert_eq(properties("Nope").length(), 0)
  assert_false(has_property("Nope", "id"))
}

///|
test "models: a property the object does not have is not offered" {
  assert_true(has_property("Email", "subject"))
  assert_false(has_property("Email", "subjectLine"))
  // The header forms are open-ended, and the description says so by leaving
  // them out: `header:Subject:asText` is still a valid property.
  assert_false(has_property("Email", "header:Subject"))
}

///|
test "models: a reference names an object that is described" {
  for model in models() {
    for field in model.fields {
      if field.kind is Ref(name) {
        assert_true(models().any(fn(other) { other.name == name }))
      }
    }
  }
}
