// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// A `set` answer is per record, not per call: some creations succeed while
/// others are refused, and the client matches each by the creation id it chose
/// (RFC 8620 section 5.3). These three readers are that answer.

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

///|
/// Why one creation was refused, in the server's own words, or none when it was
/// not refused. `arguments` is the `notCreated` entry, which carries whatever
/// the SetError type defines beside `type`.
pub fn not_created(
  response : Response,
  tag : String,
  creation : String,
) -> Json? raise Refused {
  let answer = response.answer(tag)
  match optional(answer.args, "notCreated") {
    Some(Json::Object(refused)) => refused.get(creation)
    _ => None
  }
}

///|
/// The ids a `set` changed, and the server's state after it: the pair a client
/// needs before it fetches again.
pub fn updated_ids(
  response : Response,
  tag : String,
) -> Array[String] raise Refused {
  let answer = response.answer(tag)
  let out : Array[String] = []
  match optional(answer.args, "updated") {
    Some(Json::Object(updated)) =>
      for id, _ in updated {
        out.push(id)
      }
    _ => ()
  }
  out
}

///|
/// The state string a `set` answered with, which the next `/changes` call uses
/// as its `sinceState`.
pub fn new_state(response : Response, tag : String) -> String raise Refused {
  let answer = response.answer(tag)
  text_opt(answer.args, "newState").unwrap_or("")
}
