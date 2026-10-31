// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
fn text(data : Bytes) -> String {
  @utf8.decode_lossy(data[:])
}

///|
fn[T] refusal(f : () -> T raise @moonmail.Refused) -> @moonmail.Refused? {
  try {
    let _ = f()
    None
  } catch {
    e => Some(e)
  }
}

///|
/// Write, read back, write again: the tree and the octets must hold.
fn stable(message : @moonmail.Message, utf8~ : Bool = false) -> Bytes raise {
  let wire = message.encode(utf8~)
  let back = @moonmail.Message::parse(wire[:])
  let again = back.encode(utf8~)
  assert_eq(text(again), text(wire))
  assert_eq(@moonmail.Message::parse(again[:]), back)
  wire
}

///|
test "message reads a simple message and writes it back" {
  let message = @moonmail.Message::parse(
    b"From: a@example.com\nSubject: Hi\n\nline one\nline two\n",
  )
  assert_eq(message.headers.get("subject"), Some("Hi"))
  assert_eq(message.body, Leaf(b"line one\nline two\n"))
  let wire = stable(message)
  inspect(
    text(wire),
    content="From: a@example.com\r\nSubject: Hi\r\n\r\nline one\r\nline two\r\n",
  )
}

///|
test "message unfolds the header and folds it again at 78 columns" {
  let message = @moonmail.Message::parse(
    b"Subject: one two\r\n three\r\n\tfour\r\n\r\n",
  )
  assert_eq(message.headers.get("Subject"), Some("one two three\tfour"))
  let long = "word ".repeat(30).trim_end().to_owned()
  let headers = @moonmail.Headers::new()
  headers.add("Subject", long)
  let wire = stable({ headers, body: Leaf(b""), })
  for line in text(wire).split("\r\n") {
    assert_true(line.length() <= 78)
  }
  assert_eq(
    @moonmail.Message::parse(wire[:]).headers.get("Subject"),
    Some(long),
  )
}

///|
test "message writes what 7bit cannot carry in quoted-printable or base64" {
  let headers = @moonmail.Headers::new()
  headers.add("Content-Type", "text/plain; charset=utf-8")
  let wire = stable({ headers, body: Leaf(@utf8.encode("café\r\n")), })
  inspect(
    text(wire).contains("Content-Transfer-Encoding: quoted-printable"),
    content="true",
  )
  inspect(text(wire).contains("caf=C3=A9"), content="true")
  let binary = @moonmail.Headers::new()
  binary.add("Content-Type", "application/octet-stream")
  let blob = stable({ headers: binary, body: Leaf(b"\x00\x01\xff"), })
  inspect(
    text(blob).contains("Content-Transfer-Encoding: base64"),
    content="true",
  )
  let long = @moonmail.Headers::new()
  long.add("Content-Type", "text/plain")
  let wide = stable({
    headers: long,
    body: Leaf(@utf8.encode("x".repeat(1200))),
  })
  inspect(text(wide).contains("quoted-printable"), content="true")
}

///|
test "message writes non-ASCII header text as encoded words or as UTF-8" {
  let headers = @moonmail.Headers::new()
  headers.add("From", "Renée <renee@example.com>")
  headers.add("Subject", "Grüße")
  let message : @moonmail.Message = { headers, body: Leaf(b"hi\r\n"), }
  let wire = text(stable(message))
  inspect(wire.contains("From: =?utf-8?"), content="true")
  inspect(wire.contains("<renee@example.com>"), content="true")
  inspect(wire.contains("Subject: =?utf-8?"), content="true")
  let back = @moonmail.Message::parse(@utf8.encode(wire))
  assert_eq(back.subject(), Some("Grüße"))
  assert_eq(back.from(), [
    { name: Some("Renée"), address: "renee@example.com", },
  ])
  let raw = text(stable(message, utf8=true))
  inspect(raw.contains("Subject: Grüße"), content="true")
}

///|
test "headers keep order, ignore case and refuse injection" {
  let headers = @moonmail.Headers::new()
  headers.add("Received", "one")
  headers.add("X-Tag", "a")
  headers.add("received", "two")
  assert_eq(headers.all("RECEIVED"), ["one", "two"])
  headers.set("Received", "only")
  assert_eq(headers.all("received"), ["only"])
  headers.remove("x-tag")
  assert_eq(headers.length(), 1)
  assert_eq(
    refusal(() => headers.add("Subject", "hi\r\nBcc: victim@example.com")),
    Some(Header(at=2)),
  )
  assert_eq(refusal(() => headers.add("Bad Name", "x")), Some(Header(at=3)))
}

///|
test "message tolerates what strict refuses" {
  let stray = b"Subject: a\r\nnot a field\r\n\r\nbody"
  let lenient = @moonmail.Message::parse(stray)
  assert_eq(lenient.headers.length(), 1)
  assert_eq(
    refusal(() => @moonmail.Message::parse(stray, strict=true)),
    Some(Header(at=12)),
  )
  let open = b"Content-Type: multipart/mixed; boundary=b\r\n\r\n--b\r\n\r\nonly part"
  guard @moonmail.Message::parse(open).body is Multipart([part]) else {
    fail("the last part should run to the end")
  }
  assert_eq(part.body, Leaf(b"only part"))
  assert_eq(
    refusal(() => @moonmail.Message::parse(open, strict=true)),
    Some(Boundary(at=61)),
  )
  let unknown = b"Content-Transfer-Encoding: x-uuencode\r\n\r\nbegin"
  assert_eq(@moonmail.Message::parse(unknown).body, Leaf(b"begin"))
  assert_eq(
    refusal(() => @moonmail.Message::parse(unknown, strict=true)),
    Some(Encoding(at=41)),
  )
  let broken = b"Content-Transfer-Encoding: base64\r\n\r\n!!!!"
  assert_eq(
    refusal(() => @moonmail.Message::parse(broken, strict=true)),
    Some(Encoding(at=37)),
  )
}

///|
test "message reads an attached message and a digest" {
  let forward = @moonmail.Message::parse(
    b"Content-Type: message/rfc822\r\n\r\nSubject: Inner\r\n\r\ninner\r\n",
  )
  guard forward.body is Embedded(inner) else { fail("no embedded message") }
  assert_eq(inner.subject(), Some("Inner"))
  let digest = @moonmail.Message::parse(
    b"Content-Type: multipart/digest; boundary=d\r\n\r\n--d\r\n\r\nSubject: One\r\n\r\nfirst\r\n--d--\r\n",
  )
  guard digest.body is Multipart([part]) else { fail("no digest part") }
  guard part.body is Embedded(first) else { fail("a digest part is a message") }
  assert_eq(first.subject(), Some("One"))
}

///|
test "message reads dates in their old forms too" {
  let dates = [
    "Tue, 1 Jul 2003 10:52:37 +0200", "1 Jul 03 10:52 EDT", "Thu, 13 Feb 1969 23:32:54 -0330 (Newfoundland Time)",
    "Fri, 21 Nov 97 09:55:06 GMT", "21 Nov 1997 09:55:06 -0000",
  ]
  let written = dates.map(d => @moonmail.format_date(@moonmail.parse_date(d)))
  assert_eq(written, [
    "Tue, 01 Jul 2003 10:52:37 +0200", "Tue, 01 Jul 2003 10:52:00 -0400", "Thu, 13 Feb 1969 23:32:54 -0330",
    "Fri, 21 Nov 1997 09:55:06 +0000", "Fri, 21 Nov 1997 09:55:06 +0000",
  ])
  assert_eq(refusal(() => @moonmail.parse_date("yesterday")), Some(Date))
}

///|
test "message new picks the nesting from what it carries" {
  let from = @moonmail.Mailbox::new("alice@example.com", name="Alice")
  let to = [
    @moonmail.Address::Mailbox(@moonmail.Mailbox::new("bob@example.com")),
  ]
  let plain = @moonmail.Message::new(from~, to~, subject="One", text="hello")
  assert_eq(plain.content_type().essence, "text/plain")
  let both = @moonmail.Message::new(
    from~,
    to~,
    subject="Two",
    text="hi",
    html="<p>hi</p>",
  )
  assert_eq(both.content_type().essence, "multipart/alternative")
  let logo = @moonmail.Attachment::new(
    "logo.png",
    b"\x89PNG",
    inline=true,
    id="logo",
  )
  let report = @moonmail.Attachment::new("report.pdf", b"%PDF")
  let full = @moonmail.Message::new(
    from~,
    to~,
    subject="Three",
    text="hi",
    html="<img src=\"cid:logo\">",
    attachments=[logo, report],
    date=@moonmail.parse_date("Tue, 1 Jul 2003 10:52:37 +0200"),
    message_id="<1@example.com>",
  )
  assert_eq(full.content_type().essence, "multipart/mixed")
  guard full.body is Multipart([related, _]) else {
    fail("mixed has two parts")
  }
  assert_eq(related.content_type().essence, "multipart/related")
  assert_eq(related.content_type().param("type"), Some("multipart/alternative"))
  let wire = stable(full)
  let back = @moonmail.Message::parse(wire[:])
  assert_eq(back.text(), Some("hi"))
  assert_eq(back.html(), Some("<img src=\"cid:logo\">"))
  assert_eq(back.attachments(), [
    {
      name: "logo.png",
      media_type: "image/png",
      data: b"\x89PNG",
      inline: true,
      id: Some("logo"),
    },
    {
      name: "report.pdf",
      media_type: "application/pdf",
      data: b"%PDF",
      inline: false,
      id: None,
    },
  ])
  assert_eq(back.message_id(), Some("<1@example.com>"))
  assert_eq(
    back.date().map(@moonmail.format_date),
    Some("Tue, 01 Jul 2003 10:52:37 +0200"),
  )
}

///|
test "message gives a multipart without a boundary one of its own" {
  let headers = @moonmail.Headers::new()
  headers.add("Content-Type", "multipart/mixed")
  let part_headers = @moonmail.Headers::new()
  part_headers.add("Content-Type", "text/plain")
  let message : @moonmail.Message = {
    headers,
    body: Multipart([{ headers: part_headers, body: Leaf(b"inside\r\n"), }]),
  }
  let wire = stable(message)
  let back = @moonmail.Message::parse(wire[:])
  assert_eq(
    back.content_type().param("boundary").map(b => b.has_prefix("=_")),
    Some(true),
  )
  assert_eq(back.text(), Some("inside\r\n"))
}

///|
test "addresses refuse what is not an address list" {
  assert_eq(
    refusal(() => @moonmail.parse_addresses("a@b.test, <unclosed@x")),
    Some(Address(at=21)),
  )
  assert_eq(
    refusal(() => @moonmail.parse_address("no-domain")),
    Some(Address(at=9)),
  )
  assert_eq(
    @moonmail.Address::Group(name="Team", members=[]).encode(),
    "Team:;",
  )
  assert_eq(
    @moonmail.Mailbox::new("a@b.test", name="Doe, John").encode(),
    "\"Doe, John\" <a@b.test>",
  )
}
