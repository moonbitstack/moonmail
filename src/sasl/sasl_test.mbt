// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
fn first(mechanism : &@sasl.Mechanism) -> String {
  match mechanism.start() {
    Some(data) => @base64.encode(data[:])
    None => "(none)"
  }
}

///|
fn[T] refusal(f : () -> T raise @sasl.Refused) -> @sasl.Refused? {
  try {
    let _ = f()
    None
  } catch {
    e => Some(e)
  }
}

///|
fn text(data : Bytes) -> String {
  @utf8.decode_lossy(data[:])
}

///|
test "sasl plain sends everything at once" {
  let plain = @sasl.Plain::new("tim", "tanstaaftanstaaf")
  inspect(plain.name(), content="PLAIN")
  inspect(first(plain), content="AHRpbQB0YW5zdGFhZnRhbnN0YWFm")
  let proxied = @sasl.Plain::new("tim", "tanstaaftanstaaf", authzid="admin")
  inspect(first(proxied), content="YWRtaW4AdGltAHRhbnN0YWFmdGFuc3RhYWY=")
  inspect(@sasl.respond(plain, ""), content="AHRpbQB0YW5zdGFhZnRhbnN0YWFm")
}

///|
test "sasl login answers user then password" {
  let login = @sasl.Login::new("tim", "tanstaaftanstaaf")
  inspect(first(login), content="(none)")
  inspect(@sasl.respond(login, "VXNlcm5hbWU6"), content="dGlt")
  inspect(
    @sasl.respond(login, "UGFzc3dvcmQ6"),
    content="dGFuc3RhYWZ0YW5zdGFhZg==",
  )
}

///|
test "sasl cram-md5 matches RFC 2195" {
  let cram = @sasl.CramMd5::new("tim", "tanstaaftanstaaf")
  let challenge = @base64.encode(
    b"<1896.697170952@postoffice.reston.mci.net>"[:],
  )
  inspect(
    @sasl.respond(cram, challenge),
    content="dGltIGI5MTNhNjAyYzdlZGE3YTQ5NWI0ZTZlNzMzNGQzODkw",
  )
}

///|
test "sasl xoauth2 keeps the error the server sends" {
  let xoauth = @sasl.XOAuth2::new("tim", "TOKEN")
  inspect(first(xoauth), content="dXNlcj10aW0BYXV0aD1CZWFyZXIgVE9LRU4BAQ==")
  let error = "{\"status\":\"401\"}"
  inspect(
    @sasl.respond(xoauth, @base64.encode(@utf8.encode(error)[:])),
    content="",
  )
  assert_eq(xoauth.error(), Some(error))
}

///|
test "sasl oauthbearer matches RFC 7628" {
  let bearer = @sasl.OAuthBearer::new(
    "vF9dft4qmTc2Nvb3RlckBhbHRhdmlzdGEuY29tCg==",
    username="user@example.com",
    host="server.example.com",
    port=143,
  )
  inspect(bearer.name(), content="OAUTHBEARER")
  inspect(
    first(bearer),
    content="bixhPXVzZXJAZXhhbXBsZS5jb20sAWhvc3Q9c2VydmVyLmV4YW1wbGUuY29tAXBvcnQ9MTQzAWF1dGg9QmVhcmVyIHZGOWRmdDRxbVRjMk52YjNSbGNrQmhiSFJoZG1semRHRXVZMjl0Q2c9PQEB",
  )
}

///|
test "sasl oauthbearer answers a failure with 0x01" {
  let bearer = @sasl.OAuthBearer::new("t")
  inspect(
    text(bearer.start().unwrap()),
    content="n,,\u{1}auth=Bearer t\u{1}\u{1}",
  )
  let error = "{\"status\":\"invalid_token\"}"
  inspect(
    @sasl.respond(bearer, @base64.encode(@utf8.encode(error)[:])),
    content="AQ==",
  )
  inspect(bearer.error() == Some(error), content="true")
}

///|
test "sasl scram-sha-256 matches RFC 7677" {
  let scram = @sasl.ScramSha256::new(
    "user",
    "pencil",
    nonce="rOprNGfwEbeRWgbNEkqO",
  )
  inspect(scram.name(), content="SCRAM-SHA-256")
  assert_eq(text(scram.start().unwrap()), "n,,n=user,r=rOprNGfwEbeRWgbNEkqO")
  let server_first = "r=rOprNGfwEbeRWgbNEkqO%hvYDpWUa2RaTCAfuxFIlj)hNlF$k0,s=W22ZaJ0SNY7soEsUEjb6gQ==,i=4096"
  assert_eq(
    text(scram.step(@utf8.encode(server_first)[:])),
    "c=biws,r=rOprNGfwEbeRWgbNEkqO%hvYDpWUa2RaTCAfuxFIlj)hNlF$k0,p=dHzbZapWIk4jUhN+Ute9ytag9zjfMHgsqmmiz7AndVQ=",
  )
  let server_final = "v=6rriTRBi23WpRR/wtup+mMhUZUn/dB5nLTJRsjl95G4="
  assert_eq(scram.step(@utf8.encode(server_final)[:]), b"")
  scram.finish()
}

///|
fn scram_after_first() -> @sasl.ScramSha256 raise {
  let scram = @sasl.ScramSha256::new(
    "user",
    "pencil",
    nonce="rOprNGfwEbeRWgbNEkqO",
  )
  let _ = scram.start()
  let _ = scram.step(
    @utf8.encode(
      "r=rOprNGfwEbeRWgbNEkqO%hvYDpWUa2RaTCAfuxFIlj)hNlF$k0,s=W22ZaJ0SNY7soEsUEjb6gQ==,i=4096",
    )[:],
  )
  scram
}

///|
test "sasl scram refuses a wrong server signature" {
  let scram = scram_after_first()
  let wrong = "v=AAAATRBi23WpRR/wtup+mMhUZUn/dB5nLTJRsjl95G4="
  assert_eq(
    refusal(() => scram.step(@utf8.encode(wrong)[:])),
    Some(@sasl.Signature),
  )
  assert_eq(refusal(() => scram.finish()), Some(@sasl.Signature))
}

///|
test "sasl scram refuses a success without a server signature" {
  let scram = scram_after_first()
  assert_eq(refusal(() => scram.finish()), Some(@sasl.Signature))
}

///|
test "sasl scram passes the server's error on" {
  let scram = scram_after_first()
  assert_eq(
    refusal(() => scram.step(b"e=invalid-proof"[:])),
    Some(@sasl.Server("invalid-proof")),
  )
}

///|
test "sasl scram refuses a nonce the server did not extend" {
  let scram = @sasl.ScramSha256::new("user", "pencil", nonce="abc")
  let _ = scram.start()
  assert_eq(
    refusal(() => scram.step(b"r=xyz123,s=W22ZaJ0SNY7soEsUEjb6gQ==,i=4096"[:])),
    Some(@sasl.Malformed("the server's nonce does not extend the client's")),
  )
  let again = @sasl.ScramSha256::new("user", "pencil", nonce="abc")
  let _ = again.start()
  assert_eq(
    refusal(() => again.step(b"r=abc1,s=W22ZaJ0SNY7soEsUEjb6gQ==,i=0"[:])),
    Some(@sasl.Malformed("i= must be positive")),
  )
}

///|
test "sasl scram escapes the user name and checks the nonce" {
  let scram = @sasl.ScramSha256::new("a=b,c", "p", nonce="n")
  inspect(text(scram.start().unwrap()), content="n,,n=a=3Db=2Cc,r=n")
  assert_eq(
    refusal(() => @sasl.ScramSha256::new("u", "p", nonce="a,b")),
    Some(@sasl.Malformed("the nonce must be printable ASCII without commas")),
  )
  assert_eq(
    refusal(() => @sasl.ScramSha256::new("u", "p", nonce="")),
    Some(@sasl.Malformed("the nonce must be printable ASCII without commas")),
  )
}

///|
test "sasl respond refuses a challenge that is not base64" {
  assert_eq(
    refusal(() => @sasl.respond(@sasl.Login::new("u", "p"), "!!")),
    Some(@sasl.Malformed("the challenge is not base64")),
  )
}

///|
/// RFC 4013 section 3.
test "saslprep follows the RFC 4013 examples" {
  assert_eq(@sasl.prep("I\u{AD}X"), "IX")
  assert_eq(@sasl.prep("user"), "user")
  assert_eq(@sasl.prep("USER"), "USER")
  assert_eq(@sasl.prep("\u{AA}"), "a")
  assert_eq(@sasl.prep("\u{2168}"), "IX")
  assert_eq(refusal(() => @sasl.prep("\u{7}")), Some(@sasl.Prep('\u{7}')))
  assert_eq(refusal(() => @sasl.prep("\u{627}1")), Some(@sasl.Prep('1')))
}

///|
test "saslprep maps spaces and checks bidi" {
  assert_eq(@sasl.prep("a\u{A0}b\u{3000}c"), "a b c")
  assert_eq(@sasl.prep("\u{627}\u{628}"), "\u{627}\u{628}")
  assert_eq(refusal(() => @sasl.prep("1\u{627}")), Some(@sasl.Prep('1')))
  assert_eq(refusal(() => @sasl.prep("\u{627}a\u{628}")), Some(@sasl.Prep('a')))
  assert_eq(
    refusal(() => @sasl.prep("x\u{E000}")),
    Some(@sasl.Prep('\u{E000}')),
  )
}

///|
test "saslprep refuses unassigned code points unless asked" {
  assert_eq(refusal(() => @sasl.prep("\u{221}")), Some(@sasl.Prep('\u{221}')))
  assert_eq(@sasl.prep("\u{221}", unassigned=true), "\u{221}")
}

///|
test "saslprep applies to scram passwords" {
  let spelled = @sasl.ScramSha256::new("user", "I\u{AD}X", nonce="n")
  let plain = @sasl.ScramSha256::new("user", "IX", nonce="n")
  let server_first = b"r=n1,s=QSXCR+Q6sek8bf92,i=4096"
  assert_eq(spelled.step(server_first[:]), plain.step(server_first[:]))
}

///|
/// A mechanism this package does not ship, as a third party would write it.
struct Anonymous {
  trace : String
}

///|
impl @sasl.Mechanism for Anonymous with fn name(_self) {
  "ANONYMOUS"
}

///|
impl @sasl.Mechanism for Anonymous with fn start(self) {
  Some(@utf8.encode(self.trace))
}

///|
impl @sasl.Mechanism for Anonymous with fn step(self, _challenge) {
  @utf8.encode(self.trace)
}

///|
test "sasl takes a mechanism from outside the package" {
  let anonymous = Anonymous::{ trace: "sirhc", }
  inspect(first(anonymous), content="c2lyaGM=")
  inspect(@sasl.respond(anonymous, ""), content="c2lyaGM=")
  @sasl.Mechanism::finish(anonymous)
}
