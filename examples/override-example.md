# Override Example

How to override a shared rule for a specific project without touching the shared rule itself.

---

## Scenario

The shared `testing-strategy.md` rule says: prefer unit tests for pure logic, integration tests for boundaries.

This project is an end-to-end data pipeline. Integration tests against the real pipeline are more valuable than unit tests for individual steps. The testing priority is reversed.

---

## Solution

Create a project-level override file in `.claude/rules/`:

```bash
touch .claude/rules/testing-override.md
```

Contents of `.claude/rules/testing-override.md`:

```markdown
# Testing Override: Pipeline Project

For this project, integration tests against the full pipeline take priority over unit tests.

Rationale: pipeline steps have minimal logic but complex coordination. The bugs we care about
appear at the boundaries between steps, not inside individual steps.

## Adjusted priorities

1. Integration tests covering end-to-end pipeline runs with real data samples (highest priority)
2. Unit tests for transformation logic with complex branching
3. Unit tests for pure utility functions (lowest priority, only when logic is non-trivial)

This overrides the default priority order in shared/testing-strategy.md.
```

---

## Resulting Directory Structure

```
project/.claude/rules/
├── shared/                        ← symlink → ~/engineering-dna/rules/
│   ├── ai-agent-behavior.md
│   ├── code-review.md
│   ├── commit-conventions.md
│   ├── documentation.md
│   ├── session-tracking.md
│   └── testing-strategy.md
└── testing-override.md            ← project-specific override
```

Claude Code loads all `.md` files from `.claude/rules/` (including inside `shared/`). The override file loads alongside the shared rule. When there's a conflict, the override's directives apply because they are more specific and load after the shared rule alphabetically.

---

## When to Use Overrides

- The shared rule makes the right default choice, but this project is a genuine exception.
- The exception is project-specific and would not benefit other projects.
- The override is temporary (e.g., during a migration) — note an expiry condition in the file.

**When not to use overrides**: if you find yourself overriding the same rule in three projects, the shared rule is wrong. Update the shared rule and delete the overrides.

---

## Cleaning Up

When the project no longer needs the override, delete the file:

```bash
rm .claude/rules/testing-override.md
```

The shared rule resumes its default effect immediately.
