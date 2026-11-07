// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// One correspondent of an address header (RFC 8621 section 4.1.2.3). The
/// display name is decoded; the address is the addr-spec as written.
#derive(Eq, Debug)
pub(all) struct EmailAddress {
  name : String?
  email : String
}

///|
pub extend EmailAddress with Eq::{equal, not_equal}

///|
pub extend EmailAddress with Debug::{to_repr}

///|
pub fn EmailAddress::parse(json : Json) -> EmailAddress {
  {
    name: text_opt(json, "name"),
    email: text_opt(json, "email").unwrap_or(""),
  }
}

///|
/// The address the way a header would write it: `Alice <alice@example.com>`, or
/// the bare address when there is no name.
pub fn EmailAddress::to_string(self : EmailAddress) -> String {
  match self.name {
    Some(name) if name != "" => name + " <" + self.email + ">"
    _ => self.email
  }
}

///|
pub fn EmailAddress::of_header(header : @moonmail.Mailbox) -> EmailAddress {
  { name: header.name, email: header.address, }
}

///|
/// One header field of a message, in the order and the capitalisation the
/// message has it (RFC 8621 section 4.1.3).
#derive(Eq, Debug)
pub(all) struct EmailHeader {
  name : String
  value : String
}

///|
pub extend EmailHeader with Eq::{equal, not_equal}

///|
pub extend EmailHeader with Debug::{to_repr}

///|
pub fn EmailHeader::parse(json : Json) -> EmailHeader {
  {
    name: text_opt(json, "name").unwrap_or(""),
    value: text_opt(json, "value").unwrap_or(""),
  }
}

///|
/// The text of a part, decoded by the server so the client need not fetch the
/// blob (RFC 8621 section 4.1.4).
#derive(Eq, Debug)
pub(all) struct EmailBodyValue {
  value : String
  encoding_problem : Bool
  truncated : Bool
}

///|
pub extend EmailBodyValue with Eq::{equal, not_equal}

///|
pub extend EmailBodyValue with Debug::{to_repr}

///|
pub fn EmailBodyValue::parse(json : Json) -> EmailBodyValue {
  {
    value: text_opt(json, "value").unwrap_or(""),
    encoding_problem: flag(json, "isEncodingProblem"),
    truncated: flag(json, "isTruncated"),
  }
}

///|
/// One part of a message body (RFC 8621 section 4.1.4): a leaf with its decoded
/// size and its own headers, or a multipart with its children under it.
#derive(Eq, Debug)
pub(all) struct EmailBodyPart {
  part_id : String?
  blob_id : String?
  size : Int32
  headers : Array[EmailHeader]
  name : String?
  media_type : String
  charset : String?
  disposition : String?
  cid : String?
  language : Array[String]
  location : String?
  sub_parts : Array[EmailBodyPart]?
}

///|
pub extend EmailBodyPart with Eq::{equal, not_equal}

///|
pub extend EmailBodyPart with Debug::{to_repr}

///|
pub fn EmailBodyPart::parse(json : Json) -> EmailBodyPart {
  let headers : Array[EmailHeader] = []
  for entry in list_or_empty(json, "headers") {
    headers.push(EmailHeader::parse(entry))
  }
  let sub_parts : Array[EmailBodyPart]? = match optional(json, "subParts") {
    Some(Json::Array(entries)) =>
      Some(entries.map(fn(entry) { EmailBodyPart::parse(entry) }))
    _ => None
  }
  {
    part_id: text_opt(json, "partId"),
    blob_id: text_opt(json, "blobId"),
    size: int(json, "size"),
    headers,
    name: text_opt(json, "name"),
    media_type: text_opt(json, "type").unwrap_or("text/plain"),
    charset: text_opt(json, "charset"),
    disposition: text_opt(json, "disposition"),
    cid: text_opt(json, "cid"),
    language: string_list(json, "language"),
    location: text_opt(json, "location"),
    sub_parts,
  }
}

///|
/// The part as JSON, with a property that means nothing here left out rather
/// than written as null: a multipart has no `partId` and no `blobId`, and
/// saying so with null is what the type allows.
pub fn EmailBodyPart::to_json(self : EmailBodyPart) -> Json {
  let pairs : Array[(String, Json)] = [
    ("size", number(self.size)),
    ("type", Json::string(self.media_type)),
  ]
  match self.part_id {
    Some(value) => pairs.push(("partId", Json::string(value)))
    None => pairs.push(("partId", Json::null()))
  }
  match self.blob_id {
    Some(value) => pairs.push(("blobId", Json::string(value)))
    None => pairs.push(("blobId", Json::null()))
  }
  if !self.headers.is_empty() {
    pairs.push(
      (
        "headers",
        Json::array(
          self.headers.map(fn(header) {
            object([
              ("name", Json::string(header.name)),
              ("value", Json::string(header.value)),
            ])
          }),
        ),
      ),
    )
  }
  for
    pair in [
      ("name", self.name),
      ("charset", self.charset),
      ("disposition", self.disposition),
      ("cid", self.cid),
      ("location", self.location),
    ] {
    match pair.1 {
      Some(value) => pairs.push((pair.0, Json::string(value)))
      None => ()
    }
  }
  if !self.language.is_empty() {
    pairs.push(("language", strings(self.language)))
  }
  match self.sub_parts {
    Some(parts) =>
      pairs.push(
        ("subParts", Json::array(parts.map(fn(part) { part.to_json() }))),
      )
    None => ()
  }
  object(pairs)
}

///|
/// A letter as a list shows it: the metadata, the sender written the way a
/// header writes it, and the flag a reader looks for. The whole object is
/// `email_object`, which is JSON because RFC 8621 leaves it open-ended —
/// `header:Subject:asText:all` is a property like any other.
#derive(Eq, Debug)
pub(all) struct Email {
  id : String
  subject : String
  from : String?
  received_at : String?
  preview : String
  unread : Bool
}

///|
pub extend Email with Eq::{equal, not_equal}

///|
pub extend Email with Debug::{to_repr}

///|
/// The properties a list of letters shows. Each one is expected to be fast to
/// fetch (RFC 8621 section 4.2), which is why the list stops here.
pub let email_properties : Array[String] = [
  "id", "threadId", "mailboxIds", "keywords", "size", "receivedAt", "from", "subject",
  "sentAt", "hasAttachment", "preview",
]

///|
fn one_address(json : Json) -> String? {
  match json {
    Json::Array(entries) =>
      if entries.is_empty() {
        None
      } else {
        let first = entries[0]
        let email = text_opt(first, "email").unwrap_or("")
        match text_opt(first, "name") {
          Some(name) if name != "" => Some(name + " <" + email + ">")
          _ => if email == "" { None } else { Some(email) }
        }
      }
    _ => None
  }
}

///|
pub fn Email::parse(json : Json) -> Email {
  {
    id: text_opt(json, "id").unwrap_or(""),
    subject: text_opt(json, "subject").unwrap_or("(no subject)"),
    from: one_address(field_or_null(json, "from")),
    received_at: text_opt(json, "receivedAt"),
    preview: text_opt(json, "preview").unwrap_or(""),
    unread: !seen_keyword(json),
  }
}

///|
fn seen_keyword(json : Json) -> Bool {
  match optional(json, "keywords") {
    Some(Json::Object(keywords)) =>
      match keywords.get("$seen") {
        Some(Json::True) => true
        _ => false
      }
    _ => false
  }
}

///|
fn field_or_null(json : Json, name : String) -> Json {
  match optional(json, name) {
    Some(value) => value
    None => Json::null()
  }
}

///|
/// The letters in an `Email/get` answer.
pub fn emails(response : Response, tag : String) -> Array[Email] raise Refused {
  let answer = response.answer(tag)
  let out : Array[Email] = []
  for entry in items(answer.args, "list") {
    out.push(Email::parse(entry))
  }
  out
}

///|
/// The ids an `Email/query` answer lists, in the order the server sorted them.
pub fn email_ids(
  response : Response,
  tag : String,
) -> Array[String] raise Refused {
  let answer = response.answer(tag)
  string_list(answer.args, "ids")
}

///|
/// The one letter an `Email/get` answer carries, whole, as the JSON the server
/// sent: every property an `Email` has is here, including the `header:…` ones
/// this library does not name.
pub fn email_object(response : Response, tag : String) -> Json raise Refused {
  let answer = response.answer(tag)
  match items(answer.args, "list") {
    [first, ..] => first
    [] => raise Refused::Missing(name="list")
  }
}

///|
/// The body structure of a letter out of its JSON, or none when the request did
/// not ask for it.
pub fn body_structure(json : Json) -> EmailBodyPart? {
  match optional(json, "bodyStructure") {
    Some(structure) => Some(EmailBodyPart::parse(structure))
    None => None
  }
}

///|
/// The leaves of a body tree, depth first, which is the order RFC 8621's
/// decomposition walks them in.
pub fn EmailBodyPart::leaves(self : EmailBodyPart) -> Array[EmailBodyPart] {
  let out : Array[EmailBodyPart] = []
  match self.sub_parts {
    Some(parts) =>
      for part in parts {
        out.push_iter(part.leaves().iter())
      }
    None => out.push(self)
  }
  out
}

///|
/// A letter to write, before the server has given it an id.
pub(all) struct Draft {
  from : String?
  to : Array[String]
  cc : Array[String]
  bcc : Array[String]
  subject : String
  text : String
}

///|
pub fn Draft::new(
  to~ : Array[String],
  subject~ : String,
  text~ : String,
) -> Draft {
  { from: None, to, cc: [], bcc: [], subject, text, }
}

///|
fn addressed(value : String) -> Json {
  object([("email", Json::string(value))])
}

///|
fn address_list(values : Array[String]) -> Json {
  Json::array(values.map(fn(value) { addressed(value) }))
}

///|
/// `Email/query` (RFC 8621 section 4.4): the ids in one mailbox, newest first.
/// The ids say nothing about the messages, so `email_get` follows.
pub fn Request::email_query(
  self : Request,
  account : String,
  mailbox : String,
  limit : Int32,
) -> String {
  self.using_capability(Kind::Email.capability())
  let args = query_args(
    account,
    Some(object([("inMailbox", Json::string(mailbox))])),
    Some([Comparator::new(property="receivedAt", ascending=false)]),
    None,
    None,
    None,
    Some(limit),
    None,
  )
  self.call("Email/query", object(args))
}

///|
/// `Email/set` with one `create` (RFC 8621 section 4.6): a draft in the given
/// mailbox. The body goes as `textBody` with a `bodyValues` entry, which is
/// the shape a server expects when it renders the letter itself.
pub fn Request::email_set_draft(
  self : Request,
  account : String,
  mailbox : String,
  draft : Draft,
) -> String {
  let properties : Array[(String, Json)] = [
    ("mailboxIds", flagged([mailbox])),
    ("keywords", flagged(["$draft"])),
    ("subject", Json::string(draft.subject)),
    (
      "textBody",
      Json::array([
        object([
          ("partId", Json::string("body")),
          ("type", Json::string("text/plain")),
        ]),
      ]),
    ),
    (
      "bodyValues",
      object([("body", object([("value", Json::string(draft.text))]))]),
    ),
    ("to", address_list(draft.to)),
  ]
  if !draft.cc.is_empty() {
    properties.push(("cc", address_list(draft.cc)))
  }
  if !draft.bcc.is_empty() {
    properties.push(("bcc", address_list(draft.bcc)))
  }
  match draft.from {
    Some(from) => properties.push(("from", Json::array([addressed(from)])))
    None => ()
  }
  self.call(
    "Email/set",
    object([
      ("accountId", Json::string(account)),
      ("create", object([("draft", object(properties))])),
    ]),
  )
}

///|
/// `Email/set` with one `update` (RFC 8621 section 4.6): change a letter that
/// already exists. The patch keys are paths, so `keywords/$seen` sets one
/// keyword without rewriting the map, and `mailboxIds` replaces the set of
/// mailboxes the letter is filed in.
pub fn Request::email_set_update(
  self : Request,
  account : String,
  id : String,
  patch : Array[(String, Json)],
) -> String {
  self.call(
    "Email/set",
    object([
      ("accountId", Json::string(account)),
      ("update", object([(id, object(patch))])),
    ]),
  )
}

///|
/// Mark a letter read or unread. This is the write a mail client performs more
/// than any other, and the one a reader notices if it is wrong.
pub fn Request::email_mark_seen(
  self : Request,
  account : String,
  id : String,
  seen : Bool,
) -> String {
  self.email_set_update(account, id, [("keywords/$seen", Json::boolean(seen))])
}

///|
/// File a letter in a mailbox. JMAP replaces the set, so the letter ends up in
/// `mailbox` and nowhere else — one mailbox is how a move is spelled.
pub fn Request::email_move(
  self : Request,
  account : String,
  id : String,
  mailbox : String,
) -> String {
  self.email_set_update(account, id, [("mailboxIds", flagged([mailbox]))])
}

///|
/// `Email/set` with one `destroy`: delete a letter for good, not into Trash.
/// Moving to the trash mailbox is `email_move`, and a client that offers
/// "delete" should say which of the two it means.
pub fn Request::email_destroy(
  self : Request,
  account : String,
  id : String,
) -> String {
  self.call(
    "Email/set",
    object([
      ("accountId", Json::string(account)),
      ("destroy", Json::array([Json::string(id)])),
    ]),
  )
}
