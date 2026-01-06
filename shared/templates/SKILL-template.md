---
name: "[Skill Name]"
description: >
  Activate when user says "[trigger phrase 1]", "[trigger phrase 2]", or
  "[trigger phrase 3]". [One sentence describing what this skill does].
  [Optional: Key capabilities or differentiators].
tools:
  - Bash
  - Read
  - Grep
  # Add other tools as needed: Write, Edit, Glob, WebFetch, etc.
  # Restricting tools improves security by limiting skill capabilities
---

# [Skill Name]

## Overview

[2-3 sentences explaining the problem this skill solves and why it's valuable. Focus on the pain point and the benefit.]

## Prerequisites

### Required Tools
- **[Tool 1]** - [What it does] (`brew install [package]`)
- **[Tool 2]** - [What it does] (`[install command]`)

### Verification
```bash
# Check all prerequisites are installed
command -v [tool1] >/dev/null && echo "✓ [tool1]" || echo "✗ [tool1] missing"
command -v [tool2] >/dev/null && echo "✓ [tool2]" || echo "✗ [tool2] missing"
```

### Environment
- [Required OS/platform]
- [Required configuration]
- [Any other environmental requirements]

## When to Activate

This skill activates when the user:
- Says "[trigger phrase 1]" or "[trigger phrase 2]"
- Wants to [accomplish specific goal]
- Mentions keywords like: "[keyword1]", "[keyword2]", "[keyword3]"
- Is experiencing [specific problem this skill solves]

## Execution Steps

### Phase 1: [Detection/Analysis]

**[Sub-step Name]**:

```bash
# Example commands
command --flags argument
```

**What to check**:
- [Check item 1]
- [Check item 2]
- [Check item 3]

### Phase 2: [Planning/Preparation]

**[Sub-step Name]**:

[Explanation of what happens in this phase]

**Key Decisions**:
- If [condition] → [action]
- If [condition] → [action]
- Otherwise → [default action]

### Phase 3: [Execution]

**[Sub-step Name]**:

```bash
# Step-by-step commands
step1_command
step2_command
```

### Phase 4: [Validation]

**[Sub-step Name]**:

Verify the operation succeeded:

```bash
# Validation commands
verify_command
test_command
```

**Success Criteria**:
- ✅ [Criterion 1]
- ✅ [Criterion 2]
- ✅ [Criterion 3]

### Phase 5: [Reporting]

**Success Report**:
```
✨ [Skill Name] Complete

📊 Summary:
✅ [Achievement 1]
✅ [Achievement 2]
✅ [Achievement 3]

🎯 Results:
[Key result 1]: [Value]
[Key result 2]: [Value]

⏱️ Total time: [X] seconds

Next steps:
- [Suggestion 1]
- [Suggestion 2]
```

## Examples

### Example 1: [Common Use Case]

**User**: "[User request]"

**Skill Actions**:
```
1. [Step 1]
2. [Step 2]
3. [Step 3]
4. Result: [Outcome]
```

### Example 2: [Edge Case]

**User**: "[User request]"

**Skill Actions**:
```
1. [Step 1]
2. [Detected edge case]
3. [Special handling]
4. Result: [Outcome]
```

### Example 3: [Error Prevented]

**User**: "[User request]"

**Skill Actions**:
```
1. [Step 1]
2. [Validation failed]
3. [Blocked operation]
4. Result: [Error prevented, user guided to fix]
```

## Error Handling

### [Error Type 1]
**Symptom**: "[What the user sees]"
**Cause**: [Why this happens]
**Resolution**:
1. [Fix step 1]
2. [Fix step 2]
3. [Verification step]

### [Error Type 2]
**Symptom**: "[What the user sees]"
**Cause**: [Why this happens]
**Resolution**:
1. [Fix step 1]
2. [Fix step 2]

### [Error Type 3]
**Symptom**: "[What the user sees]"
**Cause**: [Why this happens]
**Resolution**:
[Fix description]

## Limitations

This skill:
- ❌ Cannot [limitation 1]
- ❌ Does not [limitation 2]
- ❌ Only works with [constraint]
- ❌ Requires [prerequisite that might not be obvious]
- ❌ Not supported on [platform/environment]

## Guidelines

### DO:
- ✅ [Best practice 1]
- ✅ [Best practice 2]
- ✅ [Best practice 3]
- ✅ Always validate before executing
- ✅ Provide specific error messages
- ✅ Show actionable next steps

### DON'T:
- ❌ [Anti-pattern 1]
- ❌ [Anti-pattern 2]
- ❌ [Anti-pattern 3]
- ❌ Skip validation steps
- ❌ Execute destructive operations without confirmation

## Advanced Features

### [Feature 1 Name]

[Description of advanced feature]

**Implementation**:
```bash
# Advanced feature code
```

### [Feature 2 Name]

[Description of advanced feature]

**Use Case**: [When this is useful]

## Configuration

[Any configuration options or environment variables]

```bash
# Example configuration
export SETTING_NAME=value
```

## Integration

Works seamlessly with:
- **[Other Skill 1]**: [How they work together]
- **[Other Skill 2]**: [How they work together]

## Success Metrics

A successful [skill name] execution includes:
- ✅ [Success criterion 1]
- ✅ [Success criterion 2]
- ✅ [Success criterion 3]
- ✅ Completion time under [X] seconds

## Version History

- v1.0.0 (YYYY-MM-DD): Initial release
  - [Feature or improvement]
  - [Feature or improvement]

---

## Template Usage Guide

### Step 1: Update YAML Metadata

1. **name**: Clear, descriptive identifier
2. **description**: Focus on TRIGGER PHRASES first, then capabilities
   - Start with "Activate when user says..."
   - Include 3-5 common trigger phrases
   - End with brief capability summary
3. **tools**: List only the tools this skill needs
   - Common tools: `Bash`, `Read`, `Write`, `Edit`, `Grep`, `Glob`
   - Fewer tools = better security

### Step 2: Fill Required Sections

1. **Overview**: Problem + solution (2-3 sentences)
2. **Prerequisites**: What's needed + verification commands
3. **When to Activate**: Trigger phrases and keywords
4. **Execution Steps**: 3-5 phases with code examples
5. **Examples**: At least 3 (common, edge case, error)
6. **Error Handling**: At least 3 common errors
7. **Limitations**: At least 5 things it cannot do

### Step 3: Quality Checklist

Before considering a skill complete:

- [ ] Description starts with trigger phrases
- [ ] `tools` field lists only required tools
- [ ] Prerequisites include verification commands
- [ ] All workflow phases documented with code
- [ ] Error handling covers 3+ scenarios
- [ ] Limitations section is honest and complete
- [ ] At least 3 examples provided
- [ ] DO/DON'T guidelines included
- [ ] Tested on real use case

### Token Efficiency Tips

- Keep total skill under 5000 tokens when possible
- Front-load critical information (triggers, core workflow)
- Move verbose examples to separate files if needed
- Use concise code comments
