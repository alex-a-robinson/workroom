---
name: workroom-info
description: Report plugin version, loaded skills, declared hooks, and MCPs. Triggers on "what version of Workroom", "Workroom plugin info", "what's loaded", "show me what Workroom is running", "plugin status", "Workroom version", "show the changelog"
---

# Workroom Info

Read the plugin metadata and report:

1. **Plugin version** — for this plugin, version lives in the marketplace manifest, not the plugin manifest. Read it from `${CLAUDE_PLUGIN_ROOT}/../.claude-plugin/marketplace.json` at `.plugins[0].version`. If `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json` contains a `version` field, flag it as a hazard — for relative-path plugins Anthropic's docs say the plugin-manifest version silently shadows the marketplace value, so it must not be set.
2. **Commit SHA** — run `git -C "${CLAUDE_PLUGIN_ROOT}/.." rev-parse --short HEAD` to get the shipped commit. If the command fails (plugin not installed from a git source), skip this line.
3. **Skills loaded** — list the names of all skill folders under `${CLAUDE_PLUGIN_ROOT}/skills/*/SKILL.md`.
4. **Hooks declared** — read `${CLAUDE_PLUGIN_ROOT}/hooks/hooks.json` and list which event types are wired.
5. **MCPs declared** — check if `${CLAUDE_PLUGIN_ROOT}/.mcp.json` exists. If yes, list the server names. If not, say "none shipped in this version".
6. **Recent changelog** — read `${CLAUDE_PLUGIN_ROOT}/../CHANGELOG.md` and print the most recent release block (the top `## [x.y.z]` section).

Format as a short markdown summary, under 20 lines. Print the version and commit SHA in the header (e.g. `# Workroom v0.4.2 — <sha>`). End with the trust reminder below.

**Trust reminder:** Trust is per-marketplace-identity. Plugin updates can silently change MCPs and hooks — re-run this skill after any `/reload-plugins` to confirm the state matches what you expect.
