---
allowed-tools: Read, Write
description: Convert between formats (JSON to YAML, cURL to fetch, etc.)
---

# Format Converter

Convert code or data between formats.

## Supported Conversions

- **Data**: JSON <-> YAML, JSON <-> TOML, CSV <-> JSON
- **HTTP**: cURL <-> fetch/axios/requests, HTTP <-> any client
- **Config**: .env <-> docker-compose env, nginx <-> Caddyfile
- **Code**: CommonJS <-> ESM, class <-> functional, callback <-> async/await
- **Markup**: Markdown <-> HTML

## Instructions

1. **Read the input** — from `$ARGUMENTS` or a file path the user provides
2. **Detect the source format** automatically (or use what the user specifies)
3. **Convert** to the target format, preserving:
   - All data/values
   - Comments where possible
   - Logical ordering
4. **Output the result** — print it or write to a file if requested

## Input

$ARGUMENTS
