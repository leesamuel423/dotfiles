---
allowed-tools: Bash, Read
description: Compare installed Homebrew packages against a tracked list
---

# Homebrew Audit

Compare currently installed Homebrew packages against a tracked package list.

## Current State

- Installed formulae: !`brew list --formulae 2>/dev/null`
- Installed casks: !`brew list --cask 2>/dev/null`
- Tracked Brewfile: !`cat ~/dotfiles/Brewfile 2>/dev/null || cat Brewfile 2>/dev/null || echo "no Brewfile found"`

## Instructions

1. **Compare installed packages** against the Brewfile (or a package list the user provides)
2. **Report**:
   - **Tracked & installed** — all good
   - **Tracked but missing** — in Brewfile but not installed
   - **Installed but untracked** — installed but not in Brewfile
3. **Flag notable untracked packages** — large apps, dev tools, or anything that looks intentional
4. **Suggest updates** to the Brewfile to capture the current state

If the user wants to focus on formulae or casks only:

$ARGUMENTS
