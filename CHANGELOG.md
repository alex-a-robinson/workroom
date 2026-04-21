# Changelog

All notable changes to the `workroom` plugin. Format loosely follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning follows SemVer.

## [0.4.1] — 2026-04-21

Patch release: the v0.4.0 MCP wrapper never started because of an unbound-var crash. This fixes it.

### Fixed

- **`plugin/mcp/workroom-fs.sh`** used `set -eu` and referenced `${CLAUDE_PLUGIN_DATA}` directly — Cowork doesn't always pass that env var to plugin-spawned MCPs, so the wrapper exited with "unbound variable" before ever invoking `npx`. The dashboard showed "MCP isn't running" because the server never started. Wrapper now uses `:-` defaults, falls back to `$HOME/.workroom` for config and `$HOME/Documents/Claude/Projects/Workroom` for the served root, creates the root if it doesn't exist, and logs its resolved path to stderr.
- **`plugin/mcp/set-workroom-root.sh`** had the same `${CLAUDE_PLUGIN_DATA}` assumption and would fail the onboarding step. Matched to the same fallback pattern; also escapes JSON for paths containing backslashes or quotes.

### Notes

- Cowork may need a full app restart (not just a new chat) for a fresh plugin's stdio MCP to appear in the tool list — confirmed from plugin manifest docs that MCPs spawn at session init.
- End-to-end verified: MCP handshake returns the expected `tools/list` including `directory_tree`, `read_text_file`, `list_directory`, `list_allowed_directories`.

## [0.4.0] — 2026-04-21

First "real" Workroom release. Four dedicated artefacts, a live filesystem MCP, a three-step onboarding, curated starter routines, and a brand style doc pulled from useworkroom.com. No mock data in the dashboard — it reads real files.

### Added

- **`.mcp.json` + bundled `workroom-fs` MCP.** Filesystem MCP wrapped in `plugin/mcp/workroom-fs.sh`. Scope resolves at launch time from `${CLAUDE_PLUGIN_DATA}/config.json` so the user can pick their workspace root during onboarding. Falls back to `~/Documents/Claude/Projects/Workroom` if the config hasn't been written yet. `plugin/mcp/set-workroom-root.sh` is the setter the onboarding skill calls. `plugin/mcp/test-mcp.sh` is a local manual test runner.
- **Dashboard artefact (`artefacts/dashboard.html`).** Replaces the broken `file-viewer.html` with a live MCP-backed three-pane knowledge-base browser: top bar, collapsible directory tree sidebar (from `mcp__workroom-fs__directory_tree`), markdown content pane (from `mcp__workroom-fs__read_text_file` via marked.js). Preview-mode fallback when `window.cowork` is absent.
- **Three-step onboarding.** Rewritten `skills/workroom-onboarding` orchestrates role inference → connect essentials → pick a first routine, following Anthropic's `setup-cowork` shape. Infers role from memory files, session titles, and already-granted MCPs before showing the role picker. Optional inbox scan surfaces tools the user already signed up for. New `artefacts/onboarding.html` is a silent wizard panel that updates as the chat progresses.
- **Education artefact (`artefacts/education.html`) + skill.** Reads progress from `~/.workroom/progress.json`. Shows in-progress + available + upcoming routines. Greys out routines whose required connectors aren't wired.
- **Admin artefact (`artefacts/admin.html`) + skill.** Team-overview placeholder with prominent invite-code CTA, honest empty state ("Invite teammates to see their progress here"), and a KPI strip. Real team wiring lands when the invite backend does.
- **Invite skill (`skills/workroom-invite`).** Placeholder that generates `WR-XXXX-XXXX-2026`-style codes via `/dev/urandom`, logs them to `${CLAUDE_PLUGIN_DATA}/invites.log`, and prints install instructions for the recipient.
- **Starter routines (`templates/routines.json`).** 55 curated workflows across seven roles (founder, sales, CS, ops, marketing, engineering, support), each tagged with required connectors, cadence, and estimated minutes.
- **Brand style doc (`plugin/style.md`).** Complete design-token spec extracted from useworkroom.com — dark-first palette, Instrument Serif + Geist pairing, coral `#E8623D` accent, motion + spacing scale. Every v0.4 artefact uses the same `:root` block.
- **Technical reference.** `plugin/technical/mcp-plumbing.md` (artefact-to-MCP plumbing) and `plugin/mcp/README.md` (server-side debug notes).

### Changed

- `workroom-file-viewer` skill now opens `dashboard.html` (not the old file-viewer). Dropped the `__DEFAULT_WORKSPACE__` placeholder injection — the artefact gets its data from the MCP.
- `plugin/.claude-plugin/plugin.json` description rewritten to match the new surface area.
- Plugin homepage/author URL updated to `useworkroom.com`.

### Removed

- `artefacts/file-viewer.html` superseded by `dashboard.html` (kept as a tombstone comment pointing at the replacement).

### Known gaps

- Hooks are still log-and-noop stubs.
- Admin artefact is placeholder data.
- Cowork env-var substitution in `.mcp.json` is standard in Claude Code but unverified for Cowork plugins — the wrapper-script approach is deliberately belt-and-braces so both substitution modes work.

## [0.3.0] — 2026-04-21

### Changed
- **Repo renamed.** `workroom-monitor-test` → `workroom`. GitHub URL updated, repo ID preserved. Plugin identity changed from `workroom-monitor-test` to `workroom`; existing installs will need to uninstall + reinstall.
- Repo is no longer a probe. It's the master Workroom plugin — skills, artefacts, templates, hooks. See README.

### Added
- `skills/workroom-onboarding` — spawns the onboarding artefact, offers to scaffold a Workroom-style workspace into the user's chosen directory.
- `skills/workroom-file-viewer` — spawns an Obsidian-style knowledge-base file viewer (folder tree + markdown preview).
- `skills/workroom-pip` — loads the Pip framework as in-session behaviour (coaching + teaching + pushback modes).
- `skills/workroom-info` — prints version, recent changelog, what skills / hooks / artefacts the plugin has loaded into the current session.
- `skills/workroom-help` — short orientation for new users.
- `artefacts/onboarding.html` — ported from `workroom-preview-v2.html`. Welcome / Home / Learning / Teach / Flows views in one artefact.
- `artefacts/file-viewer.html` — new knowledge-base browser artefact.
- `templates/` — starter workspace scaffold (blank CLAUDE.md with conventions, blank overview/mvp/log/open-questions, empty category folders).
- `hooks/hooks.json` — placeholder wiring for `SessionStart` (git-fetch nudge + onboarding detect) and `PreToolUse` (Pip safety layer). Both stubs are log-and-noop; manifest is real.

### Removed
- All monitor-probe code paths. `monitors/monitors.json` is empty, `scripts/heartbeat.sh` and `scripts/signal-watch.sh` are no-op stubs, the `monitor-status` skill is marked retired.

### Notes
- Trust model is per-marketplace-identity; updates can change hooks and MCPs silently after the initial install. `workroom-info` surfaces what's loaded so users can see post-update.
- No Workroom-custom MCP shipped in this version. Planned for 0.4.x.

## [0.2.0] — 2026-04-21 (as `workroom-monitor-test`)

Probe-only release. Validated that Cowork does not currently execute `monitors/monitors.json` (confirmed negative 2026-04-21 session 12).

## [0.1.0] — 2026-04-21 (as `workroom-monitor-test`)

Initial probe scaffolding.
