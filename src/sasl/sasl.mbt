// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// Why an authentication cannot go on.
#derive(Eq, Debug)
pub(all) suberror Refused {
  /// The character for which SASLprep refuses a string: one it prohibits, one
  /// unassigned in Unicode 3.2, or the one that breaks its bidi rule.
  Prep(Char)
  /// A server message, or a value given to a mechanism, that does not parse.
  Malformed(String)
  /// The server's own refusal: SCRAM's `e=`, OAUTHBEARER's error status.
  Server(String)
  /// The server could not prove it knows the password: SCRAM's `v=` was wrong
  /// or never came.
  Signature
}

///|
pub extend Refused with Eq::{equal, not_equal}

///|
pub extend Refused with Debug::{to_repr}

///|
/// One SASL mechanism on the client side (RFC 4422). Challenges and responses
/// are raw octets; the protocol around it does the base64.
///
/// A protocol calls `start` once: its result, when there is one, goes out with
/// the command, or in answer to the server's first empty challenge where the
/// protocol cannot send it inline. Every challenge after that goes to `step`.
/// When the server reports success, `finish` lets a mechanism that expects
/// proof from the server, as SCRAM does, refuse a success that did not carry it.
///
/// A mechanism this package does not ship implements the trait and is passed
/// to `authenticate` like the built-in ones.
pub(open) trait Mechanism {
  fn name(Self) -> String
  fn start(Self) -> Bytes?
  fn step(Self, BytesView) -> Bytes raise Refused
  fn finish(Self) -> Unit raise Refused = _
}

///|
impl Mechanism with fn finish(_self) {
  ()
}

///|
/// PLAIN (RFC 4616): the identity and the password in one message, so only
/// over TLS.
pub struct Plain {
  priv authzid : String
  priv username : String
  priv password : String
}

///|
pub fn Plain::new(
  username : String,
  password : String,
  authzid? : String,
) -> Plain {
  { authzid: authzid.unwrap_or(""), username, password, }
}

///|
fn Plain::message(self : Plain) -> Bytes {
  let out = Buffer()
  out.write_bytes(@utf8.encode(self.authzid))
  out.write_byte(0)
  out.write_bytes(@utf8.encode(self.username))
  out.write_byte(0)
  out.write_bytes(@utf8.encode(self.password))
  out.to_bytes()
}

///|
pub extend Plain with Mechanism::{name, start, step, finish}

///|
pub impl Mechanism for Plain with fn name(_self) {
  "PLAIN"
}

///|
pub impl Mechanism for Plain with fn start(self) {
  Some(self.message())
}

///|
/// The server's challenge is empty by the RFC; whatever it is, the answer is
/// the one message PLAIN has.
pub impl Mechanism for Plain with fn step(self, _challenge) {
  self.message()
}

///|
/// LOGIN: not a standard, but offered almost everywhere. The user name answers
/// the first prompt, the password the second.
pub struct Login {
  priv username : String
  priv password : String
  priv mut asked : Int32
}

///|
pub fn Login::new(username : String, password : String) -> Login {
  { username, password, asked: 0, }
}

///|
pub extend Login with Mechanism::{name, start, step, finish}

///|
pub impl Mechanism for Login with fn name(_self) {
  "LOGIN"
}

///|
pub impl Mechanism for Login with fn start(_self) {
  None
}

///|
pub impl Mechanism for Login with fn step(self, _challenge) {
  self.asked += 1
  if self.asked == 1 {
    @utf8.encode(self.username)
  } else {
    @utf8.encode(self.password)
  }
}

///|
/// CRAM-MD5 (RFC 2195): the user name and an HMAC-MD5 of the server's challenge
/// keyed with the password. Kept for servers that offer nothing better.
pub struct CramMd5 {
  priv username : String
  priv password : String
}

///|
pub fn CramMd5::new(username : String, password : String) -> CramMd5 {
  { username, password, }
}

///|
pub extend CramMd5 with Mechanism::{name, start, step, finish}

///|
pub impl Mechanism for CramMd5 with fn name(_self) {
  "CRAM-MD5"
}

///|
pub impl Mechanism for CramMd5 with fn start(_self) {
  None
}

///|
pub impl Mechanism for CramMd5 with fn step(self, challenge) {
  let digest = @hmac.mac(@utf8.encode(self.password)[:], challenge, md5)
  @utf8.encode(self.username + " " + hex(digest[:]))
}

///|
/// XOAUTH2: Google's and Microsoft's bearer-token mechanism, before OAUTHBEARER
/// was standardised. A failure arrives as a JSON challenge, answered with an
/// empty response so the server can finish.
pub struct XOAuth2 {
  priv username : String
  priv token : String
  priv mut error : String?
}

///|
pub fn XOAuth2::new(username : String, token : String) -> XOAuth2 {
  { username, token, error: None, }
}

///|
/// The JSON the server sent with a failure, if it sent one.
pub fn XOAuth2::error(self : XOAuth2) -> String? {
  self.error
}

///|
pub extend XOAuth2 with Mechanism::{name, start, step, finish}

///|
pub impl Mechanism for XOAuth2 with fn name(_self) {
  "XOAUTH2"
}

///|
pub impl Mechanism for XOAuth2 with fn start(self) {
  Some(
    @utf8.encode(
      "user=" + self.username + "\u{1}auth=Bearer " + self.token + "\u{1}\u{1}",
    ),
  )
}

///|
pub impl Mechanism for XOAuth2 with fn step(self, challenge) {
  self.error = Some(@utf8.decode_lossy(challenge))
  b""
}

///|
/// OAUTHBEARER (RFC 7628): an OAuth 2.0 bearer token with the host and port it
/// is meant for. A failure arrives as a JSON challenge; the answer is the single
/// octet `0x01` the RFC prescribes, after which the server ends the exchange.
pub struct OAuthBearer {
  priv username : String?
  priv token : String
  priv host : String?
  priv port : Int32?
  priv mut error : String?
}

///|
pub fn OAuthBearer::new(
  token : String,
  username? : String,
  host? : String,
  port? : Int32,
) -> OAuthBearer {
  { username, token, host, port, error: None, }
}

///|
/// The JSON the server sent with a failure, if it sent one.
pub fn OAuthBearer::error(self : OAuthBearer) -> String? {
  self.error
}

///|
pub extend OAuthBearer with Mechanism::{name, start, step, finish}

///|
pub impl Mechanism for OAuthBearer with fn name(_self) {
  "OAUTHBEARER"
}

///|
pub impl Mechanism for OAuthBearer with fn start(self) {
  let out = StringBuilder()
  out.write_string("n,")
  if self.username is Some(user) {
    out.write_string("a=" + saslname(user))
  }
  out.write_string(",")
  if self.host is Some(host) {
    out.write_string("\u{1}host=" + host)
  }
  if self.port is Some(port) {
    out.write_string("\u{1}port=" + port.to_string())
  }
  out.write_string("\u{1}auth=Bearer " + self.token + "\u{1}\u{1}")
  Some(@utf8.encode(out.to_string()))
}

///|
pub impl Mechanism for OAuthBearer with fn step(self, challenge) {
  self.error = Some(@utf8.decode_lossy(challenge))
  b"\x01"
}

///|
/// SCRAM-SHA-256 (RFC 7677, over RFC 5802): neither side sends the password,
/// and the server proves it holds the salted key too, which `finish` checks.
///
/// `nonce` is the client's part of the exchange nonce: fresh random printable
/// ASCII without commas on every attempt, for instance the base64 of sixteen
/// random bytes. It is an argument because this package draws no randomness.
pub struct ScramSha256 {
  priv first : String
  priv nonce : String
  priv password : String
  priv mut proof : Bytes?
  priv mut done : Bool
}

///|
pub fn ScramSha256::new(
  username : String,
  password : String,
  nonce~ : String,
) -> ScramSha256 raise Refused {
  if nonce.is_empty() || nonce.iter().any(c => c == ',' || c < '!' || c > '~') {
    raise Malformed("the nonce must be printable ASCII without commas")
  }
  let user = prep(username)
  {
    first: "n=" + saslname(user) + ",r=" + nonce,
    nonce,
    password,
    proof: None,
    done: false,
  }
}

///|
pub extend ScramSha256 with Mechanism::{name, start, step, finish}

///|
pub impl Mechanism for ScramSha256 with fn name(_self) {
  "SCRAM-SHA-256"
}

///|
pub impl Mechanism for ScramSha256 with fn start(self) {
  Some(@utf8.encode("n,," + self.first))
}

///|
pub impl Mechanism for ScramSha256 with fn step(self, challenge) {
  let text = @utf8.decode_lossy(challenge)
  match self.proof {
    None => self.client_final(text)
    Some(expected) => {
      let fields = attributes(text)
      if fields.get('e') is Some(message) {
        raise Server(message)
      }
      guard fields.get('v') is Some(v) else {
        raise Malformed("server-final-message carries no v=")
      }
      let got = @base64.decode(v[:]) catch {
        _ => raise Malformed("v= is not base64")
      }
      if got != expected {
        raise Signature
      }
      self.done = true
      b""
    }
  }
}

///|
pub impl Mechanism for ScramSha256 with fn finish(self) {
  if !self.done {
    raise Signature
  }
}

///|
/// Answer the server-first-message with the client proof, and keep the server
/// signature the server-final-message has to match.
fn ScramSha256::client_final(
  self : ScramSha256,
  server_first : String,
) -> Bytes raise Refused {
  let fields = attributes(server_first)
  if fields.get('m') is Some(_) {
    raise Malformed("server-first-message asks for an extension")
  }
  guard fields.get('r') is Some(nonce) &&
    nonce.length() > self.nonce.length() &&
    nonce.has_prefix(self.nonce) else {
    raise Malformed("the server's nonce does not extend the client's")
  }
  guard fields.get('s') is Some(salt64) else { raise Malformed("no salt") }
  let salt = @base64.decode(salt64[:]) catch {
    _ => raise Malformed("s= is not base64")
  }
  guard fields.get('i') is Some(count) else {
    raise Malformed("no iteration count")
  }
  let rounds = @string.parse_int(count) catch {
    _ => raise Malformed("i= is not a number")
  }
  if rounds < 1 {
    raise Malformed("i= must be positive")
  }
  let salted = @pbkdf2.key(
    @utf8.encode(prep(self.password))[:],
    salt[:],
    sha256,
    rounds~,
    len=32,
  )
  let client_key = @hmac.mac(salted[:], b"Client Key", sha256)
  let stored_key = @sha2.hash(client_key[:])
  let without_proof = "c=biws,r=" + nonce
  let auth = @utf8.encode(self.first + "," + server_first + "," + without_proof)
  let signature = @hmac.mac(stored_key[:], auth[:], sha256)
  let proof = Bytes::makei(client_key.length(), i => {
    client_key[i] ^ signature[i]
  })
  let server_key = @hmac.mac(salted[:], b"Server Key", sha256)
  self.proof = Some(@hmac.mac(server_key[:], auth[:], sha256))
  @utf8.encode(without_proof + ",p=" + @base64.encode(proof[:]))
}

///|
/// A SCRAM message's `a=value` attributes by their letter. A value may itself
/// hold `=`, so only the first one splits.
fn attributes(text : String) -> Map[Char, String] {
  let out : Map[Char, String] = Map([])
  for part in text.split(",") {
    if part.length() >= 2 && part[1] == '=' {
      out[part[0].unsafe_to_char()] = part[2:].to_owned()
    }
  }
  out
}

///|
/// A user name as SCRAM and OAUTHBEARER carry it: `=` and `,` escaped.
fn saslname(name : String) -> String {
  name.replace_all(old="=", new="=3D").replace_all(old=",", new="=2C")
}

///|
/// Answer a challenge as SMTP, IMAP and POP3 carry it, base64 on a line, with
/// the mechanism's next response, base64 again.
pub fn respond(
  mechanism : &Mechanism,
  challenge : StringView,
) -> String raise Refused {
  let data = @base64.decode(challenge.trim()) catch {
    _ => raise Malformed("the challenge is not base64")
  }
  @base64.encode(mechanism.step(data[:])[:])
}

///|
fn md5() -> &@spec.Hash {
  @md5.Hasher::new()
}

///|
fn sha256() -> &@spec.Hash {
  @sha2.Hasher::new()
}

///|
fn hex(data : BytesView) -> String {
  let digits = "0123456789abcdef"
  let out = StringBuilder()
  for b in data {
    out.write_char(digits[b.to_int() / 16].unsafe_to_char())
    out.write_char(digits[b.to_int() % 16].unsafe_to_char())
  }
  out.to_string()
}
