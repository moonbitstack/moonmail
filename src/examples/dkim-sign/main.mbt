// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// Sign a letter with DKIM and print the header to put above it:
///
///     moon run src/examples/dkim-sign -- key.pem letter.eml [selector] [domain]
///
/// The key is a PEM file, RSA or Ed25519; the letter is read as it is, CRLF and
/// all, because the signature covers those octets and nothing else. Run with no
/// arguments and it signs a message of its own, which is what a reader trying
/// the library wants and what CI runs.

///|
/// The key the example signs with when nobody gave it one. A test key: it signs
/// nothing that leaves this repository.
let demo_key : String =
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
  #|
  #|-----END RSA PRIVATE KEY-----
  #|

///|
/// A letter that fits in a page, in the octets DKIM signs: CRLF, folded at the
/// header, one empty line, the body.
let demo_message : String =
  #|From: Alice <alice@example.com>
  #|To: Bob <bob@example.com>
  #|Subject: Dinner on Thursday?
  #|Date: Fri, 06 Nov 2026 12:00:00 +0000
  #|Message-ID: <demo@example.com>
  #|MIME-Version: 1.0
  #|Content-Type: text/plain; charset=utf-8
  #|
  #|Noon works for me.
  #|

///|
fn parse_key(pem : String) -> @dkim.Key raise {
  match @x509.PrivateKey::pem(pem) {
    Rsa(key) => @dkim.Rsa(key)
    Ed25519(key) => @dkim.Ed25519(key)
    _ => fail("the key is neither RSA nor Ed25519")
  }
}

///|
async fn main {
  let args = @env.args()
  let (pem, message, selector, domain) = if args.length() < 3 {
    (demo_key, demo_message, "sel", "example.com")
  } else {
    let rest = args[3:]
    (
      @utf8.decode_lossy(@fs.read_file(args[1]).binary()[:]),
      @utf8.decode_lossy(@fs.read_file(args[2]).binary()[:]),
      rest.get(0).unwrap_or("sel"),
      rest.get(1).unwrap_or("example.com"),
    )
  }
  let key = parse_key(pem)
  let wire = message
    .replace_all(old="\r\n", new="\n")
    .replace_all(old="\n", new="\r\n")
  let header = @dkim.sign(
    @utf8.encode(wire)[:],
    key,
    domain~,
    selector~,
    header_canon=@dkim.Relaxed,
    body_canon=@dkim.Relaxed,
  )
  // The header is the whole answer: it goes above the fields that were signed,
  // and the letter itself is the one the caller already has. Printing the
  // letter as well would be printing it through the platform's newline
  // translation, which is not the octets that were signed.
  println(header)
}
