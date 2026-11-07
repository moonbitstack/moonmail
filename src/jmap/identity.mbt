// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// An address the account may send from (RFC 8621 section 6). A submission
/// names one of these, so it is what a client fetches before it offers to
/// write anything.
#derive(Eq, Debug)
pub(all) struct Identity {
  id : String
  name : String?
  email : String
  signature : String
  may_delete : Bool
}

///|
pub extend Identity with Eq::{equal, not_equal}

///|
pub extend Identity with Debug::{to_repr}

///|
pub fn Identity::parse(json : Json) -> Identity {
  {
    id: text_opt(json, "id").unwrap_or(""),
    name: text_opt(json, "name"),
    email: text_opt(json, "email").unwrap_or(""),
    signature: text_opt(json, "textSignature").unwrap_or(""),
    may_delete: flag(json, "mayDelete"),
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
    out.push(Identity::parse(entry))
  }
  out
}

///|
/// One identity to create: the address it may send from, and how it signs.
pub fn identity(name : String, email : String, signature? : String) -> Json {
  let pairs : Array[(String, Json)] = [
    ("name", Json::string(name)),
    ("email", Json::string(email)),
  ]
  match signature {
    Some(value) => pairs.push(("textSignature", Json::string(value)))
    None => ()
  }
  object(pairs)
}

///|
/// `Identity/get` (RFC 8621 section 6): the addresses the account may send
/// from.
pub fn Request::identity_get(
  self : Request,
  account : String,
  ids? : Array[String],
  properties? : Array[String],
) -> String {
  self.get(account, Kind::Identity, ids?, properties?)
}

///|
/// `Identity/set` (RFC 8621 section 6.3): a new sending address, or a changed
/// signature on an existing one. A server may refuse an address the user is not
/// allowed to send from with `forbiddenFrom`.
pub fn Request::identity_set(
  self : Request,
  account : String,
  create? : Map[String, Json],
  update? : Map[String, Json],
  destroy? : Array[String],
  if_in_state? : String,
) -> String {
  self.set(account, Kind::Identity, create?, update?, destroy?, if_in_state?)
}
