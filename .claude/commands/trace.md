---
allowed-tools: Read, Grep
description: Trace a function's call chain through the codebase
---

# Trace Call Chain

Map the full call chain for a function — who calls it, what it calls, and the data flow.

## Instructions

Given a function or method name:

1. **Find the definition** using Grep
2. **Trace callers** — search for all references to this function
3. **Trace callees** — read the function body and identify what it calls
4. **Build the call graph** going at least 2-3 levels deep in each direction
5. **Present the chain** as a tree:
   ```
   caller_a()
     └─ target_function()
        ├─ helper_b()
        │  └─ util_c()
        └─ helper_d()
   ```
6. **Note the data flow** — what parameters are passed through, what gets returned, any side effects

## Target

$ARGUMENTS
