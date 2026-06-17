# Roadmap Tracking

The agent owns cross-project progress tracking. `ROADMAP.md` in the engineering-dna
repo root is the single source of truth for what's done and what's next across all
projects. The human does not maintain this file — the agent does.

---

## Where ROADMAP.md lives

`ROADMAP.md` is at the root of the engineering-dna repo. This repo contains the
rules you are currently reading. Locate it by resolving the parent of the `rules/`
directory where this file lives.

On the active machine the path is `G:\development\engineering-dna\ROADMAP.md`.
Use that path directly when writing on Windows. On other machines, resolve it from
the symlink target of `.claude/rules/shared`.

`ROADMAP.md` is gitignored (local-only cross-project state). If it does not exist,
create it with a `# Roadmap` header before writing.

---

## Update ROADMAP.md on task completion

After completing any backlog item or roadmap task (commit made, or deliverable done),
update `ROADMAP.md`:

1. **Mark the completed item done** — change `- [ ]` to `- [x]`
2. **Add the next step if it's clear** — append a new `- [ ]` under the same section
3. **Do not invent next steps** — if the next step is unclear, leave the section as-is

Only touch the item(s) directly related to the work just completed. Do not rewrite
or reorganize other sections.

---

## Format

```markdown
# Roadmap

## ProjectName
- [x] Completed item — brief description of what was done
- [ ] Next item — what comes next (only if clear)
```

Sections are per-project. Add a new section header `## ProjectName` if the project
has no section yet.

---

## ROADMAP.md is a local file

It is gitignored and must never be committed. It reflects the current state of
cross-project work visible only to the agent operating on this machine.
`project-pulse` reads it and surfaces it at the top of the morning triage report.
