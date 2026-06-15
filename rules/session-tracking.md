# Session Tracking

Rules for maintaining working state between Claude Code sessions.

---

## SESSION.md

Each project maintains `.claude/SESSION.md` — a plain markdown file that is the single source of truth for "where was I?"

**It is gitignored.** SESSION.md is personal working state, not project documentation. Do not commit it.

**Keep it under 50 lines.** If it grows longer, you're writing documentation, not session notes. Trim aggressively.

---

## Session Start

When starting a session on a project:

1. Read `.claude/SESSION.md` if it exists.
2. Read the current git branch and recent commits (`git log --oneline -5`).
3. Begin from the "Next" section in SESSION.md, not from scratch.

If SESSION.md doesn't exist, it means this is the first session or it was cleared. Proceed with the task as given.

---

## Session End

Before ending a session, update `.claude/SESSION.md`:

- Move completed items from "Next" to "Done".
- Update "Next" with what remains or what should be done next session.
- Record the current branch name.
- Note the test state (passing/failing, skipped).
- Record any blockers or context that would be lost overnight.
- Write any prepared prompts for next session under "Notes".

If the session completed a full task cleanly, it's acceptable to clear "Done" and "Notes" and leave only "Next" with the next logical task.

---

## Cross-Project View

`cc-status` reads SESSION.md from all projects and outputs a summary. Keep SESSION.md parseable: use the template structure (Last session date, Done, Next, State, Notes). Freeform text under those headers is fine; changing the headers breaks `cc-status`.

---

## What Goes in SESSION.md

- What was done this session (brief, bullet points)
- What to do next (actionable, specific)
- Current branch name
- Whether tests are passing
- Any active blockers
- Prepared prompts or context snippets for the next session

**What does not go in SESSION.md**: architectural decisions (those go in docs), bug reports (those go in the issue tracker), completed features (those go in CHANGELOG).
