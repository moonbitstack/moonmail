// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The character classes the grammar keeps naming, once, with the byte and the
/// char side of each kept apart: an octet belongs to the wire, a `Char` to text
/// that has already been picked off it.
fn code(c : Char) -> Int32 {
  c.to_int()
}

///|
fn byte_code(b : Byte) -> Int32 {
  b.to_int()
}

///|
/// WSP, the two characters RFC 5322 §2.2.2 allows as folding whitespace.
fn is_wsp(c : Char) -> Bool {
  code(c) == 32 || code(c) == 9
}

///|
fn is_wsp_byte(b : Byte) -> Bool {
  byte_code(b) == 32 || byte_code(b) == 9
}

///|
/// VCHAR without `"`, `\` and CR — qtext and dtext share it here because every
/// use below adds back exactly the characters its own rule excludes.
fn is_alpha(c : Char) -> Bool {
  (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')
}

///|
fn is_digit(c : Char) -> Bool {
  c >= '0' && c <= '9'
}

///|
fn lower(s : StringView) -> String {
  s.to_owned().to_lower()
}

///|
fn same_ignore_case(a : StringView, b : StringView) -> Bool {
  a.equal_ignore_ascii_case(b)
}

///|
/// The value of one hex digit, for the `=XY` escapes of quoted-printable and of
/// RFC 2047's Q encoding.
fn hex_value(c : Char) -> Int32? {
  if c >= '0' && c <= '9' {
    Some(code(c) - code('0'))
  } else if c >= 'a' && c <= 'f' {
    Some(code(c) - code('a') + 10)
  } else if c >= 'A' && c <= 'F' {
    Some(code(c) - code('A') + 10)
  } else {
    None
  }
}

///|
/// The character for one hex digit, upper-cased because that is the form
/// RFC 2045 shows and what most mail in the wild carries.
fn hex_digit(n : Int32) -> Char {
  if n < 10 {
    (code('0') + n).unsafe_to_char()
  } else {
    (code('A') + n - 10).unsafe_to_char()
  }
}

///|
/// Whether every character is printable US-ASCII, which decides between writing
/// a header value as it stands and writing it as an encoded word.
fn is_ascii_printable(s : StringView) -> Bool {
  s.all(fn(c) { code(c) >= 32 && code(c) <= 126 })
}
