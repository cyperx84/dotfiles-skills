---
name: Pre-Commit Guardian
description: Validates configuration files before git commits to prevent broken configs from entering the repository. Automatically selects appropriate validators (yabai, shellcheck, luacheck, etc.) based on file type and blocks commits on validation failure. Use when user wants to commit dotfiles changes safely. Triggers: "validate before commit", "check configs before push", "verify dotfiles integrity", "safe commit", "pre-commit check"
version: 1.0.0
author: Dotfiles Skills
---

# Pre-Commit Guardian Skill

## Purpose

The Pre-Commit Guardian prevents catastrophic dotfiles failures by validating all configuration files before they're committed to git. A single syntax error in a yabai config or shell script can break your entire window management system. This skill catches those errors before they're committed, preventing broken configs from entering your repository and potentially spreading to other machines.

## When to Use This Skill

Activate when the user:
- Wants to commit changes to dotfiles safely
- Asks to "validate configs before commit"
- Mentions "pre-commit check" or "verify before push"
- Is about to commit changes to critical config files (yabai, skhd, sketchybar, tmux, zsh, etc.)
- Wants to install automated pre-commit validation
- Mentions keywords like: "safe commit", "validate dotfiles", "check syntax", "pre-commit hook"

## Workflow

### Phase 1: Detection & Analysis

**Detect Staged Changes**:

```bash
# Get list of staged files
git diff --cached --name-only

# Categorize files by type
# - .yabairc, yabai.yml → Yabai configs
# - .skhdrc, skhd.yml → SKHD configs
# - sketchybarrc, *.lua → SketchyBar configs
# - .zshrc, .bashrc, *.sh → Shell scripts
# - *.lua → Lua scripts
# - *.toml → TOML configs
# - *.json → JSON configs
# - .tmux.conf → Tmux configs
```

**Determine Validators Needed**:

Map each file type to appropriate validator:
- **Yabai configs** → `yabai --check-config`
- **SKHD configs** → `skhd --check-config` (if available) or parse manually
- **Shell scripts** → `shellcheck`
- **Lua scripts** → `luacheck` or `lua -c`
- **TOML files** → `taplo check` or custom parser
- **JSON files** → `jq` validation
- **Tmux configs** → `tmux -f <file> source-file <file>`

**Check Validator Availability**:

```bash
# Check which validators are installed
command -v yabai >/dev/null 2>&1 && echo "yabai: available"
command -v shellcheck >/dev/null 2>&1 && echo "shellcheck: available"
command -v luacheck >/dev/null 2>&1 && echo "luacheck: available"
command -v jq >/dev/null 2>&1 && echo "jq: available"
command -v taplo >/dev/null 2>&1 && echo "taplo: available"
```

**What to check**:
- Number of staged files to validate
- Which validators are needed
- Which validators are available
- Any missing validators (warn but don't block)
- Estimated validation time

### Phase 2: Pre-Validation Preparation

**Backup Current State**:

Create safety backup before validation testing:

```bash
# Create temporary backup of staged changes
git stash push --keep-index -m "pre-commit-guardian-backup-$(date +%s)"
```

**Set Up Validation Environment**:

```bash
# Create temporary validation directory
VALIDATION_DIR=$(mktemp -d)
export VALIDATION_DIR

# Copy staged files to validation directory
git diff --cached --name-only | while read file; do
  mkdir -p "$VALIDATION_DIR/$(dirname "$file")"
  git show ":$file" > "$VALIDATION_DIR/$file"
done
```

**Key Decisions**:
- If no validators available → Warn but allow commit (user choice)
- If critical validators missing (yabai, shellcheck) → Strong warning
- If staged changes include critical configs → Require validation success
- If only documentation changed → Skip validation
- Otherwise → Proceed with full validation

### Phase 3: Validation Execution

**Run Validators Sequentially**:

For each staged file, run appropriate validator:

```bash
# Example: Validate yabai config
if [[ $file == *"yabairc"* ]]; then
  echo "Validating yabai config..."
  yabai --check-config 2>&1
  YABAI_EXIT=$?

  if [ $YABAI_EXIT -ne 0 ]; then
    echo "❌ Yabai config validation failed!"
    VALIDATION_FAILED=true
  fi
fi

# Example: Validate shell script
if [[ $file == *.sh ]] || [[ $file == *"zshrc"* ]]; then
  echo "Validating shell script: $file"
  shellcheck "$file" 2>&1
  SHELL_EXIT=$?

  if [ $SHELL_EXIT -ne 0 ]; then
    echo "❌ Shellcheck failed: $file"
    VALIDATION_FAILED=true
  fi
fi

# Example: Validate Lua script
if [[ $file == *.lua ]]; then
  echo "Validating Lua script: $file"
  if command -v luacheck >/dev/null 2>&1; then
    luacheck "$file" 2>&1
  else
    lua -c "$file" 2>&1
  fi
  LUA_EXIT=$?

  if [ $LUA_EXIT -ne 0 ]; then
    echo "❌ Lua validation failed: $file"
    VALIDATION_FAILED=true
  fi
fi

# Example: Validate JSON
if [[ $file == *.json ]]; then
  echo "Validating JSON: $file"
  jq empty "$file" 2>&1
  JSON_EXIT=$?

  if [ $JSON_EXIT -ne 0 ]; then
    echo "❌ JSON validation failed: $file"
    VALIDATION_FAILED=true
  fi
fi
```

**Collect Validation Results**:

```bash
# Track results per file
declare -A VALIDATION_RESULTS
VALIDATION_RESULTS[$file]="$VALIDATOR_EXIT_CODE"

# Track overall status
TOTAL_FILES=0
PASSED_FILES=0
FAILED_FILES=0
SKIPPED_FILES=0
```

**Error Handling**:

If validation fails for any file:
1. **Capture error output** with line numbers and specific issues
2. **Parse error messages** to extract actionable information
3. **Map to source file locations** (critical for includes/imports)
4. **Generate fix suggestions** based on error type
5. **Prepare detailed failure report**

### Phase 4: Results Analysis

**Parse Validation Errors**:

Extract meaningful information from validator output:

```bash
# Example: Parse shellcheck errors
# SC2034: var appears unused. Verify use (or export if used externally).
# Line 42: FOO="bar"

# Example: Parse yabai errors
# yabai: configuration file '/Users/user/.yabairc' line 23: unknown command 'invalid_command'

# Example: Parse Lua errors
# syntax error: /path/to/file.lua:15: unexpected symbol near '}'
```

**Categorize Issues**:

- **Syntax errors** (blocking): Must fix before commit
- **Style warnings** (non-blocking): Can commit but should fix
- **Unused variables** (non-blocking): Informational
- **Security issues** (blocking): Must fix before commit
- **Deprecation warnings** (non-blocking): Should fix soon

**Determine Commit Gate Status**:

```bash
# Block commit if:
# - Any syntax errors found
# - Any security issues found
# - Critical config files failed validation
# - User previously requested strict mode

# Allow commit if:
# - Only style warnings
# - Only informational messages
# - User explicitly overrides (--no-verify)
```

### Phase 5: Auto-Fix Attempts (Optional)

**Attempt Safe Auto-Fixes**:

For certain types of issues, offer automatic fixes:

```bash
# Example: Fix trailing whitespace
sed -i '' 's/[[:space:]]*$//' "$file"

# Example: Fix missing newline at EOF
echo "" >> "$file"

# Example: Format JSON
jq '.' "$file" > "$file.tmp" && mv "$file.tmp" "$file"

# Example: Format shell scripts
shfmt -w "$file"
```

**Re-validate After Fixes**:

```bash
# Run validators again on auto-fixed files
# Update validation results
# Report which fixes were successful
```

**User Interaction**:

For fixes that can't be automated:
- Show exact error location
- Suggest specific fix
- Offer to open file in editor at error line
- Provide documentation links

### Phase 6: Commit Gate Decision

**Block Commit**:

If validation failed with blocking errors:

```bash
# Exit with non-zero status to block git commit
exit 1
```

**Report blocking errors**:
```
❌ Pre-Commit Validation FAILED - Commit Blocked

🛑 Blocking Issues Found:

1. yabai/.config/yabai/yabairc:23
   ❌ Unknown command 'invalid_command'
   💡 Fix: Check yabai documentation for valid commands

2. zsh/.zshrc:142
   ❌ SC2086: Double quote to prevent globbing and word splitting
   💡 Fix: Change $var to "$var"

📋 Summary:
❌ 2 files failed validation
⚠️ 3 warnings found
✅ 5 files passed

🚫 COMMIT BLOCKED - Fix errors above before committing

💡 To see full details: git diff --cached
💡 To skip validation (NOT recommended): git commit --no-verify
```

**Allow Commit**:

If validation passed or only non-blocking warnings:

```bash
# Exit with zero status to allow git commit
exit 0
```

**Report success**:
```
✅ Pre-Commit Validation PASSED

📊 Validation Results:
✅ 8 files validated
✅ 0 errors
⚠️ 2 warnings (non-blocking)

⚠️ Warnings:
1. zsh/.zshrc:89
   SC2034: FOO appears unused

2. sketchybar/plugins/battery.lua:42
   Unused variable: old_value

✅ COMMIT ALLOWED - Consider fixing warnings

⏱️ Validation time: 2.1 seconds
```

### Phase 7: Cleanup & Reporting

**Clean Up Temporary Files**:

```bash
# Remove validation directory
rm -rf "$VALIDATION_DIR"

# Pop git stash if created
git stash pop >/dev/null 2>&1 || true
```

**Generate Validation Report**:

```
🛡️ Pre-Commit Guardian - Validation Report

📊 Files Validated:
- yabai/.config/yabai/yabairc ✅
- skhd/.config/skhd/skhdrc ✅
- zsh/.zshrc ⚠️ (warnings)
- tmux/.tmux.conf ✅
- sketchybar/sketchybarrc ✅
- sketchybar/plugins/battery.lua ⚠️ (warnings)

🔍 Validators Used:
- Yabai config checker ✅
- Shellcheck ✅
- Luacheck ✅
- JSON validator (jq) ✅

📈 Statistics:
Total files: 8
Passed: 6
Warnings: 2
Failed: 0
Skipped: 0

⏱️ Total validation time: 2.1 seconds

🎯 Result: ✅ COMMIT ALLOWED
```

**Update Metrics**:

Track validation effectiveness:
- Total validations run
- Errors caught before commit
- Auto-fixes applied
- Time saved (vs debugging after commit)

## Examples

### Example 1: All Validations Pass

**User**: "Commit my yabai config changes"

**Skill Actions**:
```
1. Detect staged files: yabai/.config/yabai/yabairc
2. Select validator: yabai --check-config
3. Run validation: PASSED ✅
4. Check for warnings: None
5. Result: ✅ Commit allowed

Pre-Commit Guardian: All validations passed
- yabai config: ✅ Valid
- 0 errors, 0 warnings
- Safe to commit!
```

### Example 2: Syntax Error Caught

**User**: "Commit dotfiles changes"

**Skill Actions**:
```
1. Detect staged files: yabai/.config/yabai/yabairc, zsh/.zshrc
2. Validate yabai config: FAILED ❌
   Error: Line 23: unknown command 'invalid_command'
3. Validate zsh script: PASSED ✅
4. Result: ❌ Commit BLOCKED

Pre-Commit Guardian: Validation FAILED
❌ yabai config has syntax error at line 23
   Found: invalid_command
   Expected: valid yabai command

💡 Fix:
1. Open file: nvim +23 yabai/.config/yabai/yabairc
2. Check documentation: yabai --help
3. Fix the error
4. Try commit again

🚫 Commit blocked to prevent broken config
```

### Example 3: Auto-Fix Applied

**User**: "Safe commit my shell scripts"

**Skill Actions**:
```
1. Detect staged files: setup.sh, install.sh
2. Validate with shellcheck:
   - setup.sh: 2 warnings (missing quotes)
   - install.sh: 1 warning (trailing whitespace)
3. Offer auto-fix: User confirms
4. Apply fixes:
   - Added quotes around variables
   - Removed trailing whitespace
5. Re-validate: All PASSED ✅
6. Stage auto-fixes
7. Result: ✅ Commit allowed

Pre-Commit Guardian: Auto-fixes applied
✨ Fixed 3 issues automatically:
- setup.sh: Added quotes (2 places)
- install.sh: Removed trailing whitespace

✅ All validations now pass
📝 Auto-fixes staged for commit
```

### Example 4: Missing Validator Warning

**User**: "Commit my Lua plugins"

**Skill Actions**:
```
1. Detect staged files: 5 .lua files
2. Check for Lua validator:
   - luacheck: Not installed
   - lua -c: Available (fallback)
3. Validate with fallback: All PASSED ✅
4. Result: ✅ Commit allowed (with warning)

Pre-Commit Guardian: Validation passed (limited)
⚠️ luacheck not installed - using basic validation

✅ Syntax check: All files valid
⚠️ Style check: Skipped (install luacheck for full validation)

💡 Recommendation: brew install luacheck

✅ Commit allowed
```

### Example 5: Multiple File Types

**User**: "Commit all my dotfiles changes"

**Skill Actions**:
```
1. Detect staged files:
   - 3 shell scripts
   - 2 Lua files
   - 1 JSON file
   - 1 yabai config
   - 1 TOML file
2. Run 4 different validators
3. Results:
   - Shell: 3/3 passed ✅
   - Lua: 2/2 passed ✅
   - JSON: 1/1 passed ✅
   - Yabai: 1/1 passed ✅
   - TOML: 1/1 passed ⚠️ (validator missing, skipped)
4. Result: ✅ Commit allowed

Pre-Commit Guardian: Multi-file validation complete
✅ 7/8 files fully validated
⚠️ 1 file skipped (TOML validator not installed)

📊 Results by type:
- Shell scripts (3): ✅ All valid
- Lua scripts (2): ✅ All valid
- JSON (1): ✅ Valid
- Yabai config (1): ✅ Valid
- TOML (1): ⚠️ Skipped

⏱️ Total time: 1.8 seconds
✅ Commit allowed
```

## Guidelines

### DO:
✅ Validate all critical config files before commits
✅ Use appropriate validators for each file type
✅ Block commits on syntax errors and security issues
✅ Provide specific error messages with line numbers
✅ Offer auto-fix for simple issues
✅ Show clear fix suggestions for complex issues
✅ Allow override with --no-verify (document why)
✅ Track validation metrics over time
✅ Install as git pre-commit hook for automation
✅ Warn about missing validators but don't block
✅ Provide fallback validators when possible
✅ Test validators are working before relying on them

### DON'T:
❌ Block commits for style warnings only
❌ Run validators that aren't installed (check first)
❌ Modify user's git configuration without permission
❌ Validate files that aren't staged (respect git workflow)
❌ Use overly strict rules that block legitimate code
❌ Hide validator output (show full errors for debugging)
❌ Auto-fix without user confirmation
❌ Proceed if critical validators fail to run
❌ Ignore validator exit codes
❌ Skip validation on "minor" changes (syntax errors can be anywhere)
❌ Make commits slower than necessary (optimize validator calls)
❌ Validate binary files or non-config files

## Advanced Features

### Intelligent Caching

Cache validation results for unchanged files:

```bash
# Hash file content
FILE_HASH=$(shasum -a 256 "$file" | cut -d' ' -f1)

# Check cache
if [ -f "$CACHE_DIR/$FILE_HASH.valid" ]; then
  echo "✅ Using cached validation result for $file"
  continue
fi

# Run validation and cache result
if validate_file "$file"; then
  touch "$CACHE_DIR/$FILE_HASH.valid"
fi
```

**Benefits**:
- Faster validations on re-commits
- Reduced validator overhead
- Better performance for large repos

### Parallel Validation

Run validators in parallel for speed:

```bash
# Validate multiple files concurrently
for file in "${staged_files[@]}"; do
  validate_file "$file" &
  pids+=($!)
done

# Wait for all validators to finish
for pid in "${pids[@]}"; do
  wait "$pid" || VALIDATION_FAILED=true
done
```

**Use Case**: Large commits with many files

### Custom Validator Configuration

Allow users to define custom validators:

```yaml
# .pre-commit-guardian.yml
validators:
  yabai:
    command: "yabai --check-config"
    files: ["*yabairc*", "*.yabai.yml"]
    blocking: true

  custom_lua:
    command: "luacheck --globals vim --std max"
    files: ["*.lua"]
    blocking: false
```

### Fix Suggestions Database

Build database of common errors and fixes:

```yaml
errors:
  - pattern: "SC2086"
    description: "Double quote to prevent globbing"
    fix_template: 'Change $VAR to "$VAR"'
    auto_fixable: true

  - pattern: "yabai.*unknown command"
    description: "Invalid yabai command"
    fix_template: "Check: yabai --help"
    documentation: "https://github.com/koekeishiya/yabai/wiki"
```

### Integration with CI/CD

Export validation results for CI systems:

```bash
# Generate JUnit XML report
generate_junit_xml "$VALIDATION_RESULTS" > validation-report.xml

# Or JSON for GitHub Actions
jq -n \
  --arg status "$OVERALL_STATUS" \
  --arg errors "$ERROR_COUNT" \
  '{"status": $status, "errors": ($errors|tonumber)}' \
  > validation-report.json
```

## Dependencies

### Required
- **git** - Version control (built-in on macOS)
  - Used to detect staged files
  - Pre-commit hook integration

### Highly Recommended
- **shellcheck** - `brew install shellcheck`
  - Validates shell scripts (bash, zsh)
  - Catches common shell script errors

- **yabai** - `brew install yabai`
  - Validates yabai configs
  - Required if using yabai window manager

### Optional
- **luacheck** - `brew install luacheck`
  - Advanced Lua validation
  - Falls back to `lua -c` if not available

- **jq** - `brew install jq`
  - JSON validation and formatting
  - Widely used for JSON handling

- **taplo** - `brew install taplo`
  - TOML validation and formatting
  - Optional but recommended for TOML configs

- **shfmt** - `brew install shfmt`
  - Shell script formatting
  - Enables auto-fix features

## Configuration

### Install as Git Pre-Commit Hook

**Automatic Installation**:

```bash
# Let the skill install itself as a hook
claude-code "install pre-commit guardian as git hook"
```

**Manual Installation**:

```bash
# Create pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
claude-code "run pre-commit validation"
exit $?
EOF

# Make executable
chmod +x .git/hooks/pre-commit
```

### Configure Validation Behavior

Set via environment variables or config file:

```bash
# Environment variables (in .zshrc or .bashrc)
export PRE_COMMIT_GUARDIAN_STRICT=true      # Block on warnings
export PRE_COMMIT_GUARDIAN_AUTO_FIX=true    # Auto-fix when possible
export PRE_COMMIT_GUARDIAN_CACHE=true       # Enable caching
export PRE_COMMIT_GUARDIAN_PARALLEL=true    # Parallel validation

# Or create .pre-commit-guardian.toml
cat > .pre-commit-guardian.toml << 'EOF'
strict_mode = false
auto_fix = true
enable_cache = true
parallel_validation = true

[validators]
shellcheck_severity = "warning"  # error, warning, info, style
luacheck_std = "max"            # lua51, lua52, max
EOF
```

### Bypass Validation

Sometimes you need to commit without validation:

```bash
# Skip pre-commit hook (use with caution)
git commit --no-verify -m "Emergency fix - validation skipped"

# Temporary disable
export SKIP_PRE_COMMIT_GUARDIAN=true
git commit -m "Message"
unset SKIP_PRE_COMMIT_GUARDIAN
```

## Troubleshooting

### Common Issues

**Issue**: "Validator not found: shellcheck"
**Solution**:
```bash
# Install missing validator
brew install shellcheck

# Or disable that validator
export PRE_COMMIT_GUARDIAN_SKIP_SHELLCHECK=true
```

**Issue**: "Validation is too slow"
**Solution**:
```bash
# Enable caching
export PRE_COMMIT_GUARDIAN_CACHE=true

# Enable parallel validation
export PRE_COMMIT_GUARDIAN_PARALLEL=true

# Or skip non-critical validators
export PRE_COMMIT_GUARDIAN_SKIP_STYLE_CHECKS=true
```

**Issue**: "False positives blocking commits"
**Solution**:
```bash
# Disable strict mode
export PRE_COMMIT_GUARDIAN_STRICT=false

# Or add exceptions to config
echo "ignore_pattern = 'SC2034'" >> .pre-commit-guardian.toml
```

**Issue**: "Auto-fix made unwanted changes"
**Solution**:
```bash
# Disable auto-fix
export PRE_COMMIT_GUARDIAN_AUTO_FIX=false

# Revert changes
git restore --staged .
git restore .

# Restore from backup
git reflog
git reset --hard <commit-before-auto-fix>
```

**Issue**: "Hook doesn't run"
**Solution**:
```bash
# Check hook exists and is executable
ls -la .git/hooks/pre-commit
cat .git/hooks/pre-commit

# Make executable if needed
chmod +x .git/hooks/pre-commit

# Test manually
.git/hooks/pre-commit
```

## Success Metrics

A successful Pre-Commit Guardian execution includes:
- ✅ All staged files detected correctly
- ✅ Appropriate validators selected for each file type
- ✅ All available validators executed successfully
- ✅ Clear error messages with line numbers for failures
- ✅ Actionable fix suggestions provided
- ✅ Correct commit gate decision (block/allow)
- ✅ Validation completed in < 5 seconds for typical commits
- ✅ Zero false negatives (missed errors that should have been caught)
- ✅ Minimal false positives (< 5% blocking valid code)

## Integration

Works seamlessly with:
- **[Stow Health Manager](../stow-health-manager/)** - Validates symlinks before commit
- **[Service Orchestrator](../service-orchestrator/)** - Test services after config changes
- **[Theme Switcher](../theme-switcher/)** - Validate theme configs before commit

### Workflow Example

```bash
# 1. Make config changes
nvim ~/.config/yabai/yabairc

# 2. Test changes
brew services restart yabai

# 3. Stage changes
git add .

# 4. Commit (Pre-Commit Guardian runs automatically)
git commit -m "Update yabai config"
# → Validates yabairc
# → Checks for syntax errors
# → Allows/blocks commit
# → Shows detailed results

# 5. If blocked, fix and retry
nvim +23 ~/.config/yabai/yabairc  # Fix error at line 23
git add .
git commit -m "Update yabai config"
# → Validates again
# → Passes
# → Commit succeeds
```

## Version History

- v1.0.0 (2025-10-30): Initial production release
  - Full validation workflow
  - 6 validator types supported
  - Auto-fix capabilities
  - Git hook integration
  - Caching and parallel execution
  - Comprehensive error reporting
