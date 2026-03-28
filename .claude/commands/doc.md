---
allowed-tools: Read, Edit
description: Generate docstrings and comments for a file or function
---

# Generate Documentation

Add docstrings, JSDoc, or inline comments to the specified code.

## Instructions

Given a file or function:

1. **Read the target code** to understand behavior, parameters, return values, and side effects
2. **Generate documentation** matching the language convention:
   - Python: docstrings (Google or NumPy style, match existing project convention)
   - JS/TS: JSDoc comments
   - Go: godoc-style comments
   - Other: language-appropriate format
3. **Document**:
   - Purpose of the function/class/module
   - Parameters and their types
   - Return values
   - Exceptions/errors that can be raised
   - Non-obvious behavior or side effects
4. **Add inline comments only** where logic is genuinely non-obvious
5. **Apply changes** using Edit

Don't add comments that restate what the code already says clearly.

## Target

$ARGUMENTS
