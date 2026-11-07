// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The rights the user has in one mailbox (RFC 8621 section 2), spelled the way
/// IMAP ACLs are so a server that also speaks IMAP has one answer to give.
#derive(Eq, Debug)
pub(all) struct Rights {
  may_read_items : Bool
  may_add_items : Bool
  may_remove_items : Bool
  may_set_seen : Bool
  may_set_keywords : Bool
  may_create_child : Bool
  may_rename : Bool
  may_delete : Bool
  may_submit : Bool
}

///|
pub extend Rights with Eq::{equal, not_equal}

///|
pub extend Rights with Debug::{to_repr}

///|
/// A mailbox as `Mailbox/get` reports it. Role is the well-known name — `inbox`,
/// `sent`, `drafts`, `trash` — and says what the mailbox is for regardless of
/// what it is called in the user's language.
#derive(Eq, Debug)
pub(all) struct Mailbox {
  id : String
  name : String
  role : String?
  parent_id : String?
  total : Int32
  unread : Int32
  total_threads : Int32
  unread_threads : Int32
  sort_order : Int32
  is_subscribed : Bool
  rights : Rights?
}

///|
pub extend Mailbox with Eq::{equal, not_equal}

///|
pub extend Mailbox with Debug::{to_repr}

///|
/// The properties a list of folders shows. Asking for the counts of a mailbox
/// is what makes a folder list cost anything, so the shortcut the reading code
/// uses stops here.
pub let mailbox_properties : Array[String] = [
  "id", "name", "role", "parentId", "totalEmails", "unreadEmails", "totalThreads",
  "unreadThreads", "sortOrder", "isSubscribed", "myRights",
]

///|
fn mailbox_rights(json : Json) -> Rights? {
  match optional(json, "myRights") {
    Some(rights) =>
      Some({
        may_read_items: flag(rights, "mayReadItems"),
        may_add_items: flag(rights, "mayAddItems"),
        may_remove_items: flag(rights, "mayRemoveItems"),
        may_set_seen: flag(rights, "maySetSeen"),
        may_set_keywords: flag(rights, "maySetKeywords"),
        may_create_child: flag(rights, "mayCreateChild"),
        may_rename: flag(rights, "mayRename"),
        may_delete: flag(rights, "mayDelete"),
        may_submit: flag(rights, "maySubmit"),
      })
    None => None
  }
}

///|
fn flag(json : Json, name : String) -> Bool {
  match optional(json, name) {
    Some(Json::True) => true
    _ => false
  }
}

///|
/// One mailbox, from the JSON a server answered with. A property the request
/// did not ask for reads as its default rather than as an error: JMAP leaves it
/// out, and a reader that failed on that could not ask for less.
pub fn Mailbox::parse(json : Json) -> Mailbox {
  {
    id: text_opt(json, "id").unwrap_or(""),
    name: text_opt(json, "name").unwrap_or(""),
    role: text_opt(json, "role"),
    parent_id: text_opt(json, "parentId"),
    total: int(json, "totalEmails"),
    unread: int(json, "unreadEmails"),
    total_threads: int(json, "totalThreads"),
    unread_threads: int(json, "unreadThreads"),
    sort_order: int(json, "sortOrder"),
    is_subscribed: flag(json, "isSubscribed"),
    rights: mailbox_rights(json),
  }
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
    out.push(Mailbox::parse(entry))
  }
  out
}

///|
/// The ids in a `Mailbox/query` answer, in the order the server sorted them.
pub fn mailbox_ids(
  response : Response,
  tag : String,
) -> Array[String] raise Refused {
  let answer = response.answer(tag)
  string_list(answer.args, "ids")
}

///|
/// `Mailbox/get` (RFC 8621 section 2.1): every mailbox in the account, with the
/// counts the list needs.
pub fn Request::mailbox_get(
  self : Request,
  account : String,
  ids? : Array[String],
  properties? : Array[String],
) -> String {
  self.get(
    account,
    Kind::Mailbox,
    ids?,
    properties=properties.unwrap_or(mailbox_properties),
  )
}
