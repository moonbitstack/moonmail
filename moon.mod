name = "moonbitstack/moonmail"

version = "0.1.6"

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
  "moonbitstack/mooncrypt@0.4.12",
  "moonbitstack/moonmime@0.2.3",
  "moonbitstack/moondate@0.1.5",
  "moonbitstack/moonucd@0.1.4",
  "moonbitstack/moonnet@0.1.11",
  "moonbitstack/moontls@0.9.15",
  "moonbitstack/mooncred@0.6.10",
  "moonbitlang/async@0.22.5",
  "moonbitstack/moonfetch@0.1.6",
}
