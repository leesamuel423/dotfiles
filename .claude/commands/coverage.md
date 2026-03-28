---
allowed-tools: Bash, Read
description: Run test coverage and suggest tests for uncovered lines
---

# Test Coverage

Run coverage analysis and identify untested code.

## Instructions

1. **Run coverage** with the project's test framework:
   - JS/TS: `npx vitest run --coverage` or `npx jest --coverage`
   - Python: `python -m pytest --cov --cov-report=term-missing`
   - Go: `go test -coverprofile=coverage.out ./... && go tool cover -func=coverage.out`
2. **Parse the report** and identify files/functions with low coverage
3. **For the least-covered areas**, read the source code and suggest specific tests that would improve coverage
4. **Prioritize** by:
   - Business-critical code paths
   - Complex logic with many branches
   - Recently changed code
5. **Present a summary table**: file, current %, uncovered lines, suggested test

If the user specifies a file or threshold:

$ARGUMENTS
