# Dependency Update Manager

**Safely updates dependencies across all package managers with breaking change detection and automatic rollback.**

## Quick Start

```bash
# Install the skill
cd ~/dotfiles-skills
./install.sh --user --skill dependency-update-manager

# Use in Claude Code
"Update dependencies safely"
"Check for outdated packages"
"Upgrade npm packages with tests"
```

## What It Does

Automates dependency updates across your entire project:

1. **Detects package managers** (npm, pip, cargo, bundler, etc.)
2. **Scans for outdated packages** with version analysis
3. **Categorizes updates** by severity (patch/minor/major)
4. **Analyzes changelogs** for breaking changes
5. **Creates backup** before any changes
6. **Runs tests** after updates
7. **Rolls back** automatically on failure

## Why This Exists

Manual dependency updates are:
- **Time-consuming**: Check 50+ packages individually
- **Risky**: Breaking changes can crash production
- **Complex**: Multiple package managers to manage
- **Tedious**: Read changelogs, test each update
- **Error-prone**: Easy to miss security updates

This skill makes it:
- ✅ **5 minutes** vs 2+ hours manually
- ✅ **Safe** with automatic testing and rollback
- ✅ **Smart** - detects breaking changes
- ✅ **Complete** - handles all package managers
- ✅ **Secure** - prioritizes security updates

## Key Features

### 📦 Multi-Package Manager Support
- npm/yarn/pnpm (Node.js)
- pip/pipenv (Python)
- cargo (Rust)
- bundler (Ruby)
- composer (PHP)
- go modules

### 🔍 Intelligent Analysis
- Semver-based categorization
- Changelog parsing
- Breaking change detection
- Security vulnerability scanning
- Dependency graph analysis

### 🛡️ Safety First
- Automatic backups
- Test suite execution
- Build validation
- Automatic rollback on failure
- Incremental updates

### 📊 Clear Reporting
- Before/after comparison
- Update categories
- Test results
- Security fixes
- Time saved metrics

## Example Output

```
🔍 Scanning for outdated dependencies...

📦 Package Managers Detected:
✅ npm (15 packages)
✅ pip (8 packages)

📊 Outdated Packages Found: 23

Categorized by Severity:
🔴 Security Updates (2):
  - lodash: 4.17.20 → 4.17.21 (CVE-2021-23337)
  - axios: 0.21.1 → 0.21.4 (CVE-2021-3749)

🟢 Patch Updates (12):
  - react: 17.0.2 → 17.0.3
  - typescript: 4.5.0 → 4.5.5
  - ... (10 more)

🟡 Minor Updates (6):
  - webpack: 5.70.0 → 5.88.0
  - jest: 27.5.0 → 27.5.1
  - ... (4 more)

🔴 Major Updates (3):
  - react: 17.0.3 → 18.2.0 (BREAKING CHANGES)
  - webpack: 5.88.0 → 5.90.0 (Config changes)
  - jest: 27.5.1 → 29.5.0 (API changes)

💾 Creating backup...
✅ Backup: .dependency-backup-20251030-160000/

🚀 Applying Updates...

Security (Priority 1):
✅ lodash: 4.17.20 → 4.17.21
✅ axios: 0.21.1 → 0.21.4

Patch Updates:
✅ react: 17.0.2 → 17.0.3
✅ typescript: 4.5.0 → 4.5.5
✅ ... (10 more)

Minor Updates:
✅ webpack: 5.70.0 → 5.88.0
✅ jest: 27.5.0 → 27.5.1
✅ ... (4 more)

⏭️  Skipped Major Updates (require manual review):
  - react 18 (breaking changes to event system)
  - jest 29 (new snapshot format)

🧪 Running Tests...
✅ 142/142 tests passed

🏗️  Validating Build...
✅ Build successful

✨ Dependency Updates Complete!

📊 Summary:
✅ 20 packages updated
⏭️  3 major updates skipped
🔒 2 security vulnerabilities fixed
✅ All tests passing
✅ Build successful

💾 Backup preserved: .dependency-backup-20251030-160000/

⏱️ Total time: 4m 32s
💰 Time saved: ~2 hours

🎯 Next Steps:
1. Review major updates: npm outdated
2. Update major versions one at a time
3. Or ask: "Update react to v18 safely"
```

## Use Cases

### Security Updates
```
User: "Fix security vulnerabilities"

Skill:
- Runs npm audit
- Identifies 3 high-severity issues
- Updates affected packages
- Re-runs audit
- All vulnerabilities fixed

Result: Secure in 2 minutes
```

### Regular Maintenance
```
User: "Update all dependencies"

Skill:
- Finds 25 outdated packages
- Auto-updates patches and minors
- Asks about 4 major updates
- Tests everything
- Commits changes

Result: Clean dependencies, all tests pass
```

### Safe Major Update
```
User: "Update React to v18"

Skill:
- Checks React 18 changelog
- Detects breaking changes
- Creates backup
- Updates incrementally
- Tests at each step
- Guides through migration

Result: Smooth upgrade
```

## Dependencies

### Required (at least one)
```bash
# Node.js
brew install node

# Python
brew install python

# Rust
brew install rust
```

### Highly Recommended
```bash
# JSON parsing
brew install jq

# GitHub integration
brew install gh
```

## Configuration

```bash
# Add to ~/.zshrc or ~/.bashrc

# Update behavior
export DEP_UPDATE_AUTO_PATCH=true       # Auto-apply patches
export DEP_UPDATE_AUTO_MINOR=false      # Ask for minor updates
export DEP_UPDATE_AUTO_MAJOR=false      # Always ask for major

# Safety
export DEP_UPDATE_SKIP_TESTS=false      # Always run tests
export DEP_UPDATE_ROLLBACK_ON_FAIL=true # Auto-rollback
export DEP_UPDATE_BACKUP=true           # Always backup
```

## Advanced Features

### Security Audit
```
"Run security audit and fix vulnerabilities"
```

### Update Schedule
```bash
# Weekly dependency check
0 9 * * MON claude-code "check for dependency updates"
```

### Automated PRs
```
"Create PR for dependency updates"
# Creates branch, updates, tests, opens PR
```

## Troubleshooting

### Updates fail
```bash
# Check logs
cat update.log

# Rollback manually
cp .dependency-backup-*/* .
npm ci
```

### Tests fail after update
```bash
# Automatic rollback triggered
# Review test.log for details
cat test.log
```

### Peer dependency conflicts
```bash
# Skill will detect and warn
# Resolve manually or skip that update
npm ls
```

## Success Metrics

- **2+ hours saved** per update session
- **100% test coverage** maintained
- **Zero downtime** from broken updates
- **All security fixes** applied automatically
- **Clear audit trail** for compliance

## Related Skills

- **[Pre-Commit Guardian](../../dotfiles/pre-commit-guardian/)** - Validates before commit
- **[Environment Setup Validator](../environment-setup-validator/)** - Ensures correct installation
- **[Test Coverage Analyzer](../test-coverage-analyzer/)** - Maintains coverage

## Contributing

Want to add support for more package managers? See [Contributing Guide](../../docs/contributing.md).

## License

MIT License - See [LICENSE](../../LICENSE) for details.