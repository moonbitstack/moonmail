// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// Every corner of moonmail in one run: reading a message, its headers and
/// encodings, then writing it back, then a POP3 dialogue and a DKIM signature.
///
///     moon run src/examples/tour
///
/// The point is not the output — the same paths are asserted in the test suite —
/// but that each is reached the same way a caller would reach it.

///|
fn or_empty(value : String?) -> String {
  match value {
    Some(v) => v
    None => ""
  }
}

///|
fn prefix(s : String, n : Int32) -> String {
  let m = if s.length() < n { s.length() } else { n }
  s[0:m].to_owned()
}

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
/// A tiny in-memory POP3 server: hands out recorded lines and keeps every
/// command the client writes.
struct Scripted {
  inbox : Array[String]
  sent : Array[String]
}

///|
fn Scripted::new(lines : Array[String]) -> Scripted {
  let inbox : Array[String] = []
  let n = lines.length()
  for i in 0..<n {
    inbox.push(lines[n - 1 - i])
  }
  { inbox, sent: [], }
}

///|
impl @pop3.Pop3Io for Scripted with fn write_line(self, line) -> Unit raise @pop3.Pop3Error {
  self.sent.push(line)
}

///|
impl @pop3.Pop3Io for Scripted with fn read_line(self) -> String raise @pop3.Pop3Error {
  match self.inbox.pop() {
    Some(line) => line
    None => raise @pop3.Pop3Error::Io(msg="the tour's script ran out of lines")
  }
}

///|
/// Run an SMTP client against an SMTP server in memory until neither has
/// anything to send, answering each request with `decide`, and collect what
/// the client reports.
fn converse(
  client : @smtp.Client,
  server : @smtp.Server,
  decide : (@smtp.Server, @smtp.Request) -> Unit raise @smtp.Refused,
) -> Array[@smtp.Event] raise @smtp.Refused {
  let events = []
  let mut moved = true
  while moved {
    moved = false
    if server.next_write() is Some(data) {
      events.append(client.feed(data))
      moved = true
    }
    if client.next_write() is Some(data) {
      server.feed(data)
      moved = true
    }
    while server.next() is Some(request) {
      decide(server, request)
      moved = true
    }
  }
  events
}

///|
fn accept_all(
  server : @smtp.Server,
  request : @smtp.Request,
) -> Unit raise @smtp.Refused {
  match request {
    Rset | Quit => ()
    _ => server.accept()
  }
}

///|
/// The sending side against a relay: hello, a whole transaction in one call,
/// and goodbye. LMTP is the same client with `lmtp=true`, where the message
/// gets one reply per recipient.
fn smtp_tour(raw : Bytes) -> Unit raise @smtp.Refused {
  let relay = @smtp.Server::new("relay.example")
  let smtp = @smtp.Client::new()
  smtp.ehlo("client.example")
  let _ = converse(smtp, relay, accept_all)
  smtp.send("alice@example.com", ["bob@example.com"], raw[:])
  smtp.quit()
  let replies = converse(smtp, relay, accept_all)
  println("--- smtp")
  println("extensions   -> \{smtp.extensions().length()}")
  println("pipelining   -> \{smtp.has("PIPELINING")}")
  println("replies      -> \{replies.length()}")
  let lmtp_server = @smtp.Server::new("lmtp.example", lmtp=true)
  let lmtp = @smtp.Client::new(lmtp=true)
  lmtp.ehlo("client.example")
  let _ = converse(lmtp, lmtp_server, accept_all)
  lmtp.send(
    "alice@example.com",
    ["bob@example.com", "carol@example.com"],
    raw[:],
  )
  let deliveries = converse(lmtp, lmtp_server, (server, request) => {
    match request {
      Rcpt(to, _) if to.has_prefix("carol") =>
        server.reply(550, "5.1.1 No such user")
      _ => accept_all(server, request)
    }
  }).filter(event => event is Reply(Delivery(_), _))
  println("lmtp replies -> \{deliveries.length()}")
  let chunked = @smtp.Server::new("relay.example")
  let bdat = @smtp.Client::new()
  bdat.ehlo("client.example")
  let _ = converse(bdat, chunked, accept_all)
  let body = @utf8.encode("Subject: Hi\r\n\r\n")
  bdat.mail("alice@example.com", size=body.length(), body=Binary)
  bdat.rcpt("bob@example.com", notify=[Success, Failure])
  bdat.bdat(body[:], last=true)
  let chunks = converse(bdat, chunked, accept_all)
  println("bdat replies -> \{chunks.length()}")
}

///|
/// An in-memory NNTP server.
struct NntpScript {
  inbox : Array[String]
  sent : Array[String]
}

///|
fn NntpScript::new(lines : Array[String]) -> NntpScript {
  let inbox : Array[String] = []
  let n = lines.length()
  for i in 0..<n {
    inbox.push(lines[n - 1 - i])
  }
  { inbox, sent: [], }
}

///|
impl @nntp.NntpIo for NntpScript with fn write_line(self, line) -> Unit raise @nntp.NntpError {
  self.sent.push(line)
}

///|
impl @nntp.NntpIo for NntpScript with fn read_line(self) -> String raise @nntp.NntpError {
  match self.inbox.pop() {
    Some(line) => line
    None => raise @nntp.NntpError::Io(msg="tour nntp script ended")
  }
}

///|
/// A client session against a recorded server: the server's lines go in one
/// by one, and the client's writes in between are dropped.
fn imap_tour() -> Unit raise @imap.Refused {
  let imap = @imap.Client::new()
  let events = []
  let replay = (text : String) => {
    let _ = imap.next_write()
    events.append(imap.feed(@utf8.encode(text + "\r\n")))
  }
  replay("* OK [CAPABILITY IMAP4rev2 IDLE AUTH=PLAIN] ready")
  let _ = imap.login("alice", "secret")
  replay("A0001 OK LOGIN completed")
  let _ = imap.select("INBOX")
  replay("* 5 EXISTS")
  replay("* OK [UIDVALIDITY 77] UIDs valid")
  replay("A0002 OK [READ-WRITE] SELECT completed")
  let _ = imap.search("UNSEEN", uid=true)
  replay("* ESEARCH (TAG \"A0003\") UID ALL 101:103")
  replay("A0003 OK SEARCH completed")
  let _ = imap.fetch("1", "(FLAGS BODY[HEADER.FIELDS (SUBJECT)])")
  replay("* 1 FETCH (FLAGS (\\Seen) BODY[HEADER.FIELDS (SUBJECT)] {13}")
  replay("Subject: hi\r\n)")
  replay("A0004 OK FETCH completed")
  let _ = imap.idle()
  replay("+ idling")
  replay("* 6 EXISTS")
  imap.done()
  replay("A0005 OK IDLE terminated")
  let _ = imap.logout()
  replay("* BYE logging out")
  replay("A0006 OK LOGOUT completed")
  println("--- imap")
  println("responses    -> \{events.length()}")
  println("state        -> \{@debug.to_string(imap.state())}")
  for event in events {
    if event is Data(Fetch(n, items)) {
      let subject = items
        .get("BODY[HEADER.FIELDS (SUBJECT)]")
        .bind(v => v.text())
        .unwrap_or("")
      println("fetch \{n}      -> \{subject.trim()}")
    }
  }
}

///|
#coverage.skip
fn main {
  // --------------------------------------------------------------- parse
  //
  // A message is bytes in, a tree out. The Subject carries an RFC 2047 encoded
  // word, and the body is quoted-printable, so both decoders run on the way.
  let raw = @utf8.encode(
    "From: Alice <alice@example.com>\r\nTo: Bob <bob@example.com>\r\nSubject: =?utf-8?B?Q2Fmw6k=?=\r\nContent-Type: text/plain; charset=utf-8\r\nContent-Transfer-Encoding: quoted-printable\r\n\r\nCaf=C3=A9 and cr=C3=A8me\r\n",
  )
  let msg = @moonmail.parse(raw[:])
  let subject = or_empty(msg.decoded_header("Subject"))
  let ctype = msg.content_type()
  let payload = @utf8.decode_lossy(msg.payload()[:])
  println("--- parse")
  println("subject      -> \{subject}")
  println("content-type -> \{ctype.main}")
  println("multipart    -> \{msg.is_multipart()}")
  println("body         -> \{payload}")

  // ------------------------------------------------------------ multipart
  //
  // A multipart splits at its boundary; each part is itself a message, so the
  // same reader runs again on every child.
  let multi = @utf8.encode(
    "Content-Type: multipart/alternative; boundary=\"BOUND\"\r\n\r\n--BOUND\r\nContent-Type: text/plain\r\n\r\nplain\r\n--BOUND\r\nContent-Type: text/html\r\n\r\n<p>html</p>\r\n--BOUND--\r\n",
  )
  let tree = @moonmail.parse(multi[:])
  let parts = tree.parts()
  println("--- multipart")
  println("parts        -> \{parts.length()}")
  for i in 0..<parts.length() {
    println("  part \{i}       -> \{@utf8.decode_lossy(parts[i].payload()[:])}")
  }

  // ----------------------------------------------------- quoted-printable
  //
  // The transfer encoding on its own: high octets become =XY, and decoding
  // turns them back. Round-tripping is the only safe way to show both.
  let greeting = @utf8.encode("Café ☕ — naïve")[:]
  let encoded = @qp.encode(greeting)
  let decoded = @qp.decode(encoded[:]) catch { _ => b"" }
  println("--- quoted-printable")
  println("encoded      -> \{@utf8.decode_lossy(encoded[:])}")
  println("round trip   -> \{@utf8.decode_lossy(decoded[:])}")

  // ------------------------------------------------------- encoded words
  //
  // RFC 2047: a header that is not plain ASCII is written as encoded words.
  let words = @moonmime.encode_words("Grüße aus München") catch { _ => "" }
  println("--- encoded words")
  println("encoded      -> \{words}")
  println("decoded      -> \{@moonmime.decode_words(words[:])}")

  // ----------------------------------------------------------- charsets
  //
  // Non-UTF-8 bodies. Encoding refuses what a set cannot hold, decoding never
  // does, so a stray octet costs a character and not the whole part.
  let latin = @moonmime.encode_charset(name="iso-8859-1", text="é") catch {
    _ => b""
  }
  let back = @moonmime.decode_charset(name="iso-8859-1", data=latin[:]) catch {
    _ => ""
  }
  println("--- charsets")
  println("iso-8859-1   -> \{latin.length()} octet, back to \{back}")
  let refused = try {
    let _ = @moonmime.encode_charset(name="us-ascii", text="é")
    false
  } catch {
    _ => true
  }
  println("ascii refuses é -> \{refused}")

  // ---------------------------------------------------------- serialize
  //
  // Headers, a blank line, and the body re-encoded under its declared encoding.
  let saved = @moonmail.serialize(msg)
  let again = @moonmail.serialize(@moonmail.parse(saved[:]))
  println("--- serialize")
  println("re-emitted   -> \{saved.length()} octets, stable: \{saved == again}")

  // --------------------------------------------------------------- pop3
  //
  // POP3 over a scripted transport, so the dialogue is visible and no socket is
  // opened. The client refuses a mailbox command until it has authenticated.
  let transcript = [
    "+OK POP3 server ready", "+OK password required", "+OK mailbox locked", "+OK 2 320",
    "+OK 2 messages", "1 120", "2 200", ".", "+OK 120 octets", "From: alice@example.com",
    "Subject: one", "", "first message body", ".",
  ]
  let inbox : Array[String] = []
  let count = transcript.length()
  for i in 0..<count {
    inbox.push(transcript[count - 1 - i])
  }
  let script : Scripted = { inbox, sent: [], }
  let client = @pop3.Pop3::new(script as &@pop3.Pop3Io)
  let _ = client.greeting() catch { _ => "" }
  let _ = client.user("alice") catch { _ => () }
  let _ = client.pass("secret") catch { _ => () }
  let mut messages = 0
  let mut octets = 0
  let _ = try {
    let st = client.stat()
    messages = st.count
    octets = st.size
  } catch {
    _ => ()
  }
  let mut list = ""
  let _ = try {
    for item in client.list() {
      list = list +
        "#" +
        item.number.to_string() +
        "=" +
        item.size.to_string() +
        " "
    }
  } catch {
    _ => ()
  }
  let fetched = client.retr(1) catch { _ => "" }
  println("--- pop3")
  println("state        -> \{client.state() == @pop3.Pop3State::Transaction}")
  println("stat         -> \{messages} messages, \{octets} octets")
  println("list         -> \{list}")
  println("retr         -> \{fetched.length()} octets")
  println("commands sent -> \{script.sent.length()}")

  // --------------------------------------------------------------- smtp
  smtp_tour(raw) catch {
    e => println("smtp tour stopped: " + @debug.to_string(e))
  }

  // --------------------------------------------------------------- nntp
  let nntp_script = NntpScript::new([
    "200 posting ok", "211 2 1 2 comp.lang.moonbit", "220 1 <m1@example.com>", "Subject: hi",
    "", "body", ".",
  ])
  let nntp = @nntp.Nntp::new(nntp_script as &@nntp.NntpIo)
  let _ = nntp.greeting() catch { _ => "" }
  let mut group_count = 0
  let _ = try {
    group_count = nntp.group("comp.lang.moonbit").count
  } catch {
    _ => ()
  }
  let article = nntp.article("1") catch { _ => "" }
  println("--- nntp")
  println("group count  -> \{group_count}")
  println("article len  -> \{article.length()}")

  // --------------------------------------------------------------- imap
  imap_tour() catch {
    e => println("imap tour stopped: " + @debug.to_string(e))
  }

  // --------------------------------------------------------------- jmap
  //
  // JMAP is JSON over HTTP; the model here builds the request and reads the
  // method responses. The `@moonmail/jmap/fetch` package posts them with
  // moonfetch.
  let jmap_request = @jmap.Request::mail([@jmap.mailbox_get("acct1", "c1")])
  let jmap_body = @jmap.dumps_request(jmap_request)
  let mut jmap_method = ""
  let _ = try {
    let reply = @jmap.parse_response(
      "{\"methodResponses\":[[\"Mailbox/get\",{\"list\":[]},\"c1\"]],\"sessionState\":\"ss1\"}",
    )
    jmap_method = reply.responses[0].name
  } catch {
    _ => ()
  }
  println("--- jmap")
  println("request bytes -> \{jmap_body.length()}")
  println("reply method  -> \{jmap_method}")
  // Email/set is how a draft is created; the reply names the server-side id.
  let email_set = @jmap.email_set("acct1", "c2")
  email_set.create(
    "draft1",
    @jmap.email_draft(
      "Drafts",
      "alice@example.com",
      ["bob@example.com"],
      "Hello",
      "Body text",
    ),
  )
  let set_body = @jmap.dumps_request(@jmap.Request::mail([email_set.to_call()]))
  let mut created_id = ""
  let _ = try {
    let reply = @jmap.parse_response(
      "{\"methodResponses\":[[\"Email/set\",{\"created\":{\"draft1\":{\"id\":\"M100\"}}},\"c2\"]],\"sessionState\":\"ss1\"}",
    )
    let result = @jmap.parse_set_response(reply.responses[0].arguments)
    created_id = or_empty(result.created.get("draft1"))
  } catch {
    _ => ()
  }
  println("set bytes     -> \{set_body.length()}")
  println("created id    -> \{created_id}")

  // --------------------------------------------------------------- mapi
  //
  // MAPI over HTTP: the ROP buffer framing, a little-endian size and the ROPs.
  let rops = @mapi.RopBuffer::new()
  rops.add(@mapi.rop_logon, 0, b""[:])
  rops.add(@mapi.rop_release, 0, b""[:])
  let framed = rops.encode()
  // A full request sequence: log on, open the inbox, ask for a hierarchy
  // table, then release what was opened. The payload builders lay the fields
  // out per MS-OXCROPS; none of this has been checked against a live server.
  let session = @mapi.RopBuffer::new()
  session.add(@mapi.rop_logon, 0, @mapi.LogonRequest::new("alice").encode()[:])
  session.add(
    @mapi.rop_open_folder,
    1,
    @mapi.rop_open_folder_request(1, 2, 258L)[:],
  )
  session.add(
    @mapi.rop_get_hierarchy_table,
    1,
    @mapi.rop_get_table_request(2, 3, 0)[:],
  )
  session.add(
    @mapi.rop_set_columns,
    1,
    @mapi.rop_set_columns_request(3, 0, [
      @mapi.prop_tag(@mapi.pid_tag_display_name, @mapi.pt_unicode),
      @mapi.prop_tag(@mapi.pid_tag_content_count, @mapi.pt_long),
    ])[:],
  )
  session.add(
    @mapi.rop_query_rows,
    1,
    @mapi.rop_query_rows_request(3, 0, true, 50)[:],
  )
  session.add(@mapi.rop_release, 1, @mapi.rop_release_request(3)[:])
  let session_bytes = session.encode()
  println("--- mapi")
  println("rop bytes     -> \{framed.length()}")
  println("rop size      -> \{@mapi.rop_size(framed[:]) catch { _ => -1 }}")
  println("session rops  -> \{session.count()}")
  println(
    "session size  -> \{@mapi.rop_size(session_bytes[:]) catch { _ => -1 }}",
  )

  // ---------------------------------------------------------- extensions
  //
  // The smaller pieces each protocol grew: CHUNKING and DSN on SMTP, single
  // message UIDL and readable CAPA names on POP3, overview rows on NNTP.
  let pop_script = Scripted::new([
    "+OK ready", "+OK password required", "+OK logged in", "+OK capability list follows",
    "TOP", "UIDL", "SASL PLAIN LOGIN", ".", "+OK 2 200",
  ])
  let pop = @pop3.Pop3::new(pop_script as &@pop3.Pop3Io)
  let _ = pop.greeting() catch { _ => "" }
  let _ = pop.user("alice") catch { _ => () }
  let _ = pop.pass("secret") catch { _ => () }
  let caps = pop.capa_names() catch { _ => [] }
  let uid = pop.uidl_one(2) catch { _ => "" }

  let over_script = NntpScript::new([
    "200 posting ok", "224 overview information follows", "1\tSubject one\talice@example.com",
    "2\tSubject two\tbob@example.com", ".",
  ])
  let news = @nntp.Nntp::new(over_script as &@nntp.NntpIo)
  let _ = news.greeting() catch { _ => "" }
  let rows = news.over("1-2") catch { _ => [] }

  println("--- extensions")
  println("pop3 caps    -> \{caps.length()}, uid \{uid}")
  println("over rows    -> \{rows.length()}")

  // --------------------------------------------------------------- dkim
  //
  // Sign a message and check the signature we just made. The key is a throwaway
  // 1024-bit RSA key generated for this tour; a real one comes from the key
  // the `d=`/`s=` selector publishes.
  let n = hex_bytes(
    "cc5b577e919dacc7d97bfbba88a6dff832697cf0fd67efecc5c5884393d945c98cea2327c32a74fa96526f48cf4b081c6444ee91d2f85da5405d5f665e40d3ad5afb35c77af79e14f8610b58900e90ee7cbdd659c5303d02b504655c13601d143bf05c4c2a6ec35add559e116c6989125d3dc89962d44b95e40d3d73659a66f7",
  )
  let e = hex_bytes("010001")
  let d = hex_bytes(
    "b5da52f1ff03214e76eb2e07c0b33f7bcee0b09e83e28a4f596f7ee3241ea54bc66a54fe7d5ebada840ab79d435ab1cd122d855f9f2e05a798af7ec5c9fa4662d5ad9868d75cd3305ae18a49f8b9bd1082045b2d69e97803406af1f0607e2f2c94aeddaf2c0e967d1ab71ddd2ce055ac0881654009f4c89d7ff9b0edb1440001",
  )
  let mut verified = false
  let mut tags = ""
  let _ = try {
    let key = @rsa.PrivateKey::new(
      n[:],
      e[:],
      d[:],
      digest=@rsa.Digest::Sha256,
      scheme=@rsa.Scheme::Pkcs1,
    )
    let opts = @dkim.SignOptions::new(domain="example.com", selector="tour", headers=[
      "From", "To", "Subject",
    ])
    let sig = @dkim.sign(raw[:], key, opts)
    tags = sig
    let signed = Buffer()
    signed.write_string_utf8("DKIM-Signature: " + sig + "\r\n")
    signed.write_bytes(raw)
    verified = @dkim.verify(signed.to_bytes()[:], key.public())
  } catch {
    _ => ()
  }
  println("--- dkim")
  println("tags         -> \{prefix(tags, 24)}…")
  println("verifies     -> \{verified}")
}
