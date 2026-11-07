// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// One envelope address with its ESMTP parameters (RFC 8621 section 7.1): the
/// `NOTIFY` and `ORCPT` a delivery status request travels in. A parameter that
/// takes no value reads as `Some("")` rather than as missing.
#derive(Eq, Debug)
pub(all) struct Address {
  email : String
  parameters : Map[String, String]
}

///|
pub extend Address with Eq::{equal, not_equal}

///|
pub extend Address with Debug::{to_repr}

///|
pub fn Address::parse(json : Json) -> Address {
  let parameters : Map[String, String] = Map([])
  match optional(json, "parameters") {
    Some(Json::Object(values)) =>
      for name, value in values {
        match value {
          Json::String(text) => parameters[name] = text
          _ => parameters[name] = ""
        }
      }
    _ => ()
  }
  { email: text_opt(json, "email").unwrap_or(""), parameters, }
}

///|
/// The SMTP envelope of a submission (RFC 8621 section 7.1), which is what the
/// dialogue says rather than what the headers read.
#derive(Eq, Debug)
pub(all) struct Envelope {
  mail_from : Address
  rcpt_to : Array[Address]
}

///|
pub extend Envelope with Eq::{equal, not_equal}

///|
pub extend Envelope with Debug::{to_repr}

///|
pub fn Envelope::parse(json : Json) -> Envelope {
  let rcpt_to : Array[Address] = []
  for entry in list_or_empty(json, "rcptTo") {
    rcpt_to.push(Address::parse(entry))
  }
  { mail_from: Address::parse(field_or_null(json, "mailFrom")), rcpt_to, }
}

///|
/// How far one recipient's copy has got (RFC 8621 section 7.1).
#derive(Eq, Debug)
pub(all) struct DeliveryStatus {
  smtp_reply : String
  delivered : String
  displayed : String
}

///|
pub extend DeliveryStatus with Eq::{equal, not_equal}

///|
pub extend DeliveryStatus with Debug::{to_repr}

///|
pub fn DeliveryStatus::parse(json : Json) -> DeliveryStatus {
  {
    smtp_reply: text_opt(json, "smtpReply").unwrap_or(""),
    delivered: text_opt(json, "delivered").unwrap_or("unknown"),
    displayed: text_opt(json, "displayed").unwrap_or("unknown"),
  }
}

///|
/// One sending of one letter (RFC 8621 section 7.1). `undo_status` says whether
/// it can still be called back: `pending` while it can, `final` once at least
/// one recipient's copy has left in a way that cannot be recalled.
#derive(Eq, Debug)
pub(all) struct EmailSubmission {
  id : String
  identity_id : String
  email_id : String
  thread_id : String?
  envelope : Envelope?
  send_at : String?
  undo_status : String
  delivery : Map[String, DeliveryStatus]
}

///|
pub extend EmailSubmission with Eq::{equal, not_equal}

///|
pub extend EmailSubmission with Debug::{to_repr}

///|
pub fn EmailSubmission::parse(json : Json) -> EmailSubmission {
  let delivery : Map[String, DeliveryStatus] = Map([])
  match optional(json, "deliveryStatus") {
    Some(Json::Object(statuses)) =>
      for recipient, status in statuses {
        delivery[recipient] = DeliveryStatus::parse(status)
      }
    _ => ()
  }
  {
    id: text_opt(json, "id").unwrap_or(""),
    identity_id: text_opt(json, "identityId").unwrap_or(""),
    email_id: text_opt(json, "emailId").unwrap_or(""),
    thread_id: text_opt(json, "threadId"),
    envelope: match optional(json, "envelope") {
      Some(envelope) => Some(Envelope::parse(envelope))
      None => None
    },
    send_at: text_opt(json, "sendAt"),
    undo_status: text_opt(json, "undoStatus").unwrap_or("final"),
    delivery,
  }
}

///|
/// The submissions an `EmailSubmission/get` answer carries.
pub fn submissions(
  response : Response,
  tag : String,
) -> Array[EmailSubmission] raise Refused {
  let answer = response.answer(tag)
  let out : Array[EmailSubmission] = []
  for entry in items(answer.args, "list") {
    out.push(EmailSubmission::parse(entry))
  }
  out
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
  envelope? : Json,
  send_at? : String,
  on_success_update_email? : Json,
  on_success_destroy_email? : Bool,
) -> String {
  self.using_capability(Kind::EmailSubmission.capability())
  let args = set_args(
    account,
    Some(
      Map([
        (
          "submission",
          submission_new(identity~, email=email_id, envelope?, send_at?),
        ),
      ]),
    ),
    None,
    None,
    None,
  )
  match on_success_update_email {
    Some(patch) => args.push(("onSuccessUpdateEmail", patch))
    None => ()
  }
  match on_success_destroy_email {
    Some(value) => args.push(("onSuccessDestroyEmail", Json::boolean(value)))
    None => ()
  }
  self.call("EmailSubmission/set", object(args))
}

///|
/// Calling a submission back: the only update a submission takes is
/// `undoStatus`, and only while it is `pending` (RFC 8621 section 7.5).
pub fn Request::email_submission_cancel(
  self : Request,
  account : String,
  id : String,
) -> String {
  self.using_capability(Kind::EmailSubmission.capability())
  self.call(
    "EmailSubmission/set",
    object([
      ("accountId", Json::string(account)),
      (
        "update",
        object([(id, object([("undoStatus", Json::string("canceled"))]))]),
      ),
    ]),
  )
}
