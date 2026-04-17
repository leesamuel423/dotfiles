---
name: commit-pr
description: Commit changes in logical chunks, push, and create or update a PR
disable-model-invocation: true
allowed-tools: Bash(git:*), Bash(gh:*), Read
argument-hint: "[optional: description of changes]"
---

# Commit, Push & PR

Full pipeline: branch creation (if needed) → logical commits → push → PR creation/update.

## Context

### User Hint
$ARGUMENTS

### Current Branch & Remote
- Current branch: !`git branch --show-current`
- Default branch: !`git remote show origin 2>/dev/null | grep 'HEAD branch' | sed 's/.*: //'`
- Remote branches: !`git branch -r --list 'origin/*' | head -20`

### Working Tree Status
- Status: !`git status --porcelain`
- Staged diff (stat): !`git diff --cached --stat`
- Unstaged diff (stat): !`git diff --stat`
- Untracked files: !`git ls-files --others --exclude-standard`

### Detailed Changes
- Full staged diff: !`git diff --cached`
- Full unstaged diff: !`git diff`

### Recent History
- Last 10 commits: !`git log --oneline -10`

### Existing PR
- PR for current branch: !`gh pr view --json number,title,url,body,baseRefName 2>/dev/null || echo "No PR exists for this branch"`

## Instructions

### Step 0: Preconditions

If the working tree is clean (no staged changes, no unstaged changes, no untracked files), tell the user there is nothing to commit and **stop**.

Scan the changeset for sensitive files (.env, credentials, private keys, tokens, secrets). If any are found, **warn the user and exclude them** from all subsequent staging operations.

### Step 1: Detect Scenario

Check the current branch name:

- **Scenario A — Protected branch**: If on `main`, `master`, `staging`, or `develop`, a new feature branch is required.
- **Scenario B — Feature branch**: Already on a topic branch. No branch creation needed.

---

### Step 2A: Protected Branch Flow (new branch)

1. Analyze the changes and `$ARGUMENTS` to determine the type and scope.
2. Generate a branch name following the pattern `type/short-description` (e.g., `feat/add-commit-pr-command`, `fix/auth-token-refresh`).
3. Create and switch to the branch:
   ```bash
   git checkout -b <branch-name>
   ```

### Step 2B: Feature Branch Flow (existing branch)

No branch creation needed. Determine the PR target branch:
- If `origin/staging` exists → target `staging`
- Otherwise → target the default branch from remote

---

### Step 3: Chunk & Commit

Group the changes into logical commits. Use directory, module, or concern as grouping heuristics. **A single commit is perfectly fine if all changes are cohesive — do not force artificial splits.**

For **each** chunk:

1. Stage only the specific files for this chunk — **never use `git add -A` or `git add .`**:
   ```bash
   git add file1 file2 ...
   ```
2. Commit using a conventional commit message with a HEREDOC:
   ```bash
   git commit -m "$(cat <<'EOF'
   type(scope): subject

   body
   EOF
   )"
   ```

Repeat until all changes are committed.

---

### Step 4: Push

- **New branch** (no upstream): `git push -u origin <branch-name>`
- **Existing upstream**: `git push`
- **Never force-push.** If the push fails, report the error and stop.

---

### Step 5: Create or Update PR

Determine the target base branch (from Step 2A or 2B).

#### No existing PR → Create

Use `gh pr create`:

```bash
gh pr create --base <target-branch> --title "<title>" --body "$(cat <<'EOF'
## Problem
[What prompted this change]

## Change
[What was done — bullet points per commit/area]

## Effect
[What's different after this lands]
EOF
)"
```

- Keep the title under 70 characters.
- Fill in each section based on the actual changes and `$ARGUMENTS`.
- Only include a `## Tradeoffs` section if there are meaningful alternatives considered or compromises made. Omit it otherwise.

#### Existing PR → Update

Use `gh pr edit` to update the body, incorporating the new commits:

```bash
gh pr edit <number> --body "$(cat <<'EOF'
...updated description...
EOF
)"
```

---

### Step 6: Summary

Print a final summary:

```
Branch:   <branch-name>
Target:   <base-branch>
Commits:  <count>
PR:       <url>
Status:   Created | Updated
```
