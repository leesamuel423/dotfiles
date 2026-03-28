---
allowed-tools: Bash, Read
description: Diff active system configs against the dotfiles repo
---

# Dotfiles Sync Check

Compare currently active config files against what's tracked in the dotfiles repo.

## Key Config Locations

- Dotfiles repo: !`git -C ~/dotfiles ls-files`

## Instructions

1. **Identify tracked configs** from the dotfiles repo (e.g., `.zshrc`, neovim config, aerospace, etc.)
2. **For each tracked file**, diff the repo version against the active version:
   - `diff ~/dotfiles/<path> ~/<active-path>`
3. **Report**:
   - **In sync** — no differences
   - **Repo ahead** — dotfiles has changes not yet deployed
   - **System ahead** — active config has changes not committed to dotfiles
   - **Missing** — tracked in repo but not present on system (or vice versa)
4. **Suggest actions**:
   - Copy from repo to system (deploy)
   - Copy from system to repo (capture)
   - Or mark as intentionally different

If the user specifies particular configs to check:

$ARGUMENTS
