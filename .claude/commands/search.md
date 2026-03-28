---
allowed-tools: Read, Grep, Glob
description: Deep semantic search across the codebase
---

# Deep Search

Search the codebase thoroughly for a concept, pattern, or string.

## Instructions

Given a search query:

1. **Start broad** — search for the exact term and common variations
2. **Search across layers**:
   - Function/class names (definitions)
   - String literals and comments
   - Config files and constants
   - File names matching the concept
3. **Read relevant matches** to understand context
4. **Present findings** organized by relevance:
   - **Exact matches** — direct references
   - **Related** — code that deals with the same concept
   - **Peripheral** — tangentially related mentions
5. **Summarize** what you found and where the concept lives in the codebase

## Query

$ARGUMENTS
