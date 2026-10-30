// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// What the server sends after `input`, its requests answered by `decide`.
fn exchange(
  server : @smtp.Server,
  input : String,
  decide? : (@smtp.Request) -> Unit raise @smtp.Refused,
) -> String raise @smtp.Refused {
  server.feed(lines(input))
  while server.next() is Some(request) {
    match decide {
      Some(f) => f(request)
      None =>
        match request {
          Rset | Quit => ()
          _ => server.accept()
        }
    }
  }
  wire(server.next_write())
}

///|
/// A server past its greeting and an accepted `EHLO`.
fn hello(server : @smtp.Server) -> @smtp.Server raise @smtp.Refused {
  let _ = exchange(server, "EHLO c.example\r\n")
  server
}

///|
test "smtp server greets and announces its extensions" {
  let server = @smtp.Server::new("mx.example", starttls=true, auth=["plain"])
  inspect(wire(server.next_write()), content="220 mx.example ESMTP\r\n")
  inspect(
    exchange(server, "EHLO c.example\r\n"),
    content="250-mx.example Hello c.example\r\n250-PIPELINING\r\n250-SIZE 10240000\r\n250-8BITMIME\r\n250-BINARYMIME\r\n250-CHUNKING\r\n250-SMTPUTF8\r\n250-DSN\r\n250-ENHANCEDSTATUSCODES\r\n250 STARTTLS\r\n",
  )
  inspect(
    exchange(server, "HELO c.example\r\n"),
    content="250 mx.example Hello c.example\r\n",
  )
}

///|
test "smtp server offers auth only once tls has started" {
  let server = hello(
    @smtp.Server::new("mx.example", starttls=true, auth=["PLAIN"]),
  )
  inspect(
    exchange(server, "AUTH PLAIN\r\n"),
    content="502 5.5.1 AUTH not offered\r\n",
  )
  inspect(
    exchange(server, "STARTTLS\r\nEHLO injected\r\n"),
    content="220 2.0.0 Ready to start TLS\r\n",
  )
  inspect(server.next() is None, content="true")
  let after = exchange(server, "EHLO c.example\r\n")
  inspect(after.contains("STARTTLS"), content="false")
  inspect(after.contains("250 AUTH PLAIN"), content="true")
  inspect(
    exchange(server, "STARTTLS\r\n"),
    content="503 5.5.1 TLS already started\r\n",
  )
}

///|
test "smtp server answers sequence errors itself" {
  let server = @smtp.Server::new("mx.example")
  let _ = server.next_write()
  inspect(
    exchange(server, "MAIL FROM:<a@x>\r\n"),
    content="503 5.5.1 Send EHLO first\r\n",
  )
  let _ = hello(server)
  inspect(
    exchange(server, "RCPT TO:<b@x>\r\n"),
    content="503 5.5.1 Need MAIL before RCPT\r\n",
  )
  inspect(
    exchange(server, "DATA\r\n"),
    content="503 5.5.1 Need MAIL before DATA\r\n",
  )
  inspect(exchange(server, "MAIL FROM:<a@x>\r\n"), content="250 2.1.0 Ok\r\n")
  inspect(
    exchange(server, "MAIL FROM:<a@x>\r\n"),
    content="503 5.5.1 Nested MAIL command\r\n",
  )
  inspect(
    exchange(server, "DATA\r\n"),
    content="554 5.5.1 No valid recipients\r\n",
  )
  inspect(
    exchange(server, "FROB\r\n"),
    content="500 5.5.2 Command unrecognized\r\n",
  )
}

///|
test "smtp server checks the envelope parameters" {
  let server = hello(
    @smtp.Server::new("mx.example", limits=@smtp.Limits::new(size=100)),
  )
  inspect(
    exchange(server, "MAIL FROM:<a@x> SIZE=101\r\n"),
    content="552 5.3.4 Message size exceeds fixed maximum message size\r\n",
  )
  inspect(
    exchange(server, "MAIL FROM:<a@x> BODY=9BIT\r\n"),
    content="501 5.5.4 Bad value for BODY\r\n",
  )
  inspect(
    exchange(server, "MAIL FROM:<a@x> XFOO=1\r\n"),
    content="555 5.5.4 Unsupported parameter XFOO\r\n",
  )
  inspect(
    exchange(server, "MAIL FROM:<a@x> SIZE=1 SIZE=2\r\n"),
    content="501 5.5.4 Malformed parameters\r\n",
  )
  inspect(
    exchange(server, "MAIL FROM:<ä@x>\r\n"),
    content="553 5.6.7 A non-ASCII address needs SMTPUTF8\r\n",
  )
  inspect(
    exchange(server, "MAIL FROM:a@x\r\n"),
    content="501 5.5.4 Syntax: MAIL FROM:<address>\r\n",
  )
  let mut seen = None
  inspect(
    exchange(server, "mail from: <@relay:a@x> size=10 smtputf8 ret=HDRS\r\n", decide=request => {
      seen = Some(request)
      server.accept()
    }),
    content="250 2.1.0 Ok\r\n",
  )
  assert_eq(
    seen,
    Some(
      Mail(
        "a@x",
        Map([("SIZE", Some("10")), ("SMTPUTF8", None), ("RET", Some("HDRS"))]),
      ),
    ),
  )
  inspect(
    exchange(server, "RCPT TO:<>\r\n"),
    content="501 5.1.3 Syntax: RCPT TO:<address>\r\n",
  )
  inspect(
    exchange(server, "RCPT TO:<b@x> NOTIFY=SOMETIMES\r\n"),
    content="501 5.5.4 Bad value for NOTIFY\r\n",
  )
  inspect(
    exchange(server, "RCPT TO:<b@x> NOTIFY=SUCCESS,DELAY ORCPT=rfc822;b@x\r\n"),
    content="250 2.1.5 Ok\r\n",
  )
}

///|
test "smtp server limits the recipients" {
  let server = hello(
    @smtp.Server::new("mx.example", limits=@smtp.Limits::new(recipients=1)),
  )
  let out = exchange(
    server, "MAIL FROM:<a@x>\r\nRCPT TO:<b@x>\r\nRCPT TO:<c@x>\r\n",
  )
  inspect(
    out,
    content="250 2.1.0 Ok\r\n250 2.1.5 Ok\r\n452 4.5.3 Too many recipients\r\n",
  )
}

///|
test "smtp server reads the message and unstuffs it" {
  let server = hello(@smtp.Server::new("mx.example"))
  let mut message = b""
  let out = exchange(
    server,
    "MAIL FROM:<a@x>\r\nRCPT TO:<b@x>\r\nDATA\r\n..lead\r\nfake\n.\nend\r\n.\r\n",
    decide=request => {
      if request is Data(data) {
        message = data
      }
      server.accept()
    },
  )
  inspect(
    out,
    content="250 2.1.0 Ok\r\n250 2.1.5 Ok\r\n354 End data with <CR><LF>.<CR><LF>\r\n250 2.0.0 Ok: queued\r\n",
  )
  inspect(@utf8.decode_lossy(message[:]), content=".lead\r\nfake\n.\nend\r\n")
}

///|
test "smtp server refuses a message over the size limit after reading it" {
  let server = hello(
    @smtp.Server::new("mx.example", limits=@smtp.Limits::new(size=8)),
  )
  let out = exchange(
    server, "MAIL FROM:<a@x>\r\nRCPT TO:<b@x>\r\nDATA\r\n0123456789\r\n.\r\nNOOP\r\n",
  )
  inspect(
    out,
    content="250 2.1.0 Ok\r\n250 2.1.5 Ok\r\n354 End data with <CR><LF>.<CR><LF>\r\n552 5.3.4 Message size exceeds fixed maximum message size\r\n250 2.0.0 Ok\r\n",
  )
}

///|
test "smtp server joins bdat chunks and reads refused ones through" {
  let server = hello(@smtp.Server::new("mx.example"))
  inspect(
    exchange(server, "BDAT 5\r\nhello"),
    content="503 5.5.1 Need MAIL before BDAT\r\n",
  )
  let mut message = b""
  let out = exchange(
    server,
    "MAIL FROM:<a@x> BODY=BINARYMIME\r\nRCPT TO:<b@x>\r\nDATA\r\nBDAT 3\r\nabcBDAT 2 LAST\r\nde",
    decide=request => {
      if request is Data(data) {
        message = data
      }
      server.accept()
    },
  )
  inspect(
    out,
    content="250 2.1.0 Ok\r\n250 2.1.5 Ok\r\n503 5.5.1 BINARYMIME needs BDAT\r\n250 2.0.0 3 octets received\r\n250 2.0.0 Ok: queued\r\n",
  )
  inspect(@utf8.decode_lossy(message[:]), content="abcde")
}

///|
test "smtp server waits for a chunk that arrives in pieces" {
  let server = hello(@smtp.Server::new("mx.example"))
  let _ = exchange(server, "MAIL FROM:<a@x>\r\nRCPT TO:<b@x>\r\n")
  inspect(exchange(server, "BDAT 6 LAST\r\nabc"), content="(nothing)")
  inspect(exchange(server, "def"), content="250 2.0.0 Ok: queued\r\n")
}

///|
test "smtp server refuses an over-long line and goes on" {
  let server = hello(
    @smtp.Server::new("mx.example", limits=@smtp.Limits::new(line=16)),
  )
  inspect(
    exchange(server, "NOOP " + "x".repeat(40)),
    content="500 5.5.2 Line too long\r\n",
  )
  inspect(exchange(server, "yyy\r\nNOOP\r\n"), content="250 2.0.0 Ok\r\n")
}

///|
test "smtp server runs a sasl exchange through the application" {
  let server = hello(@smtp.Server::new("mx.example", auth=["LOGIN", "PLAIN"]))
  let answers = []
  let decide = (request : @smtp.Request) => {
    match request {
      Auth("LOGIN", None) => server.challenge(b"Username:")
      Response(data) => {
        answers.push(@utf8.decode_lossy(data[:]))
        if answers.length() == 1 {
          server.challenge(b"Password:")
        } else {
          server.accept()
        }
      }
      _ => server.accept()
    }
  }
  inspect(
    exchange(server, "AUTH LOGIN\r\n", decide~),
    content="334 VXNlcm5hbWU6\r\n",
  )
  inspect(exchange(server, "dGlt\r\n", decide~), content="334 UGFzc3dvcmQ6\r\n")
  inspect(
    exchange(server, "c2VjcmV0\r\n", decide~),
    content="235 2.7.0 Authentication successful\r\n",
  )
  assert_eq(answers, ["tim", "secret"])
  inspect(
    exchange(server, "AUTH PLAIN =\r\n"),
    content="503 5.5.1 Already authenticated\r\n",
  )
}

///|
test "smtp server answers a cancelled or undecodable sasl response" {
  let server = hello(@smtp.Server::new("mx.example", auth=["LOGIN"]))
  let decide = (request : @smtp.Request) => {
    match request {
      Auth(_, _) | Response(_) => server.challenge(b"")
      _ => server.accept()
    }
  }
  inspect(
    exchange(server, "AUTH CRAM-MD5\r\n"),
    content="504 5.5.4 Unrecognized authentication type\r\n",
  )
  inspect(exchange(server, "AUTH LOGIN\r\n", decide~), content="334 \r\n")
  inspect(
    exchange(server, "*\r\n"),
    content="501 5.0.0 Authentication cancelled\r\n",
  )
  inspect(exchange(server, "AUTH LOGIN\r\n", decide~), content="334 \r\n")
  inspect(
    exchange(server, "!!\r\n"),
    content="501 5.5.2 Cannot decode response\r\n",
  )
  inspect(
    exchange(server, "AUTH LOGIN !!\r\n"),
    content="501 5.5.2 Cannot decode response\r\n",
  )
}

///|
test "lmtp server answers the message once per recipient" {
  let server = @smtp.Server::new("lmtp.example", lmtp=true)
  inspect(wire(server.next_write()), content="220 lmtp.example LMTP\r\n")
  inspect(
    exchange(server, "EHLO c\r\n"),
    content="500 5.5.2 Command unrecognized\r\n",
  )
  let _ = exchange(server, "LHLO c\r\n")
  let _ = exchange(
    server, "MAIL FROM:<a@x>\r\nRCPT TO:<b@x>\r\nRCPT TO:<c@x>\r\n",
  )
  let out = exchange(server, "DATA\r\nhi\r\n.\r\nNOOP\r\n", decide=request => {
    match request {
      Data(_) => {
        server.accept()
        server.reply(452, "4.2.2 Mailbox full")
      }
      _ => server.accept()
    }
  })
  inspect(
    out,
    content="354 End data with <CR><LF>.<CR><LF>\r\n250 2.0.0 Ok: queued\r\n452 4.2.2 Mailbox full\r\n250 2.0.0 Ok\r\n",
  )
}

///|
test "smtp server takes pipelined commands one answer at a time" {
  let server = hello(@smtp.Server::new("mx.example"))
  server.feed(lines("MAIL FROM:<a@x>\r\nRCPT TO:<b@x>\r\n"))
  assert_eq(server.next(), Some(Mail("a@x", Map([]))))
  inspect(server.next() is None, content="true")
  server.reply(550, "5.7.1 Not you")
  inspect(server.next() is None, content="true")
  inspect(
    wire(server.next_write()),
    content="550 5.7.1 Not you\r\n503 5.5.1 Need MAIL before RCPT\r\n",
  )
}

///|
test "smtp server closes after quit or a 421" {
  let server = hello(@smtp.Server::new("mx.example"))
  assert_eq(
    refusal(() => server.accept()),
    Some(Order("no request awaits an answer")),
  )
  inspect(
    exchange(server, "RSET\r\nQUIT\r\nNOOP\r\n"),
    content="250 2.0.0 Ok\r\n221 2.0.0 Bye\r\n",
  )
  inspect(server.closed(), content="true")
  let busy = @smtp.Server::new("mx.example")
  let _ = exchange(busy, "EHLO c\r\n", decide=_ => busy.reply(421, "4.3.2 Busy"))
  inspect(busy.closed(), content="true")
}
