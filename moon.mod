name = "moonbitstack/moonmail"

version = "0.1.0"

readme = "README.md"

repository = "https://github.com/moonbitstack/moonmail"

license = "Apache-2.0"

keywords = [
  "email",
  "mail",
  "smtp",
  "imap",
  "pop3",
  "nntp",
  "dkim",
  "mime",
  "moonbit",
]

description = "Email for MoonBit: the message model, MIME and DKIM, and the POP3, SMTP, LMTP, NNTP, IMAP and JMAP dialogues."

source = "src"

import {
  "moonbitstack/moonbase@0.4.2",
  "moonbitstack/mooncrypt@0.4.4",
  "moonbitstack/moonmime@0.2.1",
  "moonbitstack/moonucd@0.1.1",
  "moonbitstack/moonjson@0.4.2",
  "moonbitstack/moonfetch@0.1.0",
}
