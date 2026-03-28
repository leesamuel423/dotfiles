---
allowed-tools: Bash(git:*), Read
description: Review staged changes for bugs, security issues, and style before committing
---

# Review Staged Changes

Perform a thorough pre-commit review of all staged changes.

## Staged Changes

- Staged files: !`git diff --cached --name-only`
- Staged diff: !`git diff --cached`
- Staged stats: !`git diff --cached --stat`

## Instructions

Review every staged change for the following categories:

### 1. Bugs & Logic Errors
- Off-by-one errors, null/undefined access, race conditions
- Incorrect control flow, missing error handling
- Wrong variable or function usage

### 2. Security
- Hardcoded secrets, credentials, or API keys
- Injection vulnerabilities (SQL, XSS, command injection)
- Insecure data handling or missing input validation

### 3. Style & Consistency
- Naming conventions, formatting issues
- Dead code, debug statements left behind (console.log, print, debugger)
- Inconsistency with surrounding code patterns

### 4. Performance
- Unnecessary loops, redundant computations
- N+1 queries, missing indexes in schema changes

## Output Format

For each issue found:
- **File:line** — description of the issue
- **Severity**: critical / warning / nit
- **Suggestion**: how to fix it

If everything looks good, say so. Don't invent issues.

$ARGUMENTS
