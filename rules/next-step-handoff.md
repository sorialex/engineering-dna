# Next-Step Handoff

The agent owns session continuity. `project_pulse.py` reads `NEXT.md` from each
repo root to produce the morning triage. The human does not maintain this file —
the agent does.

---

## Write NEXT.md on task completion

After completing any task (commit made, or prompt answered and the session is winding
down), write or overwrite `NEXT.md` at the project root with exactly:

```
date: YYYY-MM-DD
done: <one-line summary of what was just completed>
next: <1–3 lines describing the logical next step>
```

No extra sections. No prose. No markdown formatting inside values.

## When the next step is unclear

Write exactly:

```
next: Next step unclear — review backlog
```

Do not invent a plausible-sounding next step. An honest "unclear" is more useful
than a fabricated one that misdirects the next session.

## NEXT.md is ephemeral

This file reflects current session state, not project history. It must be in
`.gitignore`. If `.gitignore` does not contain `NEXT.md`, add it before writing
the file for the first time.

## One file, always overwritten

Never append to NEXT.md. Each task completion replaces the previous entry entirely.
The file always describes the current stopping point — not a log of past sessions.
