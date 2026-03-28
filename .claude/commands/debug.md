---
allowed-tools: Read, Bash(git:*), Grep
description: Trace an error or stack trace to its root cause
---

# Debug

Investigate an error, stack trace, or unexpected behavior to find the root cause.

## Instructions

Given an error message, stack trace, or description of unexpected behavior:

1. **Parse the error** — extract file paths, line numbers, function names, and error types
2. **Read the relevant source files** at the indicated locations
3. **Trace the call chain** — follow function calls upward to find where the bad state originates
4. **Check recent changes** with `git log -p --follow <file>` if the bug might be a regression
5. **Identify the root cause** — not just the symptom, but why it happens
6. **Suggest a fix** with clear reasoning

Present findings as:
- **Error**: what's happening
- **Location**: file:line
- **Root cause**: why it's happening
- **Fix**: what to change

Do NOT apply fixes automatically — present them for user approval.

## Error / Description

$ARGUMENTS
