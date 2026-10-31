// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// A mailbox as `Mailbox/get` reports it. Role is the well-known name — `inbox`,
/// `sent`, `drafts`, `trash` — and says what the mailbox is for regardless of
/// what it is called in the user's language.
pub(all) struct Mailbox {
  id : String
  name : String
  role : String?
  parent_id : String?
  total : Int32
  unread : Int32
} derive(Eq, Debug)

///|
pub extend Mailbox with Eq::{equal, not_equal}

///|
pub extend Mailbox with Debug::{to_repr}

///|
/// A letter as `Email/get` reports it, reduced to what a list shows. `from` is
/// the first sender, already written the way a header writes it.
pub(all) struct Email {
  id : String
  subject : String
  from : String?
  received_at : String?
  preview : String
  unread : Bool
} derive(Eq, Debug)

///|
pub extend Email with Eq::{equal, not_equal}

///|
pub extend Email with Debug::{to_repr}

///|
/// An address the account may send from (RFC 8621 section 6). A submission
/// names one of these.
pub(all) struct Identity {
  id : String
  name : String?
  email : String
} derive(Eq, Debug)

///|
pub extend Identity with Eq::{equal, not_equal}

///|
pub extend Identity with Debug::{to_repr}

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
fn string_list(json : Json, name : String) -> Array[String] {
  let out : Array[String] = []
  match optional(json, name) {
    Some(Json::Array(entries)) =>
      for entry in entries {
        match entry {
          Json::String(value) => out.push(value)
          _ => ()
        }
      }
    _ => ()
  }
  out
}

///|
/// The mailboxes in a `Mailbox/get` answer.
pub fn mailboxes(
  response : Response,
  tag : String,
) -> Array[Mailbox] raise Refused {
  let answer = response.answer(tag)
  let out : Array[Mailbox] = []
  for entry in items(answer.args, "list") {
    out.push({
      id: text(entry, "id"),
      name: text(entry, "name"),
      role: text_opt(entry, "role"),
      parent_id: text_opt(entry, "parentId"),
      total: int(entry, "totalEmails"),
      unread: int(entry, "unreadEmails"),
    })
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
/// The letters in an `Email/get` answer.
pub fn emails(response : Response, tag : String) -> Array[Email] raise Refused {
  let answer = response.answer(tag)
  let out : Array[Email] = []
  for entry in items(answer.args, "list") {
    let keywords = match optional(entry, "keywords") {
      Some(Json::Object(map)) => map
      _ => Map([])
    }
    out.push({
      id: text(entry, "id"),
      subject: text_opt(entry, "subject").unwrap_or("(no subject)"),
      from: one_address(field_or_null(entry, "from")),
      received_at: text_opt(entry, "receivedAt"),
      preview: text_opt(entry, "preview").unwrap_or(""),
      unread: keywords.get("$seen") is None,
    })
  }
  out
}

///|
fn field_or_null(json : Json, name : String) -> Json {
  match optional(json, name) {
    Some(value) => value
    None => Json::null()
  }
}

///|
/// The identities an `Identity/get` answer lists.
pub fn identities(
  response : Response,
  tag : String,
) -> Array[Identity] raise Refused {
  let answer = response.answer(tag)
  let out : Array[Identity] = []
  for entry in items(answer.args, "list") {
    out.push({
      id: text(entry, "id"),
      name: text_opt(entry, "name"),
      email: text_opt(entry, "email").unwrap_or(""),
    })
  }
  out
}

///|
/// The server-side id of something a `set` created, looked up by the creation
/// id the request used. A `notCreated` entry is a refusal, and reads as one.
pub fn created_id(
  response : Response,
  tag : String,
  creation : String,
) -> String raise Refused {
  let answer = response.answer(tag)
  match optional(answer.args, "notCreated") {
    Some(Json::Object(refused)) =>
      match refused.get(creation) {
        Some(failure) =>
          raise Refused::Failed(
            call=answer.name,
            kind=text_opt(failure, "type").unwrap_or("unknown"),
            description=text_opt(failure, "description").unwrap_or(""),
          )
        None => ()
      }
    _ => ()
  }
  match optional(answer.args, "created") {
    Some(Json::Object(created)) =>
      match created.get(creation) {
        Some(Json::Object(entry)) => text(Json::object(entry), "id")
        _ => raise Refused::Missing(name=creation)
      }
    _ => raise Refused::Missing(name=creation)
  }
}
