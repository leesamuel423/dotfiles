---
allowed-tools: Bash, Read, Edit
description: Run type checker, explain errors, and offer fixes
---

# Type Check

Run the project's type checker and help resolve any errors.

## Project Detection

- TypeScript config: !`cat tsconfig.json 2>/dev/null | head -30 || echo "no tsconfig"`
- Python type config: !`grep -A 5 'mypy\|pyright\|pytype' pyproject.toml 2>/dev/null || echo "no python type config"`

## Instructions

1. **Run the type checker**:
   - TypeScript: `npx tsc --noEmit`
   - Python: `mypy` or `pyright` (whichever is configured)
2. **Parse the output** and group errors by file
3. **For each error**, explain:
   - What the type checker expects
   - Why the current code doesn't satisfy it
   - The simplest correct fix
4. **Offer to apply fixes** — wait for user confirmation before editing
5. **Re-run the type checker** after fixes to verify

If the user specifies a file, focus there:

$ARGUMENTS
