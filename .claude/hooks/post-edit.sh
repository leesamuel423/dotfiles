#!/bin/bash
# Consolidated PostToolUse hook for Write|Edit operations
# Combines: auto-format, shellcheck, TODO count, file length warning, test file notice

file="$CLAUDE_FILE_PATH"
[ -z "$file" ] && exit 0

# Auto-format by file type
case "$file" in
  *.py) isort --quiet --profile black "$file" 2>/dev/null; black --quiet "$file" 2>/dev/null ;;
  *.js|*.ts|*.tsx|*.jsx|*.css|*.html|*.json|*.md|*.yaml|*.yml) prettier --write "$file" 2>/dev/null ;;
esac

# Shellcheck for shell scripts
case "$file" in
  *.sh|*.bash|*.zsh) shellcheck "$file" 2>&1 | head -20 ;;
esac

# TODO/FIXME marker count
count=$(grep -cE '(TODO|FIXME|HACK|XXX)' "$file" 2>/dev/null || echo 0)
[ "$count" -gt 0 ] && echo "Note: $count TODO/FIXME markers in $file" >&2

# File length warning
lines=$(wc -l < "$file" 2>/dev/null || echo 0)
[ "$lines" -gt 300 ] && echo "Warning: $file is $lines lines — consider splitting" >&2

# Test file modification notice
case "$file" in
  *test_*|*_test.*|*.test.*|*.spec.*|*tests/*) echo "Notice: Test file modified — verify intentional" >&2 ;;
esac

exit 0
