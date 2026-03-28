---
allowed-tools: Bash(git:*)
description: Generate a changelog between two git refs
---

# Generate Changelog

Generate a human-readable changelog from git history.

## Context

- Recent tags: !`git tag --sort=-creatordate | head -10`
- Current branch: !`git branch --show-current`

## Instructions

Given the user's input (two refs, a tag, or "since last tag"), generate a changelog grouped by type:

1. **Determine the range** from user input. If none given, use the last tag to HEAD
2. **Fetch commits** in that range with `git log --oneline <from>..<to>`
3. **Group commits** by conventional commit type:
   - **Features** (feat)
   - **Bug Fixes** (fix)
   - **Breaking Changes** (BREAKING CHANGE or !)
   - **Other** (docs, chore, refactor, etc.)
4. **Output a clean markdown changelog** with the grouped entries

## Input

$ARGUMENTS
