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
fn lines(text : String) -> Bytes {
  @utf8.encode(text)
}

///|
fn[T] refusal(f : () -> T raise @smtp.Refused) -> @smtp.Refused? {
  try {
    let _ = f()
    None
  } catch {
    e => Some(e)
  }
}

///|
/// A client past the greeting and an `EHLO` whose reply announced `extensions`.
fn greeted(
  extensions : Array[String],
  lmtp~ : Bool = false,
) -> @smtp.Client raise @smtp.Refused {
  let client = @smtp.Client::new(lmtp~)
  let _ = client.feed(lines("220 mx.example ESMTP\r\n"))
  client.ehlo("c.example")
  let _ = client.next_write()
  let reply = @smtp.Reply::new(250, (["mx.example"] + extensions).join("\n"))
  let _ = client.feed(reply.encode())
  client
}

///|
test "smtp client waits for the greeting" {
  let client = @smtp.Client::new()
  client.ehlo("c.example")
  inspect(wire(client.next_write()), content="(nothing)")
  let events = client.feed(lines("220 mx.example ESMTP\r\n"))
  assert_eq(events, [Reply(Greeting, @smtp.Reply::new(220, "mx.example ESMTP"))])
  inspect(wire(client.next_write()), content="EHLO c.example\r\n")
}

///|
test "smtp client reads the extensions" {
  let client = greeted([
    "PIPELINING", "SIZE 1000", "AUTH=LOGIN PLAIN", "8bitmime",
  ])
  inspect(client.has("pipelining"), content="true")
  inspect(client.has("8BITMIME"), content="true")
  inspect(client.has("STARTTLS"), content="false")
  assert_eq(client.extensions().get("SIZE"), Some("1000"))
  assert_eq(client.extensions().get("AUTH"), Some("LOGIN PLAIN"))
}

///|
test "smtp client pipelines up to the group's end" {
  let client = greeted(["PIPELINING"])
  client.send("a@example.com", ["b@example.com", "c@example.com"], b"Hi\r\n")
  inspect(
    wire(client.next_write()),
    content="MAIL FROM:<a@example.com>\r\nRCPT TO:<b@example.com>\r\nRCPT TO:<c@example.com>\r\nDATA\r\n",
  )
  inspect(wire(client.next_write()), content="(nothing)")
  let events = client.feed(
    lines("250 2.1.0 Ok\r\n250 2.1.5 Ok\r\n550 5.1.1 No\r\n354 Go\r\n"),
  )
  inspect(events.length(), content="3")
  assert_eq(
    events[2],
    Reply(Rcpt("c@example.com"), @smtp.Reply::new(550, "5.1.1 No")),
  )
  inspect(wire(client.next_write()), content="Hi\r\n.\r\n")
  let done = client.feed(lines("250 2.0.0 Queued\r\n"))
  assert_eq(done, [Reply(Data, @smtp.Reply::new(250, "2.0.0 Queued"))])
}

///|
test "smtp client sends one command at a time without pipelining" {
  let client = greeted([])
  client.mail("a@example.com")
  client.rcpt("b@example.com")
  inspect(wire(client.next_write()), content="MAIL FROM:<a@example.com>\r\n")
  inspect(wire(client.next_write()), content="(nothing)")
  let _ = client.feed(lines("250 Ok\r\n"))
  inspect(wire(client.next_write()), content="RCPT TO:<b@example.com>\r\n")
}

///|
test "smtp client stuffs dots and fixes line ends" {
  let client = greeted([])
  client.mail("a@example.com")
  client.rcpt("b@example.com")
  client.data(b".hidden\nbare\rlast")
  for reply in ["250 Ok\r\n", "250 Ok\r\n"] {
    let _ = client.next_write()
    let _ = client.feed(lines(reply))
  }
  inspect(wire(client.next_write()), content="DATA\r\n")
  let _ = client.feed(lines("354 Go\r\n"))
  inspect(
    wire(client.next_write()),
    content="..hidden\r\nbare\r\nlast\r\n.\r\n",
  )
}

///|
test "smtp client refuses what the server did not announce" {
  let client = greeted([])
  assert_eq(
    refusal(() => client.mail("a@example.com", size=10)),
    Some(Unsupported("SIZE")),
  )
  assert_eq(
    refusal(() => client.mail("a@example.com", utf8=true)),
    Some(Unsupported("SMTPUTF8")),
  )
  assert_eq(refusal(() => client.starttls()), Some(Unsupported("STARTTLS")))
  assert_eq(
    refusal(() => client.auth(@sasl.Plain::new("u", "p"))),
    Some(Unsupported("AUTH")),
  )
  let auth = greeted(["AUTH LOGIN"])
  assert_eq(
    refusal(() => auth.auth(@sasl.Plain::new("u", "p"))),
    Some(Unsupported("AUTH PLAIN")),
  )
}

///|
test "smtp client refuses commands out of sequence" {
  let fresh = @smtp.Client::new()
  assert_eq(
    refusal(() => fresh.mail("a@example.com")),
    Some(Order("greet with ehlo or helo first")),
  )
  let client = greeted([])
  assert_eq(
    refusal(() => client.rcpt("b@example.com")),
    Some(Order("rcpt needs mail first")),
  )
  client.mail("a@example.com")
  assert_eq(
    refusal(() => client.data(b"x")),
    Some(Order("data needs at least one rcpt")),
  )
  assert_eq(
    refusal(() => client.mail("a@example.com")),
    Some(Order("a transaction is open: send its message or rset")),
  )
  let lmtp = @smtp.Client::new(lmtp=true)
  assert_eq(refusal(() => lmtp.helo("c")), Some(Order("LMTP greets with LHLO")))
  let pending = @smtp.Client::new()
  pending.ehlo("c")
  assert_eq(
    refusal(() => pending.starttls()),
    Some(Order("the EHLO reply has not arrived")),
  )
}

///|
test "smtp client refuses arguments that smuggle a command" {
  let client = greeted([])
  assert_eq(
    refusal(() => client.mail("a@example.com>\r\nRCPT TO:<x")),
    Some(Malformed("not an address: a@example.com>\r\nRCPT TO:<x")),
  )
  assert_eq(
    refusal(() => client.vrfy("x\r\nQUIT")),
    Some(Malformed("not a command argument: x\r\nQUIT")),
  )
}

///|
test "smtp client writes the extension parameters" {
  let client = greeted([
    "SIZE 100", "8BITMIME", "SMTPUTF8", "DSN", "AUTH PLAIN", "CHUNKING", "BINARYMIME",
  ])
  client.mail(
    "ä@example.com",
    size=50,
    body=EightBit,
    utf8=true,
    ret=Headers,
    envid="id+1=2",
    auth="",
  )
  client.rcpt("ö@example.com", notify=[], orcpt="ö@example.com")
  client.rcpt("b@example.com", notify=[Success, Delay], orcpt="b@example.com")
  inspect(
    wire(client.next_write()),
    content="MAIL FROM:<ä@example.com> SIZE=50 BODY=8BITMIME SMTPUTF8 RET=HDRS ENVID=id+2B1+3D2 AUTH=<>\r\n",
  )
  let _ = client.feed(lines("250 Ok\r\n"))
  inspect(
    wire(client.next_write()),
    content="RCPT TO:<ö@example.com> NOTIFY=NEVER ORCPT=utf-8;\\x{F6}@example.com\r\n",
  )
  let _ = client.feed(lines("250 Ok\r\n"))
  inspect(
    wire(client.next_write()),
    content="RCPT TO:<b@example.com> NOTIFY=SUCCESS,DELAY ORCPT=rfc822;b@example.com\r\n",
  )
  assert_eq(
    refusal(() => greeted(["SIZE 100"]).mail("a@example.com", size=101)),
    Some(Exceeded(limit=100, got=101)),
  )
}

///|
test "smtp client sends a long first response after the challenge" {
  let client = greeted(["AUTH PLAIN"])
  let password = "p".repeat(400)
  client.auth(@sasl.Plain::new("user", password))
  inspect(wire(client.next_write()), content="AUTH PLAIN\r\n")
  let _ = client.feed(lines("334 \r\n"))
  let answer = wire(client.next_write())
  assert_eq(
    answer,
    @base64.encode(@utf8.encode("\u{0}user\u{0}" + password)[:]) + "\r\n",
  )
  let events = client.feed(lines("235 2.7.0 Ok\r\n"))
  assert_eq(events, [Reply(Auth("PLAIN"), @smtp.Reply::new(235, "2.7.0 Ok"))])
}

///|
test "smtp client runs scram and checks the server" {
  let client = greeted(["AUTH SCRAM-SHA-256"])
  client.auth(
    @sasl.ScramSha256::new("user", "pencil", nonce="rOprNGfwEbeRWgbNEkqO"),
  )
  inspect(
    wire(client.next_write()),
    content="AUTH SCRAM-SHA-256 biwsbj11c2VyLHI9ck9wck5HZndFYmVSV2diTkVrcU8=\r\n",
  )
  let _ = client.feed(
    lines(
      "334 cj1yT3ByTkdmd0ViZVJXZ2JORWtxTyVodllEcFdVYTJSYVRDQWZ1eEZJbGopaE5sRiRrMCxzPVcyMlphSjBTTlk3c29Fc1VFamI2Z1E9PSxpPTQwOTY=\r\n",
    ),
  )
  inspect(
    wire(client.next_write()),
    content="Yz1iaXdzLHI9ck9wck5HZndFYmVSV2diTkVrcU8laHZZRHBXVWEyUmFUQ0FmdXhGSWxqKWhObEYkazAscD1kSHpiWmFwV0lrNGpVaE4rVXRlOXl0YWc5empmTUhnc3FtbWl6N0FuZFZRPQ==\r\n",
  )
  let _ = client.feed(
    lines(
      "334 dj02cnJpVFJCaTIzV3BSUi93dHVwK21NaFVaVW4vZEI1bkxUSlJzamw5NUc0PQ==\r\n",
    ),
  )
  inspect(wire(client.next_write()), content="\r\n")
  let events = client.feed(lines("235 2.7.0 Ok\r\n"))
  assert_eq(events, [
    Reply(Auth("SCRAM-SHA-256"), @smtp.Reply::new(235, "2.7.0 Ok")),
  ])
}

///|
test "smtp client reports a server that skips the scram proof" {
  let client = greeted(["AUTH SCRAM-SHA-256"])
  client.auth(
    @sasl.ScramSha256::new("user", "pencil", nonce="rOprNGfwEbeRWgbNEkqO"),
  )
  let _ = client.next_write()
  let _ = client.feed(
    lines(
      "334 cj1yT3ByTkdmd0ViZVJXZ2JORWtxTyVodllEcFdVYTJSYVRDQWZ1eEZJbGopaE5sRiRrMCxzPVcyMlphSjBTTlk3c29Fc1VFamI2Z1E9PSxpPTQwOTY=\r\n",
    ),
  )
  let _ = client.next_write()
  let events = client.feed(lines("235 2.7.0 Ok\r\n"))
  assert_eq(events, [Sasl(Signature)])
}

///|
test "smtp client cancels a challenge the mechanism refuses" {
  let client = greeted(["AUTH LOGIN"])
  client.auth(@sasl.Login::new("u", "p"))
  let _ = client.next_write()
  let events = client.feed(lines("334 !!\r\n"))
  assert_eq(events, [Sasl(Malformed("the challenge is not base64"))])
  inspect(wire(client.next_write()), content="*\r\n")
  let after = client.feed(lines("501 5.0.0 Cancelled\r\n"))
  assert_eq(after, [
    Reply(Auth("LOGIN"), @smtp.Reply::new(501, "5.0.0 Cancelled")),
  ])
}

///|
test "smtp client forgets the extensions after starttls" {
  let client = greeted(["STARTTLS", "PIPELINING"])
  client.starttls()
  inspect(wire(client.next_write()), content="STARTTLS\r\n")
  let _ = client.feed(lines("220 2.0.0 Go ahead\r\n"))
  inspect(client.has("PIPELINING"), content="false")
  assert_eq(
    refusal(() => client.mail("a@example.com")),
    Some(Order("greet with ehlo or helo first")),
  )
}

///|
test "lmtp client names each delivery reply" {
  let client = greeted(["PIPELINING"], lmtp=true)
  client.send(
    "a@example.com",
    ["b@example.com", "c@example.com", "d@example.com"],
    b"Hi",
  )
  let _ = client.next_write()
  let _ = client.feed(
    lines("250 Ok\r\n250 Ok\r\n550 No\r\n250 Ok\r\n354 Go\r\n"),
  )
  let _ = client.next_write()
  let events = client.feed(lines("250 2.0.0 Saved\r\n452 4.2.2 Full\r\n"))
  assert_eq(events, [
    Reply(Delivery("b@example.com"), @smtp.Reply::new(250, "2.0.0 Saved")),
    Reply(Delivery("d@example.com"), @smtp.Reply::new(452, "4.2.2 Full")),
  ])
}

///|
test "smtp client reports an unprompted reply as from the server" {
  let client = greeted([])
  let events = client.feed(lines("421 4.3.2 Shutting down\r\n"))
  assert_eq(events, [
    Reply(Greeting, @smtp.Reply::new(421, "4.3.2 Shutting down")),
  ])
}

///|
test "smtp client refuses malformed replies" {
  assert_eq(
    refusal(() => @smtp.Client::new().feed(lines("hello\r\n"))),
    Some(Malformed("a reply code is three digits from 200 to 599: hello")),
  )
  assert_eq(
    refusal(() => @smtp.Client::new().feed(lines("250-a\r\n251 b\r\n"))),
    Some(Malformed("a multi-line reply changed its code")),
  )
  assert_eq(
    refusal(() => @smtp.Client::new().feed(lines("250x\r\n"))),
    Some(Malformed("a reply code is followed by a space or a hyphen: 250x")),
  )
  let small = @smtp.Client::new(limits=@smtp.Limits::new(line=8))
  assert_eq(
    refusal(() => small.feed(lines("250 123456789\r\n"))),
    Some(Exceeded(limit=8, got=13)),
  )
}

///|
test "smtp client send picks the parameters" {
  let client = greeted(["SIZE 1000", "8BITMIME", "SMTPUTF8"])
  client.send("ä@example.com", ["b@example.com"], b"\xC3\xA4\r\n")
  inspect(
    wire(client.next_write()),
    content="MAIL FROM:<ä@example.com> SIZE=4 BODY=8BITMIME SMTPUTF8\r\n",
  )
  let plain = greeted([])
  assert_eq(
    refusal(() => plain.send("a@example.com", ["b@example.com"], b"\xC3\xA4")),
    Some(Unsupported("8BITMIME")),
  )
}

///|
test "smtp reply reads its enhanced status and writes itself" {
  let reply = @smtp.Reply::new(250, "2.1.5 Ok\nsecond line")
  assert_eq(reply.status(), Some("2.1.5"))
  assert_eq(reply.text(), "2.1.5 Ok\nsecond line")
  inspect(
    @utf8.decode_lossy(reply.encode()[:]),
    content="250-2.1.5 Ok\r\n250 second line\r\n",
  )
  assert_eq(@smtp.Reply::new(250, "4.1.5 Mismatch").status(), None)
  assert_eq(@smtp.Reply::new(550, "Plain").status(), None)
  inspect(
    @utf8.decode_lossy(@smtp.Reply::new(221, "").encode()[:]),
    content="221\r\n",
  )
}
