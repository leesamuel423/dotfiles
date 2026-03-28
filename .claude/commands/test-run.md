---
allowed-tools: Bash, Read
description: Run the test suite and summarize failures with suggested fixes
---

# Run Tests

Execute the project's test suite and analyze results.

## Project Detection

- Package.json test script: !`cat package.json 2>/dev/null | grep -E '"test"' || echo "no npm test"`
- Python test config: !`ls pytest.ini pyproject.toml setup.cfg 2>/dev/null | head -1 || echo "no pytest config"`
- Go tests: !`ls *_test.go **/*_test.go 2>/dev/null | head -1 || echo "no go tests"`

## Instructions

1. **Detect and run** the appropriate test command:
   - JS/TS: `npm test`, `npx vitest run`, `npx jest`
   - Python: `python -m pytest`
   - Go: `go test ./...`
2. **If all tests pass**, report the summary (count, time)
3. **If tests fail**, for each failure:
   - Show the test name and assertion that failed
   - Read the relevant test and source code
   - Explain why it's failing
   - Suggest a fix (in the source or the test, as appropriate)

If the user specifies a file or pattern, scope the run to that:

$ARGUMENTS
