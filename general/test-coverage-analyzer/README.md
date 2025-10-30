# Test Coverage Analyzer

**Analyzes test coverage across frameworks with gap identification and trend tracking.**

## Quick Start

```bash
# Install
cd ~/dotfiles-skills
./install.sh --user --skill test-coverage-analyzer

# Use
"Analyze test coverage"
"Show me untested code"
"Generate coverage report"
```

## What It Does

1. **Detects test frameworks** (Jest, pytest, cargo, etc.)
2. **Runs coverage analysis**
3. **Identifies untested code** and gaps
4. **Generates reports** with visual charts
5. **Tracks trends** over time
6. **Enforces thresholds** (fail if < X%)

## Why This Exists

- ✅ **One command** for all test frameworks
- ✅ **Actionable insights** on what needs tests
- ✅ **Trend tracking** shows improvement
- ✅ **Threshold enforcement** maintains quality

## Example Output

```
📊 Coverage: 87.3% ✅

⚠️ Low Coverage:
- src/legacy/parser.js: 38.2%
- src/services/cache.js: 65.1%

💡 Add 120 lines of tests to reach 90%
```

## Use Cases

- PR coverage checks
- Quality gates
- Test improvement
- Coverage trends

## License

MIT License
