# Commit Conventions

All commits in this codebase follow Conventional Commits.

---

## Format

```
type(scope): description
```

- Lowercase throughout. No period at the end.
- Subject line under 72 characters.
- Scope is **mandatory** — it identifies the module, layer, or area affected.
- Body is optional but recommended when "why" isn't obvious from the description.

---

## Types

| Type | Use for |
|------|---------|
| `feat` | New user-facing feature |
| `fix` | Bug fix |
| `refactor` | Code change with no behavior change |
| `test` | Adding or modifying tests |
| `docs` | Documentation only |
| `chore` | Tooling, dependencies, config |
| `ci` | CI/CD pipeline changes |
| `perf` | Performance improvement |
| `style` | Formatting, whitespace (no logic change) |

---

## Scope

The scope identifies what was changed, not how. Use the module name, layer, or feature area:

```
feat(auth): add refresh token rotation
fix(api): handle empty response from upstream
refactor(db): extract connection pooling into module
```

Use `*` only when a change genuinely spans multiple unrelated areas — rare.

---

## Breaking Changes

Add a footer to the commit body:

```
feat(api): remove deprecated v1 endpoints

BREAKING CHANGE: /v1/users and /v1/orders are removed. Migrate to /v2/.
```

---

## Atomicity

**One logical change per commit.** A commit should be a complete, reviewable unit of work. "WIP" commits are acceptable on feature branches but must be squashed before merging.

**If a commit touches more than 5 files**, stop and ask whether it should be split. Cross-cutting changes (rename a constant everywhere) are an exception — they're inherently wide but logically single.

---

## Commit Message Quality

Write commit messages for your future self six months from now:

- What changed (the subject line)
- Why it changed (the body, when non-obvious)

"fix(parser): correct off-by-one in token slice" — good.
"fix stuff" — not a commit message.

Reference issue numbers in the body when a commit closes a tracked issue:
```
Closes #42
```
