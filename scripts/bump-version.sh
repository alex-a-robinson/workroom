#!/usr/bin/env bash
# Atomically bump the plugin version, rotate the [Unreleased] CHANGELOG entries
# into a new dated release section, commit the result, and tag it. Does NOT
# push — run scripts/release.sh for the full cut-release flow, or scripts/push.sh
# to ship the commit + tag.
#
# Usage:
#   scripts/bump-version.sh <new-version>      # e.g. 0.4.0
#   scripts/bump-version.sh patch              # 0.3.0 -> 0.3.1
#   scripts/bump-version.sh minor              # 0.3.0 -> 0.4.0
#   scripts/bump-version.sh major              # 0.3.0 -> 1.0.0
#
# Files touched:
#   - .claude-plugin/marketplace.json  (plugins[0].version — single source of truth)
#   - CHANGELOG.md                     (Unreleased -> new release block)
#
# Why only marketplace.json? For relative-path plugin sources ("./plugin"),
# Anthropic's docs say: "For relative-path plugins, set the version in the
# marketplace entry. The plugin manifest always wins silently, which can cause
# the marketplace version to be ignored." Keeping version only in
# marketplace.json avoids the silent-shadowing trap. plugin.json has no version
# field — by design.
#
# Exits non-zero if:
#   - plugin.json has a version field (publishing hazard — see above)
#   - the CHANGELOG [Unreleased] section is empty
#   - the working tree has unstaged changes to files we're about to touch
#   - the target tag already exists
set -euo pipefail

cd "$(dirname "$0")/.."

PLUGIN_MANIFEST="plugin/.claude-plugin/plugin.json"
MARKETPLACE_MANIFEST=".claude-plugin/marketplace.json"
CHANGELOG="CHANGELOG.md"

die() { echo "error: $*" >&2; exit 1; }

command -v jq >/dev/null 2>&1 || die "jq is required (brew install jq)"

[ -f "$PLUGIN_MANIFEST" ]      || die "missing $PLUGIN_MANIFEST"
[ -f "$MARKETPLACE_MANIFEST" ] || die "missing $MARKETPLACE_MANIFEST"
[ -f "$CHANGELOG" ]            || die "missing $CHANGELOG"

# Hazard: plugin.json must NOT have a version field for relative-path plugins.
if jq -e 'has("version")' "$PLUGIN_MANIFEST" >/dev/null; then
  die "$PLUGIN_MANIFEST has a 'version' field — remove it. For relative-path plugins, version lives only in $MARKETPLACE_MANIFEST. Having it in both silently shadows the marketplace value."
fi

current=$(jq -r '.plugins[0].version' "$MARKETPLACE_MANIFEST")
[ -n "$current" ] && [ "$current" != "null" ] || die "$MARKETPLACE_MANIFEST plugins[0].version is missing"

# Resolve bump arg
arg="${1:-}"
[ -n "$arg" ] || die "usage: $(basename "$0") <new-version|major|minor|patch>"

bump_semver() {
  local ver="$1" part="$2"
  IFS='.' read -r maj min pat <<<"$ver"
  case "$part" in
    major) echo "$((maj+1)).0.0" ;;
    minor) echo "${maj}.$((min+1)).0" ;;
    patch) echo "${maj}.${min}.$((pat+1))" ;;
  esac
}

case "$arg" in
  major|minor|patch) new=$(bump_semver "$current" "$arg") ;;
  *)
    if [[ ! "$arg" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      die "new version must be semver (X.Y.Z) or one of: major, minor, patch"
    fi
    new="$arg"
    ;;
esac

[ "$new" != "$current" ] || die "new version ($new) matches current; nothing to do"

# Refuse if we'd clobber pre-existing local changes to the files we edit
if ! git diff --quiet -- "$MARKETPLACE_MANIFEST" "$CHANGELOG"; then
  die "unstaged changes exist in marketplace.json / CHANGELOG.md. Commit or stash first."
fi

# Refuse if the tag already exists
if git rev-parse -q --verify "refs/tags/v${new}" >/dev/null; then
  die "tag v${new} already exists"
fi

# Extract the Unreleased section body.
unreleased_body=$(awk '
  /^## \[Unreleased\]/ { capture=1; next }
  capture && /^## \[/  { exit }
  capture             { print }
' "$CHANGELOG")

# Strip leading/trailing blank lines
unreleased_body=$(printf '%s' "$unreleased_body" | awk 'NF { found=1 } found { print }' | awk '
  { buf[NR]=$0 }
  END {
    last=NR
    while (last>0 && buf[last] ~ /^[[:space:]]*$/) last--
    for (i=1;i<=last;i++) print buf[i]
  }')

if [ -z "$unreleased_body" ]; then
  die "CHANGELOG.md [Unreleased] section is empty. Add entries before bumping."
fi

today=$(date +%Y-%m-%d)

echo "bumping $current -> $new"

# 1. marketplace.json
tmp=$(mktemp)
jq --arg v "$new" '.plugins[0].version = $v' "$MARKETPLACE_MANIFEST" > "$tmp" && mv "$tmp" "$MARKETPLACE_MANIFEST"

# 2. CHANGELOG.md — insert '## [new] — today' block with the Unreleased body,
#    then reset Unreleased to an empty scaffold.
tmp=$(mktemp)
awk -v new="$new" -v today="$today" -v body="$unreleased_body" '
  BEGIN { replaced=0 }
  /^## \[Unreleased\]/ && !replaced {
    print "## [Unreleased]"
    print ""
    print "## [" new "] — " today
    print ""
    print body
    # Skip the original Unreleased block (until the next ## [ line).
    getline
    while ($0 !~ /^## \[/ && getline > 0) {}
    if ($0 ~ /^## \[/) print ""
    replaced=1
  }
  { print }
' "$CHANGELOG" > "$tmp" && mv "$tmp" "$CHANGELOG"

# 3. Commit + tag
git add "$MARKETPLACE_MANIFEST" "$CHANGELOG"
git commit -m "Release v${new}"
git tag -a "v${new}" -m "v${new}"

echo
echo "done. Committed Release v${new} and tagged v${new}."
echo "next: scripts/push.sh    (pushes branch + tag together)"
