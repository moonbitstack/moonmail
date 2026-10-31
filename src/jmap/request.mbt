// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// One method call in a request: the name, its arguments, and the tag the
/// answer comes back under. Tags are how a server that reorders or batches
/// calls still lets a client match them up.
pub(all) struct Call {
  name : String
  args : Json
  tag : String
} derive(Eq, Debug)

///|
pub extend Call with Eq::{equal, not_equal}

///|
pub extend Call with Debug::{to_repr}

///|
/// A request document: the capabilities it uses and the calls it makes. RFC
/// 8620 section 3 makes one POST carry the whole lot, which is why the builders
/// below append rather than return a finished body.
pub(all) struct Request {
  capabilities : Array[String]
  calls : Array[Call]
} derive(Eq, Debug)

///|
pub extend Request with Eq::{equal, not_equal}

///|
pub extend Request with Debug::{to_repr}

///|
pub fn Request::new() -> Request {
  {
    capabilities: [
      "urn:ietf:params:jmap:core",
      "urn:ietf:params:jmap:mail",
      "urn:ietf:params:jmap:submission",
    ],
    calls: [],
  }
}

///|
/// Append a call and answer its tag: `c0`, `c1`, and so on.
pub fn Request::call(self : Request, name : String, args : Json) -> String {
  let tag = "c" + self.calls.length().to_string()
  self.calls.push({ name, args, tag })
  tag
}

///|
pub fn Request::to_json(self : Request) -> Json {
  let calls = self.calls.map(fn(call) {
    Json::array([
      Json::string(call.name),
      call.args,
      Json::string(call.tag),
    ])
  })
  object([("using", strings(self.capabilities)), ("methodCalls", Json::array(calls))])
}

///|
pub fn Request::to_string(self : Request) -> String {
  self.to_json().stringify()
}

///|
/// `Mailbox/get` (RFC 8621 section 2.2): every mailbox in the account, with
/// the counts the list needs.
pub fn Request::mailbox_get(self : Request, account : String) -> String {
  self.call(
    "Mailbox/get",
    object([
      ("accountId", Json::string(account)),
      (
        "properties",
        strings(["id", "name", "role", "parentId", "totalEmails", "unreadEmails"]),
      ),
    ]),
  )
}

///|
/// `Identity/get` (RFC 8621 section 6): the addresses the account may send
/// from. A submission names one, so this comes before any send.
pub fn Request::identity_get(self : Request, account : String) -> String {
  self.call("Identity/get", object([("accountId", Json::string(account))]))
}

///|
/// `Email/query` (RFC 8621 section 4.4): the ids in one mailbox, newest first.
/// The ids say nothing about the messages, so `email_get` follows.
pub fn Request::email_query(
  self : Request,
  account : String,
  mailbox : String,
  limit : Int,
) -> String {
  self.call(
    "Email/query",
    object([
      ("accountId", Json::string(account)),
      ("filter", object([("inMailbox", Json::string(mailbox))])),
      (
        "sort",
        Json::array([
          object([
            ("property", Json::string("receivedAt")),
            ("isAscending", Json::boolean(false)),
          ]),
        ]),
      ),
      ("limit", number(limit)),
    ]),
  )
}

///|
/// `Email/get` (RFC 8621 section 4.2): the properties a list of letters shows,
/// asked for by id.
pub fn Request::email_get(
  self : Request,
  account : String,
  ids : Array[String],
  properties : Array[String],
) -> String {
  self.call(
    "Email/get",
    object([
      ("accountId", Json::string(account)),
      ("ids", strings(ids)),
      ("properties", strings(properties)),
    ]),
  )
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
pub fn Draft::new(to~ : Array[String], subject~ : String, text~ : String) -> Draft {
  { from: None, to, cc: [], bcc: [], subject, text }
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
    ("mailboxIds", object([(mailbox, Json::boolean(true))])),
    ("keywords", object([("$draft", Json::boolean(true))])),
    ("subject", Json::string(draft.subject)),
    (
      "textBody",
      Json::array([
        object([("partId", Json::string("body")), ("type", Json::string("text/plain"))]),
      ]),
    ),
    ("bodyValues", object([("body", object([("value", Json::string(draft.text))]))])),
    ("to", address_list(draft.to)),
  ]
  if !draft.cc.is_empty() {
    properties.push(("cc", address_list(draft.cc)))
  }
  if !draft.bcc.is_empty() {
    properties.push(("bcc", address_list(draft.bcc)))
  }
  match draft.from {
    Some(from) =>
      properties.push(("from", Json::array([addressed(from)])))
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
/// `EmailSubmission/set` (RFC 8621 section 7.5): hand a stored letter to the
/// submission server. The letter has to exist first, so this always follows an
/// `Email/set` that created it.
pub fn Request::email_submission_set(
  self : Request,
  account : String,
  identity : String,
  email_id : String,
) -> String {
  self.call(
    "EmailSubmission/set",
    object([
      ("accountId", Json::string(account)),
      (
        "create",
        object([
          (
            "submission",
            object([
              ("identityId", Json::string(identity)),
              ("emailId", Json::string(email_id)),
            ]),
          ),
        ]),
      ),
    ]),
  )
}
