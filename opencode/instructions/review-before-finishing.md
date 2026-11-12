# Review code changes before finishing

Whenever you add, delete, or change code, review the complete task diff before giving the final answer. Read the surrounding implementation and affected callers, not just the changed lines.

- Remove code made unnecessary by the change: unused imports, variables, functions, dead branches, obsolete comments, and abandoned implementation paths.
- Look for duplicated logic in the changed code and relevant existing code. Keep one source of truth where the behavior is genuinely the same; do not merge distinct responsibilities just because they look similar.
- Review affected tests alongside existing tests. Remove or consolidate duplicate or obsolete tests only after verifying that retained tests cover the same behavior, assertions, and relevant failure cases, or that the behavior is intentionally no longer supported. Similar setup alone does not make tests redundant.
- Never delete, skip, or weaken a test merely because it fails or is inconvenient. Preserve distinct regression cases, boundary cases, and contract coverage.
- Keep cleanup tied to the task. Do not delete unrelated code or tests, or overwrite changes you did not make. Report unrelated findings instead of expanding the task.
- After cleanup, run the relevant tests and checks, then inspect the final diff again for accidental changes, remaining duplication, and unnecessary code. State any checks you could not run and any unresolved findings in the final answer.
