#!/usr/bin/env bash
# One-shot cut-a-release: validate, bump version, push branch + tag.
#
# Usage:
#   scripts/release.sh <new-version>   # e.g. 0.4.0
#   scripts/release.sh patch | minor | major
#
# Equivalent to:
#   scripts/validate-manifest.sh
#   scripts/bump-version.sh <arg>
#   scripts/push.sh
set -euo pipefail

cd "$(dirname "$0")/.."

arg="${1:-}"
[ -n "$arg" ] || { echo "usage: $(basename "$0") <version|major|minor|patch>" >&2; exit 1; }

echo "--- validate"
./scripts/validate-manifest.sh

echo "--- bump"
./scripts/bump-version.sh "$arg"

echo "--- push"
./scripts/push.sh

echo
echo "released. Users will see the new commit + version after Cowork refreshes the marketplace."
echo "tip: run workroom-info in-session to confirm what's loaded."
