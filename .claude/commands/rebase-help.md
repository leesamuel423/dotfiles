---
allowed-tools: Bash(git:*), Read
description: Analyze rebase conflicts and suggest resolutions
---

# Rebase Conflict Helper

Analyze the current rebase state and help resolve conflicts.

## Current State

- Rebase status: !`git status`
- Conflicting files: !`git diff --name-only --diff-filter=U 2>/dev/null`
- Rebase in progress: !`ls .git/rebase-merge 2>/dev/null || ls .git/rebase-apply 2>/dev/null || echo "No rebase in progress"`
- Current step: !`cat .git/rebase-merge/msgnum 2>/dev/null`/!`cat .git/rebase-merge/end 2>/dev/null`

## Instructions

1. **Identify all conflicting files** from `git status`
2. **Read each conflicting file** and find the conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
3. **For each conflict**, explain:
   - What the "ours" side (current branch) changed
   - What the "theirs" side (incoming) changed
   - A recommended resolution with reasoning
4. **Do NOT auto-resolve** — present options and let the user decide
5. After the user picks a resolution, apply it with `Edit` and `git add`

If the user wants help with a specific file:

$ARGUMENTS
