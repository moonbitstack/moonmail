// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
fn hex_value(c : Char) -> Int32 {
  if c >= '0' && c <= '9' {
    c.to_int() - '0'.to_int()
  } else if c >= 'a' && c <= 'f' {
    c.to_int() - 'a'.to_int() + 10
  } else if c >= 'A' && c <= 'F' {
    c.to_int() - 'A'.to_int() + 10
  } else {
    0
  }
}

///|
fn hex_bytes(s : String) -> Bytes {
  let out = Buffer()
  let n = s.length()
  let mut i = 0
  while i + 1 < n {
    let hi = hex_value(s.get_char(i).unwrap_or('0'))
    let lo = hex_value(s.get_char(i + 1).unwrap_or('0'))
    out.write_byte((hi * 16 + lo).to_byte())
    i = i + 2
  }
  out.to_bytes()
}

///|
/// A fixed 1024-bit RSA key generated for these tests; the signature only has to
/// round-trip, so the key need not be from any authority.
fn test_key() -> @rsa.PrivateKey? {
  let n = hex_bytes(
    "cc5b577e919dacc7d97bfbba88a6dff832697cf0fd67efecc5c5884393d945c98cea2327c32a74fa96526f48cf4b081c6444ee91d2f85da5405d5f665e40d3ad5afb35c77af79e14f8610b58900e90ee7cbdd659c5303d02b504655c13601d143bf05c4c2a6ec35add559e116c6989125d3dc89962d44b95e40d3d73659a66f7",
  )
  let e = hex_bytes("010001")
  let d = hex_bytes(
    "b5da52f1ff03214e76eb2e07c0b33f7bcee0b09e83e28a4f596f7ee3241ea54bc66a54fe7d5ebada840ab79d435ab1cd122d855f9f2e05a798af7ec5c9fa4662d5ad9868d75cd3305ae18a49f8b9bd1082045b2d69e97803406af1f0607e2f2c94aeddaf2c0e967d1ab71ddd2ce055ac0881654009f4c89d7ff9b0edb1440001",
  )
  Some(
    @rsa.PrivateKey::new(
      n[:],
      e[:],
      d[:],
      digest=@rsa.Digest::Sha256,
      scheme=@rsa.Scheme::Pkcs1,
    ),
  ) catch {
    _ => None
  }
}

///|
test "dkim relaxed header canonicalisation" {
  inspect(
    @dkim.canonicalize_header("A", "A: X", @dkim.Canon::Relaxed),
    content="a:X\r\n",
  )
  // A fold and stray WSP collapse to single spaces, trailing WSP disappears.
  inspect(
    @dkim.canonicalize_header("B", "B : Y\r\n\tZ  ", @dkim.Canon::Relaxed),
    content="b:Y Z\r\n",
  )
}

///|
test "dkim simple header canonicalisation keeps octets" {
  inspect(
    @dkim.canonicalize_header("A", "A:  X  Y", @dkim.Canon::Simple),
    content="A:  X  Y\r\n",
  )
}

///|
test "dkim relaxed body canonicalisation" {
  let body = @utf8.encode(" C \r\nD \tE\r\n\r\n\r\n")
  let canon = @dkim.canon_body(body[:], @dkim.Canon::Relaxed)
  inspect(@utf8.decode_lossy(canon[:]), content=" C\r\nD E\r\n")
  // Cross-checked against Python's hashlib for the same canonical octets.
  inspect(
    @dkim.body_hash(body[:], @dkim.Canon::Relaxed),
    content="unak6JHq0wL+Q1HP7dW1tjBx9FLA6DffoZ0qrLwbbpo=",
  )
}

///|
test "dkim body hash drops trailing empty lines" {
  let body = @utf8.encode("Hello\r\n\r\n\r\n")
  inspect(
    @utf8.decode_lossy(@dkim.canon_body(body[:], @dkim.Canon::Simple)[:]),
    content="Hello\r\n",
  )
  inspect(
    @dkim.body_hash(body[:], @dkim.Canon::Simple),
    content="Ba3gj8+xBPQLJTahTfzW6RbWQ/XPgESxkCi2B66PSQg=",
  )
}

///|
test "dkim body hash of an empty body" {
  inspect(
    @dkim.body_hash(@utf8.encode("")[:], @dkim.Canon::Relaxed),
    content="47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=",
  )
}

///|
test "dkim sign then verify a relaxed message" {
  let msg = @utf8.encode(
    "From: Alice <alice@example.com>\r\nTo: Bob <bob@example.com>\r\nSubject: Hello\r\nDate: Fri, 30 Oct 2026 08:00:00 +0000\r\n\r\nHello, Bob!\r\n",
  )
  let mut verified = false
  match test_key() {
    Some(key) => {
      let pkey = key.public()
      let opts = @dkim.SignOptions::new(domain="example.com", selector="sel", headers=[
        "From", "To", "Subject", "Date",
      ])
      let sig = @dkim.sign(msg[:], key, opts)
      let out = Buffer()
      out.write_string_utf8("DKIM-Signature: " + sig + "\r\n")
      out.write_bytes(msg)
      verified = @dkim.verify(out.to_bytes()[:], pkey)
    }
    None => ()
  }
  inspect(verified, content="true")
}

///|
test "dkim sign then verify a simple message" {
  let msg = @utf8.encode(
    "From: Alice <alice@example.com>\r\nSubject: Hi\r\n\r\nbody line\r\n",
  )
  let mut verified = false
  match test_key() {
    Some(key) => {
      let pkey = key.public()
      let opts = @dkim.SignOptions::new(
        domain="example.com",
        selector="sel",
        headers=["From", "Subject"],
        header_canon=@dkim.Canon::Simple,
        body_canon=@dkim.Canon::Simple,
      )
      let sig = @dkim.sign(msg[:], key, opts)
      let out = Buffer()
      out.write_string_utf8("DKIM-Signature: " + sig + "\r\n")
      out.write_bytes(msg)
      verified = @dkim.verify(out.to_bytes()[:], pkey)
    }
    None => ()
  }
  inspect(verified, content="true")
}

///|
test "dkim signature matches an openssl reference vector" {
  // The expected value was produced independently: canonicalize and hash in
  // Python, sign the signing input with `openssl dgst -sha256 -sign`. RSA
  // PKCS#1 v1.5 is deterministic, so the octets must agree exactly.
  let msg = @utf8.encode(
    "From: Alice <alice@example.com>\r\nTo: Bob <bob@example.com>\r\nSubject: Hello\r\nDate: Fri, 30 Oct 2026 08:00:00 +0000\r\n\r\nHello, Bob!\r\n",
  )
  let mut actual = ""
  match test_key() {
    Some(key) => {
      let opts = @dkim.SignOptions::new(domain="example.com", selector="sel", headers=[
        "From", "To", "Subject", "Date",
      ])
      actual = @dkim.sign(msg[:], key, opts)
    }
    None => ()
  }
  inspect(
    actual,
    content="v=1; a=rsa-sha256; c=relaxed/relaxed; d=example.com; s=sel; h=from:to:subject:date; bh=gDa01/VL/4U905vImGmcTiz9KfkZV915tbfsTFkpe5U=; b=NC8B9khNlnRjSGwre7LQacGpjxufthddo3HFueUMy5FW8Dtlkw0sfq4681UWuZvtrvBYQYSE+N+r4LRxJp/PbFjstswLzp8ixAEJLYREaKKjfsmoZWmdPKwgbD4GcbUR2YiZkkUVHqHfSPWn5WF1DW5J001N2QM7K4d6PXy2XDo=",
  )
}

///|
test "dkim verify rejects a tampered body" {
  let msg = @utf8.encode("From: Alice\r\nSubject: Hi\r\n\r\nbody line\r\n")
  let mut verified = true
  match test_key() {
    Some(key) => {
      let pkey = key.public()
      let opts = @dkim.SignOptions::new(domain="example.com", selector="sel", headers=[
        "From", "Subject",
      ])
      let sig = @dkim.sign(msg[:], key, opts)
      let out = Buffer()
      out.write_string_utf8("DKIM-Signature: " + sig + "\r\n")
      out.write_string_utf8(
        "From: Alice\r\nSubject: Hi\r\n\r\nbody line TAMPERED\r\n",
      )
      verified = @dkim.verify(out.to_bytes()[:], pkey)
    }
    None => ()
  }
  inspect(verified, content="false")
}

///|
/// Insert a folding break inside the `b=` value, the way a signer that respects
/// a line-length limit would.
fn fold_b(value : String) -> String {
  let at = value.find("b=")
  match at {
    Some(pos) => {
      let cut = pos + 2 + 40
      if cut < value.length() {
        value[0:cut].to_owned() + "\r\n " + value[cut:].to_owned()
      } else {
        value
      }
    }
    None => value
  }
}

///|
test "dkim verifies a signature folded across lines" {
  let msg = @utf8.encode(
    "From: Alice <alice@example.com>\r\nSubject: Hi\r\n\r\nbody\r\n",
  )
  let mut verified = false
  match test_key() {
    Some(key) => {
      let opts = @dkim.SignOptions::new(domain="example.com", selector="sel", headers=[
        "From", "Subject",
      ])
      let sig = @dkim.sign(msg[:], key, opts)
      let out = Buffer()
      out.write_string_utf8("DKIM-Signature: " + fold_b(sig) + "\r\n")
      out.write_bytes(msg)
      verified = @dkim.verify(out.to_bytes()[:], key.public())
    }
    None => ()
  }
  inspect(verified, content="true")
}

///|
test "dkim verify fails without a signature header" {
  let msg = @utf8.encode("From: a@example.com\r\nSubject: b\r\n\r\nbody\r\n")
  let mut result = true
  match test_key() {
    Some(key) => result = @dkim.verify(msg[:], key.public())
    None => ()
  }
  inspect(result, content="false")
}

///|
test "dkim verify rejects a tampered signed header" {
  let msg = @utf8.encode("From: Alice\r\nSubject: Hi\r\n\r\nbody\r\n")
  let mut verified = true
  match test_key() {
    Some(key) => {
      let opts = @dkim.SignOptions::new(domain="example.com", selector="sel", headers=[
        "From", "Subject",
      ])
      let sig = @dkim.sign(msg[:], key, opts)
      let out = Buffer()
      out.write_string_utf8("DKIM-Signature: " + sig + "\r\n")
      out.write_string_utf8("From: Alice\r\nSubject: Hacked\r\n\r\nbody\r\n")
      verified = @dkim.verify(out.to_bytes()[:], key.public())
    }
    None => ()
  }
  inspect(verified, content="false")
}
