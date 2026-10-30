// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
test "sasl plain initial response" {
  let client = @sasl.Client::new(
    @sasl.Mechanism::Plain,
    "tim",
    "tanstaaftanstaaf",
  )
  inspect(client.mechanism_name(), content="PLAIN")
  inspect(client.initial(), content="AHRpbQB0YW5zdGFhZnRhbnN0YWFm")
}

///|
test "sasl login walks user then password" {
  let client = @sasl.Client::new(
    @sasl.Mechanism::Login,
    "tim",
    "tanstaaftanstaaf",
  )
  inspect(client.initial(), content="")
  inspect(client.respond("VXNlcm5hbWU6") catch { _ => "" }, content="dGlt")
  inspect(
    client.respond("UGFzc3dvcmQ6") catch {
      _ => ""
    },
    content="dGFuc3RhYWZ0YW5zdGFhZg==",
  )
}

///|
test "sasl cram-md5 matches the RFC 2195 vector" {
  let client = @sasl.Client::new(
    @sasl.Mechanism::CramMd5,
    "tim",
    "tanstaaftanstaaf",
  )
  let challenge = @base64.encode(
    b"<1896.697170952@postoffice.reston.mci.net>"[:],
  )
  inspect(
    client.respond(challenge) catch {
      _ => ""
    },
    content="dGltIGI5MTNhNjAyYzdlZGE3YTQ5NWI0ZTZlNzMzNGQzODkw",
  )
}

///|
test "sasl xoauth2 carries the bearer token" {
  let client = @sasl.Client::new(@sasl.Mechanism::Xoauth2, "tim", "TOKEN")
  inspect(client.initial(), content="dXNlcj10aW0BYXV0aD1CZWFyZXIgVE9LRU4BAQ==")
}

///|
test "sasl refuses a challenge it has no response for" {
  let client = @sasl.Client::new(@sasl.Mechanism::Plain, "u", "p")
  let raised = try {
    let _ = client.respond("x")
    false
  } catch {
    _ => true
  }
  inspect(raised, content="true")
}
