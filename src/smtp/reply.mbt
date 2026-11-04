// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// What a session cannot go on with: a line that does not parse, one over its
/// limit, a command asked for out of sequence, or one that needs an extension
/// the server did not offer.
#derive(Eq, Debug)
pub(all) suberror Refused {
  Malformed(String)
  Exceeded(limit~ : Int32, got~ : Int32)
  Order(String)
  Unsupported(String)
}

///|
pub extend Refused with Eq::{equal, not_equal}

///|
pub extend Refused with Debug::{to_repr}

///|
/// One SMTP reply: a three-digit code and the text of each line, without the
/// code and the separator. A multi-line reply writes `250-` before every line
/// but the last, which gets `250 `.
#derive(Eq, Debug)
pub(all) struct Reply {
  code : Int32
  lines : Array[String]
}

///|
pub extend Reply with Eq::{equal, not_equal}

///|
pub extend Reply with Debug::{to_repr}

///|
/// A reply whose lines are `text` cut at each `\n`.
pub fn Reply::new(code : Int32, text : StringView) -> Reply {
  { code, lines: text.split("\n").map(line => line.to_owned()).to_array(), }
}

///|
/// The lines joined with `\n`.
pub fn Reply::text(self : Reply) -> String {
  self.lines.join("\n")
}

///|
/// Whether the code is a positive completion, `2yz`.
pub fn Reply::is_ok(self : Reply) -> Bool {
  self.code >= 200 && self.code < 300
}

///|
/// The enhanced status code (RFC 3463) the first line opens with, such as
/// `2.1.5`, when it has one whose class matches the reply code.
pub fn Reply::status(self : Reply) -> String? {
  guard self.lines is [line, ..] else { None }
  let token = match line.find(" ") {
    Some(i) => line[:i]
    None => line[:]
  }
  let parts = token.split(".").to_array()
  guard parts is [class, subject, detail] else { None }
  let digits = (part : StringView, most : Int32) => {
    part.length() >= 1 &&
    part.length() <= most &&
    part.iter().all(c => c >= '0' && c <= '9')
  }
  guard class.length() == 1 &&
    class[0].to_int() - '0'.to_int() == self.code / 100 &&
    (self.code / 100) is (2 | 4 | 5) &&
    digits(subject, 3) &&
    digits(detail, 3) else {
    None
  }
  Some(token.to_owned())
}

///|
/// The reply as it goes on the wire, CRLF after every line.
pub fn Reply::encode(self : Reply) -> Bytes {
  let out = StringBuilder()
  let last = self.lines.length() - 1
  if last < 0 {
    out.write_string(self.code.to_string() + "\r\n")
  }
  for i, line in self.lines {
    out.write_string(self.code.to_string())
    if i < last {
      out.write_char('-')
      out.write_string(line)
    } else if line != "" {
      out.write_char(' ')
      out.write_string(line)
    }
    out.write_string("\r\n")
  }
  @utf8.encode(out.to_string())
}

///|
/// How much a session accepts from its peer.
///
/// - `line`: the longest command or reply line, CRLF excluded. RFC 4954
///   section 4 has servers take SASL lines of 12288 octets, the longest any
///   SMTP line legitimately gets.
/// - `recipients`: how many `RCPT` one transaction may name; Postfix's
///   `smtpd_recipient_limit`.
/// - `size`: the largest message, in octets, a server takes and announces in
///   `SIZE`; Postfix's `message_size_limit`.
#derive(Eq, Debug)
pub(all) struct Limits {
  line : Int32
  recipients : Int32
  size : Int32
}

///|
pub extend Limits with Eq::{equal, not_equal}

///|
pub extend Limits with Debug::{to_repr}

///|
pub let limits : Limits = { line: 12288, recipients: 1000, size: 10240000, }

///|
pub fn Limits::new(
  line~ : Int32 = limits.line,
  recipients~ : Int32 = limits.recipients,
  size~ : Int32 = limits.size,
) -> Limits {
  { line, recipients, size, }
}

///|
/// Octets received and not yet consumed.
struct Inbox {
  mut data : Bytes
  mut at : Int32
}

///|
fn Inbox::new() -> Inbox {
  { data: b"", at: 0, }
}

///|
fn Inbox::push(self : Inbox, more : BytesView) -> Unit {
  if more.length() == 0 {
    return
  }
  let out = Buffer(size_hint=self.data.length() - self.at + more.length())
  out.write_bytes(self.data[self.at:])
  out.write_bytes(more)
  self.data = out.to_bytes()
  self.at = 0
}

///|
fn Inbox::length(self : Inbox) -> Int32 {
  self.data.length() - self.at
}

///|
/// What `Inbox::line` found.
priv enum Line {
  Got(String)
  /// A line longer than the limit, `got` octets of it consumed. `complete` is
  /// false when its end has not arrived yet.
  Long(Int32, complete~ : Bool)
  More
}

///|
/// The next line, ending at LF with a CR before it dropped, as text.
fn Inbox::line(self : Inbox, limit : Int32) -> Line {
  let mut end = self.at
  while end < self.data.length() && self.data[end] != b'\n' {
    end += 1
  }
  if end == self.data.length() {
    let got = end - self.at
    if got > limit {
      self.at = end
      return Long(got, complete=false)
    }
    return More
  }
  let mut stop = end
  if stop > self.at && self.data[stop - 1] == b'\r' {
    stop -= 1
  }
  let start = self.at
  self.at = end + 1
  if stop - start > limit {
    return Long(stop - start, complete=true)
  }
  Got(@utf8.decode_lossy(self.data[start:stop]))
}

///|
/// Drop octets up to and including the next LF; whether it came.
fn Inbox::skip_line(self : Inbox) -> Bool {
  while self.at < self.data.length() {
    let b = self.data[self.at]
    self.at += 1
    if b == b'\n' {
      return true
    }
  }
  false
}

///|
/// The next line ending in CRLF, the CRLF included. A bare LF does not end a
/// line here: message content is cut only where both octets stand, so a lone
/// LF cannot be read as the end of the data.
fn Inbox::crlf_line(self : Inbox) -> BytesView? {
  let mut i = self.at
  while i + 1 < self.data.length() {
    if self.data[i] == b'\r' && self.data[i + 1] == b'\n' {
      let start = self.at
      self.at = i + 2
      return Some(self.data[start:i + 2])
    }
    i += 1
  }
  None
}

///|
/// Up to `n` octets, as many as are in.
fn Inbox::take(self : Inbox, n : Int32) -> BytesView {
  let count = if self.length() < n { self.length() } else { n }
  let start = self.at
  self.at += count
  self.data[start:start + count]
}

///|
/// RFC 3461 section 4: `xtext`, the encoding of `ENVID` and `ORCPT`. Octets
/// outside `!` to `~`, and `+` and `=`, become `+` and two hex digits.
fn xtext(text : StringView) -> String {
  let out = StringBuilder()
  for b in @utf8.encode(text) {
    if b < b'!' || b > b'~' || b == b'+' || b == b'=' {
      out.write_char('+')
      out.write_string(hex_digit(b.to_int() / 16))
      out.write_string(hex_digit(b.to_int() % 16))
    } else {
      out.write_char(b.to_char())
    }
  }
  out.to_string()
}

///|
/// RFC 6533 section 3: `utf-8-addr-xtext`, how `ORCPT` carries an address
/// that is not ASCII. Code points outside `!` to `~`, and `+`, `=` and `\`,
/// become `\x{HEX}`.
fn utf8_xtext(text : StringView) -> String {
  let out = StringBuilder()
  for c in text {
    if c < '!' || c > '~' || c == '+' || c == '=' || c == '\\' {
      out.write_string("\\x{")
      let code = c.to_int()
      let digits = StringBuilder()
      let mut n = code
      while n > 0 {
        digits.write_string(hex_digit(n % 16))
        n /= 16
      }
      let reversed = digits.to_string().to_array().rev()
      out.write_string(String::from_array(reversed))
      out.write_char('}')
    } else {
      out.write_char(c)
    }
  }
  out.to_string()
}

///|
fn hex_digit(n : Int32) -> String {
  "0123456789ABCDEF"[n:n + 1].to_owned()
}

///|
fn is_ascii(text : StringView) -> Bool {
  text.iter().all(c => c.to_int() < 0x80)
}
