# Contributing a Local Rule Back to Shared

How to promote a project-specific rule to a shared rule that all projects benefit from.

---

## When to Promote

A local rule is ready to promote when:
- It has been useful across multiple sessions in the same project.
- You find yourself copying it to other projects manually.
- It addresses a pattern that would apply broadly, not just to this project's domain.

If the rule is highly project-specific (e.g., "always call the internal API via the gateway"), keep it local.

---

## Workflow

### 1. Validate the rule locally

The rule lives in `.claude/rules/` in your project. It's been running for a few sessions and you trust it:

```
project/.claude/rules/
├── shared/                ← symlink
└── error-handling.md      ← candidate for promotion
```

### 2. Review for generality

Open the file and ask:
- Does any language reference a specific project, team, or system? Remove or generalize it.
- Is the rule actionable in any codebase, or does it depend on project context? Generalize it.
- Does it conflict with or duplicate an existing shared rule? Reconcile the conflict first.

### 3. Move it to engineering-dna

```bash
mv .claude/rules/error-handling.md ~/engineering-dna/rules/error-handling.md
```

### 4. Commit to engineering-dna

```bash
cd ~/engineering-dna
git add rules/error-handling.md
git commit -m "feat(rules): add error-handling guidelines"
git push
```

### 5. Verify propagation

All projects with the symlink pick up the new rule immediately — no action needed on individual projects.

```bash
# Confirm the rule is visible via the symlink in the original project
ls -la project/.claude/rules/shared/
# error-handling.md should appear
```

### 6. Remove the local copy

The local copy is now redundant. Delete it:

```bash
rm project/.claude/rules/error-handling.md
```

If the local version had project-specific additions on top of the general rule, extract the general part to `engineering-dna`, and keep only the project-specific additions in a local override file.

---

## The Feedback Loop

```
Local rule (one project)
    → validate across sessions
    → generalize
    → promote to engineering-dna/rules/
    → all projects benefit via symlink
    → rule evolves through real usage
    → repeat
```

This is how engineering-dna grows: rules are earned through real use, not invented speculatively.
