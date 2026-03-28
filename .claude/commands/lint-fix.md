---
allowed-tools: Bash, Read, Edit
description: Run linters and formatters, then auto-fix issues
---

# Lint & Fix

Run project linters/formatters and fix any issues found.

## Project Detection

- Package.json scripts: !`cat package.json 2>/dev/null | grep -A 20 '"scripts"' || echo "no package.json"`
- Python config: !`ls pyproject.toml setup.cfg .flake8 .ruff.toml ruff.toml 2>/dev/null || echo "no python config"`
- Config files: !`ls .eslintrc* .prettierrc* biome.json 2>/dev/null || echo "no lint configs"`

## Instructions

1. **Detect the project's linting/formatting stack** from config files above
2. **Run the appropriate tools**:
   - JS/TS: `eslint --fix`, `prettier --write`
   - Python: `ruff check --fix`, `black`
   - Go: `gofmt`, `golangci-lint`
   - Or whatever the project uses
3. **Show a summary** of what was fixed automatically
4. **For issues that can't be auto-fixed**, explain each one and suggest a manual fix
5. **Apply manual fixes** with Edit if the user approves

If the user specifies a file or directory, scope to that. Otherwise, run on changed files:

$ARGUMENTS
