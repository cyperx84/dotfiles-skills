# Getting Started with Dotfiles Skills

## 🎉 Welcome!

You now have a complete Claude Code skills repository with:
- ✅ **10 Production-Ready Skills**: All fully functional and tested
- ✅ **Complete Documentation**: README, Contributing guidelines, skill authoring guide
- ✅ **Installation System**: One-command install script
- ✅ **Anthropic Best Practices**: All skills follow latest documentation standards

## 🚀 Quick Start (2 minutes)

### 1. Install All Skills

```bash
# Clone repository (if not already done)
git clone https://github.com/YOUR_USERNAME/dotfiles-skills.git
cd dotfiles-skills

# Install to user-level (~/.claude/skills/)
./install.sh --user

# Or install to project-level (.claude/skills/)
./install.sh --project
```

### 2. Test a Skill

Open Claude Code and try one of these prompts:

**Dotfiles Skills:**
```
"Restart my window management services"
"Check my stow symlinks"
"Switch to gruvbox theme"
"Validate my configs before committing"
"Create a new SketchyBar plugin for Docker"
```

**General Skills:**
```
"Update my dependencies safely"
"Generate API documentation"
"Check my test coverage"
"Create a database migration"
"Validate my dev environment"
```

### 3. Explore the Repository

```bash
# View structure
tree -L 2

# Read a skill
cat dotfiles/service-orchestrator/SKILL.md

# Check the template for creating new skills
cat shared/templates/SKILL-template.md
```

## 📋 Available Skills

### Dotfiles Skills (5)

| Skill | What It Does | Example Prompt |
|-------|-------------|----------------|
| **Service Orchestrator** | Restarts yabai/skhd/sketchybar safely | "Restart services" |
| **Stow Health Manager** | Scans and repairs symlinks | "Check my stow health" |
| **Theme Switcher** | Coordinates theme changes | "Switch to catppuccin" |
| **Pre-Commit Guardian** | Validates configs before commit | "Validate my configs" |
| **SketchyBar Plugin Dev** | Scaffolds new plugins | "Create sketchybar plugin" |

### General Skills (5)

| Skill | What It Does | Example Prompt |
|-------|-------------|----------------|
| **Dependency Update Manager** | Safe dependency updates | "Update my dependencies" |
| **Environment Setup Validator** | Validates dev environment | "Check my environment" |
| **API Doc Generator** | Creates OpenAPI docs | "Generate API docs" |
| **Test Coverage Analyzer** | Finds untested code | "Analyze test coverage" |
| **DB Migration Assistant** | Safe database migrations | "Create migration" |

## 🔧 Installation Methods

### Method 1: User-Level (Recommended)

Install skills for all your projects:

```bash
./install.sh --user
```

Skills available in `~/.claude/skills/`

### Method 2: Project-Level

Install skills for a specific project:

```bash
cd your-project
/path/to/dotfiles-skills/install.sh --project
```

Skills available in `.claude/skills/`

### Method 3: Individual Skills

Copy specific skills as needed:

```bash
cp -r dotfiles/service-orchestrator ~/.claude/skills/
```

### Method 4: Development (Symlink)

For active development of skills:

```bash
./install.sh --user --link
```

Changes to source files immediately reflect in Claude Code.

## 📚 Understanding Skill Structure

Each skill follows the [Anthropic skill format](https://docs.anthropic.com/claude-code/skills):

```
skill-name/
├── SKILL.md       # Main skill file (required)
├── README.md      # Documentation
├── resources/     # Supporting files (optional)
└── examples/      # Usage examples (optional)
```

### SKILL.md Anatomy

```yaml
---
name: Skill Name
description: >
  Activate when user says "trigger phrase 1", "trigger phrase 2".
  Brief description of what the skill does.
tools:
  - Bash
  - Read
  - Grep
---

# Skill Name

## Overview
What problem this solves.

## Prerequisites
What's needed to use this skill.

## When to Activate
Specific trigger conditions.

## Execution Steps
Phase-by-phase workflow.

## Examples
Concrete usage scenarios.

## Error Handling
How to handle failures.

## Limitations
What the skill cannot do.
```

## 🎯 Creating New Skills

### 1. Use the Template

```bash
# Create new skill directory
mkdir -p dotfiles/my-skill

# Copy template
cp shared/templates/SKILL-template.md dotfiles/my-skill/SKILL.md
```

### 2. Fill In the Template

1. Update YAML metadata (name, description, tools)
2. Write clear trigger-focused description
3. Define workflow phases
4. Add 3+ examples
5. Document error handling
6. List limitations

### 3. Test Your Skill

```bash
# Symlink for testing
ln -s $(pwd)/dotfiles/my-skill ~/.claude/skills/my-skill

# Test in Claude Code
# Ask: "Your trigger phrase"
```

### 4. Submit a PR

See [Contributing Guidelines](./docs/contributing.md) for PR process.

## 💡 Tips for Best Results

### Trigger Phrases Matter

The `description` field determines when Claude activates your skill. Be specific:

```yaml
# Good - clear trigger phrases
description: >
  Activate when user says "restart services", "reload yabai", "fix sketchybar".

# Bad - vague description
description: Manages services.
```

### Tool Restrictions

Limit tools to what's actually needed (security best practice):

```yaml
tools:
  - Bash   # For running commands
  - Read   # For reading files
  - Grep   # For searching
  # Only include what's necessary
```

### Prerequisites with Verification

Always include verification commands:

```markdown
## Prerequisites

### Required Tools
- **jq** - JSON processing (`brew install jq`)

### Verification
```bash
command -v jq >/dev/null && echo "✓ jq" || echo "✗ jq missing"
```
```

## 🔍 Troubleshooting

### Skill Not Activating

1. Check that skills are installed: `ls ~/.claude/skills/`
2. Verify SKILL.md exists in skill directory
3. Check description includes your trigger phrases
4. Try more specific trigger phrases

### Commands Failing

1. Verify prerequisites are installed
2. Check the skill's Prerequisites section
3. Run verification commands manually
4. Review Error Handling section

### Getting Help

- Check [Contributing Guidelines](./docs/contributing.md)
- Review [Skill Improvements](./docs/SKILL_IMPROVEMENTS.md) for best practices
- Open an issue on GitHub

## 📊 Measuring Impact

Track the value you're getting:

| Metric | Expected Improvement |
|--------|---------------------|
| Time saved per day | 15-30 minutes |
| Errors prevented | Config validation catches issues |
| Context switching | Less manual intervention |
| Onboarding time | Faster with env validation |

## 🚀 What's Next?

1. **Install skills**: `./install.sh --user`
2. **Test them**: Try the example prompts above
3. **Customize**: Modify skills for your workflow
4. **Contribute**: Add new skills or improve existing ones

---

**Questions?** Check [Contributing Guidelines](./docs/contributing.md)

**Want to create skills?** See `shared/templates/SKILL-template.md`

**Found an issue?** Open a GitHub issue!
