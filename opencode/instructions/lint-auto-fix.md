# Use lint auto-fixes before manual edits

When checking or fixing lint issues, inspect the project's scripts and linter configuration for an existing auto-fix command or supported fix flag.

- If auto-fixing is available, use the project's lint fix command rather than a check-only command. Do not manually edit issues the linter can fix automatically.
- Keep auto-fixes scoped to the task's files where supported. Do not enable unsafe fixes without explicit approval.
- Review the resulting diff, then manually fix only the remaining issues that cannot be auto-fixed.
- Rerun the relevant lint check after fixes and report any unresolved issues or checks you could not run.
