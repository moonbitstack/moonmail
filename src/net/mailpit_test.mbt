// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// Where Mailpit listens, from `MAILPIT` written as `host:smtp:http:pop3`,
/// with the certificate `scripts/write_test_certs.py` writes for STARTTLS and
/// a POP3 login of tim and secret. Without it these tests pass without doing
/// anything.
fn mailpit() -> (String, Int32, Int32, Int32)? raise {
  guard @env.get_env_var("MAILPIT") is Some(spec) else { return None }
  guard spec.split(":").to_array() is [host, smtp, http, pop3] else {
    fail("MAILPIT is host:smtp:http:pop3, not " + spec)
  }
  Some(
    (
      host.to_owned(),
      @string.parse_int(smtp),
      @string.parse_int(http),
      @string.parse_int(pop3),
    ),
  )
}

///|
async test "net delivers to Mailpit in the clear and under STARTTLS" {
  guard mailpit() is Some((host, smtp_port, http_port, pop3_port)) else {
    return
  }
  let stamp = @env.now().to_string()
  let clear = @net.Smtp::connect(host, Clear, port=smtp_port)
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
    port=smtp_port,
  )
  secure.auth(@sasl.Plain::new("tim", "secret"))
  let _ = secure.send(
    "sender@example.com",
    ["two@example.com", "three@example.com"],
    @utf8.encode("Subject: starttls " + stamp + "\r\n\r\nunder TLS\r\n"),
  )
  secure.quit()
  let listing = @moonfetch.get(
    "http://" + host + ":" + http_port.to_string() + "/api/v1/messages",
  ).json()
  guard listing is { "messages": Array(messages), .. } else {
    fail("Mailpit listed no messages")
  }
  let subjects = messages.filter_map(m => {
    match m {
      { "Subject": String(s), .. } => Some(s)
      _ => None
    }
  })
  assert_true(subjects.contains("clear " + stamp))
  assert_true(subjects.contains("starttls " + stamp))
  let pop = @net.Pop3::connect(host, Clear, port=pop3_port)
  pop.login("tim", "secret")
  let bodies = []
  for item in pop.list() {
    bodies.push(@utf8.decode_lossy(pop.retr(item.0)[:]))
  }
  pop.quit()
  assert_true(bodies.any(b => b.contains("Subject: starttls " + stamp)))
}
