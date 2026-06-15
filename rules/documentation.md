# Documentation Rules

---

## Scope

**Documentation is a deliverable, not an afterthought.** Every user-facing change — new command, new flag, new API endpoint, changed behavior — ships with updated documentation in the same commit. Documentation debt is real debt.

**README is the entry point.** It must always reflect the current state of the project. If you change a command's interface, update the README before closing the task.

---

## What to Document

**CHANGELOG for every release-worthy change.** Follow [Keep a Changelog](https://keepachangelog.com/) format: `Added`, `Changed`, `Fixed`, `Removed`, `Security`. Write entries for humans, not for parsers.

**CLI help text that actually helps.** `--help` must describe what the command does, list all flags with their effects, and show at least one example. If a new developer can't figure out how to use the tool from `--help`, the help text is broken.

**ADRs for architecture decisions.** When you make a non-obvious architectural choice (why this library, why this pattern, why not the obvious alternative), record it. Use inline sections in `HOW_IT_WORKS.md` or a separate `docs/decisions/` directory. Decisions recorded in commit messages get buried; decisions in docs get found.

---

## What Not to Document

**Don't explain what the code does.** Well-named functions and variables already do that. Comments that restate the code are noise that ages into lies.

**Don't document obvious code.** `i += 1  # increment i` is not a comment. Delete it.

**Comment the why, not the what.** Valid reasons for a comment: a non-obvious constraint, a workaround for a specific external bug, an invariant that isn't apparent from the code, behavior that would surprise a reader who knows the domain.

---

## The 10-Minute Rule

**If something took you more than 10 minutes to figure out, document it.** This applies to: build quirks, environment setup, non-obvious API behaviors, integration gotchas, performance traps. Future you (and future teammates) should not spend that 10 minutes again.

---

## Code Comments

Write comments as complete sentences. One line maximum for inline comments. Multi-paragraph comment blocks are a signal that the code needs restructuring, not more comments.

Never reference the current task or PR in code comments ("added for issue #42", "used by the payment flow"). These references rot as the codebase evolves and belong in commit messages or PR descriptions, not source files.
