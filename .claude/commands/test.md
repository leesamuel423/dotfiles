---
allowed-tools: Read, Write
description: Generate unit tests for a file or function
---

# Generate Tests

Create unit tests for the specified file or function.

## Instructions

Given a file or function name:

1. **Read the target code** to understand its behavior, inputs, outputs, and edge cases
2. **Detect the testing framework** from the project (jest, pytest, vitest, go test, etc.)
3. **Identify the test file location** — follow project conventions (e.g., `__tests__/`, `.test.ts`, `_test.go`)
4. **Generate tests** covering:
   - Happy path — normal expected inputs
   - Edge cases — empty inputs, boundaries, nulls
   - Error cases — invalid inputs, expected failures
   - If the function has side effects, test those too
5. **Follow project conventions** — match existing test style, imports, and patterns
6. **Write the test file** or append to an existing one

Don't over-mock. Prefer testing real behavior. Keep tests focused and readable.

## Target

$ARGUMENTS
