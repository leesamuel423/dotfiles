---
allowed-tools: Read, Write, Bash
description: Generate a database migration from model or schema changes
---

# Generate Migration

Create a database migration based on model/schema changes.

## Instructions

Given a model change or schema description:

1. **Detect the migration framework**:
   - Django: `python manage.py makemigrations`
   - Rails: `rails generate migration`
   - Prisma: `npx prisma migrate dev`
   - Knex/Drizzle/TypeORM: manual migration file
   - Alembic: `alembic revision --autogenerate`
2. **If auto-generation is available**, run the framework command
3. **If manual**, generate a migration file that:
   - Creates/alters/drops tables and columns
   - Handles data transformations if needed
   - Includes a rollback/down migration
   - Follows the project's naming convention
4. **Review the generated migration** for correctness
5. **Warn about destructive operations** — column drops, type changes, etc.

## Changes

$ARGUMENTS
