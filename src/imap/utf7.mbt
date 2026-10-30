// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// RFC 3501 section 5.1.3: modified UTF-7, how IMAP4rev1 writes mailbox
/// names. Printable ASCII stands for itself and `&` becomes `&-`; any other run
/// of characters becomes `&`, the base64 of its UTF-16BE with `,` for `/` and
/// no padding, and `-`.
fn encode_utf7(text : String) -> String {
  let out = StringBuilder()
  let run = Buffer()
  let flush = () => {
    if !run.is_empty() {
      let encoded = @base64.encode(run.to_bytes()[:], padding=false)
      out.write_string("&" + encoded.replace_all(old="/", new=",") + "-")
      run.reset()
    }
  }
  for c in text {
    if c >= ' ' && c <= '~' {
      flush()
      if c == '&' {
        out.write_string("&-")
      } else {
        out.write_char(c)
      }
    } else {
      let code = c.to_int()
      let units = if code >= 0x10000 {
        let v = code - 0x10000
        [0xD800 + (v >> 10), 0xDC00 + (v & 0x3FF)]
      } else {
        [code]
      }
      for unit in units {
        run.write_byte((unit >> 8).to_byte())
        run.write_byte((unit & 0xFF).to_byte())
      }
    }
  }
  flush()
  out.to_string()
}

///|
/// Read a modified UTF-7 name back. A run that does not decode is kept as
/// written, so a name the server spelled oddly still round-trips.
fn decode_utf7(text : String) -> String {
  let out = StringBuilder()
  let view = text[:]
  let mut i = 0
  while i < view.length() {
    if view[i] != '&' {
      out.write_char(view[i].unsafe_to_char())
      i += 1
      continue
    }
    guard view[i:].find("-") is Some(offset) else {
      out.write_string(view[i:].to_owned())
      break
    }
    let run = view[i + 1:i + offset]
    if run.is_empty() {
      out.write_char('&')
    } else {
      match utf16(run.to_owned().replace_all(old=",", new="/")) {
        Some(decoded) => out.write_string(decoded)
        None => out.write_string(view[i:i + offset + 1].to_owned())
      }
    }
    i += offset + 1
  }
  out.to_string()
}

///|
fn utf16(base64 : String) -> String? {
  let data = @base64.decode(base64[:], padding=false) catch { _ => return None }
  if data.length() % 2 != 0 {
    return None
  }
  let out = StringBuilder()
  let mut i = 0
  while i < data.length() {
    let unit = (data[i].to_int() << 8) | data[i + 1].to_int()
    i += 2
    if unit >= 0xD800 && unit < 0xDC00 {
      guard i + 1 < data.length() else { return None }
      let low = (data[i].to_int() << 8) | data[i + 1].to_int()
      guard low >= 0xDC00 && low < 0xE000 else { return None }
      i += 2
      out.write_char(
        (0x10000 + ((unit - 0xD800) << 10) + (low - 0xDC00)).unsafe_to_char(),
      )
    } else if unit >= 0xDC00 && unit < 0xE000 {
      return None
    } else {
      out.write_char(unit.unsafe_to_char())
    }
  }
  Some(out.to_string())
}
