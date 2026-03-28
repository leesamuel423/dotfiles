---
allowed-tools: Read, Grep, Bash
description: Show the dependency graph for a file or module
---

# Dependency Graph

Map imports and dependencies for a file or module.

## Instructions

Given a file or module:

1. **Read the target file** and extract all imports/requires
2. **Categorize dependencies**:
   - **Internal** — project files (show the import tree)
   - **External** — third-party packages
   - **Standard library** — built-in modules
3. **For internal deps**, recursively trace 1-2 levels deep
4. **Find reverse dependencies** — what other files import this one
5. **Present as a tree**:
   ```
   target.ts
   ├── imports
   │   ├── ./utils/helper.ts (internal)
   │   ├── lodash (external)
   │   └── path (stdlib)
   └── imported by
       ├── ./routes/api.ts
       └── ./index.ts
   ```
6. **Flag potential issues** — circular deps, heavy imports for simple usage

## Target

$ARGUMENTS
