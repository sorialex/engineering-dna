# engineering-dna

A framework for governing AI coding agents (Claude Code) across multiple projects.

---

## The Problem

Every project you work on with Claude Code starts from scratch. You explain the same coding standards. You re-establish the same testing strategy. You remind the agent not to over-abstract, not to scope-creep, not to hallucinate context. New project — start over.

Two things break at scale:

**Repeated context**: Claude Code has no native cross-project memory. Every `CLAUDE.md` you write from scratch drifts from every other. Standards fragment. You end up with five slightly-different testing philosophies across five repos.

**Inconsistent setup**: New projects don't inherit organizational standards. You bootstrap them manually, forget steps, and discover gaps three sessions in when something breaks in a way that a shared rule would have caught.

---

## The Solution

Three layers, all built on Claude Code's native infrastructure:

```
┌─────────────────────────────────────────────────────────┐
│  Layer 1: Base Image  (~/.claude/)                      │
│  Always active. Zero per-project setup.                 │
│  Global CLAUDE.md + rules that apply everywhere.        │
├─────────────────────────────────────────────────────────┤
│  Layer 2: Scaffold  (cc-init)                           │
│  One-time per-project bootstrap.                        │
│  Symlinks shared rules. Copies templates.               │
├─────────────────────────────────────────────────────────┤
│  Layer 3: Healthcheck  (cc-doctor)                      │
│  Cross-project compliance validation.                   │
│  Catches drift before it becomes debt.                  │
└─────────────────────────────────────────────────────────┘
```

---

## Quick Start

```bash
# 1. Clone engineering-dna somewhere permanent
git clone https://github.com/sorialex/engineering-dna ~/engineering-dna

# 2. Add to PATH
export PATH="$HOME/engineering-dna/bin:$PATH"
# (add this line to ~/.bashrc or ~/.zshrc)

# 3. Bootstrap a project — sets up global ~/.claude/ and project .claude/ in one shot
cd ~/projects/my-project
cc-init

# 4. Verify compliance
cc-doctor
```

---

## What's Inside

**`rules/`** — Opinionated, actionable rules files loaded by Claude Code:
- `ai-agent-behavior.md` — Defensive rules against scope creep, phantom context, premature abstraction
- `testing-strategy.md` — Testing standards and patterns
- `commit-conventions.md` — Conventional commits policy
- `documentation.md` — Documentation-first rules
- `code-review.md` — Pre-commit checklist
- `next-step-handoff.md` — Agent writes NEXT.md at task completion for morning triage
- `roadmap-tracking.md` — Agent updates ROADMAP.md in engineering-dna root to track cross-project progress

**`bin/`** — CLI tools:
- `cc-init` — Idempotent project bootstrapper (symlinks, templates, gitignore)
- `cc-doctor` — Healthcheck for one or all projects
- `project-pulse` — Morning triage report: git state, Claude sessions, BACKLOG, ROADMAP

**`hooks/`** — Claude Code hook infrastructure (no active hooks; see `hooks/README.md`)

**`templates/`** — Starter `CLAUDE.md`, `settings.local.json`

See [HOW_IT_WORKS.md](HOW_IT_WORKS.md) for architecture details.

---

## Philosophy

**Rules, not tools.** This framework uses Claude Code's native infrastructure: `CLAUDE.md`, `.claude/rules/`, hooks, `settings.json`. No external dependencies. No SaaS. No lock-in. If Claude Code's native features change, this framework adapts.

**Symlinks over copies.** Shared rules live in one place and propagate automatically. When you improve a rule, every project picks it up on the next session.

**Convention over configuration.** The defaults are opinionated. Override only what you need to override, in the place closest to where the override applies.

**Escape hatches at every layer.** Project-level rules override shared rules. `CLAUDE.local.md` overrides project `CLAUDE.md`. Nothing is locked.

---

## Related Projects

- [ai-coding-patterns](https://github.com/sorialex/ai-coding-patterns) — Behavioral catalog of AI agent failure modes covering patterns P-01 through P-10: UI completeness, state lifecycle, code duplication, structural fixes, and complexity thresholds. The rules in `rules/ai-agent-behavior.md` are the operationalized mitigations from that catalog.
- [test-knowledge](https://github.com/sorialex/test-knowledge) — Testing taxonomy and knowledge base. Feeds into `rules/testing-strategy.md`.

---

## License

MIT
