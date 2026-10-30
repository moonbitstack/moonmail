// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
test "parse splits headers and body" {
  let raw = @utf8.encode(
    "Subject: Hello\r\nContent-Type: text/plain\r\n\r\nBody text\r\n",
  )
  let msg = @moonmail.parse(raw[:])
  inspect(msg.get_header("Subject") == Some("Hello"), content="true")
  inspect(@utf8.decode_lossy(msg.payload()[:]), content="Body text\r\n")
  inspect(msg.is_multipart(), content="false")
}

///|
test "header lookup is case-insensitive" {
  let msg = @moonmail.parse(@utf8.encode("Subject: Hi\r\n\r\nx")[:])
  inspect(msg.get_header("subject") == Some("Hi"), content="true")
  inspect(msg.get_header("missing") == None, content="true")
}

///|
test "parse unfolds a folded header" {
  let msg = @moonmail.parse(
    @utf8.encode("Subject: Hello\r\n World\r\n\r\nbody")[:],
  )
  inspect(msg.get_header("Subject") == Some("Hello World"), content="true")
}

///|
test "parse collects repeated headers in order" {
  let msg = @moonmail.parse(
    @utf8.encode("Received: one\r\nReceived: two\r\n\r\nx")[:],
  )
  let names = msg.headers_named("Received")
  inspect(names.length(), content="2")
  inspect(names[0], content="one")
  inspect(names[1], content="two")
}

///|
test "content_type parses main type and quoted boundary" {
  let raw = @utf8.encode(
    "Content-Type: multipart/mixed; boundary=\"XYZ\"\r\n\r\nx",
  )
  let ct = @moonmail.parse(raw[:]).content_type()
  inspect(ct.main, content="multipart/mixed")
  inspect(ct.is_multipart, content="true")
  inspect(ct.boundary == Some("XYZ"), content="true")
}

///|
test "parse decodes a base64 body" {
  let raw = @utf8.encode(
    "Content-Type: text/plain\r\nContent-Transfer-Encoding: base64\r\n\r\nSGVsbG8=",
  )
  let msg = @moonmail.parse(raw[:])
  inspect(@utf8.decode_lossy(msg.payload()[:]), content="Hello")
}

///|
test "parse decodes a quoted-printable body" {
  let raw = @utf8.encode(
    "Content-Transfer-Encoding: quoted-printable\r\n\r\nCaf=C3=A9",
  )
  let msg = @moonmail.parse(raw[:])
  inspect(@utf8.decode_lossy(msg.payload()[:]), content="Café")
}

///|
test "parse splits a multipart body into parts" {
  let raw = @utf8.encode(
    "Content-Type: multipart/alternative; boundary=\"BOUND\"\r\n\r\n--BOUND\r\nContent-Type: text/plain\r\n\r\nplain\r\n--BOUND\r\nContent-Type: text/html\r\n\r\n<p>x</p>\r\n--BOUND--\r\n",
  )
  let msg = @moonmail.parse(raw[:])
  inspect(msg.is_multipart(), content="true")
  let parts = msg.parts()
  inspect(parts.length(), content="2")
  inspect(@utf8.decode_lossy(parts[0].payload()[:]), content="plain")
  inspect(@utf8.decode_lossy(parts[1].payload()[:]), content="<p>x</p>")
}

///|
test "decoded_header resolves encoded words" {
  let msg = @moonmail.parse(
    @utf8.encode("Subject: =?utf-8?B?Q2Fmw6k=?=\r\n\r\nx")[:],
  )
  inspect(msg.decoded_header("Subject") == Some("Café"), content="true")
}

///|
test "serialize reproduces a simple message" {
  let msg = @moonmail.parse(@utf8.encode("Subject: Hi\r\n\r\nbody")[:])
  inspect(
    @utf8.decode_lossy(@moonmail.serialize(msg)[:]),
    content="Subject: Hi\r\n\r\nbody",
  )
}

///|
test "parse passes an 8bit body through unchanged" {
  let raw = @utf8.encode("Content-Transfer-Encoding: 8bit\r\n\r\nCafé raw\r\n")
  let msg = @moonmail.parse(raw[:])
  inspect(@utf8.decode_lossy(msg.payload()[:]), content="Café raw\r\n")
}

///|
test "content_type defaults to text/plain when the header is absent" {
  let ct = @moonmail.parse(@utf8.encode("Subject: x\r\n\r\nbody")[:]).content_type()
  inspect(ct.main, content="text/plain")
  inspect(ct.is_multipart, content="false")
  inspect(ct.boundary == None, content="true")
}

///|
test "a message with headers only has an empty body" {
  let msg = @moonmail.parse(@utf8.encode("Subject: only headers")[:])
  inspect(msg.get_header("Subject") == Some("only headers"), content="true")
  inspect(msg.payload().length(), content="0")
}

///|
test "serialize re-encodes a base64 body and round trips" {
  let raw = @utf8.encode("Content-Transfer-Encoding: base64\r\n\r\nSGVsbG8=")
  let msg = @moonmail.parse(raw[:])
  let saved = @moonmail.serialize(msg)
  let again = @moonmail.parse(saved[:])
  inspect(@utf8.decode_lossy(again.payload()[:]), content="Hello")
}

///|
test "parse falls back to raw bytes when base64 is broken" {
  let raw = @utf8.encode(
    "Content-Transfer-Encoding: base64\r\n\r\n!!!not base64",
  )
  let msg = @moonmail.parse(raw[:])
  inspect(@utf8.decode_lossy(msg.payload()[:]), content="!!!not base64")
}

///|
test "serialize keeps multipart preamble and epilogue" {
  let raw = @utf8.encode(
    "Content-Type: multipart/mixed; boundary=B\r\n\r\nPREAMBLE\r\n--B\r\n\r\npart\r\n--B--\r\nEPILOGUE\r\n",
  )
  let saved = @utf8.decode_lossy(
    @moonmail.serialize(@moonmail.parse(raw[:]))[:],
  )
  inspect(saved.find("PREAMBLE") is Some(_), content="true")
  inspect(saved.find("EPILOGUE") is Some(_), content="true")
}
