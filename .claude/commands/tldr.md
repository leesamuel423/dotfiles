---
allowed-tools: Read, Bash(git:*, gh:*), Grep
description: Summarize a file, directory, or pull request
---

# TL;DR Summary

Generate a concise summary of the specified target.

## Instructions

Based on what the user provides:

### For a file:
- Read it and summarize: purpose, key functions/classes, notable patterns

### For a directory:
- List files, read key ones, explain the module's role and structure

### For a PR (number or URL):
- Fetch PR details with `gh pr view <number>`
- Fetch diff with `gh pr diff <number>`
- Summarize: what changed, why, and any risks

### For a commit or range:
- Show the commit(s) with `git show` or `git log`
- Summarize the changes and their purpose

Output should be brief — a paragraph or short bullet list. The whole point is speed.

## Target

$ARGUMENTS
