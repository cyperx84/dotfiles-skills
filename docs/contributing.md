# Contributing to Dotfiles Skills

Thank you for your interest in contributing! This guide will help you create high-quality Claude Code skills.

## Table of Contents

- [Getting Started](#getting-started)
- [Creating a New Skill](#creating-a-new-skill)
- [Skill Quality Standards](#skill-quality-standards)
- [Testing Your Skill](#testing-your-skill)
- [Submitting a Pull Request](#submitting-a-pull-request)
- [Skill Development Best Practices](#skill-development-best-practices)

## Getting Started

### Prerequisites

- Claude Code (2025+ version with skills support)
- Git for version control
- Familiarity with the tools your skill will automate

### Fork and Clone

```bash
# Fork the repository on GitHub
# Then clone your fork
git clone https://github.com/YOUR_USERNAME/dotfiles-skills.git
cd dotfiles-skills

# Add upstream remote
git remote add upstream https://github.com/ORIGINAL_OWNER/dotfiles-skills.git
```

## Creating a New Skill

### 1. Choose Skill Category

Determine if your skill is:
- **Dotfiles-specific**: Goes in `dotfiles/`
- **General-purpose**: Goes in `general/`

### 2. Create Skill Directory

```bash
# For dotfiles skill
mkdir -p dotfiles/my-skill-name/{resources,examples}

# For general skill
mkdir -p general/my-skill-name/{resources,examples}
```

### 3. Use the Template

```bash
# Copy the skill template
cp shared/templates/SKILL-template.md dotfiles/my-skill-name/SKILL.md

# Edit the SKILL.md file
# Follow the instructions in the template
```

### 4. Fill Out SKILL.md

**Required Sections**:

1. **YAML Frontmatter**
   ```yaml
   ---
   name: My Skill Name
   description: Clear description with trigger keywords
   version: 0.1.0
   author: Your Name
   ---
   ```

2. **Purpose**: 2-3 sentences on what problem this solves

3. **When to Use**: Clear trigger conditions

4. **Workflow**: 3-5 phases breaking down the automation

5. **Examples**: At least 3 examples showing different scenarios

6. **Guidelines**: DO/DON'T best practices

7. **Dependencies**: All required tools

8. **Troubleshooting**: Common issues and fixes

### 5. Create README.md

Every skill needs a README explaining:
- Quick start usage
- What it does
- Why it exists
- Example output
- Dependencies
- Configuration

See `dotfiles/service-orchestrator/README.md` for an excellent example.

## Skill Quality Standards

### Minimum Requirements

- [ ] **YAML frontmatter** complete with name, description, version, author
- [ ] **Clear trigger keywords** in description
- [ ] **Workflow broken into phases** (3-5 logical steps)
- [ ] **At least 3 examples** (success, edge case, error)
- [ ] **Error handling** for common failures
- [ ] **Validation** before executing destructive operations
- [ ] **Clear output** with success/failure reporting
- [ ] **README.md** explaining the skill
- [ ] **Dependencies documented**
- [ ] **Tested** on actual use case

### Recommended Additions

- [ ] Resources directory with helper files
- [ ] Examples directory with real-world usage
- [ ] Troubleshooting guide
- [ ] Integration notes with other skills
- [ ] Performance considerations
- [ ] Advanced features documented

## Testing Your Skill

### Local Testing

1. **Install to local Claude Code**:
   ```bash
   # Symlink for easy testing
   ln -s $(pwd)/dotfiles/my-skill-name ~/.claude/skills/my-skill-name
   ```

2. **Test activation**:
   - Use trigger keywords
   - Verify skill activates correctly
   - Test happy path

3. **Test error handling**:
   - Intentionally cause errors
   - Verify error messages are clear
   - Confirm operations are rolled back

4. **Test edge cases**:
   - Missing dependencies
   - Partial failures
   - Concurrent operations

### Validation Checklist

Before submitting:

```bash
# Check SKILL.md syntax
# Ensure all placeholders are replaced
grep -r "\[.*\]" dotfiles/my-skill-name/SKILL.md

# Verify no TODO markers
grep -ri "TODO\|FIXME" dotfiles/my-skill-name/

# Test installation
./install.sh --user --skill my-skill-name
```

## Submitting a Pull Request

### 1. Create Feature Branch

```bash
git checkout -b feature/my-skill-name
```

### 2. Make Your Changes

```bash
# Add your skill files
git add dotfiles/my-skill-name/

# Commit with clear message
git commit -m "Add: My Skill Name - Brief description

- Feature 1
- Feature 2
- Tested on [platform/use case]"
```

### 3. Update Documentation

If your skill is complete (not just a template):
- Update main README.md skill status table
- Add skill to appropriate category in README

### 4. Push and Create PR

```bash
# Push to your fork
git push origin feature/my-skill-name

# Create PR on GitHub
# Include:
# - What the skill does
# - Why it's useful
# - Testing performed
# - Screenshots/examples if relevant
```

### PR Template

```markdown
## Skill: [Name]

### Description
[Brief description of what the skill does]

### Category
- [ ] Dotfiles-specific
- [ ] General-purpose

### Type
- [ ] Complete skill (production-ready)
- [ ] Template/Framework
- [ ] Enhancement to existing skill

### Testing
- [ ] Tested on macOS/Linux/Windows
- [ ] Happy path works
- [ ] Error handling tested
- [ ] Edge cases covered

### Checklist
- [ ] SKILL.md complete
- [ ] README.md added
- [ ] Examples provided
- [ ] Dependencies documented
- [ ] No placeholders remain
- [ ] Follows skill quality standards

### Example Output
[Paste example of skill in action]

### Additional Notes
[Any other context, limitations, or future improvements]
```

## Skill Development Best Practices

### 1. Clear Trigger Keywords

Good:
```yaml
description: "Manages database migrations safely. Triggers: 'create migration', 'update schema', 'migrate database'"
```

Bad:
```yaml
description: "Database stuff"
```

### 2. Phase-Based Workflow

Structure skills in logical phases:
1. **Detection/Analysis** - Understand current state
2. **Planning** - Determine what to do
3. **Execution** - Perform the action
4. **Validation** - Verify success
5. **Reporting** - Communicate results

### 3. Always Validate First

```markdown
### Phase 1: Validation

Before making any changes:
- Check prerequisites
- Validate input
- Verify safe to proceed
- Backup if destructive

If validation fails:
- STOP immediately
- Show clear error
- Suggest fix
- DO NOT proceed
```

### 4. Comprehensive Error Handling

For each phase, document:
- What can go wrong
- How to detect it
- How to recover
- What to tell the user

### 5. Actionable Output

Good output:
```
❌ Service failed to start

Error: Port 3000 already in use

💡 Fix:
1. Find process: lsof -i :3000
2. Kill it: kill -9 [PID]
3. Try again
```

Bad output:
```
Error: Failed
```

### 6. Integration Awareness

Skills should:
- Work independently
- Compose with other skills
- Share common patterns
- Avoid conflicts

### 7. Performance Considerations

- Minimize tool invocations
- Use parallel operations where safe
- Show progress for long operations
- Target < 10 seconds for most operations

### 8. Documentation = Code

Treat documentation as importantly as the skill logic:
- Clear examples
- Complete troubleshooting
- Accurate dependencies
- Realistic use cases

## Code Style

### SKILL.md Formatting

- Use `###` for phase headers
- Use `**Bold**` for sub-steps
- Use code blocks with language hints
- Use ✅ ❌ ⚠️ emojis for status
- Use lists for steps and checklists

### README.md Formatting

- Start with one-line description
- Quick start first
- Examples before details
- Troubleshooting near end
- Contributing/license at bottom

## Getting Help

- 💬 **Discussions**: Ask questions
- 🐛 **Issues**: Report problems
- 📧 **Email**: Direct contact
- 📖 **Docs**: Check existing skills

## Recognition

Contributors will be:
- Listed in skill author field
- Mentioned in release notes
- Featured in community showcases

## Thank You!

Every contribution makes dotfiles management easier for everyone. We appreciate your time and effort!

---

**Questions?** Open a discussion or issue. We're here to help!
