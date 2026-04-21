# monitor-test

A minimal Claude Code plugin whose only job is to answer one blocking question:

> Do plugin **monitors** actually deliver stdout lines to Claude as chat notifications the user and Claude can both see?

If they do, we can build the artefact→chat bridge properly — a Workroom-custom mailbox MCP lets the artefact write messages to a file, a monitor tails the file, Claude gets notified, reacts, and (optionally) clears the breadcrumb. That closes the gap the session-9 walkback opened up in `technical/artefact-prototype-findings.md`.

If they don't, the bridge approach is dead and we re-think.

## What's in here

```
monitor-test/
├── .claude-plugin/plugin.json     # identity
├── monitors/monitors.json         # declares two monitors
├── scripts/
│   ├── heartbeat.sh               # emits a line every 60s (proves monitors work at all)
│   └── signal-watch.sh            # tails signals/signal.log and echoes any appended line
└── signals/.gitkeep               # signal.log gets created on monitor start
```

**Heartbeat monitor** is the dumb-simple primitive: a line every 60 seconds. If Claude doesn't see these, the whole pattern is dead.

**Signal-watch monitor** is the bridge-shape: tails a file, echoes new lines as notifications. Demonstrates the pattern without requiring a custom MCP — for the test, you can just append lines to the file by hand.

## How to test it

1. **Install the plugin** in Cowork. (Either add this directory to a local marketplace, or add the repo root as a marketplace and filter to this plugin — exact flow depends on how Workroom's dev harness ends up wired. For the first test, pointing Cowork at this directory as a local-dev plugin is the quickest path; see the [plugins reference](https://code.claude.com/docs/en/plugins-reference).)

2. **Open a new chat in Cowork.** The monitors should start automatically.

3. **Heartbeat test.** Wait up to 60 seconds. A `WORKROOM-HEARTBEAT <timestamp> — monitor-test plugin is alive` line should appear in the chat as a notification. Ask Claude "did you get a heartbeat?" — it should acknowledge the recent notification.

4. **Signal test.** In Terminal, find the installed plugin path (something like `~/Library/Application Support/Claude/.../rpm/plugin_<id>/signals/signal.log`) and append a line:
   ```
   echo "hello from the outside world" >> /path/to/signal.log
   ```
   A `WORKROOM-SIGNAL hello from the outside world` notification should show up in the chat within seconds.

5. **If step 4 works**, the bridge pattern is viable: build a Workroom-custom mailbox MCP that exposes a `write(msg)` tool to artefacts, pointing at the same file the signal-watch monitor tails.

## What "working" looks like (for step 3 specifically)

- The notification is visible in the chat transcript (user can see it).
- Claude can read the notification content when asked.
- Nothing else broke — Cowork still responsive, no error prompts.

## What "not working" looks like

- Monitor command runs (check logs if Cowork exposes them) but no notification shows up.
- Notification shows up for Claude but not for the user, or vice versa.
- Notification interrupts Claude mid-turn in a way that breaks the current flow.

Record findings in `technical/artefact-prototype-findings.md` — append a new dated session section.

## Notes

- **Requires Claude Code ≥ v2.1.105.** Monitors are a recent addition; older Cowork builds won't have them.
- **Session-scoped.** Monitors die when the chat session ends or Cowork quits. This plugin does not — and cannot — solve the always-on problem. That's Tier 3's job (see `concepts/07-remote-scheduled-tasks.md`).
- **Adoption is low.** Very few published plugins ship monitors today. Expect some rough edges and undocumented behaviour. Known unknowns: cross-chat behaviour (one monitor instance shared, or one per chat?), rate-limiting on notification floods, exact `when`-field schema.
- **Not for Workroom production yet.** This plugin is a probe, not a deliverable. Once the mailbox-MCP bridge is built on top, it becomes part of the Workroom plugin proper.

## Wider context

- Plugin schema reference: `technical/plugin-schema-deep-dive.md` — element-by-element, including the full monitor section.
- Why we care about the bridge: `concepts/02-artefact-chat-workflow.md` and the session-11 addendum in `technical/artefact-prototype-findings.md`.
- Why we also need Tier 3: `concepts/07-remote-scheduled-tasks.md`.
