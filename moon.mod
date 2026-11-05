name = "moonbitstack/moonmail"

version = "0.1.4"

readme = "README.md"

repository = "https://github.com/moonbitstack/moonmail"

license = "Apache-2.0"

keywords = [
  "email",
  "mail",
  "smtp",
  "lmtp",
  "imap",
  "pop3",
  "jmap",
  "mime",
  "dkim",
  "sasl",
  "starttls",
  "xoauth2",
  "oauthbearer",
  "scram",
  "cram-md5",
  "client",
  "server",
  "rfc5321",
  "rfc5322",
  "rfc9051",
  "rfc1939",
  "rfc6376",
  "rfc8620",
  "moonbit",
]

description = "Email for MoonBit: the message model, MIME and DKIM, and SMTP, LMTP, IMAP and POP3."

source = "src"

import {
  "moonbitstack/moonbase@0.4.3",
  "moonbitstack/mooncrypt@0.4.11",
  "moonbitstack/moonmime@0.2.2",
  "moonbitstack/moondate@0.1.4",
  "moonbitstack/moonucd@0.1.3",
  "moonbitstack/moonnet@0.1.10",
  "moonbitstack/moontls@0.9.14",
  "moonbitstack/mooncred@0.6.9",
  "moonbitlang/async@0.22.5",
  "moonbitstack/moonfetch@0.1.5",
}
