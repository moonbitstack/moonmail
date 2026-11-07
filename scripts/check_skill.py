#!/usr/bin/env python3
# Copyright 2026 Leo Cheng
# SPDX-License-Identifier: Apache-2.0
"""Check the code an agent is handed: every MoonBit block in
docs/skills/<name>/SKILL.md has to compile in an empty project that depends on
the published module and nothing else.

    python3 scripts/check_skill.py [name]

Exit code 0 when the blocks compile, 1 when they do not, and 2 when the version
in moon.mod is not on the registry yet — the check belongs to a release, and a
pull request that has not been published cannot be held to it.
"""

from __future__ import annotations

import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
MODULE = "moonbitstack/moonmail"

# The packages a block may name: the module itself and the subpackages that
# carry the protocols.
IMPORTS = (
    MODULE,
    MODULE + "/dkim",
    MODULE + "/imap",
    MODULE + "/jmap",
    MODULE + "/sasl",
    MODULE + "/net",
)


def version() -> str:
    for line in (ROOT / "moon.mod").read_text(encoding="utf-8").splitlines():
        if line.startswith("version"):
            return line.split("=", 1)[1].strip().strip('"')
    raise SystemExit("moon.mod has no version")


def blocks(skill: Path) -> list[str]:
    """Every MoonBit block, the ones that only build for native included: a
    block marked `moonbit native` names `@net`, and is compiled here with the
    native target rather than left out."""
    text = skill.read_text(encoding="utf-8")
    return re.findall(r"```moonbit(?: native)?\n(.*?)```", text, re.S)


def main() -> int:
    name = sys.argv[1] if len(sys.argv) > 1 else "moonmail"
    skill = ROOT / "docs" / "skills" / name / "SKILL.md"
    if not skill.is_file():
        print(f"error: {skill} is missing")
        return 1
    found = blocks(skill)
    if not found:
        print(f"error: {skill} has no MoonBit block to check")
        return 1

    scratch = Path(tempfile.mkdtemp(prefix="moonmail-skill-"))
    try:
        (scratch / "moon.mod").write_text(
            f'name = "moonmail/check"\nversion = "0.0.1"\n'
            f'import {{\n  "{MODULE}@{version()}",\n}}\n',
            encoding="utf-8",
        )
        (scratch / "moon.pkg").write_text(
            "import {\n" + "".join(f'  "{i}",\n' for i in IMPORTS) + "}\n",
            encoding="utf-8",
        )
        (scratch / "snippet.mbt").write_text("\n".join(found), encoding="utf-8")

        added = subprocess.run(
            ["moon", "add", f"{MODULE}@{version()}"],
            cwd=scratch,
            capture_output=True,
            text=True,
        )
        if added.returncode != 0:
            print(f"{MODULE}@{version()} is not on the registry yet; the skill is checked when it is released")
            return 2
        checked = subprocess.run(
            ["moon", "check", "--target", "native", "--deny-warn"],
            cwd=scratch,
            capture_output=True,
            text=True,
        )
        if checked.returncode != 0:
            print(checked.stdout)
            print(checked.stderr, file=sys.stderr)
            print(f"error: the blocks in {skill} do not compile against {MODULE}@{version()}")
            return 1
        print(f"ok: {len(found)} blocks in {skill.name} compile against {MODULE}@{version()}")
        return 0
    finally:
        shutil.rmtree(scratch, ignore_errors=True)


if __name__ == "__main__":
    sys.exit(main())
