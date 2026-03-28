---
allowed-tools: Bash(git:*), Read
description: Analyze uncommitted changes and create a well-formatted conventional commit
disable-model-invocation: true
argument-hint: "[message hint or options]"
---

# Intelligent Git Commit

Analyze all uncommitted changes and create a commit following conventional commit standards.

## Context

### User Hint
$ARGUMENTS

### Current Status
- Working tree status: !`git status --porcelain`
- Staged changes: !`git diff --cached --stat`
- Unstaged changes: !`git diff --stat`

### Detailed Changes
- Full staged diff: !`git diff --cached`
- Full unstaged diff: !`git diff`

### Recent Commit History
- Last 5 commits for style context: !`git log --oneline -5`

## Instructions

### 0. Check for changes
If the working tree is clean (no staged or unstaged changes, no untracked files), tell the user there is nothing to commit and stop.

### 1. Analyze the changes
- What files were modified/added/deleted
- The nature of changes (feature, fix, docs, style, refactor, test, chore)
- The primary purpose of the changes
- If `$ARGUMENTS` was provided, use it as a hint for the commit message intent

### 2. Generate a conventional commit message
Format:
```
<type>(<scope>): <subject>

<body>

<footer>
```

Where:
- **type**: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert
- **scope**: optional, the module or area affected (e.g., `auth`, `api`, `ui`)
- **subject**: imperative mood, lowercase, no period at end, <50 chars
- **body**: optional, explain what and why vs how, wrap at 72 chars
- **footer**: optional, breaking changes or issue references

### 3. Present the message and wait for approval
Show the proposed commit message to the user. **Do not proceed until the user confirms.** If the user requests changes, revise and present again.

### 4. Stage appropriate files
- Use `git add <specific-files>` — stage only the files relevant to this commit
- **Never use `git add -A` or `git add .`** — these can accidentally stage sensitive files (.env, credentials, keys), large binaries, or unrelated work-in-progress
- Before staging, check that no sensitive files (.env, credentials, private keys, tokens) are in the changeset. Warn the user if any are found.

### 5. Create the commit
Use a HEREDOC to safely handle special characters:
```bash
git commit -m "$(cat <<'EOF'
type(scope): subject

body

footer
EOF
)"
```

## Examples

- `feat(auth): add OAuth2 login flow`
- `fix: resolve telescope picker crash on empty results`
- `docs: update installation instructions for macOS Sonoma`
- `refactor(config): simplify prompt configuration using starship`
- `chore: update tmux plugins to latest versions`

## Notes
- Group related changes into logical commits
- If changes span multiple concerns, suggest splitting into multiple commits
- Match the style of recent commits shown above when possible

