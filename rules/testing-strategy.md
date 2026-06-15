# Testing Strategy

These rules define how tests are written and organized in this codebase.

---

## Test Selection

**Unit tests for pure logic.** Functions with no side effects, no I/O, and no external dependencies get unit tests. Fast, isolated, deterministic.

**Integration tests for boundaries.** Code that touches a database, filesystem, network, or external API gets integration tests that exercise the real boundary. Do not mock the database in integration tests — mocks let divergence accumulate silently.

**No tests for trivial delegation.** A function that does nothing but call another function with its arguments does not need its own test.

---

## Test Structure

**AAA pattern consistently.** Every test: Arrange (set up), Act (call the thing), Assert (check the result). Keep each phase visually distinct. Do not mix setup into assertions.

**One behavior per test.** Each test verifies one specific behavior. If a test has multiple `assert` statements checking unrelated things, split it.

**No test interdependence.** Tests must be runnable in any order. No shared mutable state between tests. No test that only passes if another test ran first.

---

## Test Names

**Describe behavior, not implementation.** Name tests after what they verify, not what code they call:
- `should_reject_negative_amounts` — good
- `test_validate` — useless
- `test_validate_raises_on_negative_input` — acceptable

**Test names as documentation.** A developer new to the codebase should understand a feature's behavior by reading its test names. If the names don't tell the story, rename them.

---

## Coverage

**Regression tests for every bug.** Before fixing a bug, write a test that reproduces it and fails. Then fix the bug. The test proves the fix and prevents regression.

**Happy path + one failure mode minimum.** Every new function needs at least a happy path test and one test for an error or edge case. More as complexity warrants.

**Snapshot tests for output stability.** Use snapshot/golden tests for CLI output, serialized formats, or rendered templates where exact output matters and changes should be deliberate.

**Ground-truth tests when an oracle exists.** If there's a known-correct reference implementation or a mathematical truth (e.g., checksums, encodings), write tests that validate against it directly.

---

## Maintenance

**Tests are production code.** Apply the same quality bar: clear names, no duplication, no dead code. A flaky test is a broken test — fix or delete it.

**Do not disable tests to make CI pass.** If a test is failing, diagnose and fix the root cause. Skipping or commenting out tests hides problems; it doesn't solve them.
