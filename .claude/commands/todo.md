---
allowed-tools: Grep
description: Scan the codebase for TODO, FIXME, HACK, and similar comments
---

# Find TODOs

Scan the project for TODO/FIXME/HACK/XXX comments.

## Instructions

1. **Search for markers** across the codebase:
   - `TODO` — planned work
   - `FIXME` — known bugs or issues
   - `HACK` — workarounds that should be cleaned up
   - `XXX` — areas needing attention
   - `WARN` / `NOTE` — important callouts
2. **Group results** by category, then by file
3. **Present as a summary table**:
   - Type | File:Line | Comment text
4. **Highlight priority items** — FIXMEs and HACKs are usually more urgent than TODOs

If the user specifies a directory or file, scope to that:

$ARGUMENTS
