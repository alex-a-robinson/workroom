---
name: workroom-invite
description: Generate a Workroom invite code to share with teammates. Triggers on "invite a teammate", "send an invite", "invite code", "workroom invite".
---

## Generate Workroom Invite Code

I'll generate a unique invite code you can share with teammates to join Workroom.

Let me create a code for you:

```
WR-ABCD-EFGH-2026
```

Replace ABCD and EFGH with random uppercase letters and numbers — here's one approach via bash to generate it fresh each time:

```bash
CODE="WR-$(LC_ALL=C tr -dc 'A-Z0-9' < /dev/urandom | head -c 4)-$(LC_ALL=C tr -dc 'A-Z0-9' < /dev/urandom | head -c 4)-2026"
echo "$CODE"
```

Your invite code is unique. Share it with anyone you want to onboard to Workroom.

## How teammates install Workroom

Have them run these two commands in their Claude.ai session:

```
/plugin marketplace add alex-a-robinson/workroom
/plugin install workroom@workroom
```

When prompted for an invite code, they'll paste the code above. (The code validation isn't live yet — this is a placeholder for when the backend ships, but save the code for reference.)

## Tracking invites

All generated codes are logged locally so you can review who you've invited:

```bash
mkdir -p "${CLAUDE_PLUGIN_DATA:-$HOME/.claude}"
echo "$CODE | $(date)" >> "${CLAUDE_PLUGIN_DATA:-$HOME/.claude}/invites.log"
```

Real invite distribution and admin linkage coming in a future release.
