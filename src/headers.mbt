// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The header of a message: fields in order, names compared without regard to
/// case, each value as written with its folding taken out. Encoded words stay
/// encoded here; the readers on `Message` decode them.
pub struct Headers {
  priv fields : Array[(String, String)]
} derive(Eq, Debug)

///|
pub extend Headers with Eq::{equal, not_equal}

///|
pub extend Headers with Debug::{to_repr}

///|
pub fn Headers::new() -> Headers {
  { fields: [], }
}

///|
/// The first value of the field `name`.
pub fn Headers::get(self : Headers, name : StringView) -> String? {
  for field in self.fields {
    if same(field.0, name) {
      return Some(field.1)
    }
  }
  None
}

///|
/// Every value of the field `name`, in order.
pub fn Headers::all(self : Headers, name : StringView) -> Array[String] {
  self.fields.filter(f => same(f.0, name)).map(f => f.1)
}

///|
/// Add a field after the others. A name outside RFC 5322 section 2.2, or a
/// value with a line break that could start a field of its own, is refused.
pub fn Headers::add(
  self : Headers,
  name : String,
  value : String,
) -> Unit raise Refused {
  check(name, value)
  self.fields.push((name, value))
}

///|
/// Give the field `name` this one value: the first occurrence takes it in its
/// place and the others go; a field not there yet is added at the end.
pub fn Headers::set(
  self : Headers,
  name : String,
  value : String,
) -> Unit raise Refused {
  check(name, value)
  match self.fields.search_by(f => same(f.0, name)) {
    Some(i) => {
      self.fields[i] = (self.fields[i].0, value)
      let mut j = self.fields.length() - 1
      while j > i {
        if same(self.fields[j].0, name) {
          let _ = self.fields.remove(j)
        }
        j -= 1
      }
    }
    None => self.fields.push((name, value))
  }
}

///|
/// Take out every field named `name`.
pub fn Headers::remove(self : Headers, name : StringView) -> Unit {
  self.fields.retain(f => !same(f.0, name))
}

///|
pub fn Headers::iter(self : Headers) -> Iter[(String, String)] {
  self.fields.iter()
}

///|
pub fn Headers::length(self : Headers) -> Int32 {
  self.fields.length()
}

///|
fn same(a : StringView, b : StringView) -> Bool {
  a.equal_ignore_ascii_case(b)
}

///|
fn check(name : String, value : String) -> Unit raise Refused {
  if name.is_empty() {
    raise Header(at=0)
  }
  for i, c in name.to_array() {
    if c.to_int() < 33 || c.to_int() > 126 || c == ':' {
      raise Header(at=i)
    }
  }
  for i, c in value.to_array() {
    if c == '\r' || c == '\n' {
      raise Header(at=i)
    }
  }
}

///|
/// RFC 5322 section 2.1.1: lines should stay within 78 characters.
let soft_line = 78

///|
/// A field as it goes on the wire: folded before white space so that each
/// line stays within 78 characters where the value allows, CRLF at the end.
fn fold(name : String, value : String) -> String {
  let line = name + ": " + value
  let chars = line.to_array()
  if chars.length() <= soft_line {
    return line + "\r\n"
  }
  let out = StringBuilder()
  let space = (c : Char) => c == ' ' || c == '\t'
  let mut start = 0
  while chars.length() - start > soft_line {
    let floor = if start == 0 { name.length() + 2 } else { start + 1 }
    let ceiling = if start + soft_line < chars.length() - 1 {
      start + soft_line
    } else {
      chars.length() - 1
    }
    let mut cut = -1
    for i in floor..<=ceiling {
      if space(chars[i]) {
        cut = i
      }
    }
    // No white space within the line: break at the first that comes after.
    if cut < 0 {
      for i in (ceiling + 1)..<chars.length() {
        if space(chars[i]) {
          cut = i
          break
        }
      }
    }
    if cut <= start {
      break
    }
    out.write_string(String::from_array(chars[start:cut]))
    out.write_string("\r\n")
    start = cut
  }
  out.write_string(String::from_array(chars[start:]))
  out.write_string("\r\n")
  out.to_string()
}
