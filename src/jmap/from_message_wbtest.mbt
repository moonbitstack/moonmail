// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The structure RFC 8621 section 4.1.4 uses to show what the three lists are:
/// a plain text part, a mixed part wrapped in an alternative with a related part
/// inside, attachments at the top of that mixed part, and the list software's
/// footer after it. The section ends with the lists this must produce.
let rfc_structure =
  #|From: Alice <alice@example.com>
  #|To: Bob <bob@example.com>
  #|Subject: a message with a shape
  #|Date: Fri, 06 Nov 2026 12:00:00 +0000
  #|Message-ID: <shape@example.com>
  #|MIME-Version: 1.0
  #|Content-Type: multipart/mixed; boundary="m1"
  #|
  #|--m1
  #|Content-Type: text/plain
  #|
  #|A
  #|--m1
  #|Content-Type: multipart/mixed; boundary="m2"
  #|
  #|--m2
  #|Content-Type: multipart/alternative; boundary="m3"
  #|
  #|--m3
  #|Content-Type: multipart/mixed; boundary="m4"
  #|
  #|--m4
  #|Content-Type: text/plain
  #|
  #|B
  #|--m4
  #|Content-Type: image/jpeg
  #|
  #|C
  #|--m4
  #|Content-Type: text/plain
  #|
  #|D
  #|--m4--
  #|--m3
  #|Content-Type: multipart/related; boundary="m5"
  #|
  #|--m5
  #|Content-Type: text/html
  #|
  #|<p>E</p>
  #|--m5
  #|Content-Type: image/jpeg
  #|
  #|F
  #|--m5--
  #|--m3--
  #|--m2
  #|Content-Type: image/jpeg
  #|Content-Disposition: attachment; filename="g.jpg"
  #|
  #|G
  #|--m2
  #|Content-Type: application/vnd.ms-excel
  #|
  #|H
  #|--m2
  #|Content-Type: message/rfc822
  #|
  #|From: Carol <carol@example.com>
  #|Subject: J
  #|Content-Type: text/plain
  #|
  #|J
  #|--m2--
  #|--m1
  #|Content-Type: text/plain
  #|
  #|K
  #|--m1--

///|
fn message_bytes(text : String) -> Bytes {
  @utf8.encode(text.replace_all(old="\n", new="\r\n"))
}

///|
fn types(parts : Array[EmailBodyPart]) -> Array[String] {
  parts.map(fn(part) { part.media_type })
}

///|
/// A letter with both representations of the same body.
let alternative_message =
  #|From: Alice <alice@example.com>
  #|To: Bob <bob@example.com>
  #|Cc: Carol <carol@example.com>
  #|Subject: Lunch?
  #|Date: Fri, 06 Nov 2026 12:00:00 +0000
  #|Message-ID: <lunch@example.com>
  #|In-Reply-To: <earlier@example.com>
  #|References: <first@example.com> <earlier@example.com>
  #|MIME-Version: 1.0
  #|Content-Type: multipart/alternative; boundary="b1"
  #|
  #|--b1
  #|Content-Type: text/plain; charset=utf-8
  #|
  #|Noon works.
  #|--b1
  #|Content-Type: text/html; charset=utf-8
  #|
  #|<p>Noon works.</p>
  #|--b1--
  #|,

///|
/// A letter with a text part and a file beside it.
let attached_message =
  #|From: Alice <alice@example.com>
  #|To: Bob <bob@example.com>
  #|Subject: A map
  #|Date: Fri, 06 Nov 2026 12:00:00 +0000
  #|MIME-Version: 1.0
  #|Content-Type: multipart/mixed; boundary="b1"
  #|
  #|--b1
  #|Content-Type: text/plain; charset=utf-8
  #|
  #|Here is the map.
  #|--b1
  #|Content-Type: image/png
  #|Content-Disposition: attachment; filename="map.png"
  #|Content-Transfer-Encoding: base64
  #|
  #|iVBORw0KGgo=
  #|--b1--
  #|,

///|
test "body: the three lists RFC 8621 section 4.1.4 ends with" {
  let raw = message_bytes(rfc_structure)
  let message = @moonmail.Message::parse(raw[:]) catch {
    _ => fail("the message parses")
  }
  let body = email_body_of(message)
  assert_eq(body.structure.media_type, "multipart/mixed")
  // Ten leaves: five text parts, three images, one excel file and an attached
  // letter that is not walked into.
  assert_eq(body.structure.leaves().length(), 10)
  assert_eq(types(body.text), [
    "text/plain", "text/plain", "image/jpeg", "text/plain", "text/plain",
  ])
  assert_eq(types(body.html), ["text/plain", "text/html", "text/plain"])
  assert_eq(types(body.attachments), [
    "image/jpeg", "image/jpeg", "image/jpeg", "application/vnd.ms-excel", "message/rfc822",
  ])
}

///|
test "body: a part is named by the position it was numbered in" {
  let raw = message_bytes(rfc_structure)
  let message = @moonmail.Message::parse(raw[:]) catch {
    _ => fail("the message parses")
  }
  let body = email_body_of(message)
  let leaves = body.structure.leaves()
  let ids = leaves.map(fn(part) { part.part_id })
  assert_eq(ids, [
    Some("1"),
    Some("2"),
    Some("3"),
    Some("4"),
    Some("5"),
    Some("6"),
    Some("7"),
    Some("8"),
    Some("9"),
    Some("10"),
  ])
  // A multipart has no partId and no octets of its own.
  assert_eq(body.structure.part_id, None)
  assert_eq(body.structure.blob_id, None)
}

///|
test "body: a part carries its own headers and the charset it was sent with" {
  let raw = message_bytes(rfc_structure)
  let message = @moonmail.Message::parse(raw[:]) catch {
    _ => fail("the message parses")
  }
  let body = email_body_of(message)
  let attachment = body.attachments[2]
  assert_eq(attachment.name, Some("g.jpg"))
  assert_eq(attachment.disposition, Some("attachment"))
  // The MIME default, said out loud, because a text part without a charset is
  // us-ascii whether or not anyone wrote it.
  assert_eq(body.text[0].charset, Some("us-ascii"))
  assert_eq(attachment.charset, None)
}

///|
test "message: a letter becomes the object Email/get answers with" {
  let raw = message_bytes(alternative_message)
  let email_json = email_from_message(
    raw[:],
    mailbox_ids=["mb-in"],
    keywords=["$seen"],
    received_at="2026-11-06T12:00:01Z",
    blob_id="B1",
    thread_id="t-1",
    id="em-1",
  ) catch {
    _ => fail("the message becomes an object")
  }
  assert_eq(text_at(email_json, "id"), Some("em-1"))
  assert_eq(text_at(email_json, "blobId"), Some("B1"))
  assert_eq(text_at(email_json, "threadId"), Some("t-1"))
  assert_eq(text_at(email_json, "subject"), Some("Lunch?"))
  assert_eq(text_at(email_json, "preview"), Some("Noon works."))
  assert_eq(number_at(email_json, "size"), Some(raw.length()))
  assert_eq(text_at(email_json, "sentAt"), Some("2026-11-06T12:00:00Z"))
  assert_eq(boolean_at(email_json, "hasAttachment"), Some(false))
  assert_eq(
    key(email_json, "mailboxIds"),
    Some(object([("mb-in", Json::boolean(true))])),
  )
  assert_eq(
    key(email_json, "keywords"),
    Some(object([("$seen", Json::boolean(true))])),
  )
  assert_eq(
    key(email_json, "messageId"),
    Some(Json::array([Json::string("lunch@example.com")])),
  )
  assert_eq(
    key(email_json, "references"),
    Some(
      Json::array([
        Json::string("first@example.com"),
        Json::string("earlier@example.com"),
      ]),
    ),
  )
  // The alternative has both representations, so the plain text list has the
  // text part and the HTML list has the HTML one.
  let text = match key(email_json, "textBody") {
    Some(Json::Array(parts)) => parts
    _ => fail("textBody is an array")
  }
  let html = match key(email_json, "htmlBody") {
    Some(Json::Array(parts)) => parts
    _ => fail("htmlBody is an array")
  }
  assert_eq(text.length(), 1)
  assert_eq(html.length(), 1)
  assert_eq(text_at(text[0], "type"), Some("text/plain"))
  assert_eq(text_at(html[0], "type"), Some("text/html"))
}

///|
test "message: an attachment makes hasAttachment true and the preview plain" {
  let raw = message_bytes(attached_message)
  let email_json = email_from_message(raw[:], mailbox_ids=["mb-in"]) catch {
    _ => fail("the message becomes an object")
  }
  assert_eq(boolean_at(email_json, "hasAttachment"), Some(true))
  let attachments = match key(email_json, "attachments") {
    Some(Json::Array(parts)) => parts
    _ => fail("attachments is an array")
  }
  assert_eq(attachments.length(), 1)
  assert_eq(text_at(attachments[0], "name"), Some("map.png"))
  assert_eq(text_at(attachments[0], "type"), Some("image/png"))
  // The bytes are the decoded ones, which is what a blob would carry.
  assert_eq(number_at(attachments[0], "size"), Some(8))
}
