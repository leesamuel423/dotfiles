---
allowed-tools: Read, Write, Grep
description: Generate boilerplate code following project conventions
---

# Scaffold

Generate boilerplate for a new component, module, or file following existing project patterns.

## Instructions

Given what the user wants to scaffold (e.g., "new API route", "React component", "model"):

1. **Analyze existing patterns** — find similar files in the project and read them
2. **Identify conventions**:
   - File naming (kebab-case, PascalCase, etc.)
   - Directory structure (where this type of file lives)
   - Import patterns, export style
   - Testing patterns (co-located? separate directory?)
3. **Generate the boilerplate** matching project conventions exactly:
   - Main file
   - Test file (if the project has tests for similar files)
   - Index/barrel export updates (if the project uses them)
4. **Write the files** to the correct locations
5. **Show what was created** and any manual steps needed

## What to Scaffold

$ARGUMENTS
