// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// How the bytes of a body turn into the text they carry, and back. Three come
/// with the library; everything else arrives through this trait, so a codebase
/// that needs windows-1252 does not need a fork of this one.
pub(open) trait Charset {
  fn decode(Self, BytesView) -> String raise Refused
  fn encode(Self, StringView) -> Bytes raise Refused
}

///|
priv struct Utf8 {}

///|
impl Charset for Utf8 with fn decode(_self : Utf8, data : BytesView) -> String raise Refused {
  @utf8.decode_lossy(data)
}

///|
impl Charset for Utf8 with fn encode(_self : Utf8, text : StringView) -> Bytes raise Refused {
  @utf8.encode(text)
}

///|
priv struct Ascii {}

///|
/// US-ASCII in name, Latin-1 in tolerance: mail that declares ASCII and carries
/// a stray high octet is too common to refuse, so it is read as ISO-8859-1 and
/// never the other way around — encoding refuses what cannot be written.
impl Charset for Ascii with fn decode(_self : Ascii, data : BytesView) -> String raise Refused {
  latin1_text(data)
}

///|
impl Charset for Ascii with fn encode(_self : Ascii, text : StringView) -> Bytes raise Refused {
  let out = Buffer()
  for c in text {
    let n = code(c)
    if n > 127 {
      raise Refused::Charset(name="us-ascii")
    }
    out.write_byte(n.to_byte())
  }
  out.to_bytes()
}

///|
priv struct Latin1 {}

///|
impl Charset for Latin1 with fn decode(_self : Latin1, data : BytesView) -> String raise Refused {
  latin1_text(data)
}

///|
impl Charset for Latin1 with fn encode(_self : Latin1, text : StringView) -> Bytes raise Refused {
  let out = Buffer()
  for c in text {
    let n = code(c)
    if n > 255 {
      raise Refused::Charset(name="iso-8859-1")
    }
    out.write_byte(n.to_byte())
  }
  out.to_bytes()
}

///|
/// One octet, one character: the identity mapping the ISO-8859 family shares,
/// and what a message is read as when the declared set cannot represent what it
/// carries. Undecodable encoder keeps going, so a partially known body survives.
fn latin1_text(data : BytesView) -> String {
  let out = StringBuilder()
  for b in data {
    out.write_char(b.to_char())
  }
  out.to_string()
}

///|
/// The registered sets. Mutable under a top-level binding, which is the only
/// shape MoonBit offers a runtime registry; nothing else in this package keeps
/// state between calls.
let registry : Registry = Registry::new()

///|
/// One registered set: the lower-cased name it answers to and the codec it
/// dispatches to. A named struct rather than a `(String, &Charset)` tuple so the
/// trait object sits inside a concrete type and never reads as map material.
priv struct Entry {
  name : String
  codec : &Charset
}

///|
priv struct Registry {
  codecs : Array[Entry]
}

///|
fn Registry::new() -> Registry {
  let table : Array[Entry] = [
    { name: "utf-8", codec: Utf8::{ } as &Charset, },
    { name: "utf8", codec: Utf8::{ } as &Charset, },
    { name: "us-ascii", codec: Ascii::{ } as &Charset, },
    { name: "ascii", codec: Ascii::{ } as &Charset, },
    { name: "iso-8859-1", codec: Latin1::{ } as &Charset, },
    { name: "latin1", codec: Latin1::{ } as &Charset, },
    { name: "l1", codec: Latin1::{ } as &Charset, },
  ]
  { codecs: table, }
}

///|
/// Put a charset under a name, replacing whatever answer that name had. Use it
/// for the sets this library does not ship, and for aliasing one name another
/// file uses:
///
/// ```mbt check
/// test {
///   // The shipped sets answer by their names, including common aliases:
///   let enc = @moonmail.encode_charset(name="iso-8859-1", text="é")
///   let dec = @moonmail.decode_charset(name="iso-8859-1", data=enc[:])
///   inspect(dec, content="é")
/// }
/// ```
pub fn[T : Charset] register(name~ : String, codec~ : T) -> Unit {
  let known = lower(name[:])
  let mut at = -1
  for index, entry in registry.codecs.iter2() {
    if entry.name == known {
      at = index
    }
  }
  let boxed = codec as &Charset
  if at >= 0 {
    registry.codecs[at] = { name: known, codec: boxed, }
  } else {
    registry.codecs.push({ name: known, codec: boxed, })
  }
}

///|
fn lookup(name : StringView) -> &Charset raise Refused {
  let known = lower(name)
  for entry in registry.codecs {
    if entry.name == known {
      return entry.codec
    }
  }
  raise Refused::Charset(name=known)
}

///|
/// Read `data` as `name` says it was written. Unmapping octets become U+FFFD so
/// that one bad byte costs one character and not the whole part.
///
/// ```mbt check
/// test {
///   let text = @moonmail.decode_charset(name="iso-8859-1", data=b"\xe9") catch {
///     _ => ""
///   }
///   inspect(text, content="é")
/// }
/// ```
pub fn decode_charset(
  name~ : StringView,
  data~ : BytesView,
) -> String raise Refused {
  lookup(name).decode(data)
}

///|
/// Write `text` in `name`, refusing a character the set has no room for.
///
/// ```mbt check
/// test {
///   let bytes = @moonmail.encode_charset(name="iso-8859-1", text="é") catch {
///     _ => b""
///   }
///   inspect(bytes == b"\xe9", content="true")
/// }
/// ```
pub fn encode_charset(
  name~ : StringView,
  text~ : StringView,
) -> Bytes raise Refused {
  lookup(name).encode(text)
}

///|
/// A tiny in-package codec used only to prove `register` dispatches a caller's
/// own charset: Caesar-1 over ASCII, so `a`→`b` and `b`→`c`.
priv struct Shift1 {}

///|
impl Charset for Shift1 with fn decode(_self : Shift1, data : BytesView) -> String raise Refused {
  let out = Buffer()
  for b in data {
    out.write_byte((b.to_int() + 1).to_byte())
  }
  @utf8.decode_lossy(out.to_bytes()[:])
}

///|
impl Charset for Shift1 with fn encode(_self : Shift1, text : StringView) -> Bytes raise Refused {
  let out = Buffer()
  for c in text {
    out.write_byte((c.to_int() - 1).to_byte())
  }
  out.to_bytes()
}

///|
/// `register` accepts a codec defined anywhere in the package and answers it by
/// a lower-cased name, replacing any earlier answer.
test {
  register(name="x-shift1", codec=Shift1::{ })
  inspect(
    decode_charset(name="x-shift1", data=@utf8.encode("bcde")[:]),
    content="cdef",
  )
}

///|
/// Encoding is allowed to refuse what cannot be written, while decoding is not:
/// US-ASCII has no room for `é`, so the encoder reports `Charset`.
test {
  let raised = try {
    let _ = encode_charset(name="us-ascii", text="é")
    false
  } catch {
    _ => true
  }
  inspect(raised, content="true")
}
