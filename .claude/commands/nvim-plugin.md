---
allowed-tools: Read, Edit, Bash
description: Add or configure a Neovim plugin
---

# Neovim Plugin Manager

Add, configure, or update a Neovim plugin.

## Current Neovim Config

- Plugin manager config: !`ls ~/dotfiles/.config/nvim/lua/plugins/ 2>/dev/null || ls ~/.config/nvim/lua/plugins/ 2>/dev/null || echo "no plugins dir found"`
- Lazy-lock: !`cat ~/dotfiles/.config/nvim/lazy-lock.json 2>/dev/null | head -5 || echo "no lazy-lock"`

## Instructions

Given a plugin name or desired functionality:

1. **Find the plugin** — search for the correct GitHub repo/name
2. **Read the existing plugin config** to understand the project's pattern (lazy.nvim, packer, etc.)
3. **Add the plugin spec** following the existing convention:
   - For lazy.nvim: add to the appropriate file in `lua/plugins/`
   - Include sensible default config
   - Add keymaps if the plugin needs them
4. **Show the user** what was added and any manual steps (like running `:Lazy sync`)

If the user wants to configure an existing plugin:
1. Find its current config
2. Make the requested changes
3. Explain what changed

## Plugin / Request

$ARGUMENTS
