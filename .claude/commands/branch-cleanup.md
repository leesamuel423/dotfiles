---
allowed-tools: Bash(git:*)
description: List and delete merged or stale local branches
---

# Branch Cleanup

Find and clean up merged or stale local branches.

## Current State

- All local branches: !`git branch`
- Current branch: !`git branch --show-current`
- Merged branches: !`git branch --merged`
- Remote tracking info: !`git branch -vv`

## Instructions

1. **List candidates for deletion**:
   - Branches already merged into the current/default branch
   - Branches whose remote tracking branch is gone
2. **Never suggest deleting**: `main`, `master`, `develop`, or the current branch
3. **Present a summary table** of branches with:
   - Branch name
   - Last commit date
   - Merge status
   - Recommendation (safe to delete / keep)
4. **Wait for user confirmation** before deleting anything
5. Delete confirmed branches with `git branch -d` (safe delete, not `-D`)

$ARGUMENTS
