---
name: workroom-onboarding
description: Three-step onboarding — infer your role, connect essential tools, pick your first routine. Silent wizard artefact shows progress; chat guides you through.
---

# Workroom Onboarding

A guided, three-step setup flow. Opens a visual wizard artefact and orchestrates role inference, tool connection, and routine selection via chat. One step at a time. Skips are fine.

## Step 1: Infer and Confirm Role

Infer the user's role from available signals: memory files (role hints), past session titles, or granted MCPs (HubSpot → sales, Linear → eng, etc.). Keep this silent — no chat yet.

Then say:

> I'm going to help you get Workroom set up in about three minutes. First — what kind of work do you do?

Call `mcp__cowork-onboarding__show_onboarding_role_picker` with the inferred role if you have a strong signal, else no preselection. 

The user clicks a role. Their choice comes back in the result. Tell the artefact which role was selected so it highlights Step 1 as complete. (If dismissed, default to "Founder" and move on.)

## Step 2: Connect Essential Tools

Based on the chosen role, there's a priority-ordered list of connectors to wire:

| Role | 1st | 2nd | 3rd |
|------|-----|-----|-----|
| **Sales** | Email | CRM (HubSpot/Salesforce/Pipedrive) | Calendar |
| **Ops** | Email | Calendar | Project tracker (Linear/Asana) |
| **Finance** | Email | Accounting (QuickBooks/Xero) | Sheets/Excel |
| **Marketing** | Email | Notion/Docs | Google Analytics/Sheets |
| **Support** | Helpdesk (Zendesk/Intercom) | Email | Knowledge base |
| **Founder** | Email | Calendar | Slack |
| **Engineering** | Issue tracker (Linear/Jira) | GitHub | Slack |

For each essential connector:
- Check if already connected. Use `mcp__mcp-registry__search_mcp_registry` to look up the tool by name (e.g., search `['hubspot', 'crm']`), then check the session's active MCP list.
- If connected, mark as ✓ in the artefact. Skip to the next.
- If not connected, call `mcp__mcp-registry__suggest_connectors` with the relevant UUIDs from the search, passing the role as the context label (e.g., "For your sales tools").

**Optional email scan:** If email is connected, search for tool invites or onboarding emails. Use `mcp__gmail-begly__search_emails` (or the connected Gmail MCP) with a broad query like:

```
from:(notion.so OR monday.com OR hubspot.com OR linear.app OR zendesk.com) 
subject:(welcome OR invite OR "confirm your account" OR activate)
older_than:180d
```

If matches, surface: "Looks like you've already got [Tool] — want to connect it now?" This is the clever move: no new account needed.

Keep the chat message short. Something like:

> Now let's connect your tools. Starting with email, then [tool]. I'll show you setup in order of impact.

Wait for each connection to complete (or the user to skip), then move to Step 3.

## Step 3: Pick Your First Routine

Show a visual grid of 6-8 role-matched routines. Each tile has title, 1-line description, required connector pills, and an `enabled` flag (true only if all required connectors are connected).

Load routines from `${CLAUDE_PLUGIN_ROOT}/templates/routines.json` (Agent E ships this file; artefact fetches it via MCP). If that file doesn't exist, use a placeholder inline TODO — *do not author that file*.

Say:

> Last step: pick your first routine. I've highlighted ones you can start right now.

The user clicks a routine. Update the artefact to mark Step 3 as complete and highlight the selected routine.

Then:

> You're all set. Start a new conversation anytime and ask me to run [routine name], or type `/` to see all your skills.

## Ground Rules

- One step at a time. Don't jam all three steps into one message.
- Skips are fine. If the user waves off a connector step or says "I'll do that later," move on.
- Keep each message short: two or three sentences plus the widget, not a wall.
- The artefact is a silent companion. It updates as you report progress, but the user doesn't type into it. All interaction is in the chat.
- If the user asks about the Workroom directory during onboarding, offer to scaffold it *after* these three steps: "Once we're done here, I can set up your Workroom directory with templates and conventions."

## References

- Artefact file: `${CLAUDE_PLUGIN_ROOT}/artefacts/onboarding.html`
- Routines data (ship by Agent E): `${CLAUDE_PLUGIN_ROOT}/templates/routines.json`
- Role-priority table documented here; do not hardcode in the artefact — the skill drives it.
