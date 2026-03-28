---
allowed-tools: Bash(gh:*)
description: Fetch a failed CI run and explain what went wrong
---

# Debug CI Failure

Fetch and analyze a failed CI/CD run.

## Recent Runs

- Latest workflow runs: !`gh run list --limit 5 2>/dev/null || echo "no gh CLI or not in a repo"`

## Instructions

Given a CI run ID, PR number, or "latest failure":

1. **Fetch the failed run** using `gh run view <id>` or `gh run list --status failure`
2. **Get the logs** with `gh run view <id> --log-failed`
3. **Analyze the failure**:
   - Which job/step failed?
   - What's the error message?
   - Is it a flaky test, real bug, config issue, or infra problem?
4. **Trace to root cause**:
   - If it's a test failure, identify the failing test and what changed
   - If it's a build failure, identify the dependency or config issue
   - If it's infra, note it as likely transient
5. **Suggest a fix** or recommend re-running if it's flaky

## Input

$ARGUMENTS
