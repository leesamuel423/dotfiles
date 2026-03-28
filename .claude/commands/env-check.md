---
allowed-tools: Read, Grep
description: Validate .env has all required variables referenced in the codebase
---

# Environment Variable Check

Compare environment variable usage in code against .env files.

## Current Env Files

- .env.example: !`cat .env.example 2>/dev/null || echo "no .env.example"`

## Instructions

1. **Scan the codebase** for environment variable references:
   - `process.env.VAR_NAME` (Node.js)
   - `os.environ["VAR"]` or `os.getenv("VAR")` (Python)
   - `ENV["VAR"]` or `ENV.fetch("VAR")` (Ruby)
   - `os.Getenv("VAR")` (Go)
   - Generic patterns: `${VAR}`, `$VAR` in configs
2. **Read .env.example** (or .env.template) if it exists
3. **Compare and report**:
   - **Missing from .env.example**: vars used in code but not in template
   - **Unused in code**: vars in template but never referenced
   - **No default/fallback**: vars accessed without a default value (risky)
4. **Output a summary table**: variable name, where used, in template?, has default?

Do NOT read actual .env files — they may contain secrets.

$ARGUMENTS
