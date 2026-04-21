---
name: workroom-info
description: Report plugin version, loaded skills, declared hooks, and MCPs. Triggers on "what version of Workroom", "Workroom plugin info", "what's loaded", "show me what Workroom is running", "plugin status", "Workroom version", "show the changelog"
---

# Workroom Info

Read the plugin metadata and report:

1. **Plugin version** — read `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json` and extract the `version` field.
2. **Skills loaded** — list the names of all skill folders under `${CLAUDE_PLUGIN_ROOT}/skills/*/SKILL.md`.
3. **Hooks declared** — read `${CLAUDE_PLUGIN_ROOT}/hooks/hooks.json` and list which event types are wired.
4. **MCPs declared** — check if `${CLAUDE_PLUGIN_ROOT}/.mcp.json` exists. If yes, list the server names. If not, say "none shipped in this version".
5. **Recent changelog** — read `${CLAUDE_PLUGIN_ROOT}/../CHANGELOG.md` and print the most recent release block (the top `## [x.y.z]` section).

Format as a short markdown summary, under 15 lines. Print the version as a header. End with the trust reminder below.

**Trust reminder:** Trust is per-marketplace-identity. Plugin updates can silently change MCPs and hooks — re-run this skill after any `/reload-plugins` to confirm the state matches what you expect.
