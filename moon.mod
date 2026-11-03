name = "moonbitstack/moonmail"

version = "0.1.3"

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
  "moonbitstack/moonbase@0.4.2",
  "moonbitstack/mooncrypt@0.4.6",
  "moonbitstack/moonmime@0.2.1",
  "moonbitstack/moondate@0.1.0",
  "moonbitstack/moonucd@0.1.2",
  "moonbitstack/moonnet@0.1.7",
  "moonbitstack/moontls@0.9.6",
  "moonbitstack/mooncred@0.6.7",
  "moonbitlang/async@0.22.5",
  "moonbitstack/moonfetch@0.1.2",
}
