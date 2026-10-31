// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// Read an RFC 5322 date-time, `Tue, 1 Jul 2003 10:52:37 +0200`, with the
/// obsolete forms of section 4.3: two- and three-digit years, a missing
/// second, the named zones of RFC 822 and comments anywhere. A zone of
/// `-0000` or an unknown name reads as UTC, as section 3.3 says it means.
pub fn parse_date(text : StringView) -> @moondate.Moment raise Refused {
  let words = date_words(text)
  let mut i = 0
  if i < words.length() && words[i].has_suffix(",") {
    i += 1
  } else if i < words.length() &&
    month_of(words[i]) is None &&
    number(words[i]) is None {
    // A weekday without its comma.
    i += 1
  }
  guard i + 4 <= words.length() else { raise Date }
  guard number(words[i]) is Some(day) else { raise Date }
  guard month_of(words[i + 1]) is Some(month) else { raise Date }
  guard number(words[i + 2]) is Some(written) else { raise Date }
  let year = match words[i + 2].length() {
    2 => if written < 50 { 2000 + written } else { 1900 + written }
    3 => 1900 + written
    _ => written
  }
  let clock = words[i + 3].split(":").to_array()
  let (hour, minute, second) = match clock.map(c => number(c.to_owned())) {
    [Some(h), Some(m)] => (h, m, 0)
    [Some(h), Some(m), Some(s)] => (h, m, s)
    _ => raise Date
  }
  let zone = if i + 4 < words.length() {
    zone_of(words[i + 4])
  } else {
    @moondate.Utc
  }
  let date = @moondate.Date::new(year, month, day) catch { _ => raise Date }
  // A leap second is read as the last second of its minute.
  let time = @moondate.Time::new(
    hour,
    minute,
    second=if second == 60 { 59 } else { second },
  ) catch {
    _ => raise Date
  }
  @moondate.Moment::combine(date, time, zone~)
}

///|
/// A date-time as RFC 5322 writes it, `Tue, 01 Jul 2003 10:52:37 +0200`.
pub fn format_date(moment : @moondate.Moment) -> String {
  moment.strftime("%a, %d %b %Y %H:%M:%S %z")
}

///|
/// The words of a date, comments dropped.
fn date_words(text : StringView) -> Array[String] {
  let out = StringBuilder()
  let mut depth = 0
  for c in text {
    if c == '(' {
      depth += 1
    } else if c == ')' && depth > 0 {
      depth -= 1
    } else if depth == 0 {
      out.write_char(if c == '\t' || c == '\r' || c == '\n' { ' ' } else { c })
    }
  }
  out
  .to_string()
  .split(" ")
  .filter(w => !w.is_empty())
  .map(w => w.to_owned())
  .to_array()
}

///|
fn number(word : String) -> Int32? {
  if word.is_empty() || word.length() > 9 {
    return None
  }
  let mut n = 0
  for c in word {
    guard c >= '0' && c <= '9' else { return None }
    n = n * 10 + (c.to_int() - '0'.to_int())
  }
  Some(n)
}

///|
fn month_of(word : String) -> Int32? {
  let months = [
    "jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov",
    "dec",
  ]
  let key = word.to_lower()
  match months.search_by(m => key.has_prefix(m)) {
    Some(i) => Some(i + 1)
    None => None
  }
}

///|
/// `+hhmm` or `-hhmm`, or a zone named by RFC 822.
fn zone_of(word : String) -> @moondate.Zone {
  let view = word[:]
  if view.length() == 5 && (view[0] == '+' || view[0] == '-') {
    match number(view[1:].to_owned()) {
      Some(n) => {
        let minutes = n / 100 * 60 + n % 100
        if minutes == 0 && view[0] == '-' {
          return @moondate.Utc
        }
        return @moondate.Offset(if view[0] == '-' { -minutes } else { minutes })
      }
      None => ()
    }
  }
  match word.to_upper() {
    "EDT" => @moondate.Offset(-4 * 60)
    "EST" | "CDT" => @moondate.Offset(-5 * 60)
    "CST" | "MDT" => @moondate.Offset(-6 * 60)
    "MST" | "PDT" => @moondate.Offset(-7 * 60)
    "PST" => @moondate.Offset(-8 * 60)
    "UT" | "GMT" => @moondate.Offset(0)
    _ => @moondate.Utc
  }
}
