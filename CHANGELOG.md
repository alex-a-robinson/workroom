# Changelog

All notable changes to the `workroom` plugin. Format loosely follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning follows SemVer.

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
- All monitor-probe code paths. `monitors/monitors.json` is empty, `scripts/heartbeat.sh` and `scripts/signal-watch.sh` are no-op stubs, the `monitor-status` skill is marked retired. `CLEANUP.sh` at repo root removes the legacy directories once; run it before the first push of v0.3.x.

### Notes
- Trust model is per-marketplace-identity; updates can change hooks and MCPs silently after the initial install. `workroom-info` surfaces what's loaded so users can see post-update.
- No Workroom-custom MCP shipped in this version. Planned for 0.4.x.

## [0.2.0] — 2026-04-21 (as `workroom-monitor-test`)

Probe-only release. Validated that Cowork does not currently execute `monitors/monitors.json` (confirmed negative 2026-04-21 session 12). See `technical/artefact-prototype-findings.md` in the Workroom repo.

## [0.1.0] — 2026-04-21 (as `workroom-monitor-test`)

Initial probe scaffolding.
