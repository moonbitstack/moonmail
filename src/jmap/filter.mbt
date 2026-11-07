// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// Filters and sorts as data a caller can build. A `FilterCondition` names the
/// properties to match; a `FilterOperator` combines conditions, and the three
/// operators are the whole of the grammar (RFC 8620 section 5.5) — everything
/// else is which properties a type lets you name.

///|
/// One condition: the given properties must all match. A condition with nothing
/// in it matches everything, which is how an unfiltered query is spelled.
pub fn condition(pairs : Array[(String, Json)]) -> Json {
  object(pairs)
}

///|
fn operator(kind : String, conditions : Array[Json]) -> Json {
  object([
    ("operator", Json::string(kind)),
    ("conditions", Json::array(conditions)),
  ])
}

///|
/// Every condition matches.
pub fn all_of(conditions : Array[Json]) -> Json {
  operator("AND", conditions)
}

///|
/// At least one condition matches.
pub fn any_of(conditions : Array[Json]) -> Json {
  operator("OR", conditions)
}

///|
/// No condition matches.
pub fn none_of(conditions : Array[Json]) -> Json {
  operator("NOT", conditions)
}

///|
/// The letters in one mailbox.
pub fn in_mailbox(id : String) -> Json {
  condition([("inMailbox", Json::string(id))])
}

///|
/// The letters in at least one mailbox outside this list, which is how a search
/// leaves out what is only in trash or spam.
pub fn in_mailbox_other_than(ids : Array[String]) -> Json {
  condition([("inMailboxOtherThan", strings(ids))])
}

///|
/// Received before this moment, written as a UTCDate.
pub fn before(stamp : String) -> Json {
  condition([("before", Json::string(stamp))])
}

///|
/// Received at or after this moment, written as a UTCDate.
pub fn after(stamp : String) -> Json {
  condition([("after", Json::string(stamp))])
}

///|
/// At least this many octets.
pub fn min_size(bytes : Int32) -> Json {
  condition([("minSize", number(bytes))])
}

///|
/// Fewer than this many octets.
pub fn max_size(bytes : Int32) -> Json {
  condition([("maxSize", number(bytes))])
}

///|
/// This letter carries the keyword.
pub fn has_keyword(keyword : String) -> Json {
  condition([("hasKeyword", Json::string(keyword))])
}

///|
/// This letter does not carry the keyword.
pub fn not_keyword(keyword : String) -> Json {
  condition([("notKeyword", Json::string(keyword))])
}

///|
/// The conversation has a letter with the keyword, wherever it is filed.
pub fn some_in_thread_have_keyword(keyword : String) -> Json {
  condition([("someInThreadHaveKeyword", Json::string(keyword))])
}

///|
/// Every letter of the conversation has the keyword.
pub fn all_in_thread_have_keyword(keyword : String) -> Json {
  condition([("allInThreadHaveKeyword", Json::string(keyword))])
}

///|
/// No letter of the conversation has the keyword.
pub fn none_in_thread_have_keyword(keyword : String) -> Json {
  condition([("noneInThreadHaveKeyword", Json::string(keyword))])
}

///|
/// There is something a reader would offer to download.
pub fn has_attachment() -> Json {
  condition([("hasAttachment", Json::boolean(true))])
}

///|
/// The text appears in a header or in the body, matched case-insensitively.
pub fn text_search(text : String) -> Json {
  condition([("text", Json::string(text))])
}

///|
/// The address appears in the From, To, Cc or Bcc field.
pub fn from_address(address : String) -> Json {
  condition([("from", Json::string(address))])
}

///|
pub fn to_address(address : String) -> Json {
  condition([("to", Json::string(address))])
}

///|
pub fn cc_address(address : String) -> Json {
  condition([("cc", Json::string(address))])
}

///|
pub fn bcc_address(address : String) -> Json {
  condition([("bcc", Json::string(address))])
}

///|
/// The subject contains the text.
pub fn subject_contains(subject : String) -> Json {
  condition([("subject", Json::string(subject))])
}

///|
/// The body contains the text, headers left out.
pub fn body_contains(body : String) -> Json {
  condition([("body", Json::string(body))])
}

///|
/// A header field of this name contains the text: `["Subject", "invoice"]`.
pub fn header_contains(name~ : String, value~ : String) -> Json {
  condition([("header", Json::array([Json::string(name), Json::string(value)]))])
}

///|
/// A mailbox directly under this one, or `None` for the top level.
pub fn child_of(parent : String?) -> Json {
  condition([
    (
      "parentId",
      match parent {
        Some(id) => Json::string(id)
        None => Json::null()
      },
    ),
  ])
}

///|
/// The mailbox name contains the text.
pub fn mailbox_name_contains(name : String) -> Json {
  condition([("name", Json::string(name))])
}

///|
/// The mailbox has this role: `inbox`, `sent`, `trash` and the rest.
pub fn with_role(role : String) -> Json {
  condition([("role", Json::string(role))])
}

///|
/// The mailbox has a role at all, which is how a list picks out the well-known
/// folders without knowing their names.
pub fn has_any_role() -> Json {
  condition([("hasAnyRole", Json::boolean(true))])
}

///|
/// The user subscribed to the mailbox.
pub fn subscribed() -> Json {
  condition([("isSubscribed", Json::boolean(true))])
}
