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
fn prefix(s : String, n : Int32) -> String {
  let m = if s.length() < n { s.length() } else { n }
  s[0:m].to_owned()
}

///|
/// A client session against a recorded POP3 server: the server's lines go in
/// one by one, and the client's writes in between are dropped.
fn pop3_tour() -> Unit raise @pop3.Refused {
  let pop = @pop3.Client::new()
  let events = []
  let replay = (text : String) => {
    let _ = pop.next_write()
    events.append(pop.feed(@utf8.encode(text + "\r\n")))
  }
  replay("+OK POP3 server ready <1896.697170952@dbc.mtview.ca.us>")
  pop.capa()
  replay("+OK capability list follows\r\nTOP\r\nUIDL\r\nSASL PLAIN\r\n.")
  pop.apop("mrose", "tanstaaf")
  replay("+OK maildrop has 2 messages")
  pop.stat()
  replay("+OK 2 320")
  pop.list()
  replay("+OK 2 messages\r\n1 120\r\n2 200\r\n.")
  pop.retr(1)
  replay(
    "+OK 120 octets\r\nSubject: one\r\n\r\n..a line that starts with a dot\r\n.",
  )
  pop.uidl(message=2)
  replay("+OK 2 QhdPYR:00WBw1Ph7x7")
  pop.quit()
  replay("+OK bye")
  println("--- pop3")
  for event in events {
    match event {
      Reply(command, Content(data)) =>
        println(
          @debug.to_string(command) +
          " -> " +
          @utf8.decode_lossy(data[:]).escape(),
        )
      Reply(command, reply) =>
        println(@debug.to_string(command) + " -> " + @debug.to_string(reply))
      Sasl(why) => println("sasl -> " + @debug.to_string(why))
    }
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
/// A message read into a tree, its readers, one built from scratch, and the
/// round trip that writes the same octets twice.
fn message_tour() -> Unit raise @moonmail.Refused {
  let raw = @utf8.encode(
    "From: =?utf-8?q?Ren=C3=A9e?= <renee@example.com>\r\nTo: Bob <bob@example.com>, team: carol@example.com, dan@example.com;\r\nSubject: =?utf-8?B?Q2Fmw6k=?=\r\nDate: Tue, 1 Jul 2003 10:52:37 +0200\r\nContent-Type: multipart/alternative; boundary=\"BOUND\"\r\n\r\n--BOUND\r\nContent-Type: text/plain; charset=utf-8\r\nContent-Transfer-Encoding: quoted-printable\r\n\r\nCaf=C3=A9 and cr=C3=A8me\r\n--BOUND\r\nContent-Type: text/html; charset=utf-8\r\n\r\n<p>Caf\u{e9}</p>\r\n--BOUND--\r\n",
  )
  let message = @moonmail.Message::parse(raw[:])
  println("--- message")
  println("subject      -> \{message.subject().unwrap_or("")}")
  println(
    "from         -> \{message.from().map(m => m.encode(utf8=true)).join(", ")}",
  )
  println(
    "to           -> \{message.to().map(a => a.encode(utf8=true)).join(", ")}",
  )
  println("date         -> \{@moonmail.format_date(message.date().unwrap())}")
  println("type         -> \{message.content_type().essence}")
  println("text         -> \{message.text().unwrap_or("")}")
  println("html         -> \{message.html().unwrap_or("")}")
  let built = @moonmail.Message::new(
    from=@moonmail.Mailbox::new("alice@example.com", name="Alice"),
    to=[Mailbox(@moonmail.Mailbox::new("bob@example.com"))],
    subject="Grüße",
    text="Hello",
    html="<p>Hello</p>",
    attachments=[@moonmail.Attachment::new("notes.txt", b"one\r\ntwo\r\n")],
  )
  let wire = built.encode()
  let again = @moonmail.Message::parse(wire[:]).encode()
  println(
    "built        -> \{built.content_type().essence}, \{built.attachments().length()} attachment",
  )
  println("stable       -> \{wire == again}")
}

///|
/// Sign with the Ed25519 key of RFC 8463 and check the signature against the
/// record that publishes its public half.
fn dkim_tour(raw : Bytes) -> Unit raise {
  let seed = @base64.decode("nWGxne/9WmC6hEr0kuwsxERJxWl7MmkZcDusAxyuf2A=")
  let key = @ed25519.PrivateKey::of_secret(seed[:])
  let field = @dkim.sign(
    raw[:],
    Ed25519(key),
    domain="football.example.com",
    selector="brisbane",
  )
  let signed = @utf8.encode(field + "\r\n" + @utf8.decode_lossy(raw[:]))
  let record = "v=DKIM1; k=ed25519; p=11qYAYKxCrfVS/7TyWQHOg7hcvPapiMlrwIaaPcHURo="
  let verdicts = @dkim.verify(
    signed[:],
    name => {
      if name == "brisbane._domainkey.football.example.com" {
        Some(record)
      } else {
        None
      }
    },
    now=0,
  )
  println("--- dkim")
  println("field        -> \{prefix(field, 48)}…")
  println("verdicts     -> \{@debug.to_string(verdicts)}")
}

///|
#coverage.skip
fn main {
  // --------------------------------------------------------------- message
  message_tour() catch {
    e => println("message tour stopped: " + @debug.to_string(e))
  }
  let raw = @utf8.encode(
    "From: Alice <alice@example.com>\r\nTo: Bob <bob@example.com>\r\nSubject: Hi\r\n\r\nHello\r\n",
  )

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

  // --------------------------------------------------------------- pop3
  pop3_tour() catch {
    e => println("pop3 tour stopped: " + @debug.to_string(e))
  }

  // --------------------------------------------------------------- smtp
  smtp_tour(raw) catch {
    e => println("smtp tour stopped: " + @debug.to_string(e))
  }

  // --------------------------------------------------------------- imap
  imap_tour() catch {
    e => println("imap tour stopped: " + @debug.to_string(e))
  }

  // --------------------------------------------------------------- dkim
  dkim_tour(raw) catch {
    e => println("dkim tour stopped: " + @debug.to_string(e))
  }
}
