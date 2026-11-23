# Use the built-in tools before shell commands

Always try the dedicated tool first. It returns structured, truncated-safe output and keeps file access visible, while a raw command duplicates it less reliably.

- Search file contents with Grep, not `grep`/`rg`.
- Find files by name or pattern with Glob, not `find`.
- Read files with Read, not `cat`/`head`/`tail`/`less`.
- Change files with Edit/Write, not `sed`/`awk`/`tee` or shell redirection.
- List a directory with Read, not `ls`.

Use the shell only for what a tool cannot do, such as running builds, tests, git or package managers, or feeding a tool's output through a pipeline. When the shell is needed, keep it to that step and do not reimplement a tool call inside it.
