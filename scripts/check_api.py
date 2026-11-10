#!/usr/bin/env python3
"""Check that docs/api.html lists every item the compiler exports.

`gen_api.py` writes the page from the `pkg.generated.mbti` files. This script
reads those same files by another route — no shared code, its own regexes — and
looks up every public name in the section the page gives that package. A
package, a type or a method the generator loses is a failure here, in CI,
rather than a gap a reader finds.

    python3 scripts/check_api.py

Exit code is 0 when the page carries every exported name and 1 when it does
not, one line per missing name.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "src"
PAGE = ROOT / "docs" / "api.html"

DECL = re.compile(
    r"^pub(?:\([^)]*\))?\s+(?:async\s+)?(struct|enum|suberror|trait|fn|let)\s+([A-Za-z0-9_:]+)",
    re.M,
)

# The page leaves the three methods `derive` writes for every type to the
# interface files; they are plumbing, not something to look up.
DERIVED = {"equal", "not_equal", "to_repr"}

SECTION = re.compile(r'<section class="pkg"')
COVER_PATH = re.compile(r'<span class="cover__path">([^<]+)</span>')
ALSO_PATH = re.compile(r'<h3 class="thread__more--path">([^<]+)</h3>')


def package_paths() -> dict[str, str]:
    """Each published package directory, as the API path the page prints."""
    found: dict[str, str] = {}
    for pkg in sorted(SRC.rglob("moon.pkg")):
        rel = pkg.parent.relative_to(SRC)
        if rel.parts and rel.parts[0] == "examples":
            continue
        suffix = "" if not rel.parts else "/" + rel.as_posix()
        found["." if not rel.parts else rel.as_posix()] = "moonmail" + suffix
    return found


def exported(directory: Path) -> tuple[list[str], list[str]]:
    """The names the compiler exports: types and loose values on one side, the
    members of a type on the other."""
    text = (directory / "pkg.generated.mbti").read_text(encoding="utf-8")
    names: list[str] = []
    members: list[str] = []
    for kind, name in DECL.findall(text):
        if kind in ("struct", "enum", "suberror", "trait"):
            names.append(name)
        elif kind == "let":
            names.append(name)
        elif "::" in name:
            member = name.split("::", 1)[1]
            if member not in DERIVED:
                members.append(name.split("::", 1)[0] + "::" + member)
        else:
            names.append(name)
    return names, members


def sections(page: str) -> dict[str, str]:
    """The page cut into packages, keyed by the path each card prints."""
    cuts = [m.start() for m in SECTION.finditer(page)]
    found: dict[str, str] = {}
    for index, start in enumerate(cuts):
        end = cuts[index + 1] if index + 1 < len(cuts) else len(page)
        body = page[start:end]
        for path in COVER_PATH.findall(body) + ALSO_PATH.findall(body):
            found[path] = body
    return found


def main() -> int:
    if not PAGE.is_file():
        print("error: docs/api.html is missing")
        return 1

    page = PAGE.read_text(encoding="utf-8")
    found = sections(page)
    problems: list[str] = []
    looked_up = 0

    for directory, path in sorted(package_paths().items()):
        body = found.get(path)
        if body is None:
            problems.append(f"{path} has no section on the page")
            continue
        names, members = exported(SRC / directory)
        for name in names:
            looked_up += 1
            # Every item is rendered with its own name in bold, which is what
            # the generator's markup promises; a name that only turns up in
            # prose or in another signature does not count.
            if f"<b>{name}</b>" not in body:
                problems.append(f"{path}: {name} is not on the page")
        for item in members:
            looked_up += 1
            if f"<b>{item}</b>" not in body:
                problems.append(f"{path}: {item} is not on the page")

    if problems:
        for line in problems:
            print(f"error: {line}")
        return 1

    print(f"ok: {len(found)} sections, {looked_up} exported names on the page")
    return 0


if __name__ == "__main__":
    sys.exit(main())
