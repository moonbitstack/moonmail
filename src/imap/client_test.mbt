// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
fn wire(data : Bytes?) -> String {
  match data {
    Some(bytes) => @utf8.decode_lossy(bytes[:])
    None => "(nothing)"
  }
}

///|
fn crlf(text : String) -> Bytes {
  @utf8.encode(text + "\r\n")
}

///|
fn[T] refusal(f : () -> T raise @imap.Refused) -> @imap.Refused? {
  try {
    let _ = f()
    None
  } catch {
    e => Some(e)
  }
}

///|
/// A client past a greeting that announced `capabilities`.
fn opened(capabilities : String) -> @imap.Client raise @imap.Refused {
  let client = @imap.Client::new()
  let _ = client.feed(crlf("* OK [CAPABILITY " + capabilities + "] ready"))
  client
}

///|
/// The one untagged response `line` decodes to.
fn untagged(line : String) -> @imap.Response raise {
  let client = opened("IMAP4rev2")
  guard client.feed(crlf(line)) is [Data(response)] else {
    fail("not one untagged response: " + line)
  }
  response
}

///|
test "imap reads the greeting and its capabilities" {
  let client = @imap.Client::new()
  let _ = client.capability()
  inspect(wire(client.next_write()), content="(nothing)")
  let events = client.feed(crlf("* OK [CAPABILITY IMAP4rev2 IDLE] Hello"))
  assert_eq(events, [
    Data(Condition("OK", Some(Capability(["IMAP4rev2", "IDLE"])), "Hello")),
  ])
  inspect(client.has("idle"), content="true")
  inspect(wire(client.next_write()), content="A0001 CAPABILITY\r\n")
  let preauth = @imap.Client::new()
  let _ = preauth.feed(crlf("* PREAUTH ready"))
  assert_eq(preauth.state(), Authenticated)
}

///|
test "imap decodes the untagged responses" {
  assert_eq(untagged("* 23 EXISTS"), Exists(23))
  assert_eq(untagged("* 3 EXPUNGE"), Expunge(3))
  assert_eq(
    untagged("* FLAGS (\\Answered \\Seen $Junk)"),
    Flags(["\\Answered", "\\Seen", "$Junk"]),
  )
  assert_eq(
    untagged("* LIST (\\HasNoChildren \\Sent) \"/\" \"Sent Items\""),
    List(
      flags=["\\HasNoChildren", "\\Sent"],
      delimiter=Some("/"),
      name="Sent Items",
    ),
  )
  assert_eq(
    untagged("* LIST () NIL INBOX"),
    List(flags=[], delimiter=None, name="INBOX"),
  )
  assert_eq(
    untagged("* STATUS blurdybloop (MESSAGES 231 UIDNEXT 44292)"),
    Status("blurdybloop", Map([("MESSAGES", 231L), ("UIDNEXT", 44292L)])),
  )
  assert_eq(
    untagged("* ESEARCH (TAG \"A282\") UID MIN 2 COUNT 3 ALL 2,10:11"),
    Esearch(
      tag=Some("A282"),
      uid=true,
      items=Map([
        ("MIN", Number(2)),
        ("COUNT", Number(3)),
        ("ALL", Atom("2,10:11")),
      ]),
    ),
  )
  assert_eq(untagged("* SEARCH 2 84 882"), Search([2, 84, 882], modseq=None))
  assert_eq(
    untagged("* SEARCH 2 5 (MODSEQ 917162500)"),
    Search([2, 5], modseq=Some(917162500)),
  )
  assert_eq(untagged("* ENABLED CONDSTORE"), Enabled(["CONDSTORE"]))
  assert_eq(
    untagged("* NAMESPACE ((\"\" \"/\")) NIL NIL"),
    Namespace(List([List([Text(b""), Text(b"/")])]), Nil, Nil),
  )
  assert_eq(
    untagged("* XYZZY 1 \"two\""),
    Other("XYZZY", [Number(1), Text(b"two")]),
  )
}

///|
test "imap decodes the response codes" {
  let codes = [
    "* OK [UIDVALIDITY 3857529045] UIDs valid", "* OK [UIDNEXT 4392] Predicted next UID",
    "* OK [PERMANENTFLAGS (\\Deleted \\Seen \\*)] Limited", "* OK [HIGHESTMODSEQ 715194045007] Highest",
    "* OK [NOMODSEQ] Sorry", "* NO [ALERT] System shutdown in 10 minutes", "* OK [XFOO bar baz] What",
  ]
  let got = codes.map(line => {
    match untagged(line) {
      Condition(_, code, _) => code
      _ => None
    }
  })
  assert_eq(got, [
    Some(UidValidity(3857529045)),
    Some(UidNext(4392)),
    Some(PermanentFlags(["\\Deleted", "\\Seen", "\\*"])),
    Some(HighestModseq(715194045007)),
    Some(NoModseq),
    Some(Alert),
    Some(Other("XFOO", Some("bar baz"))),
  ])
}

///|
test "imap reads a fetch with literals and sections" {
  let client = opened("IMAP4rev2")
  let first = client.feed(
    @utf8.encode(
      "* 12 FETCH (FLAGS (\\Seen) UID 4827313 MODSEQ (12121231000) RFC822.SIZE 44827 BODY[HEADER.FIELDS (FROM)] {20}\r\nFrom: a@example.com\n",
    ),
  )
  inspect(first.length(), content="0")
  let events = client.feed(@utf8.encode(" BODY[]<0> \"x\\\"y\")\r\n"))
  guard events is [Data(Fetch(12, items))] else { fail("no fetch") }
  assert_eq(items.get("FLAGS"), Some(List([Atom("\\Seen")])))
  assert_eq(items.get("UID"), Some(Number(4827313)))
  assert_eq(items.get("MODSEQ"), Some(List([Number(12121231000)])))
  assert_eq(
    items.get("BODY[HEADER.FIELDS (FROM)]").bind(v => v.text()),
    Some("From: a@example.com\n"),
  )
  assert_eq(items.get("BODY[]<0>"), Some(Text(b"x\"y")))
}

///|
test "imap pipelines uid commands and holds the rest" {
  let client = opened("IMAP4rev2")
  let _ = client.login("u", "p")
  let _ = client.select("INBOX")
  inspect(wire(client.next_write()), content="A0001 LOGIN \"u\" \"p\"\r\n")
  let _ = client.feed(crlf("A0001 OK done"))
  inspect(wire(client.next_write()), content="A0002 SELECT \"INBOX\"\r\n")
  let _ = client.feed(crlf("A0002 OK [READ-WRITE] done"))
  assert_eq(client.state(), Selected("INBOX"))
  let _ = client.fetch("1:*", "(FLAGS)", uid=true)
  let _ = client.store("5", "+FLAGS (\\Seen)", uid=true)
  let _ = client.fetch("1", "(FLAGS)")
  inspect(
    wire(client.next_write()),
    content="A0003 UID FETCH 1:* (FLAGS)\r\nA0004 UID STORE 5 +FLAGS (\\Seen)\r\n",
  )
  let _ = client.feed(crlf("A0003 OK done"))
  inspect(wire(client.next_write()), content="(nothing)")
  let events = client.feed(crlf("A0004 OK done"))
  assert_eq(events, [Done(4, Ok, None, "done")])
  inspect(wire(client.next_write()), content="A0005 FETCH 1 (FLAGS)\r\n")
}

///|
test "imap sends a literal at once or after the continuation" {
  let quick = opened("IMAP4rev2")
  let _ = quick.login("u", "p")
  let _ = quick.next_write()
  let _ = quick.feed(crlf("A0001 OK done"))
  let _ = quick.append(
    "Drafts",
    b"hello",
    flags=["\\Draft"],
    date="17-Jul-1996 02:44:25 -0700",
  )
  inspect(
    wire(quick.next_write()),
    content="A0002 APPEND \"Drafts\" (\\Draft) \"17-Jul-1996 02:44:25 -0700\" {5+}\r\nhello\r\n",
  )
  let slow = opened("IMAP4rev1")
  let _ = slow.login("u", "p")
  let _ = slow.next_write()
  let _ = slow.feed(crlf("A0001 OK done"))
  let _ = slow.append("Drafts", b"hello")
  inspect(wire(slow.next_write()), content="A0002 APPEND \"Drafts\" {5}\r\n")
  inspect(wire(slow.next_write()), content="(nothing)")
  let _ = slow.feed(crlf("+ Ready for literal data"))
  inspect(wire(slow.next_write()), content="hello\r\n")
}

///|
test "imap writes rev1 mailbox names in modified utf-7" {
  let client = opened("IMAP4rev1")
  let _ = client.login("u", "p")
  let _ = client.next_write()
  let _ = client.feed(crlf("A0001 OK done"))
  let _ = client.create("~peter/mail/台北/日本語")
  inspect(
    wire(client.next_write()),
    content="A0002 CREATE \"~peter/mail/&U,BTFw-/&ZeVnLIqe-\"\r\n",
  )
  let events = client.feed(crlf("* LIST () \"/\" \"Entw&APw-rfe &- Tom\""))
  assert_eq(events, [
    Data(List(flags=[], delimiter=Some("/"), name="Entwürfe & Tom")),
  ])
  let rev2 = opened("IMAP4rev2")
  let _ = rev2.login("u", "p")
  let _ = rev2.next_write()
  let _ = rev2.feed(crlf("A0001 OK done"))
  let _ = rev2.create("Entwürfe \"x\"")
  inspect(
    wire(rev2.next_write()),
    content="A0002 CREATE \"Entwürfe \\\"x\\\"\"\r\n",
  )
}

///|
test "imap authenticates with an inline first response or after +" {
  let rev2 = opened("IMAP4rev2 AUTH=PLAIN")
  let _ = rev2.authenticate(@sasl.Plain::new("tim", "tanstaaftanstaaf"))
  inspect(
    wire(rev2.next_write()),
    content="A0001 AUTHENTICATE PLAIN AHRpbQB0YW5zdGFhZnRhbnN0YWFm\r\n",
  )
  let rev1 = opened("IMAP4rev1 AUTH=PLAIN")
  let _ = rev1.authenticate(@sasl.Plain::new("tim", "tanstaaftanstaaf"))
  inspect(wire(rev1.next_write()), content="A0001 AUTHENTICATE PLAIN\r\n")
  let _ = rev1.feed(crlf("+ "))
  inspect(wire(rev1.next_write()), content="AHRpbQB0YW5zdGFhZnRhbnN0YWFm\r\n")
  let events = rev1.feed(crlf("A0001 OK [CAPABILITY IMAP4rev1 IDLE] done"))
  assert_eq(events, [
    Done(1, Ok, Some(Capability(["IMAP4rev1", "IDLE"])), "done"),
  ])
  assert_eq(rev1.state(), Authenticated)
  inspect(rev1.has("AUTH=PLAIN"), content="false")
}

///|
test "imap runs scram and refuses a server without the proof" {
  let client = opened("IMAP4rev2 AUTH=SCRAM-SHA-256")
  let _ = client.authenticate(
    @sasl.ScramSha256::new("user", "pencil", nonce="rOprNGfwEbeRWgbNEkqO"),
  )
  inspect(
    wire(client.next_write()),
    content="A0001 AUTHENTICATE SCRAM-SHA-256 biwsbj11c2VyLHI9ck9wck5HZndFYmVSV2diTkVrcU8=\r\n",
  )
  let _ = client.feed(
    crlf(
      "+ cj1yT3ByTkdmd0ViZVJXZ2JORWtxTyVodllEcFdVYTJSYVRDQWZ1eEZJbGopaE5sRiRrMCxzPVcyMlphSjBTTlk3c29Fc1VFamI2Z1E9PSxpPTQwOTY=",
    ),
  )
  let _ = client.next_write()
  let events = client.feed(crlf("A0001 OK done"))
  assert_eq(events, [Sasl(Signature)])
}

///|
test "imap idles until done" {
  let client = opened("IMAP4rev2")
  let _ = client.login("u", "p")
  let _ = client.next_write()
  let _ = client.feed(crlf("A0001 OK done"))
  let tag = client.idle()
  inspect(wire(client.next_write()), content="A0002 IDLE\r\n")
  let events = client.feed(crlf("+ idling\r\n* 4 EXISTS"))
  assert_eq(events, [Data(Exists(4))])
  assert_eq(refusal(() => client.idle()), Some(Order("already idling")))
  client.done()
  inspect(wire(client.next_write()), content="DONE\r\n")
  let finished = client.feed(crlf("A0002 OK IDLE terminated"))
  assert_eq(finished, [Done(tag, Ok, None, "IDLE terminated")])
  assert_eq(refusal(() => client.done()), Some(Order("not idling")))
}

///|
test "imap tracks the state through select, close and bye" {
  let client = opened("IMAP4rev2 CONDSTORE")
  assert_eq(
    refusal(() => client.select("INBOX")),
    Some(Order("not allowed in the not authenticated state")),
  )
  let _ = client.login("u", "p")
  let _ = client.select("INBOX", condstore=true)
  let _ = client.next_write()
  let _ = client.feed(crlf("A0001 OK done"))
  inspect(
    wire(client.next_write()),
    content="A0002 SELECT \"INBOX\" (CONDSTORE)\r\n",
  )
  let _ = client.feed(crlf("A0002 NO [NONEXISTENT] no such mailbox"))
  assert_eq(client.state(), Authenticated)
  let _ = client.examine("Archive")
  let _ = client.next_write()
  let _ = client.feed(crlf("A0003 OK [READ-ONLY] done"))
  assert_eq(client.state(), Selected("Archive"))
  let _ = client.fetch("1:*", "(FLAGS)", uid=true, changedsince=12345)
  let _ = client.store("1", "+FLAGS (\\Seen)", unchangedsince=200)
  inspect(
    wire(client.next_write()),
    content="A0004 UID FETCH 1:* (FLAGS) (CHANGEDSINCE 12345)\r\n",
  )
  let _ = client.feed(crlf("A0004 OK done"))
  inspect(
    wire(client.next_write()),
    content="A0005 STORE 1 (UNCHANGEDSINCE 200) +FLAGS (\\Seen)\r\n",
  )
  let _ = client.feed(crlf("A0005 OK [MODIFIED 7,9] Conditional STORE failed"))
  let _ = client.close()
  let _ = client.next_write()
  let _ = client.feed(crlf("A0006 OK done"))
  assert_eq(client.state(), Authenticated)
  let _ = client.feed(crlf("* BYE shutting down"))
  assert_eq(client.state(), Logout)
}

///|
test "imap refuses what the server did not announce" {
  let client = opened("IMAP4rev1 LOGINDISABLED")
  assert_eq(refusal(() => client.login("u", "p")), Some(Unsupported("LOGIN")))
  assert_eq(refusal(() => client.starttls()), Some(Unsupported("STARTTLS")))
  assert_eq(
    refusal(() => client.authenticate(@sasl.Plain::new("u", "p"))),
    Some(Unsupported("AUTH=PLAIN")),
  )
  let rev1 = opened("IMAP4rev1")
  let _ = rev1.login("u", "p")
  assert_eq(refusal(() => rev1.idle()), Some(Unsupported("IDLE")))
  assert_eq(refusal(() => rev1.namespaces()), Some(Unsupported("NAMESPACE")))
  let rev2 = opened("IMAP4rev2")
  let _ = rev2.login("u", "p")
  assert_eq(
    refusal(() => rev2.create("a\r\nb")),
    Some(Malformed("a line break or NUL cannot be quoted: a\r\nb")),
  )
}

///|
test "imap forgets the capabilities after starttls" {
  let client = opened("IMAP4rev2 STARTTLS")
  let _ = client.starttls()
  let _ = client.next_write()
  let _ = client.feed(crlf("A0001 OK begin TLS"))
  inspect(client.capabilities().length(), content="0")
}

///|
test "imap refuses malformed and oversized responses" {
  assert_eq(
    refusal(() => opened("IMAP4rev2").feed(crlf("A0009 OK who"))),
    Some(Malformed("a completion for a tag nobody sent: A0009")),
  )
  assert_eq(
    refusal(() => opened("IMAP4rev2").feed(crlf("+ hello"))),
    Some(Malformed("a continuation nobody asked for")),
  )
  assert_eq(
    refusal(() => opened("IMAP4rev2").feed(crlf("* LIST (\\Noselect \"/\""))),
    Some(Malformed("expected a space at 21")),
  )
  let small = @imap.Client::new(limits=@imap.Limits::new(literal=4))
  assert_eq(
    refusal(() => small.feed(crlf("* 1 FETCH (BODY[] {5}"))),
    Some(Exceeded(limit=4, got=5)),
  )
}
