---
name: Test Coverage Analyzer
description: Analyzes test coverage across multiple test frameworks, identifies untested code, generates coverage reports, and enforces coverage thresholds. Tracks coverage trends over time. Use when user wants to analyze or improve test coverage. Triggers: "analyze test coverage", "check coverage", "coverage report", "untested code"
version: 1.0.0
author: Dotfiles Skills
---

# Test Coverage Analyzer Skill

## Purpose

The Test Coverage Analyzer helps maintain high-quality test suites by measuring code coverage, identifying gaps, and tracking improvements. Manually checking coverage across multiple test frameworks and languages is tedious. This skill automatically analyzes coverage, highlights untested code paths, and provides actionable suggestions for improvement.

## When to Use This Skill

Activate when the user:
- Wants to check test coverage
- Needs coverage report
- Is improving test suite
- Wants to enforce coverage thresholds
- Mentions keywords like: "test coverage", "code coverage", "untested code", "coverage report"

## Workflow

### Phase 1: Test Framework Detection

**Detect Testing Tools**:

```bash
detect_test_frameworks() {
  # JavaScript/TypeScript
  grep -q "jest" package.json && echo "jest"
  grep -q "vitest" package.json && echo "vitest"
  
  # Python
  [ -f "pytest.ini" ] && echo "pytest"
  [ -f ".coveragerc" ] && echo "coverage.py"
  
  # Rust
  [ -f "Cargo.toml" ] && echo "cargo-tarpaulin"
  
  # Go
  [ -f "go.mod" ] && echo "go test -cover"
}
```

### Phase 2: Coverage Analysis

**Run Coverage**:

```bash
run_coverage_jest() {
  npm test -- --coverage --json --outputFile=coverage.json
}

run_coverage_pytest() {
  pytest --cov=. --cov-report=json --cov-report=html
}
```

**Parse Results**:

```bash
parse_coverage() {
  local total=$(jq '.total.lines.pct' coverage.json)
  local uncovered=$(jq '.total.lines.missed' coverage.json)
  
  echo "Coverage: ${total}%"
  echo "Uncovered lines: $uncovered"
}
```

### Phase 3: Gap Identification

**Find Untested Code**:

```bash
identify_gaps() {
  # Files with < 80% coverage
  jq -r '.files | to_entries[] | select(.value.lines.pct < 80) | "\(.key): \(.value.lines.pct)%"' coverage.json
}
```

### Phase 4: Reporting

**Generate Report**:

```
📊 Test Coverage Report

Overall Coverage: 87.3% ✅
Total Lines: 5,420
Covered: 4,732
Uncovered: 688

By Category:
✅ src/utils/: 95.2%
✅ src/api/: 89.1%
⚠️ src/services/: 76.4%
❌ src/legacy/: 42.1%

Top 5 Untested Files:
1. src/legacy/parser.js: 38.2%
2. src/services/cache.js: 65.1%
3. src/utils/validator.js: 71.8%

💡 Suggestions:
1. Add tests for src/legacy/parser.js
2. Improve coverage in src/services/

⏱️ Analysis time: 8 seconds
```

## Guidelines

### DO:
✅ Support multiple test frameworks
✅ Identify specific untested code paths
✅ Track coverage trends
✅ Enforce thresholds
✅ Generate visual reports

### DON'T:
❌ Focus only on line coverage (check branches too)
❌ Ignore test quality
❌ Set unrealistic thresholds
❌ Skip edge cases

## Success Metrics

- ✅ Coverage measured accurately
- ✅ Gaps identified
- ✅ Report generated
- ✅ Trends tracked
- ✅ < 30 seconds analysis

## Version History

- v1.0.0 (2025-10-30): Initial release
  - Multi-framework support
  - Gap identification
  - Trend tracking
  - Threshold enforcement
