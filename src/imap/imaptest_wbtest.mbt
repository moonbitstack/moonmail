// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// imaptest's scripted tests say what a server answers: every `*` line in them
/// is a reply a client has to understand. `vectors_test.mbt` holds all of them,
/// generated from a pinned commit, and this replays each one through the client
/// and compares what it parsed with what the script said it would be.
///
/// The comparison is imaptest's own: case does not matter, a `$name` stands for
/// whatever the server put there, and the two lists whose order means nothing —
/// the items of a FETCH, the pairs of a STATUS, the flags of a LIST — were put
/// in a fixed order by the generator so that both sides can be compared as
/// words.

///|
/// The reply as one line of words: parentheses stand alone, a quoted string is
/// one word without its quotes, and a literal is the octets it announces. The
/// octets are what a reply is, so this reads bytes rather than characters.
fn words_of(text : String) -> Array[String] {
  let data = @utf8.encode(text)
  let size = data.length()
  let out : Array[String] = []
  let mut at = 0
  while at < size {
    let byte = data[at].to_int()
    if byte == 32 || byte == 13 || byte == 10 || byte == 9 {
      at = at + 1
      continue
    }
    if byte == 40 || byte == 41 {
      out.push(@utf8.decode_lossy(data[at:at + 1]))
      at = at + 1
      continue
    }
    if byte == 34 {
      at = at + 1
      let word = Buffer()
      while at < size && data[at].to_int() != 34 {
        if data[at].to_int() == 92 && at + 1 < size {
          at = at + 1
        }
        word.write_byte(data[at])
        at = at + 1
      }
      at = at + 1
      out.push(@utf8.decode_lossy(word.to_bytes()[:]))
      continue
    }
    if byte == 123 {
      let mut close = at + 1
      while close < size && data[close].to_int() != 125 {
        close = close + 1
      }
      let digits = @utf8.decode_lossy(data[at + 1:close][:])
      let count = @string.parse_int(digits) catch { _ => -1 }
      if count >= 0 {
        let mut start = close + 1
        while start < size &&
              (data[start].to_int() == 13 || data[start].to_int() == 10) {
          start = start + 1
        }
        out.push(@utf8.decode_lossy(data[start:start + count][:]))
        at = start + count
        continue
      }
    }
    let start = at
    while at < size {
      let current = data[at].to_int()
      if current == 32 ||
        current == 13 ||
        current == 10 ||
        current == 9 ||
        current == 40 ||
        current == 41 {
        break
      }
      at = at + 1
    }
    out.push(@utf8.decode_lossy(data[start:at][:]))
  }
  out
}

///|
/// Whether one word of a script matches one word of a reply: case is ignored,
/// `$$` is a literal `$`, and every other `$name` or `${name}` stands for
/// whatever the server wrote — including inside a word, which is how
/// `$mailbox${sep}test` names a mailbox under the separator the server chose.
fn word_matches(pattern : String, actual : String) -> Bool {
  match_text(pattern.to_lower(), 0, actual.to_lower(), 0)
}

///|
/// A `$` in the pattern stands for any run of the reply, including none, so the
/// rest of the pattern has to be tried at every position it could start at.
fn match_text(
  pattern : String,
  from : Int32,
  actual : String,
  at : Int32,
) -> Bool {
  let mut index = from
  let mut position = at
  while index < pattern.length() {
    if pattern[index] == '$' {
      if index + 1 < pattern.length() && pattern[index + 1] == '$' {
        if position >= actual.length() || actual[position] != '$' {
          return false
        }
        index = index + 2
        position = position + 1
        continue
      }
      let mut after = index + 1
      if after < pattern.length() && pattern[after] == '{' {
        while after < pattern.length() && pattern[after] != '}' {
          after = after + 1
        }
        after = after + 1
      } else {
        while after < pattern.length() &&
              pattern[after] != ' ' &&
              pattern[after] != '$' {
          after = after + 1
        }
      }
      if after >= pattern.length() {
        return true
      }
      let mut skip = position
      while skip <= actual.length() {
        if match_text(pattern, after, actual, skip) {
          return true
        }
        skip = skip + 1
      }
      return false
    }
    if position >= actual.length() || actual[position] != pattern[index] {
      return false
    }
    index = index + 1
    position = position + 1
  }
  position == actual.length()
}

///|
/// Whether a script's reply and a reply this library parsed are the same
/// answer, word for word.
fn same_reply(expected : String, actual : String) -> Bool {
  // The script writes the untagged marker; what the client parses is the reply
  // itself, without it.
  let text = if expected.has_prefix("* ") {
    expected[2:].to_owned()
  } else {
    expected
  }
  let wanted = words_of(text)
  let got = words_of(actual)
  if wanted.length() != got.length() {
    return false
  }
  let mut index = 0
  while index < wanted.length() {
    if !word_matches(wanted[index], got[index]) {
      return false
    }
    index = index + 1
  }
  true
}

///|
fn quote(text : String) -> String {
  let builder = StringBuilder()
  builder.write_char('"')
  for char in text {
    if char == '"' || char == '\\' {
      builder.write_char('\\')
    }
    builder.write_char(char)
  }
  builder.write_char('"')
  builder.to_string()
}

///|
fn words_value(value : Value) -> String {
  match value {
    Nil => "NIL"
    Number(number) => number.to_string()
    Atom(atom) => atom
    Text(bytes) => quote(@utf8.decode_lossy(bytes[:]))
    List(items) => "(" + items.map(words_value).join(" ") + ")"
  }
}

///|
/// Whether one word sorts before another, comparing characters rather than
/// whatever the `<` operator on a String compares.
fn before(left : String, right : String) -> Bool {
  let size = if left.length() < right.length() {
    left.length()
  } else {
    right.length()
  }
  let mut at = 0
  while at < size {
    if left[at] != right[at] {
      return left[at] < right[at]
    }
    at = at + 1
  }
  left.length() < right.length()
}

///|
/// A parenthesised list of `key value` pairs in a fixed order, which is how a
/// FETCH and a STATUS are written here: their order means nothing to either
/// side, so sorting both is what lets them be compared at all.
fn words_pairs(values : Map[String, Value]) -> String {
  let keys = values.keys().collect()
  let sorted = []
  for key in keys {
    sorted.push(key)
  }
  let mut index = 1
  while index < sorted.length() {
    let mut at = index
    while at > 0 && before(sorted[at].to_lower(), sorted[at - 1].to_lower()) {
      let held = sorted[at - 1]
      sorted[at - 1] = sorted[at]
      sorted[at] = held
      at = at - 1
    }
    index = index + 1
  }
  let out = StringBuilder()
  out.write_char('(')
  for key in sorted {
    out.write_char(' ')
    out.write_string(key)
    out.write_char(' ')
    out.write_string(words_value(values[key]))
  }
  out.write_string(" )")
  out.to_string()
}

///|
/// `key value` pairs with nothing around them, which is how an ESEARCH lists
/// what it found.
fn words_flat(values : Map[String, Value]) -> String {
  let keys = values.keys().collect()
  let sorted = []
  for key in keys {
    sorted.push(key)
  }
  let mut index = 1
  while index < sorted.length() {
    let mut at = index
    while at > 0 && before(sorted[at].to_lower(), sorted[at - 1].to_lower()) {
      let held = sorted[at - 1]
      sorted[at - 1] = sorted[at]
      sorted[at] = held
      at = at - 1
    }
    index = index + 1
  }
  let out = StringBuilder()
  let mut first = true
  for key in sorted {
    if !first {
      out.write_char(' ')
    }
    first = false
    out.write_string(key)
    out.write_char(' ')
    out.write_string(words_value(values[key]))
  }
  out.to_string()
}

///|
/// A STATUS reply's counts in a fixed order, for the same reason as a FETCH's
/// items: the order means nothing, so both sides are sorted.
fn words_counts(values : Map[String, Int64]) -> String {
  let keys = values.keys().collect()
  let sorted = []
  for key in keys {
    sorted.push(key)
  }
  let mut index = 1
  while index < sorted.length() {
    let mut at = index
    while at > 0 && before(sorted[at].to_lower(), sorted[at - 1].to_lower()) {
      let held = sorted[at - 1]
      sorted[at - 1] = sorted[at]
      sorted[at] = held
      at = at - 1
    }
    index = index + 1
  }
  let out = StringBuilder()
  out.write_char('(')
  for key in sorted {
    out.write_char(' ')
    out.write_string(key)
    out.write_char(' ')
    out.write_string(values[key].to_string())
  }
  out.write_string(" )")
  out.to_string()
}

///|
fn words_code(code : Code) -> String {
  match code {
    Alert => "[ALERT]"
    Capability(capabilities) => "[CAPABILITY " + capabilities.join(" ") + "]"
    PermanentFlags(flags) => "[PERMANENTFLAGS (" + flags.join(" ") + ")]"
    ReadOnly => "[READ-ONLY]"
    ReadWrite => "[READ-WRITE]"
    TryCreate => "[TRYCREATE]"
    UidNext(next) => "[UIDNEXT " + next.to_string() + "]"
    UidValidity(validity) => "[UIDVALIDITY " + validity.to_string() + "]"
    HighestModseq(modseq) => "[HIGHESTMODSEQ " + modseq.to_string() + "]"
    NoModseq => "[NOMODSEQ]"
    Modified(ids) => "[MODIFIED " + ids + "]"
    AppendUid(validity, uid) =>
      "[APPENDUID " + validity.to_string() + " " + uid + "]"
    CopyUid(validity, source, destination) =>
      "[COPYUID " +
      validity.to_string() +
      " " +
      source +
      " " +
      destination +
      "]"
    Closed => "[CLOSED]"
    Other(name, Some(value)) => "[" + name + " " + value + "]"
    Other(name, None) => "[" + name + "]"
  }
}

///|
fn words_response(response : Response) -> String {
  match response {
    Condition(kind, code, text) => {
      let out = StringBuilder()
      out.write_string(kind)
      match code {
        Some(code) => {
          out.write_char(' ')
          out.write_string(words_code(code))
        }
        None => ()
      }
      if text != "" {
        out.write_char(' ')
        out.write_string(text)
      }
      out.to_string()
    }
    Capability(capabilities) => "CAPABILITY " + capabilities.join(" ")
    Enabled(capabilities) => "ENABLED " + capabilities.join(" ")
    Flags(flags) => "FLAGS ( " + flags.join(" ") + " )"
    Exists(count) => count.to_string() + " EXISTS"
    Expunge(count) => count.to_string() + " EXPUNGE"
    List(flags~, delimiter~, name~) => {
      let separator = match delimiter {
        Some(delimiter) => delimiter
        None => "NIL"
      }
      // The flags of a LIST are a set: sorted here, and sorted in the vectors.
      let ordered = flags.copy()
      let mut index = 1
      while index < ordered.length() {
        let mut at = index
        while at > 0 &&
              before(ordered[at].to_lower(), ordered[at - 1].to_lower()) {
          let held = ordered[at - 1]
          ordered[at - 1] = ordered[at]
          ordered[at] = held
          at = at - 1
        }
        index = index + 1
      }
      // An empty name is a quoted empty string on the wire, not nothing.
      let shown = if name == "" { "\"\"" } else { name }
      "LIST ( " + ordered.join(" ") + " ) " + separator + " " + shown
    }
    Status(name, values) => "STATUS " + name + " " + words_counts(values)
    Esearch(tag~, uid~, items~) => {
      let out = StringBuilder()
      out.write_string("ESEARCH")
      match tag {
        Some(tag) => out.write_string(" ( TAG " + quote(tag) + " )")
        None => ()
      }
      if uid {
        out.write_string(" UID")
      }
      out.write_char(' ')
      out.write_string(words_flat(items))
      out.to_string()
    }
    Search(ids, modseq~) => {
      let out = StringBuilder()
      out.write_string("SEARCH")
      for id in ids {
        out.write_char(' ')
        out.write_string(id.to_string())
      }
      match modseq {
        Some(modseq) =>
          out.write_string(" ( MODSEQ " + modseq.to_string() + " )")
        None => ()
      }
      out.to_string()
    }
    Fetch(number, values) =>
      number.to_string() + " FETCH " + words_pairs(values)
    Namespace(personal, other, shared) =>
      "NAMESPACE " +
      words_value(personal) +
      " " +
      words_value(other) +
      " " +
      words_value(shared)
    Other(name, values) =>
      // A few untagged replies lead with their number: `3 RECENT`, not
      // `RECENT 3`.
      match (name.to_upper(), values) {
        ("RECENT", [Number(count), ..]) => count.to_string() + " " + name
        _ => name + " " + values.map(words_value).join(" ")
      }
  }
}

///|
/// The one reply a client parsed out of these octets, written the way a script
/// writes it.
fn reply_of(octets : String) -> String raise {
  let client = Client::new()
  // A reply on the wire is a line, and a line ends: the vector holds the text
  // without the CRLF that terminates it.
  let events = client.feed(@utf8.encode(octets + "\r\n")[:])
  let out = StringBuilder()
  for event in events {
    if event is Data(response) {
      if out.to_string() != "" {
        out.write_char('\n')
      }
      out.write_string(words_response(response))
    }
  }
  out.to_string()
}

///|
/// The replies this client does not read back as written, and why. They are
/// listed rather than skipped: the test asserts that each of them still fails,
/// so a fix to the parser shows up here as a vector that has to be taken off
/// the list, and a new failure cannot hide among them.
let known_gaps : Array[(String, String, String)] = [
  (
    "subscribe", "* lsub", "LSUB is read into the same value as LIST: IMAP4rev2 dropped the command",
  ),
  (
    "subscribe", "* lsub", "LSUB is read into the same value as LIST: IMAP4rev2 dropped the command",
  ),
  (
    "subscribe", "* lsub", "LSUB is read into the same value as LIST: IMAP4rev2 dropped the command",
  ),
  (
    "subscribe", "* lsub", "LSUB is read into the same value as LIST: IMAP4rev2 dropped the command",
  ),
  (
    "subscribe", "* lsub", "LSUB is read into the same value as LIST: IMAP4rev2 dropped the command",
  ),
  (
    "subscribe", "* lsub", "LSUB is read into the same value as LIST: IMAP4rev2 dropped the command",
  ),
  (
    "listext", "* list ( \\haschildren ) $sep $mailbox${sep}test2 (childinfo", "the extended data of a LIST-EXTENDED reply (RFC 5258) is not read",
  ),
  (
    "listext", "* list (  ) $sep $mailbox${sep}test2 (childinfo", "the extended data of a LIST-EXTENDED reply (RFC 5258) is not read",
  ),
  (
    "mutf7", "* list (  ) $sep \"$mailbox${sep}p&AOQA5A-\"", "the name is decoded from modified UTF-7, so it does not read as the wire wrote it",
  ),
  (
    "mutf7", "* status \"$mailbox${sep}p&AOQA5A-\"", "the name is decoded from modified UTF-7, so it does not read as the wire wrote it",
  ),
  (
    "fetch-binary-mime-base64", "* 1 fetch ( binary[1]", "a literal8 (RFC 3516), and two literals on one line, are beyond what a fetch item is read as",
  ),
]

///|
/// What a reply is known as: the script it came from and its first words, which
/// is enough to tell two apart and short enough to read.
fn gap_key(script : String, expected : String) -> String {
  script + "\u{0}" + expected
}

///|
/// The known gaps, counted so that two identical replies are two entries.
fn gap_counts() -> Map[String, Int32] {
  let counts : Map[String, Int32] = Map([])
  for entry in known_gaps {
    let key = gap_key(entry.0, entry.1)
    let seen = match counts.get(key) {
      Some(count) => count
      None => 0
    }
    counts[key] = seen + 1
  }
  counts
}

///|
/// Whether a failing reply is one of the known gaps, taking it off the list.
fn take_gap(
  counts : Map[String, Int32],
  script : String,
  expected : String,
) -> Bool {
  let prefix = script + "\u{0}"
  for key, count in counts {
    if count > 0 && key.has_prefix(prefix) {
      let wanted = key[prefix.length():].to_owned()
      if expected.has_prefix(wanted) {
        counts[key] = count - 1
        return true
      }
    }
  }
  false
}

///|
test "imaptest: every expected reply in the suite parses to what it says" {
  let gaps = gap_counts()
  let mut total = 0
  let mut passed = 0
  let mut known = 0
  let failures = []
  for group in imaptest_replies {
    for vector in group {
      let (script, expected, octets) = vector
      total = total + 1
      let parsed = reply_of(octets) catch {
        _ => "\u{0} the client refused the octets"
      }
      if same_reply(expected, parsed) {
        passed = passed + 1
      } else if take_gap(gaps, script, expected) {
        known = known + 1
      } else if failures.length() < 12 {
        failures.push(script + " @@ " + expected + "  ==>  " + parsed)
      }
    }
  }
  for failure in failures {
    println(failure)
  }
  println(
    "imaptest replies: " +
    passed.to_string() +
    " of " +
    total.to_string() +
    " read back as written, " +
    known.to_string() +
    " known not to be",
  )
  assert_eq(failures.length(), 0)
  // The counts are written down: a reply that starts passing has to come off
  // the list, and one that starts failing has to be understood.
  assert_eq(total, 676)
  assert_eq(passed, 665)
  assert_eq(known, known_gaps.length())
}
