# Skill Improvements Based on Latest Anthropic Documentation

> **✅ STATUS: IMPLEMENTED** - All high and medium priority recommendations in this document have been applied to all 10 skills in this repository as of v1.0.0.

This document outlines the improvements made to bring all skills in this repository in line with the latest Claude Code skills best practices from Anthropic's official documentation.

## Executive Summary

After comparing the skill implementations against the latest Anthropic documentation, the following improvements were made:

| Area | Previous State | Change Applied | Status |
|------|--------------|-------------------|----------|
| Tool Restrictions | Not implemented | Added `tools` field to all YAML | ✅ Done |
| Prerequisites Section | In "Dependencies" | Added explicit "Prerequisites" section | ✅ Done |
| Limitations Section | Missing | Added "Limitations" section | ✅ Done |
| Error Handling | Embedded in workflow | Added dedicated "Error Handling" section | ✅ Done |
| Description Focus | Feature-focused | Rewritten as trigger-focused | ✅ Done |
| Section Ordering | Custom structure | Aligned with official structure | ✅ Done |

**Reference Implementation**: See `dotfiles/service-orchestrator/SKILL.md` for a complete example of all best practices applied.

---

## 1. YAML Metadata Enhancements

### Current Format
```yaml
---
name: Service Orchestrator
description: Intelligently manages macOS window management service restarts...
version: 1.0.0
author: Dotfiles Skills
---
```

### Recommended Format
```yaml
---
name: Service Orchestrator
description: >
  Use when the user wants to restart, reload, or fix yabai, skhd, or sketchybar
  services. Activates for service restart requests, config reload needs, or
  window management troubleshooting. Handles validation, dependency ordering,
  and health verification.
tools:
  - Bash
  - Read
  - Grep
---
```

### Key Changes

#### A. Add `tools` Field (Security Best Practice)

The `tools` field restricts which Claude Code tools are available when the skill is active. This is a security feature that prevents unintended actions.

**Recommended tool restrictions per skill:**

| Skill | Recommended Tools | Rationale |
|-------|------------------|-----------|
| Service Orchestrator | `Bash`, `Read`, `Grep` | Runs commands, reads configs |
| Pre-Commit Guardian | `Bash`, `Read`, `Grep`, `Glob` | Validates files, runs checkers |
| Stow Health Manager | `Bash`, `Read`, `Write`, `Grep` | Manages symlinks, repairs configs |
| Theme Switcher | `Bash`, `Read`, `Write`, `Edit` | Modifies config files |
| SketchyBar Plugin Dev | `Bash`, `Read`, `Write`, `Glob` | Creates plugin files |
| API Doc Generator | `Bash`, `Read`, `Write`, `Grep`, `Glob` | Generates documentation files |
| DB Migration Assistant | `Bash`, `Read`, `Write` | Runs migrations, creates files |
| Dependency Update Manager | `Bash`, `Read`, `Grep` | Runs package managers, reads lockfiles |
| Test Coverage Analyzer | `Bash`, `Read`, `Grep`, `Glob` | Runs tests, analyzes coverage |
| Environment Setup Validator | `Bash`, `Read`, `Grep` | Checks environment, reads configs |

#### B. Improve Description for Better Triggering

Descriptions should be **trigger-focused** rather than feature-focused. Claude uses descriptions to decide when to activate skills.

**Before (feature-focused):**
```yaml
description: Intelligently manages macOS window management service restarts. Use when user wants to restart yabai, skhd, or sketchybar services, or when configs change. Handles validation, dependency order, health checks.
```

**After (trigger-focused):**
```yaml
description: >
  Activate when user says: "restart services", "reload yabai", "fix sketchybar",
  "restart window management", "apply yabai changes", "services not working".
  Handles macOS window management services (yabai, skhd, sketchybar) with
  validation, correct dependency order, and health verification.
```

#### C. Remove Non-Standard Fields (Optional)

The official spec uses `name`, `description`, and `tools`. The `version` and `author` fields are extensions that Claude Code may ignore. Consider:
- Keep them for human documentation purposes
- Or move them to a separate `metadata` block

---

## 2. Section Structure Alignment

### Official Recommended Structure

According to Anthropic documentation, skills should have:

1. **Overview** - What the skill does
2. **Prerequisites** - What's needed before using
3. **Execution Steps** - Step-by-step instructions
4. **Examples** - Concrete usage examples
5. **Error Handling** - How to handle failures
6. **Limitations** - What the skill cannot do

### Current Structure (in most skills)

1. Purpose ✓ (equivalent to Overview)
2. When to Use This Skill ✓
3. Workflow ✓ (equivalent to Execution Steps)
4. Guidelines (DO/DON'T) ✓
5. Examples ✓
6. Advanced Features
7. Dependencies (partially covers Prerequisites)
8. Configuration
9. Troubleshooting
10. Success Metrics
11. Integration
12. Version History

### Required Additions

#### A. Add "Prerequisites" Section

Move content from "Dependencies" and add verification commands:

```markdown
## Prerequisites

### Required Tools
- **yabai** - Window manager (`brew install koekeishiya/formulae/yabai`)
- **skhd** - Hotkey daemon (`brew install koekeishiya/formulae/skhd`)
- **sketchybar** - Status bar (`brew install FelixKratz/formulae/sketchybar`)

### Verification
```bash
# Check all prerequisites are installed
command -v yabai >/dev/null && echo "✓ yabai" || echo "✗ yabai missing"
command -v skhd >/dev/null && echo "✓ skhd" || echo "✗ skhd missing"
command -v sketchybar >/dev/null && echo "✓ sketchybar" || echo "✗ sketchybar missing"
```

### Environment
- macOS 12.0 or later
- Homebrew installed
- SIP partially disabled (for yabai scripting additions)
```

#### B. Add "Limitations" Section

Every skill should clearly state what it cannot do:

```markdown
## Limitations

This skill:
- ❌ Cannot install missing services (use Homebrew directly)
- ❌ Does not modify SIP settings (requires manual reboot)
- ❌ Cannot recover from corrupted config files (manual intervention needed)
- ❌ Only supports brew-installed services (not manual installations)
- ❌ Does not work on Linux or Windows (macOS only)
```

#### C. Add Dedicated "Error Handling" Section

Extract error handling from workflow into dedicated section:

```markdown
## Error Handling

### Validation Failures
**Symptom**: "Config validation failed"
**Cause**: Syntax error in configuration file
**Resolution**:
1. Check the specific line number in error message
2. Fix syntax error in config file
3. Run `yabai --check-config` to verify
4. Retry the skill

### Service Start Failures
**Symptom**: "Service failed to start"
**Cause**: Port conflict, permission issue, or dependency missing
**Resolution**:
1. Check logs: `tail -f /usr/local/var/log/yabai/yabai.err.log`
2. Verify no conflicting processes: `pgrep yabai`
3. Ensure dependencies started first
4. Try manual start to see detailed error

### Health Check Failures
**Symptom**: "Health check failed after restart"
**Cause**: Service started but not responding
**Resolution**:
1. Wait additional 5 seconds for initialization
2. Check if service is listening: `yabai -m query --windows`
3. Review recent log entries for errors
4. Restart the specific failing service
```

---

## 3. Description Best Practices

### Trigger-First Descriptions

The description is the **most important field** for skill activation. Claude reads descriptions to decide whether to use a skill.

**Pattern to follow:**
```
Activate when [specific trigger phrases]. Use for [primary use case].
[Brief capability summary].
```

### Recommended Description Updates

#### Service Orchestrator
```yaml
description: >
  Activate when user says "restart services", "reload yabai", "fix sketchybar",
  "restart window management", "services broken", or "apply config changes".
  Manages yabai, skhd, and sketchybar restarts with validation, correct
  dependency order, and health verification.
```

#### Pre-Commit Guardian
```yaml
description: >
  Activate when user says "validate configs", "check before commit",
  "run pre-commit", or "verify my changes". Validates dotfiles configurations
  (yabai, skhd, sketchybar, shell scripts) before git commits to prevent
  broken configs from entering the repository.
```

#### Stow Health Manager
```yaml
description: >
  Activate when user says "check symlinks", "fix stow", "stow health",
  "broken symlinks", or "verify dotfiles links". Scans and repairs GNU Stow
  managed symlinks, detects conflicts, and fixes configuration drift.
```

#### Theme Switcher
```yaml
description: >
  Activate when user says "switch theme", "change to dark mode", "apply gruvbox",
  "set theme to X", or "update color scheme". Coordinates theme changes across
  Starship, Ghostty, Neovim, SketchyBar, and Tmux with backup and rollback.
```

#### SketchyBar Plugin Dev
```yaml
description: >
  Activate when user says "create sketchybar plugin", "new bar widget",
  "debug sketchybar", or "scaffold plugin". Streamlines SketchyBar plugin
  development with templates, event setup, and testing utilities.
```

#### API Doc Generator
```yaml
description: >
  Activate when user says "generate API docs", "create swagger spec",
  "document endpoints", "OpenAPI from code", or "API reference". Auto-generates
  API documentation from code annotations, creates OpenAPI specs, and builds
  interactive documentation.
```

#### DB Migration Assistant
```yaml
description: >
  Activate when user says "create migration", "apply migration", "rollback db",
  "update schema", or "migrate database". Safely creates and applies database
  migrations with automatic backup, validation, and rollback capability.
```

#### Dependency Update Manager
```yaml
description: >
  Activate when user says "update dependencies", "upgrade packages", "check outdated",
  "npm update", "pip upgrade", or "cargo update". Automates dependency updates
  across package managers with safety checks, testing, and rollback on failure.
```

#### Test Coverage Analyzer
```yaml
description: >
  Activate when user says "check coverage", "analyze tests", "coverage report",
  "find untested code", or "improve test coverage". Measures test coverage,
  identifies gaps, and tracks coverage improvements over time.
```

#### Environment Setup Validator
```yaml
description: >
  Activate when user says "check environment", "validate setup", "verify dev env",
  "am I set up correctly", or "onboarding check". Validates development environment
  setup, checks tool versions, and identifies missing or misconfigured components.
```

---

## 4. Token Efficiency Considerations

### Current State
Skills are comprehensive (300-500 lines each), which provides excellent documentation but may use more tokens than necessary during skill loading.

### Recommendations

#### A. Keep Metadata Lean
- The full skill loads only when activated (~100 tokens for metadata scan)
- Full content should stay under 5000 tokens for efficiency

#### B. Move Examples to Separate Files (Optional)
For very large skills, consider:
```
skill-folder/
├── SKILL.md           # Core instructions (lean)
├── examples/          # Detailed examples
│   ├── basic.md
│   └── advanced.md
└── scripts/           # Helper scripts
```

#### C. Prioritize Critical Information
Order content by importance:
1. Trigger conditions (description)
2. Core workflow steps
3. Error handling
4. Examples
5. Advanced features (can be summarized)

---

## 5. Directory Structure Consideration

### Current Structure
```
dotfiles-skills/
├── dotfiles/
│   └── service-orchestrator/
└── general/
    └── api-doc-generator/
```

### Standard Claude Code Structure
```
.claude/skills/
├── service-orchestrator/
└── api-doc-generator/
```

### Recommendation
Keep the current structure for the **repository** (good organization for distribution), but ensure the **install script** places skills in `.claude/skills/` as expected by Claude Code.

The current `install.sh` already handles this correctly.

---

## 6. Implementation Priority

### Phase 1: High Priority (Immediate)
1. Add `tools` field to all SKILL.md files
2. Rewrite descriptions to be trigger-focused
3. Add "Prerequisites" section with verification commands

### Phase 2: Medium Priority (This Week)
4. Add "Limitations" section to all skills
5. Extract "Error Handling" into dedicated section
6. Standardize section ordering

### Phase 3: Low Priority (Future)
7. Consider splitting very large skills
8. Add more examples for edge cases
9. Create skill combination documentation

---

## 7. Updated Template

See `shared/templates/SKILL-template.md` for the updated template incorporating all these recommendations.

---

## References

- [Claude Code Skills Documentation](https://docs.anthropic.com/claude-code/skills)
- [Skill Authoring Best Practices](https://docs.anthropic.com/claude-code/skills/best-practices)
- [Claude Code Agent Skills Guide](https://claude.ai/skills-guide)
