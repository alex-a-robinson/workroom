---
name: monitor-status
description: Check whether the workroom-monitor-test plugin's monitors are delivering notifications to Claude. Use when the user asks whether the heartbeat or signal-watch monitors are working, or wants to verify the plugin is emitting correctly.
---

# Monitor status

This skill exists to help test and diagnose the `workroom-monitor-test` plugin — a probe that validates whether plugin monitors actually deliver stdout lines to Claude as chat notifications.

## When invoked, report on

**1. Heartbeat activity.** Scan the session context for lines matching `WORKROOM-HEARTBEAT <timestamp> — monitor-test plugin is alive`. This monitor fires every 60 seconds, so a live chat of more than ~90s should contain at least one. State how many you've seen and when the most recent one landed.

**2. Signal activity.** Scan for lines matching `WORKROOM-SIGNAL <message>`. These fire when something is appended to the plugin's `signals/signal.log`. State the count and the most recent payload.

**3. Diagnosis if either is absent.** Offer the most likely causes, in order:

- **Session attachment:** Cowork monitors may only attach to sessions started AFTER the plugin was installed or enabled. If the plugin was toggled on mid-chat, start a fresh chat.
- **Script permissions:** `heartbeat.sh` and `signal-watch.sh` need the executable bit. Ask the user to run `ls -l` on the installed plugin's `scripts/` directory.
- **Wrong signal path:** the artefact's default path points at the source directory. The installed copy lives under `~/.claude/plugins/cache/<marketplace>/<plugin>/...` or similar — the user needs the installed path for the signal test to work.
- **Runtime doesn't surface monitors:** Cowork may not yet wire monitor stdout into the chat notification channel, in which case this probe is the load-bearing negative result and the artefact→chat bridge idea needs to be rethought.

## Output shape

Keep the report to three short paragraphs maximum: one on heartbeats, one on signals, one on next step. This skill is diagnostic — be concise, don't speculate beyond what the context shows.
