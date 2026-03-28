# Dotfiles Repo

## Structure
- `.claude/` — Claude Code settings, hooks, and plugins
- `.config/aerospace/` — AeroSpace window manager config
- `.config/git/` — Git configuration
- `.config/nvim/` — Neovim configuration
- `.zshrc` — Zsh shell config
- `.tmux.conf` — Tmux configuration
- `scripts/` — Utility scripts (commit, push, nvim-switch, etc.)
- `Makefile` — Automation targets (run from anywhere via `make -f ~/Makefile`)

## Key Make Targets
- `make commit` — Custom git commit workflow
- `make push` — Push all unpushed commits across branches
- `make nvim-switch` — Switch between Neovim config profiles
- `make agent-links` — Create AGENTS.md and symlink CLAUDE.md/GEMINI.md to it
- `make cppbuild` / `make cppclean` — C++17 compilation

## Conventions
- Shell scripts must pass `shellcheck`
- Claude Code settings live in `.claude/` (both repo-tracked and synced to `~/.claude/`)
- Neovim configs are managed via `scripts/nvim-switch.sh` with profile isolation
