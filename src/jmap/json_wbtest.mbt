// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The request body leaves the library through `moonjson.dumps` and must come
/// back through `moonjson.loads` as the same document — the round trip the move
/// to the family JSON library has to keep exact.
test "request: the body round-trips through the JSON reader" {
  let request = Request::new()
  let tag = request.mailbox_get("u-1")
  assert_eq(tag, "c0")
  let body = request.to_string()
  let document = @moonjson.loads(body, @moonjson.strict) catch {
    _ => fail("a request body is JSON: " + body)
  }
  let calls = match document {
    Json::Object(map) =>
      match map.get("methodCalls") {
        Some(Json::Array(calls)) => calls
        _ => fail("methodCalls is an array")
      }
    _ => fail("a request document is an object")
  }
  assert_eq(calls.length(), 1)
  let first = match calls[0] {
    Json::Array(parts) => parts
    _ => fail("a call is [name, args, tag]")
  }
  assert_eq(first.length(), 3)
  assert_eq(first[0], Json::string("Mailbox/get"))
  assert_eq(first[2], Json::string("c0"))
}

///|
/// A body that is not JSON at all must be refused, not read as an empty
/// document: this is the `moonjson.loads(..., strict)` branch the library now
/// takes for every document it reads.
test "session: a body that is not JSON is refused" {
  let mut refused = false
  ignore(
    Session::parse("https://example.com/.well-known/jmap", "this is not json"),
  ) catch {
    Refused::Malformed(..) => refused = true
    _ => fail("expected Refused::Malformed, got a different refusal")
  }
  assert_true(refused)
}

///|
/// `strict` is what the library asks for, so a trailing comma that lenient
/// readers accept must be refused here.
test "session: a trailing comma is refused under strict" {
  let body = "{ \"apiUrl\": \"https://api.example.org/jmap\", \"accounts\": { \"a\": {} }, \"username\": \"u\", }"
  let mut refused = false
  ignore(Session::parse("https://example.com/.well-known/jmap", body)) catch {
    Refused::Malformed(..) => refused = true
    _ => fail("expected Refused::Malformed, got a different refusal")
  }
  assert_true(refused)
}

///|
/// The response document, read the same strict way, refuses a truncated body.
test "response: a truncated body is refused" {
  let mut refused = false
  ignore(Response::parse("{ \"methodResponses\": [")) catch {
    Refused::Malformed(..) => refused = true
    _ => fail("expected Refused::Malformed, got a different refusal")
  }
  assert_true(refused)
}
