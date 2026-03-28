---
allowed-tools: Bash(git:*), Read
description: Run git blame on a file region and explain the change history
---

# Blame & Explain

Trace the history of a file or specific lines to understand why code looks the way it does.

## Instructions

Given a file (and optionally line range), investigate its history:

1. **Run `git blame`** on the specified file/region
2. **Identify the key commits** that shaped the current code
3. **For each significant commit**, run `git show --stat <hash>` to understand the broader context
4. **Explain the timeline**: who changed what, when, and (from commit messages) why
5. **Highlight any interesting patterns** — frequent changes, reverts, or refactors

Output a clear narrative of how the code evolved.

## Target

$ARGUMENTS
