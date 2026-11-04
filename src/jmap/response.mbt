// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// One answer in a response: the method name, its arguments, and the tag the
/// call was made under. An `error` answer arrives as
/// `"error"` with the original name in `args`, which `raised` unwraps.
#derive(Eq, Debug)
pub(all) struct Invocation {
  name : String
  args : Json
  tag : String
}

///|
pub extend Invocation with Eq::{equal, not_equal}

///|
pub extend Invocation with Debug::{to_repr}

///|
/// A response document: one invocation per call, in whatever order the server
/// chose. Tags, not positions, say which is which.
#derive(Eq, Debug)
pub(all) struct Response {
  invocations : Array[Invocation]
  session_state : String
}

///|
pub extend Response with Eq::{equal, not_equal}

///|
pub extend Response with Debug::{to_repr}

///|
pub fn Response::parse(body : String) -> Response raise Refused {
  let document = reads(body)
  // RFC 8620 section 3.6.1: a request the server will not even try — bad JSON,
  // a capability it does not know, too many calls — answers with a problem
  // document instead of methodResponses. Reading it as a malformed response
  // would hide the one sentence that says what to fix.
  match optional(document, "methodResponses") {
    None =>
      raise Refused::Failed(
        call="request",
        kind=text_opt(document, "type").unwrap_or("about:blank"),
        description=text_opt(document, "detail").unwrap_or(
          "the server sent no methodResponses",
        ),
      )
    Some(_) => ()
  }
  let invocations : Array[Invocation] = []
  for entry in items(document, "methodResponses") {
    let parts = match entry {
      Json::Array(parts) => parts
      _ => raise Refused::WrongType(name="methodResponses")
    }
    if parts.length() < 3 {
      raise Refused::WrongType(name="methodResponses")
    }
    let name = match parts[0] {
      Json::String(name) => name
      _ => raise Refused::WrongType(name="methodName")
    }
    let tag = match parts[2] {
      Json::String(tag) => tag
      _ => raise Refused::WrongType(name="methodTag")
    }
    invocations.push({ name, args: parts[1], tag, })
  }
  {
    invocations,
    session_state: text_opt(document, "sessionState").unwrap_or(""),
  }
}

///|
pub fn Response::invocation(self : Response, tag : String) -> Invocation? {
  for invocation in self.invocations {
    if invocation.tag == tag {
      return Some(invocation)
    }
  }
  None
}

///|
/// The answer to one call, or the problem with it: `error` invocations carry
/// `type` and `description` in their arguments (RFC 8620 section 3.6.2), and a
/// client that treats them as data would silently show an empty mailbox
/// instead of a refused password.
pub fn Response::answer(
  self : Response,
  tag : String,
) -> Invocation raise Refused {
  let invocation = match self.invocation(tag) {
    Some(invocation) => invocation
    None => raise Refused::Missing(name=tag)
  }
  if invocation.name == "error" {
    raise Refused::Failed(
      call=text_opt(invocation.args, "description").unwrap_or(tag),
      kind=text_opt(invocation.args, "type").unwrap_or("unknown"),
      description=text_opt(invocation.args, "description").unwrap_or(""),
    )
  }
  invocation
}
