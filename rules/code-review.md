# Code Review Checklist

Run this checklist before committing or requesting review. These are gates, not suggestions.

---

## Tests

- [ ] All existing tests pass
- [ ] New code has tests covering the happy path and at least one failure mode
- [ ] No tests were disabled or skipped to make CI pass

## Code Quality

- [ ] No `console.log`, `print`, `debugger`, `pdb.set_trace()`, or similar debug artifacts left in the code
- [ ] No commented-out code committed (delete it; git history preserves it)
- [ ] No `TODO` or `FIXME` comments that weren't there before (if you're adding one, it needs a ticket number)
- [ ] Type annotations present for all new function signatures (Python and TypeScript)
- [ ] Error handling is explicit — no bare `except:` or empty `catch {}` blocks
- [ ] Linter and formatter have been run (no new lint warnings)

## Security

- [ ] No hardcoded secrets, tokens, passwords, or API keys
- [ ] No hardcoded absolute paths or environment-specific values
- [ ] User input is validated at system boundaries
- [ ] No SQL queries constructed via string concatenation

## Dependencies

- [ ] Any new dependency is justified — not added for something trivially implementable without it
- [ ] New dependencies are pinned to a specific version
- [ ] No dependency added that conflicts with existing ones

## Documentation

- [ ] README updated if user-facing behavior changed
- [ ] CHANGELOG entry added if this is a release-worthy change
- [ ] CLI `--help` updated if flags or commands changed
- [ ] Inline comments added only where the "why" is non-obvious

## Commit

- [ ] Commit message follows `type(scope): description` format
- [ ] Commit is atomic — one logical change, not a grab-bag
- [ ] Branch is up to date with main/trunk (no unnecessary merge conflicts)

---

If any item is unchecked, either fix it or consciously decide to defer it and note the deferral in the PR description.
