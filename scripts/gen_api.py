#!/usr/bin/env python3
"""Generate docs/api.html from the published package interfaces, and put the
counts the pages state where the pages state them.

Every package in the module carries a `pkg.generated.mbti` written by
`moon info`. This script reads those files — nothing else — and fills the
catalogue template with one card per package and one slip per item, so the
reference cannot drift from what the compiler exports.

    python3 scripts/gen_api.py

The output is deterministic: running it twice produces the same bytes, which
is what the docs workflow checks with `git diff --exit-code docs/`.
"""

from __future__ import annotations

import html
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TEMPLATE = ROOT / "scripts" / "api_template.html"
OUT = ROOT / "docs" / "api.html"

# The order is the reading order: the message, then the things you do to it,
# then the protocols, then the wire.
PACKAGES = [
    {
        "dir": "src",
        "anchor": "root",
        "kind": "model",
        "path": "moonmail",
        "title": "The message itself",
        "photo": "rainforest",
        "alt": "Lush green rainforest leaves in sunlight",
        "tilt": "-.7deg",
        "blurb": "Addresses, ordered headers, a tree of parts, and a builder that "
                 "picks the right nesting for you.",
        "specs": ["RFC 5322", "RFC 2045", "RFC 6532"],
    },
    {
        "dir": "src/dkim",
        "anchor": "dkim",
        "kind": "signing",
        "path": "moonmail/dkim",
        "title": "Sign it, then check the claim",
        "photo": "autumn",
        "alt": "An orange autumn forest with a soft path",
        "tilt": ".6deg",
        "blurb": "One signature over the headers you name and the body you hash, "
                 "and a verdict for every signature a letter carries.",
        "specs": ["RFC 6376", "RFC 8463"],
    },
    {
        "dir": "src/sasl",
        "anchor": "sasl",
        "kind": "auth",
        "path": "moonmail/sasl",
        "title": "Mechanisms, as a trait",
        "photo": "desert",
        "alt": "Golden desert dunes under a pale sky",
        "tilt": "-.5deg",
        "blurb": "Six mechanisms behind one trait, so a mechanism written once "
                 "works on all three protocols.",
        "specs": ["RFC 4616", "RFC 7677", "RFC 7628"],
    },
    {
        "dir": "src/smtp",
        "anchor": "smtp",
        "kind": "protocol",
        "path": "moonmail/smtp",
        "title": "Both ends of the relay",
        "photo": "river",
        "alt": "A turquoise river winding through forested hills",
        "tilt": ".55deg",
        "blurb": "A client that paces commands by the extensions a server "
                 "announced, and a server that answers the protocol itself.",
        "specs": ["RFC 5321", "RFC 1870", "RFC 3207", "RFC 4954"],
    },
    {
        "dir": "src/imap",
        "anchor": "imap",
        "kind": "protocol",
        "path": "moonmail/imap",
        "title": "Stay in the mailbox",
        "photo": "lake",
        "alt": "A clear turquoise lake ringed by pines",
        "tilt": "-.6deg",
        "blurb": "IMAP4rev2 with IDLE and CONDSTORE. Every command gets a tag and "
                 "every response comes back decoded.",
        "specs": ["RFC 9051", "RFC 2177", "RFC 7162"],
    },
    {
        "dir": "src/pop3",
        "anchor": "pop3",
        "kind": "protocol",
        "path": "moonmail/pop3",
        "title": "Pick up and go",
        "photo": "bamboo",
        "alt": "A bright green bamboo grove",
        "tilt": ".5deg",
        "blurb": "The small one: a greeting, a login, a list, and the messages "
                 "themselves.",
        "specs": ["RFC 1939", "RFC 2449"],
    },
    {
        "dir": "src/jmap",
        "anchor": "jmap",
        "kind": "protocol",
        "path": "moonmail/jmap",
        "title": "The protocol that fits in a page",
        "photo": "meadow",
        "alt": "A green meadow under soft light",
        "tilt": ".3deg",
        "blurb": "JMAP as documents: twenty-seven methods and the objects they "
                 "carry, described once in moonmodel, and the check that a "
                 "document is what it claims to be. No socket, which is how a "
                 "browser can speak it.",
        "specs": ["RFC 8620", "RFC 8621", "no I/O"],
        "also": [
            ("moonmail/jmap/validate", "src/jmap/validate",
             "The descriptions turned into JSON Schema and run against a document."),
        ],
    },
    {
        "dir": "src/net",
        "anchor": "net",
        "kind": "wire",
        "path": "moonmail/net",
        "title": "The one that touches a socket",
        "photo": "coast",
        "alt": "Clear blue sea and sky",
        "tilt": "-.45deg",
        "blurb": "The same state machines over TCP and TLS, including the upgrade "
                 "to STARTTLS mid-conversation.",
        "specs": ["TCP", "TLS", "native only"],
    },
]

TILTS = ["-.22deg", ".18deg", "-.16deg", ".24deg", "-.2deg", ".14deg"]

# Derive emits these for every type; they are plumbing, not API.
DERIVED = {"equal", "not_equal", "to_repr"}

DECL = re.compile(
    r"^pub(?:\([^)]*\))?\s+(?:(async)\s+)?(fn|let|struct|enum|suberror|trait|type|impl)\b"
)


def esc(text: str) -> str:
    return html.escape(text, quote=False)


def types_to_tags(text: str) -> str:
    """Colour capitalised identifiers, leaving `Qualifier::member` alone."""
    return re.sub(r"\b([A-Z][A-Za-z0-9_]*)\b(?!::)", r"<i>\1</i>", text)


def head_and_rest(text: str) -> tuple[str, str]:
    """Split `Pass(domain~ : String)` into the name and what follows."""
    m = re.match(r"^([A-Za-z_][A-Za-z0-9_]*)(.*)$", text, re.S)
    if not m:
        return "", text
    return m.group(1), m.group(2)


def colour_member(text: str) -> str:
    name, rest = head_and_rest(text)
    if not name:
        return types_to_tags(esc(text))
    return f"<b>{esc(name)}</b>{types_to_tags(esc(rest))}"


def colour_fn(text: str, fn_name: str) -> str:
    """`fn Mailbox::new(String, name? : String) -> Self`, minus the `pub`."""
    body = text[4:] if text.startswith("pub ") else text
    keyword = ""
    if body.startswith("async "):
        keyword += "async "
        body = body[len("async "):]
    if body.startswith("fn "):
        keyword += "fn"
        body = body[len("fn "):]
    esc_body = types_to_tags(esc(body))
    # the qualifier before :: is skipped by the lookahead, the member is lower case
    esc_body = esc_body.replace(esc(fn_name), f"<b>{esc(fn_name)}</b>", 1)
    if keyword:
        return f'<span class="k">{keyword}</span> {esc_body}'
    return esc_body


class Item:
    def __init__(self, kind: str, block: list[str]):
        self.kind = kind
        self.block = block
        self.methods: list[str] = []
        self.impls: list[str] = []
        self.name = self._name()

    def _name(self) -> str:
        head = self.block[0]
        if self.kind == "fn":
            m = re.search(r"\bfn\s+([A-Za-z0-9_:]+)", head)
            return m.group(1) if m else ""
        if self.kind == "let":
            m = re.search(r"\blet\s+([A-Za-z0-9_]+)", head)
            return m.group(1) if m else ""
        m = re.search(r"\b(?:struct|enum|suberror|trait)\s+([A-Za-z0-9_]+)", head)
        return m.group(1) if m else ""

    @property
    def owner(self) -> str:
        return self.name.split("::")[0]

    def members(self) -> list[str]:
        """Fields, variants or trait methods, one per line."""
        if self.kind not in ("struct", "enum", "suberror", "trait"):
            return []
        out: list[str] = []
        body = "\n".join(self.block)
        inner = body[body.find("{") + 1: body.rfind("}")] if "{" in body else ""
        for raw in inner.splitlines():
            line = raw.strip()
            if not line or line.startswith("//"):
                if line.startswith("// private"):
                    out.append("// private fields")
                continue
            out.append(line)
        return out

    def signature(self) -> str:
        """The first line, with a `{` body collapsed to its head."""
        head = self.block[0].strip()
        for marker in ("{",):
            if marker in head:
                head = head[: head.find(marker)].strip()
        return head


def parse(text: str) -> list[Item]:
    lines = text.splitlines()
    items: list[Item] = []
    i, n = 0, len(lines)
    while i < n:
        line = lines[i]
        m = DECL.match(line)
        if not m:
            i += 1
            continue
        kind = m.group(2)
        depth = line.count("{") - line.count("}")
        block = [line]
        i += 1
        while depth > 0 and i < n:
            block.append(lines[i])
            depth += lines[i].count("{") - lines[i].count("}")
            i += 1
        items.append(Item(kind, block))
    return items


def collect(dir_path: Path) -> list[Item]:
    raw = parse((dir_path / "pkg.generated.mbti").read_text(encoding="utf-8"))
    types: dict[str, Item] = {}
    loose: list[Item] = []
    for item in raw:
        if item.kind == "impl":
            m = re.search(r"\bimpl\s+([A-Za-z0-9_]+)\s+for\s+([A-Za-z0-9_]+)", item.block[0])
            if m and m.group(2) in types:
                types[m.group(2)].impls.append(m.group(1))
            continue
        if item.kind == "fn" and "::" in item.name:
            member = item.name.split("::", 1)[1]
            if member in DERIVED:
                continue
            owner = types.get(item.owner)
            if owner is not None:
                owner.methods.append(item.block[0].strip())
            continue
        if item.kind in ("struct", "enum", "suberror", "trait"):
            types[item.name] = item
        else:
            loose.append(item)
    # an impl may appear before its type; second pass picks those up
    for item in raw:
        if item.kind == "impl":
            m = re.search(r"\bimpl\s+([A-Za-z0-9_]+)\s+for\s+([A-Za-z0-9_]+)", item.block[0])
            if m and m.group(2) in types and m.group(1) not in types[m.group(2)].impls:
                types[m.group(2)].impls.append(m.group(1))
    # reading order: functions and values, then the data, then the trait that
    # ties them together, then the errors last.
    rank = {"fn": 0, "let": 0, "struct": 1, "enum": 1, "trait": 2, "suberror": 3}
    return sorted(list(types.values()) + loose, key=lambda it: rank.get(it.kind, 4))


KIND_LABEL = {
    "struct": ("struct", "kind--type"),
    "enum": ("enum", "kind--type"),
    "suberror": ("suberror", "kind--type"),
    "trait": ("trait", "kind--trait"),
    "fn": ("fn", "kind--fn"),
    "let": ("value", "kind--fn"),
}


def render_slip(item: Item, index: int) -> str:
    label, cls = KIND_LABEL[item.kind]
    parts: list[str] = [
        f'          <article class="slip" style="--r:{TILTS[index % len(TILTS)]}">',
        f'            <span class="slip__kind {cls}">{label}</span>',
    ]

    if item.kind in ("struct", "enum", "suberror", "trait"):
        head = f'<span class="k">{item.kind}</span> <b>{esc(item.name)}</b>'
        members = item.members()
        if members and all(not m.startswith("//") for m in members):
            if items_inline(members):
                head += " { " + "; ".join(colour_member(m) for m in members) + " }"
                parts.append(f'            <code class="sig">{head}</code>')
            else:
                parts.append(f'            <code class="sig">{head}</code>')
                parts.append('            <ul class="rows rows--one">')
                for m in members:
                    parts.append(f"              <li><code>{colour_member(m)}</code></li>")
                parts.append("            </ul>")
        else:
            if members:
                head += ' <span class="k">// private fields</span>'
            parts.append(f'            <code class="sig">{head}</code>')
        for impl in item.impls:
            parts.append(f'            <code class="sig"><span class="k">impl</span> '
                         f'<b>{esc(impl)}</b> <span class="k">for</span> '
                         f'<i>{esc(item.name)}</i></code>')
        for method in item.methods:
            parts.append(f'            <code class="sig">{colour_fn(method, item.name + "::" + method.split("::")[1].split("(")[0])}</code>')
    else:
        sig = item.signature()
        parts.append(f'            <code class="sig">{colour_fn(sig, item.name)}</code>')

    parts.append("          </article>")
    return "\n".join(parts)


def items_inline(members: list[str]) -> bool:
    """Short declarations read better on one line; long ones get rows."""
    joined = "; ".join(members)
    return len(members) <= 3 and len(joined) <= 70


def render_also(path: str, blurb: str, items: list[Item]) -> str:
    """A second package under the same card: its own heading, its own entries.

    `moonmail/jmap` and `moonmail/jmap/validate` are one subject — the objects and
    the check that a document is one — so they share a cover and a rail entry
    rather than taking two of each.
    """
    slips = "\n".join(render_slip(item, i) for i, item in enumerate(items))
    return (
        f'        <div class="thread__more">\n'
        f'          <h3 class="thread__more--path">{esc(path)}</h3>\n'
        f'          <p class="thread__more--blurb">{esc(blurb)}</p>\n'
        f'        </div>\n{slips}'
    )


def render_package(pkg: dict, items: list[Item], number: int) -> tuple[str, str]:
    anchor = pkg["anchor"]
    chips = "".join(
        f'\n              <span class="chip chip--spec">{esc(s)}</span>' for s in pkg["specs"]
    )
    slips = "\n".join(render_slip(item, i) for i, item in enumerate(items))
    for path, directory, blurb in pkg.get("also", []):
        extra = collect(ROOT / directory)
        slips = slips + "\n" + render_also(path, blurb, extra)

    block = f"""      <section class="pkg" id="{anchor}" data-pkg="{anchor}">
        <div class="pkg__wire" aria-hidden="true"></div>
        <figure class="cover" style="--r:{pkg['tilt']}">
          <div class="cover__photo">
            <img src="images/{pkg['photo']}.jpg" alt="{esc(pkg['alt'])}">
            <span class="cover__no">{number:02d}</span>
            <span class="cover__tape" aria-hidden="true"></span>
          </div>
          <figcaption class="cover__text">
            <span class="cover__path">{pkg['path']}</span>
            <h2 class="cover__name">{esc(pkg['title'])}</h2>
            <p class="cover__desc">{esc(pkg['blurb'])}</p>
            <div class="cover__foot">{chips}
              <span class="chip chip--count">{len(items)} entries</span>
            </div>
          </figcaption>
        </figure>

        <div class="thread">
{slips}
        </div>
      </section>"""

    tag = (
        f'        <li class="rail__item"><a class="rail__tag" href="#{anchor}" '
        f'style="--tilt:{pkg["tilt"]}"><span class="rail__no">{number:02d}</span>'
        f'<span class="rail__name">{anchor if anchor != "root" else pkg["path"]}</span>'
        f'<span class="rail__count">{len(items)}</span></a></li>'
    )
    return block, tag


# ---------------------------------------------------------------------------
# The numbers the pages state
#
# A count that a reader sees is read out of the repository here and never typed
# into the markup: the packages from the directories that carry a `moon.pkg`,
# the mechanisms from the SASL interface, the guide's steps from its own
# sections, the version from `moon.mod`. A page keeps a placeholder — a
# `data-value` where a numeral belongs, a `data-word` where running prose wants
# the number spelled out — and this script fills it. The docs workflow reruns
# the script and fails on a diff, so a count that drifts is a red build rather
# than a page that quietly lies.
# ---------------------------------------------------------------------------

SRC = ROOT / "src"
GUIDE = ROOT / "docs" / "guide.html"

VALUE = re.compile(r'(<[a-z]+ data-value="([a-z]+)">)[^<]*(</[a-z]+>)')
WORD = re.compile(r'(<[a-z]+ data-word="([a-z]+)">)[^<]*(</[a-z]+>)')

SPELLED = (
    "zero", "one", "two", "three", "four", "five", "six", "seven", "eight",
    "nine", "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen",
    "sixteen", "seventeen", "eighteen", "nineteen", "twenty",
)

# One step is one section of the guide. Its short name for the contents rail is
# written beside it, so the rail is rebuilt from the sections themselves and can
# no longer lose one or keep a stale number.
STEP = re.compile(r'<section class="step" id="([^"]+)" data-rail="([^"]+)">')
ANY_STEP = re.compile(r'<section class="step"')
STEP_NO = re.compile(r'(<span class="step__no">)\d+(</span>)')
STEP_MARK = re.compile(r"<!-- \d\d -->")
RAIL = re.compile(r'(<ul class="rail__list">)(.*?)(</ul>)', re.S)
RAIL_TILTS = ["-.9deg", ".7deg", "-.5deg", ".9deg", "-.7deg", ".6deg",
              "-.8deg", ".5deg", "-.6deg", ".8deg"]

# A mechanism is a type the SASL package implements its own trait for.
MECHANISM = re.compile(r"^pub impl Mechanism for ([A-Za-z0-9_]+)$", re.M)


def spell(count: int) -> str:
    """The count as a word, for the places where a numeral would shout."""
    return SPELLED[count] if 0 <= count < len(SPELLED) else str(count)


def fill_numbers(text: str, values: dict[str, str]) -> tuple[str, int]:
    """Fill every placeholder. A key nothing computes is a bug in the page, so
    it stops the run instead of leaving the markup as it was."""
    filled = 0

    def value(m: re.Match[str]) -> str:
        nonlocal filled
        key = m.group(2)
        if key not in values:
            raise SystemExit(f"nothing computes data-value={key!r}")
        filled += 1
        return f"{m.group(1)}{values[key]}{m.group(3)}"

    def word(m: re.Match[str]) -> str:
        nonlocal filled
        key = m.group(2)
        if not values.get(key, "").isdigit():
            raise SystemExit(f"no count is computed for data-word={key!r}")
        filled += 1
        return f"{m.group(1)}{spell(int(values[key]))}{m.group(3)}"

    return WORD.sub(word, VALUE.sub(value, text)), filled


def module_packages() -> list[str]:
    """Every package the module publishes: one per directory under src/ that
    carries a moon.pkg. The example programs are not part of the library."""
    found: list[str] = []
    for pkg in sorted(SRC.rglob("moon.pkg")):
        rel = pkg.parent.relative_to(SRC)
        if rel.parts and rel.parts[0] == "examples":
            continue
        found.append("." if not rel.parts else rel.as_posix())
    return found


def mechanisms() -> int:
    """How many mechanisms a caller can build."""
    mbti = (SRC / "sasl" / "pkg.generated.mbti").read_text(encoding="utf-8")
    return len(MECHANISM.findall(mbti))


def version_of_module() -> str:
    """The version a reader writes in a manifest, from the module file."""
    mod = ROOT / "moon.mod"
    m = re.search(r'version\s*=\s*"([^"]+)"', mod.read_text(encoding="utf-8")) if mod.exists() else None
    if not m:
        raise SystemExit("moon.mod has no version")
    return m.group(1)


def card_directory(path: str) -> str:
    """`src/jmap/validate` as the package list spells it: `jmap/validate`."""
    return path.removeprefix("src").lstrip("/") or "."


def check_cards(packages: list[str]) -> None:
    """A package with no card would be missing from the reference, and a card
    for a package that is gone would hang an empty thread; both stop the run."""
    carded = {card_directory(pkg["dir"]) for pkg in PACKAGES}
    for pkg in PACKAGES:
        for _, directory, _ in pkg.get("also", []):
            carded.add(card_directory(directory))
    missing = sorted(set(packages) - carded)
    extra = sorted(carded - set(packages))
    if missing:
        raise SystemExit("no card in PACKAGES for: " + ", ".join(missing))
    if extra:
        raise SystemExit("PACKAGES names a package that is gone: " + ", ".join(extra))


def guide_steps() -> list[tuple[str, str]]:
    """The guide's steps, in the order they are read. A section without its rail
    name would drop out of both the count and the rail, so it stops the run."""
    text = GUIDE.read_text(encoding="utf-8")
    found = STEP.findall(text)
    if not found:
        raise SystemExit("docs/guide.html has no step section")
    if len(found) != len(ANY_STEP.findall(text)):
        raise SystemExit("a step section in docs/guide.html has no data-rail")
    return found


def number_the_guide(text: str, steps: list[tuple[str, str]]) -> str:
    """Renumber the steps, the captions above them and the contents rail, so
    that inserting a step in the middle moves every number by itself."""
    found = list(STEP.finditer(text))
    out: list[str] = []
    cut = 0
    for index, match in enumerate(found, start=1):
        end = found[index].start() if index < len(found) else len(text)
        out.append(STEP_MARK.sub(f"<!-- {index:02d} -->", text[cut:match.start()]))
        body = STEP_NO.sub(
            lambda m, n=index: f"{m.group(1)}{n:02d}{m.group(2)}",
            text[match.start():end],
            count=1,
        )
        out.append(body)
        cut = end
    out.append(text[cut:])
    text = "".join(out)

    items = "\n".join(
        f'        <li class="rail__item"><a class="rail__tag" href="#{anchor}"'
        f' style="--tilt:{RAIL_TILTS[(n - 1) % len(RAIL_TILTS)]}">'
        f'<span class="rail__no">{n:02d}</span>'
        f'<span class="rail__name">{esc(name)}</span></a></li>'
        for n, (anchor, name) in enumerate(steps, start=1)
    )
    filled, count = RAIL.subn(lambda m: f"{m.group(1)}\n{items}\n      {m.group(3)}", text, count=1)
    if not count:
        raise SystemExit("docs/guide.html has no rail list to fill")
    return filled


def main() -> int:
    template = TEMPLATE.read_text(encoding="utf-8")
    blocks: list[str] = []
    tags: list[str] = []
    counted = 0

    packages = module_packages()
    check_cards(packages)
    steps = guide_steps()

    for number, pkg in enumerate(PACKAGES, start=1):
        items = collect(ROOT / pkg["dir"])
        for _, directory, _ in pkg.get("also", []):
            items = items + collect(ROOT / directory)
        counted += len(items)
        block, tag = render_package(pkg, items, number)
        blocks.append(block)
        tags.append(tag)

    values = {
        "packages": str(len(packages)),
        "protocols": str(sum(1 for pkg in PACKAGES if pkg["kind"] == "protocol")),
        "sasl": str(mechanisms()),
        "steps": str(len(steps)),
        "version": version_of_module(),
    }

    page = (
        template.replace("<!--RAIL-->", "\n" + "\n".join(tags) + "\n      ")
        .replace("<!--MAIN-->", "\n" + "\n\n".join(blocks) + "\n    ")
    )
    page, _ = fill_numbers(page, values)
    OUT.write_text(page, encoding="utf-8", newline="\n")

    filled = 0
    for path in sorted((ROOT / "docs").glob("*.html")):
        text = path.read_text(encoding="utf-8")
        if path == GUIDE:
            text = number_the_guide(text, steps)
        text, count = fill_numbers(text, values)
        if text != path.read_text(encoding="utf-8"):
            path.write_text(text, encoding="utf-8", newline="\n")
        filled += count

    print(f"{OUT.relative_to(ROOT)}: {len(packages)} packages, {counted} slips")
    print(" ".join(f"{key} {value}" for key, value in values.items()))
    print(f"{filled} counts on the pages")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
