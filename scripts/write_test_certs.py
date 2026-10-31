#!/usr/bin/env python3
# Copyright 2026 Leo Cheng
# SPDX-License-Identifier: Apache-2.0
"""Write the test certificate and key of src/net/certs_test.mbt as cert.pem
and key.pem into a directory, for a mail server the net tests talk to.

    python3 scripts/write_test_certs.py <directory>
"""

import pathlib
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
SOURCE = ROOT / "src" / "net" / "certs_test.mbt"


def blocks():
    out = {}
    name = None
    for line in SOURCE.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if line.startswith("let ") and line.endswith("String ="):
            name = line.split()[1]
            out[name] = []
        elif line.startswith("#|") and name:
            out[name].append(line[2:])
    return out


def main():
    target = pathlib.Path(sys.argv[1])
    target.mkdir(parents=True, exist_ok=True)
    found = blocks()
    for name in ("cert", "key"):
        (target / f"{name}.pem").write_text("\n".join(found[name]) + "\n", encoding="ascii", newline="\n")
    print(f"wrote cert.pem and key.pem to {target}", file=sys.stderr)


if __name__ == "__main__":
    main()
