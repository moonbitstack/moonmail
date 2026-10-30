// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
pub(all) suberror SaslError {
  Unsupported(mechanism~ : String)
  Protocol(msg~ : String)
}

///|
/// The mechanisms mail servers actually offer. LOGIN is not a standard but is
/// everywhere; CRAM-MD5 needs an HMAC-MD5; XOAUTH2 carries a bearer token.
pub(all) enum Mechanism {
  Plain
  Login
  CramMd5
  Xoauth2
}

///|
pub fn Mechanism::name(self : Mechanism) -> String {
  match self {
    Mechanism::Plain => "PLAIN"
    Mechanism::Login => "LOGIN"
    Mechanism::CramMd5 => "CRAM-MD5"
    Mechanism::Xoauth2 => "XOAUTH2"
  }
}

///|
/// One authentication attempt. `initial` is the response a client may send with
/// the command; `respond` answers a challenge. LOGIN walks two steps — the user
/// name, then the password — so it keeps a cursor.
pub struct Client {
  mechanism : Mechanism
  username : String
  secret : String
  mut step : Int32
}

///|
pub fn Client::new(
  mechanism : Mechanism,
  username : String,
  secret : String,
) -> Client {
  { mechanism, username, secret, step: 0, }
}

///|
pub fn Client::mechanism_name(self : Client) -> String {
  self.mechanism.name()
}

///|
/// The first response, or `""` when the mechanism begins with a challenge.
pub fn Client::initial(self : Client) -> String {
  match self.mechanism {
    Mechanism::Plain => {
      let out = Buffer()
      out.write_byte(0)
      out.write_string_utf8(self.username)
      out.write_byte(0)
      out.write_string_utf8(self.secret)
      b64(out.to_bytes())
    }
    Mechanism::Login => ""
    Mechanism::CramMd5 => ""
    Mechanism::Xoauth2 => {
      let out = Buffer()
      out.write_string_utf8("user=")
      out.write_string_utf8(self.username)
      out.write_byte(1)
      out.write_string_utf8("auth=Bearer ")
      out.write_string_utf8(self.secret)
      out.write_byte(1)
      out.write_byte(1)
      b64(out.to_bytes())
    }
  }
}

///|
/// Answer a base64 challenge. LOGIN ignores the text and returns the user name
/// once, then the password.
pub fn Client::respond(
  self : Client,
  challenge : String,
) -> String raise SaslError {
  match self.mechanism {
    Mechanism::Login =>
      if self.step == 0 {
        self.step = 1
        b64(@utf8.encode(self.username))
      } else {
        b64(@utf8.encode(self.secret))
      }
    Mechanism::CramMd5 => {
      let raw = @base64.decode(challenge[:], padding=true) catch {
        _ => raise SaslError::Protocol(msg="CRAM-MD5 challenge is not base64")
      }
      let digest = @hmac.mac(@utf8.encode(self.secret)[:], raw[:], fn() -> &@spec.Hash {
        @md5.Hasher::new()
      })
      b64(@utf8.encode(self.username + " " + hex_of(digest[:])))
    }
    _ => raise SaslError::Unsupported(mechanism=self.mechanism.name())
  }
}

///|
/// The base64 text of a continuation line: a leading `+`, an optional space, and
/// the challenge after it. IMAP and POP3 both answer challenges this way.
pub fn challenge_of(line : String) -> String {
  let view = line[:]
  if view.length() <= 1 {
    ""
  } else if view[1] == ' ' {
    view[2:].trim().to_owned()
  } else {
    view[1:].trim().to_owned()
  }
}

///|
fn b64(bytes : Bytes) -> String {
  @base64.encode(bytes[:])
}

///|
fn hex_of(data : BytesView) -> String {
  let out = StringBuilder()
  for b in data {
    let n = b.to_int()
    out.write_char(hex_digit(n / 16))
    out.write_char(hex_digit(n % 16))
  }
  out.to_string()
}

///|
fn hex_digit(n : Int32) -> Char {
  if n < 10 {
    (n + '0'.to_int()).unsafe_to_char()
  } else {
    (n - 10 + 'a'.to_int()).unsafe_to_char()
  }
}
