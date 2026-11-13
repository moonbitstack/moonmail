// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// One method call in a request: the name, its arguments, and the tag the
/// answer comes back under. Tags are how a server that reorders or batches
/// calls still lets a client match them up.
#derive(Eq, Debug)
pub(all) struct Call {
  name : String
  args : Json
  tag : String
}

///|
pub extend Call with Eq::{equal, not_equal}

///|
pub extend Call with Debug::{to_repr}

///|
/// A request document: the capabilities it uses and the calls it makes. RFC
/// 8620 section 3 makes one POST carry the whole lot, which is why the builders
/// append rather than return a finished body.
#derive(Eq, Debug)
pub(all) struct Request {
  capabilities : Array[String]
  calls : Array[Call]
}

///|
pub extend Request with Eq::{equal, not_equal}

///|
pub extend Request with Debug::{to_repr}

///|
pub fn Request::new() -> Request {
  {
    capabilities: ["urn:ietf:params:jmap:core", "urn:ietf:params:jmap:mail"],
    calls: [],
  }
}

///|
/// Ask for a capability the calls below need. RFC 8620 section 3.2 makes the
/// `using` list a claim: a server that does not offer one answers the whole
/// request with `unknownCapability`, so a request carries only what it uses —
/// asking for `submission` on a `Mailbox/get` would fail on a server that
/// cannot send at all, and reading the inbox should still work there.
pub fn Request::using_capability(self : Request, capability : String) -> Unit {
  for known in self.capabilities {
    if known == capability {
      return
    }
  }
  self.capabilities.push(capability)
}

///|
/// Append a call and answer its tag: `c0`, `c1`, and so on. A response is
/// matched by tag rather than by position, so a caller that keeps the tag finds
/// its answer whatever order the server answered in.
pub fn Request::call(self : Request, name : String, args : Json) -> String {
  let tag = "c" + self.calls.length().to_string()
  self.calls.push({ name, args, tag, })
  tag
}

///|
pub fn Request::to_json(self : Request) -> Json {
  let calls = self.calls.map(fn(call) {
    Json::array([Json::string(call.name), call.args, Json::string(call.tag)])
  })
  object([
    ("using", strings(self.capabilities)),
    ("methodCalls", Json::array(calls)),
  ])
}

///|
pub fn Request::to_string(self : Request) -> String {
  @moonjson.dumps(self.to_json())
}
