# moonmail

Email for MoonBit: read an RFC 5322 message into a tree and write it back out,
the MIME transfer encodings it carries, DKIM signing and verification, and the
POP3, SMTP/LMTP, NNTP and IMAP dialogues. Bytes in, data out — no sockets, no
files. Every protocol talks over a transport trait you implement, so a socket,
a TLS stream and a test all look alike.

```moonbit
let msg = @moonmail.parse(raw[:])
println(msg.decoded_header("Subject"))   // encoded words already resolved
println(msg.content_type().main)         // "text/plain"
println(msg.payload())                   // transfer-decoded body
```

Every call that talks to a server raises its protocol's error on a rejection;
handle it with `try`/`catch`, or propagate it from a function declared `raise`.

Run the whole surface in one go:

```bash
moon run src/examples/tour
```

## What it does

- **Reading and writing** — `parse` and `serialize`, headers unfolded,
  case-insensitive lookup, repeated headers kept in order, `Content-Type` with
  its boundary (media types parsed by `moonmime`), multipart bodies split into
  their parts.
- **Transfer encodings** — quoted-printable, base64, 7bit, 8bit and binary
  bodies, decoded by `parse` and written by `serialize`. Quoted-printable,
  RFC 2047 encoded words and charsets come from
  [moonmime](https://github.com/moonbitstack/moonmime) (`moonmime/qp`,
  `encode_words`, `decode_words`, `Charset`), which HTTP uses too.
- **SASL** (`@moonmail/sasl`) — PLAIN, LOGIN, CRAM-MD5, XOAUTH2, OAUTHBEARER
  (RFC 7628) and SCRAM-SHA-256 (RFC 7677) with SASLprep (RFC 4013). A
  mechanism is a trait: one you write goes to `authenticate` like these.
- **POP3** (`@moonmail/pop3`) — RFC 1939 state machine, dot-unstuffed replies,
  `USER`/`PASS`, `APOP`, SASL `AUTH`, `STLS`, `CAPA`, `TOP`, `UIDL`, `LAST`,
  and `retr_bytes` for a body kept as octets.
- **SMTP / LMTP** (`@moonmail/smtp`) — client and server as state machines
  with no I/O, RFC 5321 and RFC 2033: `PIPELINING` groups, `SIZE`, `8BITMIME`,
  `BINARYMIME` and `CHUNKING`, `SMTPUTF8`, DSN parameters, `STARTTLS`, SASL
  `AUTH`, and RFC 3463 enhanced status codes off any reply.
- **NNTP** (`@moonmail/nntp`) — RFC 3977 news: groups, articles, posting,
  `LISTGROUP`, `OVER`/`HDR`, `NEWGROUPS`/`NEWNEWS`, `AUTHINFO`, `CAPABILITIES`.
- **IMAP** (`@moonmail/imap`) — IMAP4rev2 client with no I/O (RFC 9051) that
  also speaks to IMAP4rev1 servers: the response grammar with literals and
  response codes, pipelined UID commands, `IDLE`, `CONDSTORE`, `LITERAL+`,
  `SASL-IR`, and modified UTF-7 names toward rev1 servers.
- **JMAP** (`@moonmail/jmap`) — RFC 8620/8621: the session, request body and
  method responses as JSON; `Email/set`, `Mailbox/set` and
  `EmailSubmission/set` with their result parsing, `Identity/get`,
  `Thread/get`, and a draft builder; `@moonmail/jmap/fetch` posts over moonfetch.
- **MAPI** (`@moonmail/mapi`) — the MS-OXCMAPIHTTP envelope, the MS-OXCROPS ROP
  buffer framing, property tags with the common `PidTag` ids, and request
  builders for logon, open folder/message, tables, columns, rows and
  `GetPropertiesSpecific`. See the caveat below.
- **DKIM** (`@moonmail/dkim`) — RFC 6376 canonicalization (simple and relaxed),
  body hash, and RSA-SHA256 sign and verify.

## POP3

```moonbit
let client = @pop3.Pop3::new(connection as &@pop3.Pop3Io)
try {
  let _ = client.greeting()
  client.user("alice")
  client.pass("secret")
  let stat = client.stat()            // { count, size }
  let message = client.retr(1)        // the raw message, ready for @moonmail.parse
} catch {
  _ => ()
}
```

## SMTP / LMTP

The client queues commands and refuses, when they are queued, the ones that are
out of sequence or need an extension the server did not announce. Octets go
out through `next_write` and come back through `feed`, which reports each reply
with the command it answers.

```moonbit
let smtp = @smtp.Client::new()
smtp.ehlo("client.example")
// ... write smtp.next_write(), feed the server's octets until the EHLO reply
smtp.send("alice@example.com", ["bob@example.com"], raw[:])
smtp.quit()
for event in smtp.feed(octets) {
  match event {
    Reply(Rcpt(to), reply) if !reply.is_ok() => println("refused: " + to)
    _ => ()
  }
}
```

The server answers syntax, sequence, limits, the `354` and the chunk replies
itself, and hands the application what it decides:

```moonbit
let server = @smtp.Server::new("mx.example", auth=["PLAIN"])
server.feed(octets)
while server.next() is Some(request) {
  match request {
    Rcpt(to, _) if !known(to) => server.reply(550, "5.1.1 No such user")
    Data(message) => { store(message); server.accept() }
    Rset | Quit => ()
    _ => server.accept()
  }
}
// write server.next_write() back to the client
```

`lmtp=true` on either side speaks LMTP, where the message gets one reply per
accepted recipient.

## SASL

SMTP's `auth` and IMAP's and POP3's `authenticate` take any
`&@sasl.Mechanism`; the protocol does the base64 and the cancelling.

```moonbit
// SCRAM never sends the password, and refuses a server that cannot prove it
// holds the salted key. The nonce is fresh random printable ASCII each time.
smtp.auth(@sasl.ScramSha256::new("alice", "secret", nonce~))
imap.authenticate(@sasl.OAuthBearer::new(token, username="alice@example.com"))
```

A mechanism of your own implements `name`, `start` and `step`, and `finish`
when it expects proof from the server.

## NNTP

```moonbit
let nntp = @nntp.Nntp::new(connection as &@nntp.NntpIo)
try {
  let _ = nntp.greeting()
  let group = nntp.group("comp.lang.moonbit")
  let article = nntp.article(group.last.to_string())
} catch {
  _ => ()
}
```

## IMAP

Each command returns its tag number; `feed` reports untagged responses as
`Data` and each completion as `Done` with that number.

```moonbit
let imap = @imap.Client::new()
let _ = imap.login("alice", "secret")
let _ = imap.select("INBOX")
let fetch = imap.fetch("1:*", "(FLAGS BODY.PEEK[HEADER])", uid=true)
// ... write imap.next_write(), feed the server's octets
for event in imap.feed(octets) {
  match event {
    Data(Fetch(n, items)) => println(n.to_string() + " " + items.length().to_string())
    Done(tag, No, _, text) if tag == fetch => println("fetch failed: " + text)
    _ => ()
  }
}
```

## DKIM

```moonbit
let options = @dkim.SignOptions::new(
  domain="example.com",
  selector="sel",
  headers=["From", "To", "Subject", "Date"],
)
let signature = @dkim.sign(raw[:], private_key, options)
// "DKIM-Signature: " + signature is the header to add; verify() checks it back.
```

## Beyond the basics

The pieces a caller reaches for once the simple path works:

```moonbit
// IMAP: ask about a mailbox without selecting it, wait for changes, and
// store flags only where nothing changed them since (CONDSTORE).
let _ = imap.status("INBOX", ["MESSAGES", "UIDNEXT", "UIDVALIDITY"])
let _ = imap.idle()                    // changes arrive as Data until done()
imap.done()
let _ = imap.store("1:5", "+FLAGS (\\Seen)", uid=true, unchangedsince=modseq)

// SMTP: chunk the body instead of using DATA, and ask for delivery status.
smtp.mail("alice@example.com", size=1234, body=Binary)
smtp.rcpt("bob@example.com", notify=[Success, Failure])
smtp.bdat(chunk[:], last=true)   // LAST ends the transaction

// JMAP: create a draft and read back the id the server gave it.
let email_set = @jmap.email_set("acct1", "c1")
email_set.create("draft1",
  @jmap.email_draft("Drafts", "alice@example.com", ["bob@example.com"], "Hi", "Body"))
let result = @jmap.parse_set_response(response.responses[0].arguments)
```

## What it is not

No network layer of its own: every protocol talks over a trait you implement.
JMAP ships a moonfetch adapter (native).

**MAPI is the honest half of the story.** The envelope, the ROP framing, the
property tags and the request builders follow MS-OXCMAPIHTTP and MS-OXCROPS, and
the tests pin their byte layout — but none of it has been checked against a live
Exchange server, so treat those octets as a starting point. Reading ROP
*responses* is only done as far as the shared header and the logon reply;
per-operation row data is left to the caller. `STARTTLS` is likewise the command
only: the TLS upgrade is the transport's job, since this library holds no TLS
stack.

## The gate

```bash
moon clean && moon fmt && moon check --target all --deny-warn \
  && moon build --target all && moon test --target all
```

## Licence

Apache-2.0.
