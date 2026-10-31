// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// RFC 8463 appendix A: the message, its two signatures, and the two keys.
let message : String =
  #|DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
  #| d=football.example.com; i=@football.example.com;
  #| q=dns/txt; s=brisbane; t=1528637909; h=from : to :
  #| subject : date : message-id : from : subject : date;
  #| bh=2jUSOH9NhtVGCQWNr9BrIAPreKQjO6Sn7XIkfJVOzv8=;
  #| b=/gCrinpcQOoIfuHNQIbq4pgh9kyIK3AQUdt9OdqQehSwhEIug4D11Bus
  #| Fa3bT3FY5OsU7ZbnKELq+eXdp1Q1Dw==
  #|DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  #| d=football.example.com; i=@football.example.com;
  #| q=dns/txt; s=test; t=1528637909; h=from : to : subject :
  #| date : message-id : from : subject : date;
  #| bh=2jUSOH9NhtVGCQWNr9BrIAPreKQjO6Sn7XIkfJVOzv8=;
  #| b=F45dVWDfMbQDGHJFlXUNB2HKfbCeLRyhDXgFpEL8GwpsRe0IeIixNTe3
  #| DhCVlUrSjV4BwcVcOF6+FF3Zo9Rpo1tFOeS9mPYQTnGdaSGsgeefOsk2Jz
  #| dA+L10TeYt9BgDfQNZtKdN1WO//KgIqXP7OdEFE4LjFYNcUxZQ4FADY+8=
  #|From: Joe SixPack <joe@football.example.com>
  #|To: Suzie Q <suzie@shopping.example.net>
  #|Subject: Is dinner ready?
  #|Date: Fri, 11 Jul 2003 21:00:37 -0700 (PDT)
  #|Message-ID: <20030712040037.46341.5F8J@football.example.com>
  #|
  #|Hi.
  #|
  #|We lost the game.  Are you hungry yet?
  #|
  #|Joe.
  #|

///|
let rsa_pem : String =
  #|-----BEGIN RSA PRIVATE KEY-----
  #|MIICXQIBAAKBgQDkHlOQoBTzWRiGs5V6NpP3idY6Wk08a5qhdR6wy5bdOKb2jLQi
  #|Y/J16JYi0Qvx/byYzCNb3W91y3FutACDfzwQ/BC/e/8uBsCR+yz1Lxj+PL6lHvqM
  #|KrM3rG4hstT5QjvHO9PzoxZyVYLzBfO2EeC3Ip3G+2kryOTIKT+l/K4w3QIDAQAB
  #|AoGAH0cxOhFZDgzXWhDhnAJDw5s4roOXN4OhjiXa8W7Y3rhX3FJqmJSPuC8N9vQm
  #|6SVbaLAE4SG5mLMueHlh4KXffEpuLEiNp9Ss3O4YfLiQpbRqE7Tm5SxKjvvQoZZe
  #|zHorimOaChRL2it47iuWxzxSiRMv4c+j70GiWdxXnxe4UoECQQDzJB/0U58W7RZy
  #|6enGVj2kWF732CoWFZWzi1FicudrBFoy63QwcowpoCazKtvZGMNlPWnC7x/6o8Gc
  #|uSe0ga2xAkEA8C7PipPm1/1fTRQvj1o/dDmZp243044ZNyxjg+/OPN0oWCbXIGxy
  #|WvmZbXriOWoSALJTjExEgraHEgnXssuk7QJBALl5ICsYMu6hMxO73gnfNayNgPxd
  #|WFV6Z7ULnKyV7HSVYF0hgYOHjeYe9gaMtiJYoo0zGN+L3AAtNP9huqkWlzECQE1a
  #|licIeVlo1e+qJ6Mgqr0Q7Aa7falZ448ccbSFYEPD6oFxiOl9Y9se9iYHZKKfIcst
  #|o7DUw1/hz2Ck4N5JrgUCQQCyKveNvjzkkd8HjYs0SwM0fPjK16//5qDZ2UiDGnOe
  #|uEzxBDAr518Z8VFbR41in3W4Y3yCDgQlLlcETrS+zYcL
  #|-----END RSA PRIVATE KEY-----

///|
fn crlf(text : String) -> Bytes {
  @utf8.encode(text.replace_all(old="\n", new="\r\n"))
}

///|
fn records(name : String) -> String? {
  match name {
    "brisbane._domainkey.football.example.com" =>
      Some("v=DKIM1; k=ed25519; p=11qYAYKxCrfVS/7TyWQHOg7hcvPapiMlrwIaaPcHURo=")
    "test._domainkey.football.example.com" =>
      Some(
        "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDkHlOQoBTzWRiGs5V6NpP3idY6Wk08a5qhdR6wy5bdOKb2jLQiY/J16JYi0Qvx/byYzCNb3W91y3FutACDfzwQ/BC/e/8uBsCR+yz1Lxj+PL6lHvqMKrM3rG4hstT5QjvHO9PzoxZyVYLzBfO2EeC3Ip3G+2kryOTIKT+l/K4w3QIDAQAB",
      )
    _ => None
  }
}

///|
fn ed25519_key() -> @dkim.Key raise {
  let seed = @base64.decode("nWGxne/9WmC6hEr0kuwsxERJxWl7MmkZcDusAxyuf2A=")
  Ed25519(@ed25519.PrivateKey::of_secret(seed[:]))
}

///|
fn rsa_key() -> @dkim.Key raise {
  guard @x509.PrivateKey::pem(rsa_pem) is Rsa(key) else { fail("not RSA") }
  Rsa(key)
}

///|
test "dkim verifies both signatures of RFC 8463" {
  let verdicts = @dkim.verify(crlf(message)[:], n => records(n), now=1528637909)
  assert_eq(verdicts, [
    Pass(domain="football.example.com", selector="brisbane"),
    Pass(domain="football.example.com", selector="test"),
  ])
}

///|
test "dkim fails a changed body, a changed header and a changed signature" {
  let body = message.replace(old="We lost the game.", new="We won the game.")
  assert_eq(
    @dkim.verify(crlf(body)[:], n => records(n), now=0)[0],
    Fail(domain="football.example.com", reason="the body hash does not match"),
  )
  let header = message.replace(old="Is dinner ready?", new="Is lunch ready?")
  assert_eq(@dkim.verify(crlf(header)[:], n => records(n), now=0), [
    Fail(domain="football.example.com", reason="the signature does not verify"),
    Fail(domain="football.example.com", reason="the signature does not verify"),
  ])
  let added = "Subject: second\n" + message
  assert_eq(
    @dkim.verify(crlf(added)[:], n => records(n), now=0).map(v => v is Pass(..)),
    [false, false],
  )
}

///|
test "dkim signs as RFC 8463 does" {
  let plain = crlf(message[message.find("From: Joe").unwrap():].to_owned())
  for key in [ed25519_key(), rsa_key()] {
    let selector = if key is Ed25519(_) { "brisbane" } else { "test" }
    let field = @dkim.sign(
      plain[:],
      key,
      domain="football.example.com",
      selector~,
      headers=[
        "from", "to", "subject", "date", "message-id", "from", "subject", "date",
      ],
      header_canon=Relaxed,
      body_canon=Relaxed,
      timestamp=1528637909,
      identity="@football.example.com",
    )
    inspect(
      field.contains("bh=2jUSOH9NhtVGCQWNr9BrIAPreKQjO6Sn7XIkfJVOzv8="),
      content="true",
    )
    let signed = @utf8.encode(field + "\r\n" + @utf8.decode_lossy(plain[:]))
    assert_eq(@dkim.verify(signed[:], n => records(n), now=0), [
      Pass(domain="football.example.com", selector~),
    ])
  }
}

///|
test "dkim judges expiry, length and the key record" {
  let plain = crlf("From: a@example.com\nSubject: hi\n\nbody\nmore\n")
  let key = ed25519_key()
  let lookup = (name : String) => {
    if name.has_prefix("brisbane.") {
      records("brisbane._domainkey.football.example.com")
    } else {
      None
    }
  }
  let expiring = @dkim.sign(
    plain[:],
    key,
    domain="football.example.com",
    selector="brisbane",
    timestamp=100,
    expire=200,
  )
  let signed = @utf8.encode(expiring + "\r\n" + @utf8.decode_lossy(plain[:]))
  assert_eq(
    @dkim.verify(signed[:], n => lookup(n), now=150).map(v => v is Pass(..)),
    [true],
  )
  assert_eq(@dkim.verify(signed[:], n => lookup(n), now=300), [
    Fail(domain="football.example.com", reason="the signature expired"),
  ])
  let counted = @dkim.sign(
    plain[:],
    key,
    domain="football.example.com",
    selector="brisbane",
    length=true,
  )
  let appended = @utf8.encode(
    counted + "\r\n" + @utf8.decode_lossy(plain[:]) + "added later\r\n",
  )
  assert_eq(
    @dkim.verify(appended[:], n => lookup(n), now=0).map(v => v is Pass(..)),
    [true],
  )
  let unknown = @dkim.sign(
    plain[:],
    key,
    domain="football.example.com",
    selector="gone",
  )
  let orphan = @utf8.encode(unknown + "\r\n" + @utf8.decode_lossy(plain[:]))
  assert_eq(@dkim.verify(orphan[:], n => lookup(n), now=0), [
    PermError("no key is published at gone._domainkey.football.example.com"),
  ])
  let failing = @dkim.verify(
    orphan[:],
    _ => fail("the resolver timed out"),
    now=0,
  )
  assert_eq(failing.map(v => v is TempError(_)), [true])
  let revoked = @dkim.verify(
    signed[:],
    _ => Some("v=DKIM1; k=ed25519; p="),
    now=150,
  )
  assert_eq(revoked, [PermError("the key is revoked")])
  let mismatched = @dkim.verify(
    signed[:],
    _ => records("test._domainkey.football.example.com"),
    now=150,
  )
  assert_eq(mismatched, [PermError("the key is k=rsa for a=ed25519-sha256")])
}

///|
test "dkim refuses rsa-sha1 and what does not cover From" {
  let sha1 = "DKIM-Signature: v=1; a=rsa-sha1; d=x.test; s=s; h=from; bh=; b=\r\nFrom: a@x.test\r\n\r\n"
  assert_eq(@dkim.verify(@utf8.encode(sha1)[:], _ => None, now=0), [
    PermError("a=rsa-sha1 is not accepted"),
  ])
  let uncovered = "DKIM-Signature: v=1; a=rsa-sha256; d=x.test; s=s; h=subject; bh=; b=\r\nFrom: a@x.test\r\n\r\n"
  assert_eq(@dkim.verify(@utf8.encode(uncovered)[:], _ => None, now=0), [
    PermError("h= does not cover From"),
  ])
  let anonymous = crlf("Subject: hi\n\nbody\n")
  let refused = try {
    let _ = @dkim.sign(
      anonymous[:],
      ed25519_key(),
      domain="x.test",
      selector="s",
    )
    None
  } catch {
    @dkim.Missing(what) => Some(what)
    e => raise e
  }
  assert_eq(refused, Some("From"))
}
