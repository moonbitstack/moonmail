#!/usr/bin/env python3
"""Generate docs/api.html from the published package interfaces.

Every package in the module carries a `pkg.generated.mbti` written by
`moon info`. This script reads those files — nothing else — and fills the
catalogue template with one card per package and one slip per item, so the
reference cannot drift from what the compiler exports.

    python3 scripts/gen_api.py

The output is deterministic: running it twice produces the same bytes, which
is what the docs workflow checks with `git diff --exit-code docs/api.html`.
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
        "path": "moonmail/jmap",
        "title": "The protocol that fits in a page",
        "photo": "meadow",
        "alt": "A green meadow under soft light",
        "tilt": ".3deg",
        "blurb": "JMAP as documents: the session, the request envelope, the "
                 "answers. No socket, which is how a browser can speak it.",
        "specs": ["RFC 8620", "RFC 8621", "no I/O"],
    },
    {
        "dir": "src/net",
        "anchor": "net",
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


def render_package(pkg: dict, items: list[Item], number: int) -> tuple[str, str]:
    anchor = pkg["anchor"]
    chips = "".join(
        f'\n              <span class="chip chip--spec">{esc(s)}</span>' for s in pkg["specs"]
    )
    slips = "\n".join(render_slip(item, i) for i, item in enumerate(items))

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


def main() -> int:
    template = TEMPLATE.read_text(encoding="utf-8")
    blocks: list[str] = []
    tags: list[str] = []
    counted = 0

    for number, pkg in enumerate(PACKAGES, start=1):
        items = collect(ROOT / pkg["dir"])
        counted += len(items)
        block, tag = render_package(pkg, items, number)
        blocks.append(block)
        tags.append(tag)

    version = "0.1.0"
    mod = ROOT / "moon.mod"
    if mod.exists():
        m = re.search(r'version\s*=\s*"([^"]+)"', mod.read_text(encoding="utf-8"))
        if m:
            version = m.group(1)

    page = (
        template.replace("<!--RAIL-->", "\n" + "\n".join(tags) + "\n      ")
        .replace("<!--MAIN-->", "\n" + "\n\n".join(blocks) + "\n    ")
        .replace("<!--N_PKG-->", str(len(PACKAGES)))
        .replace("<!--N_PROTO-->", "3")
        .replace("<!--N_SASL-->", "6")
        .replace("<!--VERSION-->", version)
    )
    OUT.write_text(page, encoding="utf-8", newline="\n")
    print(f"{OUT.relative_to(ROOT)}: {len(PACKAGES)} packages, {counted} slips")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
