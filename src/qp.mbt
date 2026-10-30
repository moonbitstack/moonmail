// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// An octet that survives the trip as itself. Every printable US-ASCII except
/// `=` may stay; so may a space and a tab in mid-line, which is what makes most
/// mail quoted-printable encodes read as plain text.
fn qp_safe(b : Byte) -> Bool {
  let n = byte_code(b)
  (n >= 33 && n <= 126 && n != 61) || n == 32 || n == 9
}

///|
/// Whether everything from `at` up to the next line break is WSP. Those are the
/// octets that have to be quoted rather than left alone, because every hop
/// between here and the recipient is entitled to strip them (RFC 2045 §6.7,
/// note 2).
fn trailing_wsp(data : BytesView, at : Int32) -> Bool {
  let mut i = at
  while i < data.length() {
    let b = data.at(i)
    if b == b'\r' || b == b'\n' {
      return true
    }
    if !is_wsp_byte(b) {
      return false
    }
    i = i + 1
  }
  true
}

///|
/// Encode as quoted-printable. Lines are broken at 75 columns so that the soft
/// break that ends one stays inside the 76 RFC 2045 allows, and line endings
/// come out as CRLF whatever they arrived as.
///
/// ```mbt check
/// test {
///   let out = @moonmail.qp_encode(b"a=b")
///   inspect(out == b"a=3Db", content="true")
/// }
/// ```
pub fn qp_encode(data : BytesView) -> Bytes {
  let out = Buffer()
  let n = data.length()
  let mut col = 0
  let mut i = 0
  while i < n {
    let b = data.at(i)
    if b == b'\r' || b == b'\n' {
      out.write_string_utf8("\r\n")
      col = 0
      if b == b'\r' && i + 1 < n && data.at(i + 1) == b'\n' {
        i = i + 2
      } else {
        i = i + 1
      }
      continue
    }
    let piece = if qp_safe(b) && !trailing_wsp(data, i) {
      let one = Buffer()
      one.write_byte(b)
      one.to_bytes()
    } else {
      let upper = hex_digit(byte_code(b) / 16)
      let lower = hex_digit(byte_code(b) % 16)
      @utf8.encode("=" + upper.to_string() + lower.to_string())
    }
    if col + piece.length() > 75 {
      out.write_string_utf8("=\r\n")
      col = 0
    }
    out.write_bytes(piece[:])
    col = col + piece.length()
    i = i + 1
  }
  out.to_bytes()
}

///|
/// Decode quoted-printable.
///
/// `=XY` becomes the octet, `=` at the end of a line is the soft break it
/// stands for and contributes nothing, and whitespace at the end of a line is
/// dropped: a gateway further upstream may already have taken it, so keeping it
/// here would not recover it.
///
/// `strict` turns the lenient last two readings into `Encoding`, which is what
/// a mail filter that wants to see exactly what was signed asks for.
///
/// ```mbt check
/// test {
///   let out = @moonmail.qp_decode(b"a=3Db") catch { _ => b"" }
///   inspect(out == b"a=b", content="true")
/// }
/// ```
pub fn qp_decode(
  data : BytesView,
  strict~ : Bool = false,
) -> Bytes raise Refused {
  let out = Buffer()
  let n = data.length()
  let mut i = 0
  while i < n {
    let b = data.at(i)
    if b == b'\r' || b == b'\n' {
      if b == b'\r' && i + 1 < n && data.at(i + 1) == b'\n' {
        out.write_string_utf8("\r\n")
        i = i + 2
      } else {
        out.write_string_utf8("\r\n")
        i = i + 1
      }
      continue
    }
    if is_wsp_byte(b) {
      // Whitespace at the end of a line: skip to the line ending.
      if trailing_wsp(data, i) {
        while i < n {
          let c = data.at(i)
          if c == b'\r' || c == b'\n' {
            break
          }
          i = i + 1
        }
        continue
      }
      out.write_byte(b)
      i = i + 1
      continue
    }
    if b == b'=' {
      // A soft line break is `=` (WSP)* then a line ending. It stands for
      // nothing at all, so it is consumed before the hex reading: even when
      // three or more octets follow, `=\r\n` is still a soft break and not a
      // failed `=XY` escape.
      let mut j = i + 1
      while j < n && is_wsp_byte(data.at(j)) {
        j = j + 1
      }
      if j < n && (data.at(j) == b'\r' || data.at(j) == b'\n') {
        if data.at(j) == b'\r' && j + 1 < n && data.at(j + 1) == b'\n' {
          i = j + 2
        } else {
          i = j + 1
        }
        continue
      }
      let rest = data.length() - i
      if rest >= 3 {
        let high = hex_value(data.at(i + 1).to_char())
        let low = hex_value(data.at(i + 2).to_char())
        match (high, low) {
          (Some(h), Some(l)) => {
            out.write_byte((h * 16 + l).to_byte())
            i = i + 3
            continue
          }
          (_, _) =>
            if strict {
              raise Refused::Encoding(at=i)
            } else {
              out.write_byte(b)
              i = i + 1
            }
        }
        continue
      }
      if strict {
        raise Refused::Encoding(at=i)
      }
      out.write_byte(b)
      i = i + 1
      continue
    }
    out.write_byte(b)
    i = i + 1
  }
  out.to_bytes()
}
