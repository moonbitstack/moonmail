---
name: moonmail
description: Email in MoonBit — parse and write RFC 5322 messages with MIME parts and attachments, sign and verify DKIM, and run SMTP, IMAP and POP3 against a real server. Use when a program has to read a .eml file, compose a letter with an attachment, or log in to a mailbox and fetch or send mail.
---

# moonmail

One module, six packages: `moonbitstack/moonmail` for the message model,
`moonmail/smtp`, `moonmail/imap`, `moonmail/pop3` and `moonmail/sasl` for the
protocol states, and `moonmail/net` for the sockets. Every protocol package is a
state machine with no I/O — octets in, events out — so only the last one needs a
network.

```bash
moon add moonbitstack/moonmail
```

## Read a message

`Message::parse` takes the octets and gives back a tree; the readers decode
encoded words, charsets and transfer encodings, so what comes out is what a mail
reader would show.

```moonbit
///|
pub fn read(raw : Bytes) -> Unit raise {
  let message = @moonmail.Message::parse(raw[:])
  println(message.subject().unwrap_or("(none)"))
  for mailbox in message.from() {
    println(mailbox.name.unwrap_or("") + " <" + mailbox.address + ">")
  }
  println(message.text().unwrap_or(""))
  for part in message.attachments() {
    println(part.name + " " + part.media_type + " " + part.data.length().to_string())
  }
}
```

An address that will not parse raises `@moonmail.Refused` with the offset it
stopped at; pass `strict=false` to accept the obsolete forms Python's `email`
accepts.

## Compose and send

`Message::new` picks `multipart/alternative` for text plus HTML, `related` for
inline pictures and `mixed` for attachments. `encode` writes CRLF, folds at 78
columns, and reads back as the same tree; `@moonmail/net` carries it to a relay.

```moonbit
///|
pub async fn send(security : @net.Security, raw_png : Bytes) -> Unit raise {
  let password = "secret"
  let message = @moonmail.Message::new(
    from=@moonmail.Mailbox::new("alice@example.com", name="Alice"),
    to=[@moonmail.Address::Mailbox(@moonmail.Mailbox::new("bob@example.com"))],
    subject="Lunch?",
    text="Noon works.",
    attachments=[@moonmail.Attachment::new("map.png", raw_png)],
  )
  let smtp = @net.Smtp::connect("smtp.example.com", security, port=465)
  smtp.auth(@sasl.Plain::new("alice", password))
  let refused = smtp.send("alice@example.com", ["bob@example.com"], message.encode())
  for (who, reply) in refused {
    println(who + " refused: " + reply.text())
  }
  smtp.quit()
}
```

`send` returns the recipients the server refused and raises on anything that
kills the transaction, so a partial rejection is something you can act on.

## Read a mailbox

`@net.Imap::connect` reads the greeting and the capabilities; each command is
queued and `wait` returns the untagged responses that arrived while it ran plus
its completion.

```moonbit
///|
pub async fn inbox(host : String, security : @net.Security) -> Unit raise {
  let password = "secret"
  let imap = @net.Imap::connect(host, security, port=993)
  imap.login("alice", password)
  let selected = imap.wait(imap.client().select("INBOX"))
  for response in selected.data {
    if response is @imap.Response::Exists(n) {
      println(n.to_string() + " messages")
    }
  }
  let found = imap.wait(imap.client().search("UNSEEN", uid=true))
  for response in found.data {
    if response is @imap.Response::Search(uids, ..) {
      for uid in uids {
        let fetched = imap.wait(
          imap.client().fetch(uid.to_string(), "(BODY.PEEK[])", uid=true),
        )
        println(fetched.data.length().to_string() + " fetched")
      }
    }
  }
  imap.logout()
}
```

Search returns sequence numbers unless `uid=true` is passed; a `FETCH` after a
sequence-number search has to use `uid=false` to match it.

## The other end of the wire

`@imap.Server` and `@imap.Store` answer IMAP4rev1 from mailboxes in memory:
`Store::new`, fill it with `deliver`, hand it to `Server::new` with a function
that checks credentials and one that gives the clock, then feed octets and write
back what `next_write` returns. It is a reference server for tests and
conformance runs, not a mail store — nothing outlives the process.

## Rules worth knowing

- **TLS 1.3 only.** The bundled client does not speak 1.2, and a server that
  offers only 1.2 drops the handshake rather than answering with an error.
- **Non-ASCII search needs a charset.** `SEARCH` refuses eight-bit octets in an
  atom, so write `CHARSET UTF-8 SUBJECT "日本語"` with the string quoted.
- **`net` is native and wasm only.** It does not build for js or wasm-gc; the
  other five packages do.
- **A page has no socket.** In a browser, reach the server over JMAP with
  `@moonmail/jmap` instead; that package is JSON in and JSON out.
- **`pop3` bounds status lines, not message lines.** A message written as one
  long line is delivered whole; `Limits::new(message=...)` bounds it.
