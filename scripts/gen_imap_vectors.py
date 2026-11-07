#!/usr/bin/env python3
# Copyright 2026 Leo Cheng
# SPDX-License-Identifier: Apache-2.0
"""Write src/imap/vectors_wbtest.mbt: every expected server reply in imaptest's
scripted test suite, as a vector the IMAP client has to parse.

imaptest is the Dovecot project's own tester, and its scripted tests are a
statement of what a server answers: each `*` line in those files is a reply a
server sends and a client has to understand. That is exactly a reply vector, and
676 of them cost this repository nothing but the text.

    python3 scripts/gen_imap_vectors.py           # write the file
    python3 scripts/gen_imap_vectors.py --check   # fail if it is not current

The suite is read from a pinned commit of https://github.com/dovecot/imaptest,
downloaded when it is not already in the cache; what is committed is the vectors,
not the suite. `--source DIR` reads a checkout instead, for working offline.

Three things are done to a line before it is written down, so that what the
script says and what the client presents can be compared as words:

- a `{{{ ... }}}` block becomes the literal a server would actually send —
  `{octets}` and the data, with the line endings the wire has — and a line may
  hold several of them;
- the item list of a FETCH, the pairs of a STATUS and the flags of a LIST are
  sorted. Order there means nothing to either implementation — imaptest itself
  compares those lists unordered — so sorting both sides is what lets the test
  compare them as text at all;
- a mailbox name is decoded from modified UTF-7, because the client does: the
  octets keep the wire's form and the expectation carries the decoded one.
"""

import argparse
import base64
import pathlib
import re
import sys
import tarfile
import urllib.request

ROOT = pathlib.Path(__file__).resolve().parent.parent
OUT = ROOT / "src" / "imap" / "vectors_wbtest.mbt"

# The suite, pinned by commit: the file this writes is only reproducible while
# the input stays what it was.
COMMIT = "d66226a339882b814130ca6b4fe2a12db4d631f8"
ARCHIVE = f"https://github.com/dovecot/imaptest/archive/{COMMIT}.tar.gz"
CACHE = pathlib.Path.home() / ".cache" / "moonmail" / f"imaptest-{COMMIT[:12]}"

# Vectors per function: a few thousand string literals in one function would
# overflow the initialiser a wasm module gets.
CHUNK = 120


def source(directory: str | None) -> pathlib.Path:
    """The `src/tests` directory of the suite, from a checkout or the cache."""
    if directory:
        return pathlib.Path(directory) / "src" / "tests"
    if not CACHE.exists():
        CACHE.parent.mkdir(parents=True, exist_ok=True)
        print(f"downloading imaptest {COMMIT[:12]}", file=sys.stderr)
        with urllib.request.urlopen(ARCHIVE, timeout=60) as response:
            archive = CACHE.with_suffix(".tar.gz")
            archive.write_bytes(response.read())
        with tarfile.open(archive) as tar:
            for member in tar.getmembers():
                if "/src/tests/" not in member.name:
                    continue
                member.name = member.name.split("/src/tests/", 1)[1]
                tar.extract(member, CACHE, filter="data")
        archive.unlink()
    return CACHE


def literal_marker(line: str) -> tuple[bool, str] | None:
    """Whether this line ends by opening a literal, and what comes before it.

    imaptest writes `{{{` at the end of the line to mean "a literal follows",
    and `~{{{` for a literal8 (RFC 3516). The second element is the line with
    the marker taken off.
    """
    if not line.endswith("{{{"):
        return None
    if line.endswith("~{{{"):
        return True, line[:-4]
    if len(line) == 3 or line[-4] in " ~":
        return False, line[:-3]
    return None


def present(
    stripped: str, lines: list[str], index: int
) -> tuple[str, str, int]:
    """The line as the client presents it, the octets a server sends, and where
    reading resumes.

    imaptest writes a literal as `{{{`, the block of lines, and `}}}`; on the
    wire it is `{n}`, the octets, and the rest of the same line. A line may hold
    several literals — `binary[1] {{{…}}} binary[2] {{{…` — so both sides are
    built in one pass over the same text rather than in two that could drift.
    """
    expected = ""
    octets = ""
    line = stripped
    while True:
        marker = literal_marker(line)
        if marker is None:
            expected += line
            octets += substituted(line)
            break
        binary, head = marker
        data = b""
        while index < len(lines) and not lines[index].startswith("}}}"):
            data += (
                lines[index].rstrip("\r").encode("utf-8", "surrogateescape")
                + b"\r\n"
            )
            index += 1
        closing = ""
        if index < len(lines):
            closing = lines[index]
            index += 1
        text = data.decode("utf-8", "surrogateescape")
        # The expectation writes the literal as the string it is, which is what
        # the client renders for one; the octets carry it as the literal.
        expected += (
            substituted(head)
            + '"'
            + text.replace("\\", "\\\\").replace('"', '\\"')
            + '"'
        )
        octets += (
            substituted(head)
            + ("~" if binary else "")
            + "{"
            + str(len(data))
            + "}\r\n"
            + text
        )
        if not closing.startswith("}}}"):
            break
        line = closing[3:].rstrip("\r")
    return canonical(expected), octets, index


def scan_value(text: str, at: int) -> tuple[str, int]:
    """One value of a reply: a quoted string, a literal, a list, or a word."""
    size = len(text)
    while at < size and text[at] in " \r\n\t":
        at += 1
    if at >= size or text[at] == ")":
        return "", at
    char = text[at]
    if char == '"':
        start = at
        at += 1
        while at < size:
            if text[at] == "\\":
                at += 2
                continue
            if text[at] == '"':
                at += 1
                break
            at += 1
        return text[start:at], at
    if char == "(":
        depth = 0
        start = at
        while at < size:
            if text[at] == '"':
                at += 1
                while at < size and text[at] != '"':
                    at += 2 if text[at] == "\\" else 1
                at += 1
                continue
            if text[at] == "(":
                depth += 1
            elif text[at] == ")":
                depth -= 1
                if depth == 0:
                    at += 1
                    break
            at += 1
        return text[start:at], at
    if char == "{" and text[at + 1 : text.find("}", at)].isdigit():
        close = text.find("}", at)
        count = int(text[at + 1 : close])
        start = close + 1
        while start < size and text[start] in "\r\n":
            start += 1
        return text[start : start + count], start + count
    start = at
    while at < size and text[at] not in " \r\n\t()":
        at += 1
    return text[start:at], at


def scan_key(text: str, at: int) -> tuple[str, int]:
    """One item name of a FETCH: a word, or a section with a list inside it —
    `BODY[HEADER.FIELDS (FROM)]<0>` is one name and not a name and a list."""
    size = len(text)
    start = at
    depth = 0
    while at < size:
        char = text[at]
        if char in "([":
            depth += 1
        elif char in ")]":
            if depth == 0:
                # The list this name was in closes here.
                break
            depth -= 1
        elif char in " \r\n\t" and depth == 0:
            break
        at += 1
    return text[start:at], at


def pairs_of(text: str, at: int) -> tuple[list[tuple[str, str]], int]:
    """The `key value` items between parentheses, from just after the `(`."""
    items = []
    size = len(text)
    while at < size:
        while at < size and text[at] in " \r\n\t":
            at += 1
        if at >= size or text[at] == ")":
            at += 1
            break
        key, at = scan_key(text, at)
        if at < size and text[at] == ")":
            # The name had no value after it.
            at += 1
            items.append((key, ""))
            break
        value, at = scan_value(text, at)
        items.append((key, value.strip()))
    return items, at


def values_in(text: str, at: int) -> tuple[list[str], int]:
    """The values between parentheses, from just after the `(` — a flag list,
    where every word stands alone."""
    items = []
    size = len(text)
    while at < size:
        while at < size and text[at] in " \r\n\t":
            at += 1
        if at >= size or text[at] == ")":
            at += 1
            break
        value, at = scan_value(text, at)
        items.append(value)
    return items, at


def sorted_items(items: list[tuple[str, str]]) -> str:
    ordered = sorted(items, key=lambda item: item[0].lower())
    return "( " + " ".join(key + (" " + value if value else "") for key, value in ordered) + " )"


def decode_mutf7(text: str) -> str:
    """RFC 3501 section 5.1.3's modified UTF-7, read back."""
    if "&" not in text:
        return text
    out = []
    at = 0
    while at < len(text):
        char = text[at]
        if char != "&":
            out.append(char)
            at += 1
            continue
        end = text.find("-", at + 1)
        if end < 0:
            out.append(text[at:])
            break
        run = text[at + 1 : end]
        if run == "":
            out.append("&")
        else:
            padded = run.replace(",", "/") + "=" * (-len(run) % 4)
            try:
                out.append(base64.b64decode(padded).decode("utf-16-be"))
            except (ValueError, UnicodeDecodeError):
                out.append(text[at : end + 1])
        at = end + 1
    return "".join(out)


def decoded_name(value: str) -> str:
    """A mailbox name as the client presents it: decoded from modified UTF-7.

    RFC 3501 writes a name that is not ASCII in modified UTF-7, and the client
    decodes it before handing a reply on, so the expectation carries the
    decoded form and the octets carry the wire's. Applying it to a name that is
    already ASCII changes nothing.
    """
    if not value:
        return value
    quoted = value.startswith('"') and value.endswith('"')
    text = value[1:-1] if quoted else value
    text = decode_mutf7(text)
    return '"' + text + '"' if quoted else text


def canonical(line: str) -> str:
    """A reply with the lists whose order means nothing put in a fixed order."""
    text = line.strip()
    if not text.startswith("* "):
        return text
    body = text[2:]
    first, at = scan_key(body, 0)
    prefix = first
    name = first
    if first.isdigit():
        # A FETCH, an EXISTS and the rest of the numbered replies.
        name, at = scan_key(body, at + 1)
        prefix = first + " " + name
    rest = body[at:].strip()
    upper = name.upper()
    if upper == "FETCH" and rest.startswith("("):
        items, _ = pairs_of(rest, 1)
        return "* " + prefix + " " + sorted_items(items)
    if upper == "STATUS":
        # The mailbox name comes first, then the counts.
        mailbox, after = scan_value(rest, 0)
        counts = rest[after:].strip()
        if counts.startswith("("):
            items, _ = pairs_of(counts, 1)
            return (
                "* " + prefix + " " + decoded_name(mailbox) + " " + sorted_items(items)
            )
    if upper in ("LIST", "LSUB") and rest.startswith("("):
        items, after = values_in(rest, 1)
        flags = sorted(items, key=str.lower)
        tail = rest[after:].strip()
        delimiter, at = scan_value(tail, 0)
        mailbox, after_name = scan_value(tail, at)
        return (
            "* "
            + prefix
            + " ( "
            + " ".join(flags)
            + " ) "
            + delimiter
            + " "
            + decoded_name(mailbox)
            + tail[after_name:]
        )
    if upper == "ESEARCH":
        prologue = ""
        if rest.startswith("("):
            close = rest.index(")") + 1
            prologue = rest[:close]
            rest = rest[close:].strip()
        if rest.upper().startswith("UID"):
            prologue = (prologue + " UID").strip()
            rest = rest[3:].strip()
        items = []
        while rest:
            key, offset = scan_key(rest, 0)
            value, offset = scan_value(rest, offset)
            items.append((key, value.strip()))
            rest = rest[offset:].strip()
        ordered = sorted(items, key=lambda item: item[0].lower())
        pairs = " ".join(key + (" " + value if value else "") for key, value in ordered)
        return "* " + prefix + " " + prologue + " " + pairs
    return "* " + prefix + (" " + rest if rest else "")


def value_of(name: str) -> str:
    """What to put where a script writes `$name`, so the octets stay legal IMAP.

    The script's variables stand for whatever the server has: a mailbox name, a
    UID, the separator it chose. A reply with `$mailbox` in it is not something a
    server can send — `$` is not an atom character — so the octets carry a
    plausible value while the expectation keeps the placeholder, which is what
    the comparison then treats as "anything".
    """
    lowered = name.lower()
    if lowered in ("sep", "separator"):
        return "/"
    if lowered in ("root",):
        return '""'
    if lowered in ("mailbox", "inbox"):
        return "INBOX"
    if lowered.startswith("uid") or lowered.startswith("modseq") or lowered.startswith("hmodseq"):
        digits = re.sub(r"\D", "", name)
        return digits or "1"
    if lowered in ("size", "unseen", "messages", "count", "next"):
        return "1"
    if lowered.startswith("hdr") or lowered.startswith("full") or lowered.startswith("body"):
        return "x"
    if lowered == "tag" or lowered.endswith("tag"):
        # A tag travels quoted, and the parser reads it as a string.
        return '"1"'
    if lowered in ("user", "username"):
        return "tim"
    if lowered in ("domain",):
        return "example.com"
    if lowered in ("password", "pass"):
        return "secret"
    return "x"


VARIABLE = re.compile(r"\$(?:\{([^}]*)\}|([A-Za-z_][A-Za-z0-9_]*)|\$)")


def substituted(line: str) -> str:
    """The line with its placeholders given the values a server would send."""
    # `$$` is an escaped dollar, not a placeholder; it is held out of the way
    # while the rest of the line is substituted.
    held = line.replace("$$", "\x00")

    def replace(match: re.Match) -> str:
        if match.group(1) is not None:
            return value_of(match.group(1))
        if match.group(2) is not None:
            return value_of(match.group(2))
        return "x"

    return VARIABLE.sub(replace, held).replace("\x00", "$")


def replies(text: str) -> list[tuple[str, str]]:
    """Every expected server reply in one scripted test file."""
    out = []
    body = text.split("\n\n", 1)
    if len(body) < 2:
        return out
    lines = body[1].split("\n")
    index = 0
    while index < len(lines):
        line = lines[index]
        index += 1
        stripped = line.rstrip("\r")
        if not stripped or stripped.startswith("#") or stripped.startswith("!"):
            continue
        if not stripped.startswith("*"):
            continue
        # `$!` words are instructions to imaptest's own matcher — "this list is
        # unordered", "allow an extra item" — and not part of the reply.
        stripped = re.sub(r"\$![^\s)]*\s*", "", stripped).rstrip()
        expected, octets, index = present(stripped, lines, index)
        out.append((expected, octets))
    return out


def moonbit_string(text: str) -> str:
    """One line of MoonBit holding exactly these octets."""
    escaped = (
        text.replace("\\", "\\\\")
        .replace('"', '\\"')
        .replace("\r", "\\r")
        .replace("\n", "\\n")
        .replace("\t", "\\t")
    )
    return '"' + escaped + '"'


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", help="a checkout of imaptest to read instead")
    parser.add_argument("--check", action="store_true", help="fail if the file is not current")
    args = parser.parse_args()

    directory = source(args.source)
    files = sorted(
        path
        for path in directory.rglob("*")
        if path.is_file() and path.suffix != ".mbox" and not path.name.startswith(".")
    )
    vectors = []
    skipped = 0
    for path in files:
        for reply in replies(path.read_text(encoding="utf-8", errors="surrogateescape")):
            # A reply made of octets that are not text cannot be written down as
            # one; the couple that carry binary literals are counted and left
            # out rather than guessed at.
            try:
                reply[0].encode("utf-8")
                reply[1].encode("utf-8")
            except UnicodeEncodeError:
                skipped += 1
                continue
            vectors.append((path.relative_to(directory).as_posix(),) + reply)

    chunks = [vectors[i : i + CHUNK] for i in range(0, len(vectors), CHUNK)]
    out = [
        "// Copyright 2026 Leo Cheng",
        "// SPDX-License-Identifier: Apache-2.0",
        "",
        f"// Generated by scripts/gen_imap_vectors.py from imaptest {COMMIT[:12]}.",
        "// Do not edit.",
        "",
        "///|",
        "/// Every expected server reply in imaptest's scripted tests, as they go on",
        "/// the wire: the script a reply came from, and the octets a server sends.",
        "/// The three lists whose order means nothing are sorted, and a mailbox name",
        "/// is decoded from modified UTF-7 as the client decodes it, so that the",
        "/// client's rendering of what it parsed can be compared with the script as",
        "/// text.",
        "///",
        f"/// {len(vectors)} replies in all.",
    ]
    if skipped:
        subject = "1 reply is" if skipped == 1 else f"{skipped} replies are"
        out += [
            "///",
            f"/// {subject} not here: the octets are not text — a literal8 with a",
            "/// byte no character stands for — and a MoonBit string cannot hold",
            "/// them. src/imap/client_test.mbt replays that one as bytes.",
        ]
    out.append(
        "let imaptest_replies : Array[Array[(String, String, String)]] = ["
    )
    for chunk in chunks:
        out.append("  [")
        for name, expected, octets in chunk:
            out.append(
                f"    ({moonbit_string(name)}, {moonbit_string(expected)}, {moonbit_string(octets)}),"
            )
        out.append("  ],")
    out.append("]")
    out.append("")
    text = "\n".join(out)

    if args.check:
        current = OUT.read_text(encoding="utf-8") if OUT.exists() else ""
        if current != text:
            print(f"{OUT.relative_to(ROOT)} is not current; run the generator", file=sys.stderr)
            return 1
        print(f"{OUT.relative_to(ROOT)} is current: {len(vectors)} replies from {len(files)} files")
        return 0
    OUT.write_text(text, encoding="utf-8", newline="\n")
    print(f"wrote {OUT.relative_to(ROOT)}: {len(vectors)} replies from {len(files)} files")
    return 0


if __name__ == "__main__":
    sys.exit(main())
