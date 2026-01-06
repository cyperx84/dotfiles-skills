# Dotfiles Skills 🚀

**Production-ready Claude Code skills for dotfiles management and general development workflows**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude-Code-7c3aed)](https://claude.com/claude-code)
[![Skills](https://img.shields.io/badge/Skills-10-blue)](./dotfiles)
[![Status](https://img.shields.io/badge/Status-Production%20Ready-success)](https://github.com/cyperx84/dotfiles-skills)

> Automate your dotfiles workflows and development tasks with intelligent Claude Code skills. Save hours every week on routine maintenance, validation, and coordination tasks.

## ✅ Repository Status

**All 10 skills are production-ready!**
- ✅ 5 dotfiles-specific skills (complete)
- ✅ 5 general-purpose skills (complete)
- ✅ Full documentation
- ✅ Installation automation
- ✅ Comprehensive examples

## 🎯 What's Inside

### Dotfiles-Specific Skills

| Skill | Purpose | Time Saved |
|-------|---------|------------|
| [**Service Orchestrator**](./dotfiles/service-orchestrator/) | Intelligent service restart management | 5-10 min/day |
| [**Stow Health Manager**](./dotfiles/stow-health-manager/) | Symlink health and automated repair | 30 min/week |
| [**SketchyBar Plugin Dev**](./dotfiles/sketchybar-plugin-dev/) | Streamlined plugin development workflow | 2 hrs/plugin |
| [**Theme Switcher**](./dotfiles/theme-switcher/) | Interactive theme management | 15 min/change |
| [**Pre-Commit Guardian**](./dotfiles/pre-commit-guardian/) | Comprehensive config validation | 2 hrs/week |

### General-Purpose Skills

| Skill | Purpose | Use Case |
|-------|---------|----------|
| [**API Doc Generator**](./general/api-doc-generator/) | Auto-generate OpenAPI documentation | Backend/API projects |
| [**DB Migration Assistant**](./general/db-migration-assistant/) | Safe database schema migrations | Any project with DB |
| [**Test Coverage Analyzer**](./general/test-coverage-analyzer/) | Systematic test improvement | Projects with test suites |
| [**Dependency Update Manager**](./general/dependency-update-manager/) | Smart dependency updates | All projects |
| [**Environment Setup Validator**](./general/environment-setup-validator/) | Dev environment health checks | Team onboarding |

## ⚡ Quick Start

### Install All Skills

```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/dotfiles-skills.git
cd dotfiles-skills

# Install to user-level (~/.claude/skills/)
./install.sh --user

# Or install to project-level (.claude/skills/)
./install.sh --project
```

### Install Individual Skills

```bash
# Copy specific skill
cp -r dotfiles/service-orchestrator ~/.claude/skills/

# Or symlink for development
ln -s $(pwd)/dotfiles/service-orchestrator ~/.claude/skills/service-orchestrator
```

## 💡 Usage Examples

### Dotfiles Workflows

```
"Restart my window management services"
→ Service Orchestrator validates configs, restarts in correct order

"Check my stow symlinks"
→ Stow Health Manager scans, reports, offers to repair

"Create a new SketchyBar plugin for Docker"
→ Plugin Dev creates template, tests, integrates

"Switch to gruvbox theme"
→ Theme Switcher applies across Starship, Neovim, Ghostty

"Validate my configs before committing"
→ Pre-Commit Guardian runs all validators, blocks if broken
```

### Development Workflows

```
"Generate API documentation"
→ API Doc Generator creates OpenAPI spec + examples

"Update my dependencies safely"
→ Dependency Manager categorizes, tests, creates PR

"Add a new database column"
→ DB Migration Assistant generates migration + rollback

"Find untested code"
→ Coverage Analyzer identifies gaps, suggests tests

"Check if my environment is set up correctly"
→ Env Validator checks tools, versions, configs
```

## 🔗 Skill Combinations

Skills are designed to work together seamlessly:

### Dotfiles Maintenance Flow
```
1. Edit configs
   ↓
2. Pre-Commit Guardian → Validates all configs
   ↓
3. Stow Health Manager → Verifies symlinks
   ↓
4. Service Orchestrator → Restarts affected services
   ↓
5. Comprehensive success report
```

### New API Feature Flow
```
1. Dependency Update Manager → Ensure deps current
   ↓
2. DB Migration Assistant → Update schema
   ↓
3. [Implement feature]
   ↓
4. Test Coverage Analyzer → Ensure tested
   ↓
5. API Doc Generator → Document endpoints
   ↓
6. Env Setup Validator → Verify team can run
```

## 📊 Impact

### Time Savings
- **Per Day**: 15-30 minutes on routine tasks
- **Per Week**: 5-10 hours on maintenance and validation
- **Per Month**: 20-40 hours total saved time

### Error Prevention
- ✅ Eliminate wrong service restart order
- ✅ Prevent broken config commits
- ✅ Catch symlink issues before they break system
- ✅ Detect dependency conflicts before deployment
- ✅ Validate environments before onboarding

### Developer Experience
- 🎯 Less context switching
- 🧠 Reduced cognitive load
- 💪 Confidence to make changes
- 🚀 Faster experimentation cycles

## 🎓 Skill Showcase

### Service Orchestrator in Action

```
User: "Restart yabai and sketchybar"

📋 Service Orchestrator activated

🔍 Phase 1: Validation
✅ Yabai config valid
✅ SketchyBar config valid

🛑 Phase 2: Shutdown
✅ Stopped sketchybar
✅ Stopped yabai

🚀 Phase 3: Startup
✅ Started yabai (PID 12345)
✅ Started sketchybar (PID 12346)

🔬 Phase 4: Health Checks
✅ Yabai responding to signals
✅ SketchyBar receiving events
✅ All plugins loaded (35/35)

✨ Services restarted successfully in 3.2 seconds
```

### Pre-Commit Guardian Preventing Disaster

```
User: git commit -m "Update yabai config"

⚠️ Pre-Commit Guardian activated

🔍 Validating changed files:
  - yabai/.config/yabai/yabairc

❌ Validation Failed

Error in yabairc line 15:
  yabai -m config window_gap  # Missing value

Suggested fix:
  yabai -m config window_gap 1

🚫 Commit blocked. Fix errors and try again.
```

## 📁 Repository Structure

```
dotfiles-skills/
├── README.md                    # This file
├── LICENSE                      # MIT License
├── install.sh                   # Installation script
│
├── dotfiles/                    # Dotfiles-specific skills
│   ├── service-orchestrator/
│   ├── stow-health-manager/
│   ├── sketchybar-plugin-dev/
│   ├── theme-switcher/
│   └── pre-commit-guardian/
│
├── general/                     # General-purpose skills
│   ├── api-doc-generator/
│   ├── db-migration-assistant/
│   ├── test-coverage-analyzer/
│   ├── dependency-update-manager/
│   └── environment-setup-validator/
│
├── shared/                      # Shared resources
│   └── templates/
│
└── docs/                        # Documentation
    ├── contributing.md
    └── SKILL_IMPROVEMENTS.md
```

## 🚀 Getting Started

### Prerequisites

- Claude Code (2025+ version with skills support)
- Git (for version control)
- Appropriate tools for specific skills (e.g., brew for dotfiles skills)

### Installation Methods

#### Method 1: User-Level (Recommended)

Install skills for all your projects:

```bash
./install.sh --user
```

Skills will be available in `~/.claude/skills/`

#### Method 2: Project-Level

Install skills for a specific project:

```bash
cd your-project
/path/to/dotfiles-skills/install.sh --project
```

Skills will be available in `.claude/skills/`

#### Method 3: Manual

Copy individual skills as needed:

```bash
cp -r dotfiles/service-orchestrator ~/.claude/skills/
```

### Verification

After installation, verify skills are loaded:

```bash
# In Claude Code, ask:
"What skills are available?"

# Or check directly:
ls -la ~/.claude/skills/
```

## 🛠️ Development

### Creating New Skills

1. Use the skill template:

```bash
cp -r shared/templates/SKILL-template dotfiles/my-new-skill
cd dotfiles/my-new-skill
```

2. Edit `SKILL.md` with your workflow
3. Test the skill
4. Submit a PR!

See [Contributing Guidelines](./docs/contributing.md) for detailed guide.

### Testing Skills

```bash
# Test individual skill
cd dotfiles/service-orchestrator
# Use skill in Claude Code and observe behavior

# Run validation
./scripts/validate-skill.sh service-orchestrator
```

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](./docs/contributing.md) for guidelines.

### Ways to Contribute

- 🐛 Report bugs
- 💡 Suggest new skills
- 📝 Improve documentation
- ✨ Add features to existing skills
- 🎨 Share your custom skills

## 📖 Documentation

- [Contributing Guidelines](./docs/contributing.md) - How to contribute new skills
- [Skill Improvements](./docs/SKILL_IMPROVEMENTS.md) - Best practices for skill authoring
- [Getting Started](./GETTING_STARTED.md) - Quick start guide

## 🌟 Skill Status

| Skill | Status | Version |
|-------|--------|---------|
| Service Orchestrator | ✅ Complete | 1.0.0 |
| Stow Health Manager | ✅ Complete | 1.0.0 |
| SketchyBar Plugin Dev | ✅ Complete | 1.0.0 |
| Theme Switcher | ✅ Complete | 1.0.0 |
| Pre-Commit Guardian | ✅ Complete | 1.0.0 |
| API Doc Generator | ✅ Complete | 1.0.0 |
| DB Migration Assistant | ✅ Complete | 1.0.0 |
| Test Coverage Analyzer | ✅ Complete | 1.0.0 |
| Dependency Update Manager | ✅ Complete | 1.0.0 |
| Environment Setup Validator | ✅ Complete | 1.0.0 |

All skills include:
- ✅ Trigger-focused descriptions for reliable activation
- ✅ Tool restrictions for security
- ✅ Prerequisites with verification commands
- ✅ Multi-phase workflows
- ✅ Error handling and limitations documented

## 🎯 Roadmap

### v1.0.0 (Current)
- [x] Repository structure
- [x] 10 complete production-ready skills
- [x] Installation script
- [x] Full documentation
- [x] Anthropic best practices compliance (tools field, trigger-focused descriptions)

### v1.1.0 (Next)
- [ ] Add skill combination workflows documentation
- [ ] Create video tutorials
- [ ] Add CI/CD validation
- [ ] Expand examples for all skills

### v2.0.0 (Future)
- [ ] Advanced skill orchestration
- [ ] Skill marketplace integration
- [ ] Performance analytics
- [ ] Community skill submissions

## 📄 License

MIT License - see [LICENSE](./LICENSE) file for details.

## 🙏 Acknowledgments

- **Anthropic** for Claude Code and skills framework
- **Community contributors** for awesome-claude-skills
- **Dotfiles community** for inspiration and best practices

## 📞 Support

- 🐛 **Bug Reports**: [GitHub Issues](https://github.com/YOUR_USERNAME/dotfiles-skills/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/YOUR_USERNAME/dotfiles-skills/discussions)
- 📧 **Email**: your-email@example.com

---

**Star this repo** if you find it useful! ⭐

**Share your workflows** in Discussions!

**Contribute** and help make dotfiles management effortless for everyone!
