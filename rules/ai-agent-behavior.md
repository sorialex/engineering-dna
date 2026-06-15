# AI Agent Behavior Rules

These rules govern how AI coding agents (Claude Code) should behave in this codebase. They are defensive rules derived from real failure patterns.

---

## Scope

**No scope creep.** Do not refactor, rename, or restructure code beyond what the task explicitly asks for. If you notice improvement opportunities while working, note them in a comment or session notes — do not act on them without explicit instruction.

**Minimal diff principle.** The best change is the smallest one that solves the problem. Prefer targeted edits over rewrites. If the fix is three lines, the diff should be approximately three lines.

**No silent modifications.** Every file you change must trace to a specific requirement in the current task. If you modify a file, state why in your response.

---

## Context

**No phantom context.** Do not assume knowledge about the codebase that wasn't provided or read from files. If you're unsure how something works, read the file. If you can't read the file, say so.

**Respect existing patterns.** Match the codebase's existing style, naming, and conventions. Do not introduce a new pattern when the codebase already has an established one for the same concern. When in doubt, grep for prior art.

---

## Abstraction

**No premature abstraction.** Do not extract functions, create utility modules, or add abstraction layers unless explicitly requested. Duplication is often better than the wrong abstraction. Three similar lines is not a call to action.

**No speculative design.** Do not add configuration options, feature flags, plugin systems, or extension points that aren't needed by the current task. Build what's asked, not what might be useful later.

---

## Decisions

**Ask vs. act threshold.** For ambiguous requirements, choose the most reasonable interpretation, implement it, and explicitly state your assumption. Do not ask clarifying questions unless you are genuinely blocked and cannot make a reasonable assumption. A wrong assumption stated clearly is more productive than a question.

**Breaking changes require confirmation.** If a task would require changing a public API, schema, or interface that other code depends on, flag it and confirm before proceeding.

---

## Completion

**Test before claiming done.** If the project has tests, run them before marking a task complete. If a test fails and the fix is a one-liner, fix it. If it's non-trivial, report the failure explicitly — do not paper over it.

**Documentation as deliverable.** When adding new commands, flags, API endpoints, or user-facing features, update the relevant documentation (README, CHANGELOG, CLI help text) as part of the same task. Documentation is not optional.

**No leftover artifacts.** Do not leave debug print statements, commented-out code, TODO comments for things you could have done, or temporary files in the committed result.
