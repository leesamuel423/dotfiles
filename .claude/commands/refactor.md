---
allowed-tools: Read, Edit
description: Suggest and apply refactoring for a file or function
---

# Refactor

Analyze code and suggest targeted refactoring improvements.

## Instructions

Given a file or function name:

1. **Read the target code** and its surrounding context
2. **Identify refactoring opportunities**:
   - Extract repeated logic into functions
   - Simplify complex conditionals
   - Reduce nesting depth
   - Improve naming clarity
   - Remove dead code
   - Apply appropriate design patterns
3. **Present each suggestion** with:
   - What to change and why
   - Before/after comparison
   - Risk assessment (safe / needs testing)
4. **Wait for approval** before applying any changes
5. **Apply approved changes** using Edit, one at a time

Keep refactoring minimal and purposeful — don't rewrite working code for style alone.

## Target

$ARGUMENTS
