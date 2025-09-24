---
allowed-tools: Bash(git:*), Read, Write
description: Analyze uncommitted changes and create a well-formatted conventional commit
---

# Intelligent Git Commit

Analyze all uncommitted changes and create a commit following conventional commit standards.

## Analysis Phase

### Current Status
- Working tree status: !`git status --porcelain`
- Staged changes: !`git diff --cached --stat`
- Unstaged changes: !`git diff --stat`

### Detailed Changes
- Full staged diff: !`git diff --cached`
- Full unstaged diff: !`git diff`

### Recent Commit History
- Last 5 commits for context: !`git log --oneline -5`

## Instructions

Based on the changes above:

1. **Analyze the changes** to understand:
   - What files were modified/added/deleted
   - The nature of changes (feature, fix, docs, style, refactor, test, chore)
   - The primary purpose of the changes

2. **Generate a conventional commit message** following this format:
   ```
   <type>: <subject>

   <body>

   <footer>
   ```

   Where:
   - **type**: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert
   - **subject**: imperative mood, lowercase, no period at end, <50 chars
   - **body**: optional, explain what and why vs how, wrap at 72 chars
   - **footer**: optional, breaking changes or issue references

3. **Stage appropriate files** (if not already staged):
   - Use `git add <files>` for specific files
   - Or `git add -A` for all changes

4. **Create the commit** with the generated message:
   ```bash
   git commit -m "type: subject" -m "body" -m "footer"
   ```

## Examples of Good Commit Messages

- `feat: add intelligent commit command for better git workflow`
- `fix: resolve telescope picker crash on empty results`
- `docs: update installation instructions for macOS Sonoma`
- `refactor: simplify prompt configuration using starship`
- `chore: update tmux plugins to latest versions`

## Notes
- Group related changes into logical commits
- Don't commit generated files, logs, or sensitive data
- If changes span multiple concerns, consider splitting into multiple commits
- Review the proposed message before committing