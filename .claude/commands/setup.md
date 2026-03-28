---
allowed-tools: Read, Bash, Grep
description: Analyze a repo and explain how to set it up locally
---

# Project Setup Guide

Analyze the current project and generate setup instructions.

## Project Analysis

- README: !`cat README.md 2>/dev/null | head -100 || echo "no README"`
- Package manager: !`ls package.json Cargo.toml go.mod pyproject.toml Gemfile Makefile 2>/dev/null`
- Environment template: !`ls .env.example .env.template .env.sample 2>/dev/null || echo "no env template"`
- Docker: !`ls Dockerfile docker-compose.yml docker-compose.yaml 2>/dev/null || echo "no docker"`
- CI config: !`ls .github/workflows/*.yml .gitlab-ci.yml Jenkinsfile 2>/dev/null || echo "no CI"`

## Instructions

1. **Identify the tech stack** from config files
2. **Generate step-by-step setup instructions**:
   - Prerequisites (runtime versions, system deps)
   - Clone and install dependencies
   - Environment configuration (.env vars needed)
   - Database setup/migrations
   - How to run the dev server
   - How to run tests
3. **Note any gotchas** — platform-specific issues, required services, etc.
4. **Output as a clear numbered guide** someone could follow from scratch

$ARGUMENTS
