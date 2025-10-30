# Environment Setup Validator

**Validates dev environment setup in seconds with detailed reports and fix suggestions.**

## Quick Start

```bash
# Install
cd ~/dotfiles-skills
./install.sh --user --skill environment-setup-validator

# Use
"Validate my development environment"
"Check if I have everything installed"
```

## What It Does

1. **Detects requirements** from project files
2. **Checks tool installations** and versions
3. **Validates configurations** and env vars
4. **Tests permissions** and access
5. **Runs smoke tests** for functionality
6. **Generates report** with fix commands

## Why This Exists

- ✅ **30 seconds** vs 2+ hours manual checking
- ✅ **Catches issues** before they cause problems
- ✅ **Perfect for onboarding** new team members
- ✅ **Platform-aware** (macOS, Linux, Windows)
- ✅ **Exact fix commands** provided

## Example Output

```
🔍 Validating Environment...

✅ 15 checks passed
⚠️ 3 warnings
❌ 2 failures

Required Actions:
1. Install Docker: brew install --cask docker
2. Update Rust: rustup update

⏱️ 12 seconds
```

## Use Cases

- New machine setup
- Team onboarding
- CI/CD validation
- Troubleshooting

## License

MIT License
