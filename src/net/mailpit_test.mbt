// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The sink, end to end: a message handed to it by SMTP — once in the clear and
/// once under STARTTLS with a login — listed over its HTTP API, and then read
/// back by POP3. Three protocols over one message, which is what says a letter
/// this library writes survives more than the path it was written for.
///
/// The sink is part of the harness the other live tests use, so it has no
/// variable of its own: `MOONMAIL_LIVE` names its three ports, and the services
/// are up or the test fails rather than passing quietly.
async test "net: a message reaches the sink, is listed, and comes back by POP3" {
  guard live() is Some(services) else { return }
  let stamp = @env.now().to_string()
  let clear = @net.Smtp::connect(services.host, Clear, port=services.sink)
  let refused = clear.send(
    "sender@example.com",
    ["one@example.com"],
    @utf8.encode("Subject: clear " + stamp + "\r\n\r\nin the clear\r\n"),
  )
  assert_eq(refused.length(), 0)
  clear.quit()
  let secure = @net.Smtp::connect(
    "localhost",
    StartTls(client_config()),
    port=services.sink,
  )
  secure.auth(@sasl.Plain::new("tim", "secret"))
  let accepted = secure.send(
    "sender@example.com",
    ["two@example.com", "three@example.com"],
    @utf8.encode("Subject: starttls " + stamp + "\r\n\r\nunder TLS\r\n"),
  )
  assert_eq(accepted.length(), 0)
  secure.quit()
  let listing = @moonfetch.get(
    "http://" +
    services.host +
    ":" +
    services.sinkapi.to_string() +
    "/api/v1/messages",
  ).json()
  guard listing is { "messages": Array(messages), .. } else {
    fail("the sink listed no messages")
  }
  let subjects = messages.filter_map(message => {
    match message {
      { "Subject": String(subject), .. } => Some(subject)
      _ => None
    }
  })
  assert_true(subjects.contains("clear " + stamp))
  assert_true(subjects.contains("starttls " + stamp))
  let pop = @net.Pop3::connect(services.host, Clear, port=services.sinkpop)
  pop.login("tim", "secret")
  let bodies = []
  for item in pop.list() {
    bodies.push(@utf8.decode_lossy(pop.retr(item.0)[:]))
  }
  pop.quit()
  assert_true(bodies.any(body => body.contains("Subject: starttls " + stamp)))
}
