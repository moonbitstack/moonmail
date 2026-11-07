// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// A conversation (RFC 8621 section 3): the emails that belong together, oldest
/// first. JMAP has no thread objects of its own beyond the list of ids, because
/// what a thread is lives in the `References` and `Message-ID` fields of the
/// letters themselves.
#derive(Eq, Debug)
pub(all) struct Thread {
  id : String
  email_ids : Array[String]
}

///|
pub extend Thread with Eq::{equal, not_equal}

///|
pub extend Thread with Debug::{to_repr}

///|
pub fn Thread::parse(json : Json) -> Thread {
  {
    id: text_opt(json, "id").unwrap_or(""),
    email_ids: string_list(json, "emailIds"),
  }
}

///|
/// The threads a `Thread/get` answer carries.
pub fn threads(
  response : Response,
  tag : String,
) -> Array[Thread] raise Refused {
  let answer = response.answer(tag)
  let out : Array[Thread] = []
  for entry in items(answer.args, "list") {
    out.push(Thread::parse(entry))
  }
  out
}

///|
/// `Thread/get` (RFC 8621 section 3.1): the emails of one conversation, by
/// thread id.
pub fn Request::thread_get(
  self : Request,
  account : String,
  ids : Array[String],
) -> String {
  self.get(account, Kind::Thread, ids~)
}
