# workroom-monitor-test

A single-plugin Claude Code / Cowork marketplace. One job: find out whether plugin monitors actually deliver stdout lines to Claude as chat notifications the user and Claude can both see.

If they do, a Workroom-custom mailbox MCP can wire an artefact→chat bridge on top. If they don't, the bridge approach is dead and we re-think.

## Contents

```
workroom-monitor-test/
├── .claude-plugin/
│   └── marketplace.json      — catalog listing one plugin
├── plugin/                   — the plugin itself
│   ├── .claude-plugin/plugin.json
│   ├── monitors/monitors.json
│   ├── scripts/
│   │   ├── heartbeat.sh      — emits a line every 60s
│   │   └── signal-watch.sh   — tails signals/signal.log and echoes new lines
│   ├── signals/.gitkeep      — where signal.log grows
│   ├── skills/monitor-status/SKILL.md — diagnostic skill
│   └── README.md
├── README.md                 — this file
└── .gitignore
```

## Install (as marketplace)

In Cowork: Customize → Personal plugins → `+` → Create plugin → **Add marketplace** → paste the GitHub `owner/repo` or full URL.

Once the marketplace appears, install the `workroom-monitor-test` plugin from it.

## Test

1. **Start a fresh chat.** Monitors may only attach to sessions started after install.
2. **Heartbeat:** within 60s, a `WORKROOM-HEARTBEAT <timestamp> — monitor-test plugin is alive` line should appear. Ask Claude "did you get a heartbeat?" — it should acknowledge.
3. **Signal:** find the installed plugin's `signals/signal.log` path (under `~/.claude/plugins/cache/...` or `~/Library/Application Support/Claude/.../rpm/plugin_<id>/...`) and run `echo "hello" >> /path/to/signal.log`. A `WORKROOM-SIGNAL hello` line should land in chat within seconds.
4. **Diagnose:** invoke the `monitor-status` skill — it asks Claude to report what it has and hasn't seen.

## Requires

Claude Code or Cowork with plugin-monitor support (≥ v2.1.105 on Claude Code CLI).

## Scope

This plugin is a probe, not a deliverable. It's session-scoped — monitors die when the chat ends or Cowork quits. See the parent Workroom project docs for why the always-on problem needs a different tier.
