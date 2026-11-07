// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// What a search matched, quoted back (RFC 8621 section 5). The match is marked
/// with `<mark>` in the subject and the preview, which is why the pair travels
/// with the email id rather than as properties of the email.
#derive(Eq, Debug)
pub(all) struct SearchSnippet {
  email_id : String
  subject : String?
  preview : String?
}

///|
pub extend SearchSnippet with Eq::{equal, not_equal}

///|
pub extend SearchSnippet with Debug::{to_repr}

///|
pub fn SearchSnippet::parse(json : Json) -> SearchSnippet {
  {
    email_id: text_opt(json, "emailId").unwrap_or(""),
    subject: text_opt(json, "subject"),
    preview: text_opt(json, "preview"),
  }
}

///|
/// The snippets a `SearchSnippet/get` answer carries.
pub fn snippets(
  response : Response,
  tag : String,
) -> Array[SearchSnippet] raise Refused {
  let answer = response.answer(tag)
  let out : Array[SearchSnippet] = []
  for entry in items(answer.args, "list") {
    out.push(SearchSnippet::parse(entry))
  }
  out
}
