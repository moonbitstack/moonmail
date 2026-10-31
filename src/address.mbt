// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// One mailbox: an address and the display name in front of it, decoded.
/// `address` is the addr-spec, its user part quoted only where a dot-atom
/// cannot carry it.
pub(all) struct Mailbox {
  name : String?
  address : String
} derive(Eq, Debug)

///|
pub extend Mailbox with Eq::{equal, not_equal}

///|
pub extend Mailbox with Debug::{to_repr}

///|
pub fn Mailbox::new(address : String, name? : String) -> Mailbox {
  { name, address, }
}

///|
/// One entry of an address list: a mailbox, or a named group of them, which
/// may be empty (`undisclosed-recipients:;`).
pub(all) enum Address {
  Mailbox(Mailbox)
  Group(name~ : String, members~ : Array[Mailbox])
} derive(Eq, Debug)

///|
pub extend Address with Eq::{equal, not_equal}

///|
pub extend Address with Debug::{to_repr}

///|
/// The mailboxes, a group's members in place of the group.
pub fn Address::mailboxes(self : Address) -> Array[Mailbox] {
  match self {
    Mailbox(m) => [m]
    Group(members~, ..) => members
  }
}

///|
/// Read one address (RFC 5322 section 3.4): a mailbox, with or without a
/// display name, or a group. The obsolete forms of section 4.4 are read too:
/// a phrase with periods, a route in the angle brackets, a user part or
/// domain with comments between its pieces. Encoded words in a display name
/// are decoded (RFC 2047).
pub fn parse_address(text : StringView) -> Address raise Refused {
  let lex = Lexer::new(text)
  let address = lex.address()
  lex.cfws() |> ignore
  if !lex.at_end() {
    raise Address(at=lex.at)
  }
  address
}

///|
/// Read an address list, as `To` and `Cc` carry; empty entries between commas
/// are skipped, as RFC 5322 section 4.4 allows.
pub fn parse_addresses(text : StringView) -> Array[Address] raise Refused {
  let lex = Lexer::new(text)
  let out = []
  while true {
    lex.cfws() |> ignore
    if lex.at_end() {
      break
    }
    if lex.eat(',') {
      continue
    }
    out.push(lex.address())
    lex.cfws() |> ignore
    if lex.at_end() {
      break
    }
    if !lex.eat(',') {
      raise Address(at=lex.at)
    }
  }
  out
}

///|
/// The mailbox as a header carries it. A display name that is not a run of
/// atoms is quoted; one that is not ASCII is written as encoded words, or as
/// UTF-8 when `utf8` is set (RFC 6532).
pub fn Mailbox::encode(self : Mailbox, utf8~ : Bool = false) -> String {
  match self.name {
    None | Some("") => self.address
    Some(name) => phrase(name, utf8) + " <" + self.address + ">"
  }
}

///|
/// The address as a header carries it; see `Mailbox::encode`.
pub fn Address::encode(self : Address, utf8~ : Bool = false) -> String {
  match self {
    Mailbox(m) => m.encode(utf8~)
    Group(name~, members~) =>
      phrase(name, utf8) +
      ":" +
      (if members.is_empty() { "" } else { " " }) +
      members.map(m => m.encode(utf8~)).join(", ") +
      ";"
  }
}

///|
/// An address list as a header carries it.
pub fn encode_addresses(
  addresses : ArrayView[Address],
  utf8~ : Bool = false,
) -> String {
  addresses.map(a => a.encode(utf8~)).join(", ")
}

///|
fn phrase(name : String, utf8 : Bool) -> String {
  let ascii = name.iter().all(c => c.to_int() < 0x80)
  if !ascii && !utf8 {
    return @moonmime.encode_words(name) catch { _ => quote(name) }
  }
  let words = name.split(" ").to_array()
  if words.iter().all(w => !w.is_empty() && w.iter().all(is_atext)) {
    name
  } else {
    quote(name)
  }
}

///|
fn quote(text : String) -> String {
  let out = StringBuilder()
  out.write_char('"')
  for c in text {
    if c == '"' || c == '\\' {
      out.write_char('\\')
    }
    out.write_char(c)
  }
  out.write_char('"')
  out.to_string()
}

///|
/// RFC 5322 section 3.2.3 `atext`, with the non-ASCII characters RFC 6532 adds.
fn is_atext(c : Char) -> Bool {
  (c >= 'a' && c <= 'z') ||
  (c >= 'A' && c <= 'Z') ||
  (c >= '0' && c <= '9') ||
  "!#$%&'*+-/=?^_`{|}~".contains_char(c) ||
  c.to_int() >= 0x80
}

///|
/// A piece of a phrase, and whether white space or a comment stood before it.
priv struct Piece {
  text : String
  spaced : Bool
  quoted : Bool
}

///|
priv struct Lexer {
  text : Array[Char]
  mut at : Int32
}

///|
fn Lexer::new(text : StringView) -> Lexer {
  { text: text.to_array(), at: 0, }
}

///|
fn Lexer::at_end(self : Lexer) -> Bool {
  self.at >= self.text.length()
}

///|
fn Lexer::peek(self : Lexer) -> Char? {
  self.text.get(self.at)
}

///|
fn Lexer::eat(self : Lexer, c : Char) -> Bool {
  if self.peek() == Some(c) {
    self.at += 1
    true
  } else {
    false
  }
}

///|
fn Lexer::expect(self : Lexer, c : Char) -> Unit raise Refused {
  if !self.eat(c) {
    raise Address(at=self.at)
  }
}

///|
/// Skip folding white space and comments; whether there was any.
fn Lexer::cfws(self : Lexer) -> Bool raise Refused {
  let start = self.at
  while self.peek() is Some(c) {
    if c == ' ' || c == '\t' || c == '\r' || c == '\n' {
      self.at += 1
    } else if c == '(' {
      self.comment()
    } else {
      break
    }
  }
  self.at > start
}

///|
/// A comment, nested ones and quoted pairs included.
fn Lexer::comment(self : Lexer) -> Unit raise Refused {
  let start = self.at
  self.at += 1
  let mut depth = 1
  while depth > 0 {
    guard self.peek() is Some(c) else { raise Address(at=start) }
    self.at += 1
    if c == '\\' {
      self.at += 1
    } else if c == '(' {
      depth += 1
    } else if c == ')' {
      depth -= 1
    }
  }
}

///|
/// A quoted string's content, the quoted pairs resolved.
fn Lexer::quoted(self : Lexer) -> String raise Refused {
  let start = self.at
  self.at += 1
  let out = StringBuilder()
  while true {
    guard self.peek() is Some(c) else { raise Address(at=start) }
    self.at += 1
    match c {
      '"' => break
      '\\' => {
        guard self.peek() is Some(next) else { raise Address(at=start) }
        out.write_char(next)
        self.at += 1
      }
      '\r' | '\n' => ()
      _ => out.write_char(c)
    }
  }
  out.to_string()
}

///|
fn Lexer::atom(self : Lexer) -> String? {
  let start = self.at
  while self.peek() is Some(c) && is_atext(c) {
    self.at += 1
  }
  if self.at == start {
    None
  } else {
    Some(String::from_array(self.text[start:self.at]))
  }
}

///|
/// A word: an atom or a quoted string.
fn Lexer::word(self : Lexer) -> (String, Bool)? raise Refused {
  match self.peek() {
    Some('"') => Some((self.quoted(), true))
    _ => self.atom().map(a => (a, false))
  }
}

///|
/// The words of a phrase, with the periods of RFC 5322 section 4.1 allowed
/// between them.
fn Lexer::phrase(self : Lexer) -> Array[Piece] raise Refused {
  let pieces = []
  while true {
    let spaced = self.cfws()
    if self.peek() == Some('.') && pieces.length() > 0 {
      self.at += 1
      pieces.push({ text: ".", spaced, quoted: false, })
      continue
    }
    match self.word() {
      Some((text, quoted)) => pieces.push({ text, spaced, quoted, })
      None => break
    }
  }
  pieces
}

///|
fn Lexer::address(self : Lexer) -> Address raise Refused {
  let start = self.at
  let pieces = self.phrase()
  self.cfws() |> ignore
  match self.peek() {
    Some(':') if pieces.length() > 0 => {
      self.at += 1
      let members = []
      while true {
        self.cfws() |> ignore
        if self.eat(';') {
          break
        }
        if self.eat(',') {
          continue
        }
        members.push(self.mailbox())
        self.cfws() |> ignore
        if self.peek() is Some(c) && c != ',' && c != ';' {
          raise Address(at=self.at)
        }
      }
      Group(name=display(pieces), members~)
    }
    _ => {
      self.at = start
      Mailbox(self.mailbox())
    }
  }
}

///|
fn Lexer::mailbox(self : Lexer) -> Mailbox raise Refused {
  self.cfws() |> ignore
  let start = self.at
  let pieces = self.phrase()
  self.cfws() |> ignore
  if self.peek() == Some('<') {
    let address = self.angle()
    let name = display(pieces)
    return { name: if name.is_empty() { None } else { Some(name) }, address, }
  }
  self.at = start
  let address = self.addr_spec()
  // RFC 5322 section 4.4 still lets a comment-only trailer stand after it.
  self.cfws() |> ignore
  { name: None, address, }
}

///|
/// `<` [route] addr-spec `>`; an obsolete route (`@a,@b:`) is read and dropped.
fn Lexer::angle(self : Lexer) -> String raise Refused {
  self.expect('<')
  self.cfws() |> ignore
  if self.peek() == Some('@') {
    while self.eat('@') || self.eat(',') {
      self.cfws() |> ignore
      if self.peek() != Some('@') && self.peek() != Some(',') {
        let _ = self.domain()
      }
      self.cfws() |> ignore
    }
    self.expect(':')
  }
  let address = self.addr_spec()
  self.cfws() |> ignore
  self.expect('>')
  address
}

///|
fn Lexer::addr_spec(self : Lexer) -> String raise Refused {
  self.cfws() |> ignore
  let words = []
  let mut quoted = false
  while true {
    self.cfws() |> ignore
    guard self.word() is Some((text, q)) else { raise Address(at=self.at) }
    words.push(text)
    quoted = quoted || q
    self.cfws() |> ignore
    if !self.eat('.') {
      break
    }
  }
  self.cfws() |> ignore
  self.expect('@')
  let user = words.join(".")
  let dot_atom = user
    .split(".")
    .all(w => !w.is_empty() && w.iter().all(is_atext))
  (if dot_atom { user } else { quote(user) }) + "@" + self.domain()
}

///|
/// A dot-atom domain, an obsolete one with comments between its atoms, or a
/// domain literal.
fn Lexer::domain(self : Lexer) -> String raise Refused {
  self.cfws() |> ignore
  if self.peek() == Some('[') {
    let start = self.at
    while self.peek() is Some(c) && c != ']' {
      if c == '\\' {
        self.at += 1
      }
      self.at += 1
    }
    self.expect(']')
    return String::from_array(self.text[start:self.at])
  }
  let atoms = []
  while true {
    self.cfws() |> ignore
    guard self.atom() is Some(atom) else { raise Address(at=self.at) }
    atoms.push(atom)
    let mark = self.at
    self.cfws() |> ignore
    if !self.eat('.') {
      self.at = mark
      break
    }
  }
  atoms.join(".")
}

///|
/// A display name from its pieces: one space where any white space or
/// comment stood, and encoded words decoded.
fn display(pieces : Array[Piece]) -> String {
  let out = StringBuilder()
  for i, piece in pieces {
    if i > 0 && piece.spaced {
      out.write_char(' ')
    }
    out.write_string(piece.text)
  }
  let joined = out.to_string()
  if pieces.iter().any(p => !p.quoted && p.text.contains("=?")) {
    @moonmime.decode_words(joined)
  } else {
    joined
  }
}
