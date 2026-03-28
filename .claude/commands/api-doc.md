---
allowed-tools: Read, Grep, Write
description: Document API endpoints from route handlers
---

# API Documentation

Generate API documentation from route handlers in the codebase.

## Instructions

Given a file, directory, or "all endpoints":

1. **Find route handlers** using Grep — look for route decorators, router definitions, or endpoint patterns:
   - Express/Fastify: `app.get`, `router.post`, etc.
   - Django/Flask: `@app.route`, `path()`, `@api_view`
   - Rails: `resources`, `get`, `post` in routes
   - Go: `http.HandleFunc`, `mux.Handle`
2. **Read each handler** and extract:
   - HTTP method and path
   - Request parameters (path, query, body)
   - Response format and status codes
   - Authentication requirements
   - Validation rules
3. **Generate documentation** in a clear format:
   ```
   ### GET /api/users/:id
   **Description**: Fetch a user by ID
   **Auth**: Required (Bearer token)
   **Params**: id (path, string, required)
   **Response**: 200 — User object, 404 — Not found
   ```
4. **Write the docs** to an appropriate file (or output to console if the user prefers)

## Target

$ARGUMENTS
