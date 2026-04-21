# {Project} — context for Claude

*This file is loaded as working memory at the start of every conversation in this directory. It tells you what this project is, how to organize work here, and what each file is for.*

## What this project is

Add a one-paragraph description of the project's goal, scope, and posture. Update this when the core concept shifts materially.

## File-system conventions

The repo is deliberately flat. Each file or folder has one job. Keep it simple; earn new folders rather than speculating structure.

```
.
├── README.md              — navigation and orientation
├── CLAUDE.md              — this file. Project context.
├── overview.md            — single-source narrative. Update when concepts shift.
├── mvp.md                 — crystallised spec. Phase 1 / 2 / 3 scope, open gates.
├── log.md                 — append-only timeline. Brain dumps here under date headings.
├── open-questions.md      — running list, grouped by domain (platform, product, business, etc).
│
├── concepts/              — one numbered markdown file per major component.
│   └── 01-example.md
│
├── ideas/                 — dated raw brain dumps, verbatim. Nothing here is structured yet.
│   └── YYYY-MM-DD-*.md
│
└── technical/             — platform facts, API notes, architecture decisions.
    └── glossary.md
```

## The workflow

1. **Brain dump lands.** Append raw version to `log.md` under today's date, preserve raw as a new file under `ideas/YYYY-MM-DD-*.md`.
2. **Distil in-session.** Move agreed structural material into the right places: `concepts/` for deep-dives, `technical/` for platform facts, `mvp.md` if scope shifts, `overview.md` if the story shifts.
3. **Raise unknowns into `open-questions.md`.**
4. **When a concept firms up, promote it** from `ideas/` into or onto an existing `concepts/` file.
5. **Don't delete, supersede.** If something turns out wrong, note it dated in `log.md` and leave the old file with a superseded note at the top. History is cheap; re-deriving is expensive.

## Style and behaviour notes

- **Prose in long docs, minimal formatting in chat.** Headings and tables are fine in concept files; in conversational replies, default to paragraphs.
- **Flag verify-before-use content.** Anything drawn from research that's now stale should be labelled so the reader can tell.
- **When in doubt, ask.** A short clarifying question beats three paragraphs of assumption.
- **Horizontal rule before the final summary.** When working through a task (reading files, reasoning, making edits), end with `---` before the concluding summary. The rule gives a clear visual boundary between "here's what I did" and "here's the state now."
- **Integration ladder for skills / workflows.** When something needs to talk to external tools, walk the ladder in order: (1) dedicated MCP server, (2) direct API with user-supplied token, (3) Chrome / browser MCP as last resort. Don't jump to pixel-level browser control when a typed MCP exists.

## Things to actively remember

(Add as you learn about this project. Placeholder examples:)
- Key decisions and why they were made
- Known constraints or tradeoffs
- People and their roles
- Tools and platforms you're building on
- Things that have been tried and failed — and why

## How Claude can help

When you start a new conversation here, Claude loads this file automatically as working memory. Use it to:

- Ask for feedback on structure or decisions
- Request research on specific questions in `open-questions.md`
- Distil brain dumps from `log.md` into shaped concepts
- Draft new concept documents or update existing ones
- Navigate the file tree and understand what's where
