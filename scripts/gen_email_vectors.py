#!/usr/bin/env python3
# Copyright 2026 Leo Cheng
# SPDX-License-Identifier: Apache-2.0
"""Write src/vectors_test.mbt: what Python's email package, under
policy.default, reads from the address lists of RFC 5322 appendix A and from
a set of messages, as tests the root package must pass.

    python3 scripts/gen_email_vectors.py
"""

import email
import email.policy
import pathlib
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
OUT = ROOT / "src" / "vectors_test.mbt"

ADDRESSES = [
    # RFC 5322 appendix A.1.1 to A.6
    "John Doe <jdoe@machine.example>",
    "Mary Smith <mary@example.net>",
    '"Joe Q. Public" <john.q.public@example.com>',
    "Mary Smith <mary@x.test>, jdoe@example.org, Who? <one@y.test>",
    '<boss@nil.test>, "Giant; \\"Big\\" Box" <sysservices@example.net>',
    "A Group:Ed Jones <c@a.test>,joe@where.test,John <jdoe@one.test>;",
    "Undisclosed recipients:;",
    "Pete(A nice \\) chap) <pete(his account)@silly.test(his host)>",
    "A Group(Some people) :Chris Jones <c@(Chris's host.)public.example>, joe@example.org, John <jdoe@one.test> (my dear friend); (the end of the group)",
    "Joe Q. Public <john.q.public@example.com>",
    "Mary Smith <@node.test:mary@example.net>, , jdoe@test  . example",
    "John Doe <jdoe@machine(comment).  example>",
    # encoded words, quoting and literals
    "=?utf-8?q?Ren=C3=A9e?= <renee@example.com>",
    "=?iso-8859-1?q?Andr=E9?= Pirard <PIRARD@vm1.ulg.ac.be>",
    '"john doe"@example.com',
    '"john.doe"@example.com',
    "jdoe@[192.168.0.1]",
    "Bob <bob@example.com>, team: carol@example.com, dan@example.com;",
]

MESSAGES = {
    "plain": "From: a@example.com\r\nSubject: =?utf-8?B?Q2Fmw6k=?=\r\nContent-Type: text/plain; charset=utf-8\r\nContent-Transfer-Encoding: quoted-printable\r\n\r\nCaf=C3=A9 and cr=C3=A8me\r\n",
    "alternative": "From: a@example.com\r\nSubject: Two\r\nMIME-Version: 1.0\r\nContent-Type: multipart/alternative; boundary=\"b1\"\r\n\r\npreamble\r\n--b1\r\nContent-Type: text/plain; charset=us-ascii\r\n\r\nplain body\r\n--b1\r\nContent-Type: text/html; charset=utf-8\r\nContent-Transfer-Encoding: base64\r\n\r\nPHA+aHRtbCBib2R5PC9wPg==\r\n--b1--\r\nepilogue\r\n",
    "mixed": "From: a@example.com\r\nSubject: Files\r\nMIME-Version: 1.0\r\nContent-Type: multipart/mixed; boundary=\"outer\"\r\n\r\n--outer\r\nContent-Type: multipart/related; boundary=\"inner\"\r\n\r\n--inner\r\nContent-Type: text/html; charset=utf-8\r\n\r\n<img src=\"cid:logo\">\r\n--inner\r\nContent-Type: image/png\r\nContent-ID: <logo>\r\nContent-Disposition: inline; filename=\"logo.png\"\r\nContent-Transfer-Encoding: base64\r\n\r\niVBORw0K\r\n--inner--\r\n--outer\r\nContent-Type: application/pdf; name=\"report.pdf\"\r\nContent-Disposition: attachment; filename*=utf-8''r%C3%A9sum%C3%A9.pdf\r\nContent-Transfer-Encoding: base64\r\n\r\nJVBERi0=\r\n--outer--\r\n",
    "latin": "From: a@example.com\r\nSubject: =?iso-8859-1?q?caf=E9?=\r\nContent-Type: text/plain; charset=iso-8859-1\r\nContent-Transfer-Encoding: 8bit\r\n\r\ncaf\xe9\n",
    "embedded": "From: a@example.com\r\nSubject: Fwd\r\nContent-Type: multipart/mixed; boundary=\"m\"\r\n\r\n--m\r\nContent-Type: text/plain\r\n\r\nsee below\r\n--m\r\nContent-Type: message/rfc822\r\n\r\nFrom: b@example.com\r\nSubject: Inner\r\n\r\ninner body\r\n--m--\r\n",
}


def mb(text):
    out = []
    for c in text:
        if c == "\\":
            out.append("\\\\")
        elif c == '"':
            out.append('\\"')
        elif c == "\r":
            out.append("\\r")
        elif c == "\n":
            out.append("\\n")
        elif ord(c) < 0x20 or ord(c) > 0x7E:
            out.append("\\u{%x}" % ord(c))
        else:
            out.append(c)
    return '"' + "".join(out) + '"'


def mailbox(a):
    name = "Some(%s)" % mb(a.display_name) if a.display_name else "None"
    return "{ name: %s, address: %s }" % (name, mb(a.addr_spec))


def addresses(value):
    header = email.policy.default.header_factory("To", value)
    out = []
    for group in header.groups:
        members = "[" + ", ".join(mailbox(a) for a in group.addresses) + "]"
        if group.display_name is None:
            out.extend("Mailbox(%s)" % mailbox(a) for a in group.addresses)
        else:
            out.append("Group(name=%s, members=%s)" % (mb(group.display_name), members))
    return "[" + ", ".join(out) + "]"


def option(text):
    return "None" if text is None else "Some(%s)" % mb(text)


def message_test(name, raw):
    msg = email.message_from_bytes(raw.encode("latin-1"), policy=email.policy.default)
    plain = msg.get_body(("plain",))
    html = msg.get_body(("html",))
    text = plain.get_content() if plain is not None and plain.get_content_type() == "text/plain" else None
    page = html.get_content() if html is not None and html.get_content_type() == "text/html" else None
    # moonmail also lists the parts beside the root of a multipart/related,
    # with inline set, which Python counts as part of the body.
    files = [p.get_filename() or "" for p in msg.iter_attachments()]
    for part in msg.walk():
        if part.get_content_type() == "multipart/related":
            files = [p.get_filename() or "" for p in part.get_payload()[1:]] + files
    lines = [
        "///|",
        'test "email vectors: message %s" {' % name,
        "  let message = @moonmail.Message::parse(%s)" % bytes_literal(raw),
        "  assert_eq(message.subject(), %s)" % option(str(msg["subject"]) if msg["subject"] is not None else None),
        "  assert_eq(message.content_type().essence, %s)" % mb(msg.get_content_type()),
        "  assert_eq(message.text(), %s)" % option(text),
        "  assert_eq(message.html(), %s)" % option(page),
        "  assert_eq(message.attachments().map(a => a.name), [%s])" % ", ".join(mb(f) for f in files),
        "}",
        "",
    ]
    return lines


def bytes_literal(raw):
    out = []
    for c in raw:
        o = ord(c)
        if c == "\\":
            out.append("\\\\")
        elif c == '"':
            out.append('\\"')
        elif c == "\r":
            out.append("\\r")
        elif c == "\n":
            out.append("\\n")
        elif o < 0x20 or o > 0x7E:
            out.append("\\x%02x" % o)
        else:
            out.append(c)
    return 'b"' + "".join(out) + '"'


def main():
    lines = [
        "// Copyright 2026 Leo Cheng",
        "// SPDX-License-Identifier: Apache-2.0",
        "",
        "// Generated by scripts/gen_email_vectors.py from Python %s's email" % sys.version.split()[0],
        "// package under policy.default. Do not edit by hand.",
        "",
    ]
    for i, value in enumerate(ADDRESSES):
        lines += [
            "///|",
            'test "email vectors: address list %d" {' % (i + 1),
            "  assert_eq(@moonmail.parse_addresses(%s), %s)" % (mb(value), addresses(value)),
            "}",
            "",
        ]
    for name, raw in MESSAGES.items():
        lines += message_test(name, raw)
    OUT.write_text("\n".join(lines), encoding="utf-8", newline="\n")
    print(f"wrote {OUT.relative_to(ROOT)}", file=sys.stderr)


if __name__ == "__main__":
    main()
