// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// RFC 8463 appendix A's Ed25519 signature field and the header it covers.
let signed_head : String =
  #|DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
  #| d=football.example.com; i=@football.example.com;
  #| q=dns/txt; s=brisbane; t=1528637909; h=from : to :
  #| subject : date : message-id : from : subject : date;
  #| bh=2jUSOH9NhtVGCQWNr9BrIAPreKQjO6Sn7XIkfJVOzv8=;
  #| b=/gCrinpcQOoIfuHNQIbq4pgh9kyIK3AQUdt9OdqQehSwhEIug4D11Bus
  #| Fa3bT3FY5OsU7ZbnKELq+eXdp1Q1Dw==
  #|From: Joe SixPack <joe@football.example.com>
  #|To: Suzie Q <suzie@shopping.example.net>
  #|Subject: Is dinner ready?
  #|Date: Fri, 11 Jul 2003 21:00:37 -0700 (PDT)
  #|Message-ID: <20030712040037.46341.5F8J@football.example.com>
  #|
  #|

///|
test "dkim reproduces the Ed25519 signature of RFC 8463 octet for octet" {
  let (fields, _) = split(
    @utf8.encode(signed_head.replace_all(old="\n", new="\r\n"))[:],
  )
  let field = without_b(fields[0].raw)
  let names = [
    "from", "to", "subject", "date", "message-id", "from", "subject", "date",
  ]
  let seed = @base64.decode("nWGxne/9WmC6hEr0kuwsxERJxWl7MmkZcDusAxyuf2A=")
  let key = Ed25519(@ed25519.PrivateKey::of_secret(seed[:]))
  let made = signature(key, fields[1:].to_owned(), names, field, Relaxed)
  assert_eq(
    @base64.encode(made[:]),
    "/gCrinpcQOoIfuHNQIbq4pgh9kyIK3AQUdt9OdqQehSwhEIug4D11BusFa3bT3FY5OsU7ZbnKELq+eXdp1Q1Dw==",
  )
}
