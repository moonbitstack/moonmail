#!/usr/bin/env python3
# Copyright 2026 Leo Cheng
# SPDX-License-Identifier: Apache-2.0
"""Write the mbox imaptest appends from: `count` messages, each with its own
Message-ID, so a stress run can track every message it has put in a mailbox.

    python3 scripts/interop/write_mbox.py <path> [count]
"""

import pathlib
import sys

SUBJECTS = [
    "the first letter",
    "a second look",
    "on the post office",
    "notes from the road",
    "a longer subject line that goes on for a while so it has to be folded in a header",
    "reply to the reply",
    "moonlight",
    "a letter with an attachment named later",
    "the desk by the window",
    "one more",
]


def message(index: int) -> str:
    subject = SUBJECTS[index % len(SUBJECTS)]
    stamp = f"Mon, {1 + index % 28:02d} Nov 2026 09:{index % 60:02d}:00 +0000"
    body = "\n".join(
        f"Line {line} of message {index}: the quick brown fox jumps over the lazy dog."
        for line in range(1, 6 + index % 7)
    )
    return (
        f"From: Post <post@example.com>\n"
        f"To: Mail Test <mailtest@moonmail.test>\n"
        f"Subject: {subject} {index}\n"
        f"Date: {stamp}\n"
        f"Message-ID: <imaptest.{index}@example.com>\n"
        f"MIME-Version: 1.0\n"
        f"Content-Type: text/plain; charset=utf-8\n"
        f"\n"
        f"{body}\n"
    )


def main() -> None:
    path = pathlib.Path(sys.argv[1])
    count = int(sys.argv[2]) if len(sys.argv) > 2 else 20
    lines = []
    for index in range(count):
        lines.append(f"From post@example.com Mon Nov  2 09:00:{index % 60:02d} 2026\n")
        lines.append(message(index))
        lines.append("\n")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("".join(lines), encoding="utf-8", newline="\n")
    print(f"wrote {count} messages to {path}", file=sys.stderr)


if __name__ == "__main__":
    main()
