// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// SASLprep (RFC 4013): the stringprep profile SCRAM applies to user names and
/// passwords, so that two spellings of one string hash alike. Non-ASCII spaces
/// become spaces, characters commonly mapped to nothing are dropped, the result
/// is put in NFKC, and a prohibited character, a broken bidi rule or, unless
/// `unassigned` allows them, a code point unassigned in Unicode 3.2 refuses it.
///
/// `unassigned` follows RFC 3454: stored strings such as passwords must not
/// hold unassigned code points, queries may.
///
/// The tables are RFC 3454's, fixed at Unicode 3.2. NFKC comes from moonucd;
/// for code points 3.2 assigns it agrees with 3.2's except for the few CJK
/// compatibility ideographs Unicode Corrigendum #4 corrected.
pub fn prep(
  text : StringView,
  unassigned~ : Bool = false,
) -> String raise Refused {
  let mapped = StringBuilder()
  for c in text {
    let code = c.to_int()
    if !unassigned && within(unassigned_32, code) {
      raise Prep(c)
    }
    if within(spaces, code) {
      mapped.write_char(' ')
    } else if !within(nothing, code) {
      mapped.write_char(c)
    }
  }
  let out = @normalize.normalize(NFKC, mapped.to_string())
  let chars = out.to_array()
  let mut ltr_char = None
  let mut rtl_seen = false
  for c in chars {
    let code = c.to_int()
    if prohibited.any(table => within(table, code)) {
      raise Prep(c)
    }
    if within(rtl, code) {
      rtl_seen = true
    } else if ltr_char is None && within(ltr, code) {
      ltr_char = Some(c)
    }
  }
  // RFC 3454 section 6: a string holding a right-to-left character holds no
  // left-to-right one, and both begins and ends with a right-to-left one.
  if rtl_seen {
    if ltr_char is Some(c) {
      raise Prep(c)
    }
    let first = chars[0]
    let last = chars[chars.length() - 1]
    if !within(rtl, first.to_int()) {
      raise Prep(first)
    }
    if !within(rtl, last.to_int()) {
      raise Prep(last)
    }
  }
  out
}

///|
/// RFC 4013 section 2.3: the stringprep tables C.1.2 to C.9.
let prohibited : Array[Array[(Int32, Int32)]] = [
  spaces, ascii_controls, controls, private_use, noncharacters, surrogates, not_plain,
  not_canonical, display, tagging,
]

///|
/// Whether `code` falls in one of the sorted, disjoint `ranges`.
fn within(ranges : Array[(Int32, Int32)], code : Int32) -> Bool {
  let mut lo = 0
  let mut hi = ranges.length()
  while lo < hi {
    let mid = (lo + hi) / 2
    let (start, end) = ranges[mid]
    if code < start {
      hi = mid
    } else if code > end {
      lo = mid + 1
    } else {
      return true
    }
  }
  false
}
