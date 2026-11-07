// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The automatic answer an account sends while nobody reads it (RFC 8621
/// section 8). There is one per account, its id is `singleton`, and a date left
/// out means "from now on".
#derive(Eq, Debug)
pub(all) struct VacationResponse {
  id : String
  enabled : Bool
  from_date : String?
  to_date : String?
  subject : String?
  text_body : String?
  html_body : String?
}

///|
pub extend VacationResponse with Eq::{equal, not_equal}

///|
pub extend VacationResponse with Debug::{to_repr}

///|
pub fn VacationResponse::parse(json : Json) -> VacationResponse {
  {
    id: text_opt(json, "id").unwrap_or("singleton"),
    enabled: flag(json, "isEnabled"),
    from_date: text_opt(json, "fromDate"),
    to_date: text_opt(json, "toDate"),
    subject: text_opt(json, "subject"),
    text_body: text_opt(json, "textBody"),
    html_body: text_opt(json, "htmlBody"),
  }
}

///|
/// The vacation response a `VacationResponse/get` answer carries, which is at
/// most one.
pub fn vacation_response_of(
  response : Response,
  tag : String,
) -> VacationResponse? raise Refused {
  let answer = response.answer(tag)
  match items(answer.args, "list") {
    [first, ..] => Some(VacationResponse::parse(first))
    [] => None
  }
}

///|
/// `VacationResponse/get` (RFC 8621 section 8.1): the singleton, which a server
/// that does not answer while away reports as disabled.
pub fn Request::vacation_response_get(
  self : Request,
  account : String,
) -> String {
  self.get(account, Kind::VacationResponse, ids=["singleton"])
}

///|
/// `VacationResponse/set` (RFC 8621 section 8.2): turn the answer on, and say
/// what it says. The update key is `singleton`, not an id the caller chose.
pub fn Request::vacation_response_set(
  self : Request,
  account : String,
  response : Json,
  if_in_state? : String,
) -> String {
  self.set(
    account,
    Kind::VacationResponse,
    update=Map([("singleton", response)]),
    if_in_state?,
  )
}
