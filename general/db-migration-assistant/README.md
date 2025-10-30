# DB Migration Assistant

**Safely applies database migrations with automatic backup and rollback.**

## Quick Start

```bash
# Install
cd ~/dotfiles-skills
./install.sh --user --skill db-migration-assistant

# Use
"Create database migration for adding user table"
"Apply pending migrations safely"
"Rollback last migration"
```

## What It Does

1. **Detects migration tool** (Prisma, Alembic, etc.)
2. **Creates backup** before changes
3. **Validates migration** for safety
4. **Applies changes** to schema
5. **Verifies success** with checks
6. **Rolls back** if anything fails

## Why This Exists

- ✅ **Zero data loss** with automatic backups
- ✅ **Instant rollback** on failure
- ✅ **Safety checks** prevent disasters
- ✅ **Multi-ORM support** (Prisma, Sequelize, Alembic, etc.)

## Example Output

```
💾 Creating backup...
✅ Backup: db_backup_20251030.sql

🔧 Applying migration: add_users_table
✅ Migration applied

🔍 Validating schema...
✅ Schema valid

⏱️ 4 seconds
```

## Use Cases

- Schema changes
- Adding tables/columns
- Data migrations
- Production deployments

## License

MIT License
