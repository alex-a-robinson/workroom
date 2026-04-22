#!/usr/bin/env bash
# Validate the plugin + marketplace manifests.
#
# Checks:
#   1. Both files are valid JSON.
#   2. plugin.json has required fields (name, description).
#   3. plugin.json has NO version field. For relative-path plugin sources,
#      Anthropic's docs say version goes only in marketplace.json — having it
#      in both silently shadows the marketplace value.
#   4. marketplace.json has required fields (name, owner, plugins[]).
#   5. marketplace.json plugins[0].name == plugin.json name.
#   6. marketplace.json plugins[0].version exists and is semver (X.Y.Z).
#   7. The path referenced by plugins[0].source exists and contains a plugin.json.
#   8. CHANGELOG.md has a section for the current version (or [Unreleased]).
#
# Exits 0 on clean, non-zero with a clear message on any failure. Used locally
# and by .github/workflows/validate.yml on every push.
set -euo pipefail

cd "$(dirname "$0")/.."

PLUGIN_MANIFEST="plugin/.claude-plugin/plugin.json"
MARKETPLACE_MANIFEST=".claude-plugin/marketplace.json"
CHANGELOG="CHANGELOG.md"

fail=0
err() { echo "  FAIL: $*" >&2; fail=1; }
ok()  { echo "  ok:   $*"; }

command -v jq >/dev/null 2>&1 || { echo "jq required" >&2; exit 2; }

echo "validate-manifest"

# 1. JSON
if jq empty "$PLUGIN_MANIFEST" 2>/dev/null; then ok "$PLUGIN_MANIFEST is valid JSON"; else err "$PLUGIN_MANIFEST is not valid JSON"; fi
if jq empty "$MARKETPLACE_MANIFEST" 2>/dev/null; then ok "$MARKETPLACE_MANIFEST is valid JSON"; else err "$MARKETPLACE_MANIFEST is not valid JSON"; fi
[ $fail -eq 0 ] || exit 1

# 2. plugin.json required fields (no version — relative-path rule)
for f in name description; do
  v=$(jq -r --arg f "$f" '.[$f] // ""' "$PLUGIN_MANIFEST")
  if [ -n "$v" ]; then ok "plugin.json has $f"; else err "plugin.json missing $f"; fi
done

# 3. plugin.json must NOT have version for relative-path plugins
if jq -e 'has("version")' "$PLUGIN_MANIFEST" >/dev/null; then
  err "plugin.json has a 'version' field — remove it. For relative-path plugins (source: \"./plugin\"), version lives only in marketplace.json. Having it in both silently shadows the marketplace value."
else
  ok "plugin.json has no version field (correct for relative-path)"
fi

# 4. marketplace.json required fields
name=$(jq -r '.name // ""' "$MARKETPLACE_MANIFEST")
[ -n "$name" ] && ok "marketplace.json has name" || err "marketplace.json missing name"
owner=$(jq -r '.owner.name // ""' "$MARKETPLACE_MANIFEST")
[ -n "$owner" ] && ok "marketplace.json has owner.name" || err "marketplace.json missing owner.name"
plugin_count=$(jq '.plugins | length' "$MARKETPLACE_MANIFEST")
[ "$plugin_count" -ge 1 ] && ok "marketplace.json has $plugin_count plugin(s)" || err "marketplace.json has no plugins"

# 5. name cross-check
pname=$(jq -r '.name' "$PLUGIN_MANIFEST")
mname=$(jq -r '.plugins[0].name // ""' "$MARKETPLACE_MANIFEST")
[ "$pname" = "$mname" ] && ok "plugin name match ($pname)" || err "name mismatch: plugin.json='$pname', marketplace.json='$mname'"

# 6. version present + semver in marketplace.json
mver=$(jq -r '.plugins[0].version // ""' "$MARKETPLACE_MANIFEST")
if [ -z "$mver" ]; then
  err "marketplace.json plugins[0].version is missing"
elif [[ ! "$mver" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  err "marketplace.json version '$mver' is not MAJOR.MINOR.PATCH"
else
  ok "marketplace.json version ($mver) is semver"
fi

# 7. Source path resolves
source_path=$(jq -r '.plugins[0].source' "$MARKETPLACE_MANIFEST")
if [ -f "${source_path}/.claude-plugin/plugin.json" ]; then
  ok "source path '$source_path' resolves to a plugin"
else
  err "source '$source_path' does not contain .claude-plugin/plugin.json"
fi

# 8. CHANGELOG mentions this version (or has Unreleased)
if grep -qE "^## \[(${mver}|Unreleased)\]" "$CHANGELOG"; then
  ok "CHANGELOG references v$mver or [Unreleased]"
else
  err "CHANGELOG has no section for v$mver or [Unreleased]"
fi

echo
if [ $fail -ne 0 ]; then
  echo "validate-manifest: FAILED" >&2
  exit 1
fi
echo "validate-manifest: ok"
