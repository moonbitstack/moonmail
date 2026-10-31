#!/usr/bin/env bash
# Build the writing desk's engine and put it where the page imports it.
#
# The desk calls moonmail from the browser through one function, `engine_call`,
# which takes a JSON document and answers one. The module is the library
# compiled for JavaScript — the same source that runs natively, so the page is
# not a mock of moonmail but moonmail.
#
#     scripts/build_engine.sh
#
# The build needs no network and no browser: `moon build` and a copy. The
# module is never committed; the docs workflow builds it before it deploys.
set -euo pipefail

cd "$(dirname "$0")/.."

moon build --target js --release --package moonbitstack/moonmail/examples/browser

engine="_build/js/release/build/examples/browser/browser.js"
test -f "$engine" || { echo "no engine at $engine" >&2; exit 1; }

mkdir -p docs/engine
cp "$engine" docs/engine/moonmail.js
printf 'docs/engine/moonmail.js: %s bytes\n' "$(wc -c < docs/engine/moonmail.js)"
