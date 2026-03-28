---
allowed-tools: Bash(git:*), Read, Grep
description: Find unused exports, functions, and imports in the codebase
---

# Dead Code Finder

Scan for potentially unused code in the project.

## Project Files

- All tracked files: !`git ls-files`

## Instructions

Given a file, directory, or the whole project:

1. **Identify exports/functions** defined in the target
2. **Search for usages** across the codebase using Grep
3. **Flag as potentially dead** any symbol that:
   - Is exported but never imported elsewhere
   - Is defined but never called (within its scope)
   - Is imported but never referenced
4. **Exclude false positives**:
   - Entry points (main, index files)
   - Framework-required exports (route handlers, middleware, hooks)
   - Test files referencing test subjects
   - Dynamic imports or reflection-based usage
5. **Present findings** grouped by file with confidence level

## Target

$ARGUMENTS
