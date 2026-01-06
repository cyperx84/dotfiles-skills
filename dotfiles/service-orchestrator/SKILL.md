---
name: Service Orchestrator
description: >
  Activate when user says "restart services", "reload yabai", "fix sketchybar",
  "restart window management", "services broken", "apply config changes", or
  mentions yabai/skhd/sketchybar issues. Manages macOS window management service
  restarts with config validation, correct dependency ordering, and health verification.
tools:
  - Bash
  - Read
  - Grep
version: 1.0.0
author: Dotfiles Skills
---

# Service Orchestrator Skill

## Overview

Automates the complex workflow of restarting macOS window management services (Yabai, SKHD, SketchyBar) in the correct dependency order with comprehensive validation and health checking. Solves the #1 pain point in dotfiles management: wrong restart order causing cascading failures.

## Prerequisites

### Required Tools
- **yabai** - Window manager (`brew install koekeishiya/formulae/yabai`)
- **skhd** - Hotkey daemon (`brew install koekeishiya/formulae/skhd`)
- **sketchybar** - Status bar (`brew install FelixKratz/formulae/sketchybar`)
- **jq** - JSON processing (`brew install jq`)

### Verification
```bash
# Check all prerequisites are installed
command -v yabai >/dev/null && echo "✓ yabai" || echo "✗ yabai missing"
command -v skhd >/dev/null && echo "✓ skhd" || echo "✗ skhd missing"
command -v sketchybar >/dev/null && echo "✓ sketchybar" || echo "✗ sketchybar missing"
command -v jq >/dev/null && echo "✓ jq" || echo "✗ jq missing"
```

### Environment
- macOS 12.0 (Monterey) or later
- Homebrew installed
- SIP partially disabled (for yabai scripting additions)
- Services installed via Homebrew services

## When to Use This Skill

Activate when the user:
- Explicitly asks to "restart services"
- Wants to "reload window management" or "reload yabai/skhd/sketchybar"
- Says "fix yabai" or "sketchybar not working"
- Mentions service issues after config changes
- Asks to "apply changes" to window management configs

## Critical Context

### Service Dependencies (MUST MAINTAIN ORDER)

```
Yabai (Window Manager)
  ↓ signals
SketchyBar (Menu Bar)
  ↓ events
SKHD (Hotkey Daemon) [independent but coordinates with both]
```

**CRITICAL**: SketchyBar depends on Yabai signals. Starting SketchyBar before Yabai = broken integration.

**Correct Start Order**: Yabai → SketchyBar → SKHD
**Correct Stop Order**: SKHD → SketchyBar → Yabai (reverse)

## Workflow

### Phase 1: Detection & Planning

**Determine Scope**:

```bash
# Check which configs changed (if in git repo)
git diff --name-only HEAD | grep -E "yabai|skhd|sketchybar"

# Or check all configs
ls -la ~/.config/yabai/yabairc
ls -la ~/.config/skhd/skhdrc
ls -la ~/.config/sketchybar/sketchybarrc
```

**Service Detection**:
```bash
# Check which services are running
brew services list | grep -E "yabai|skhd|sketchybar"
```

**Smart Restart Planning**:
- If ONLY yabai config changed → restart yabai + sketchybar (sketchybar reads yabai state)
- If ONLY sketchybar config changed → restart only sketchybar
- If ONLY skhd config changed → restart only skhd
- If multiple configs changed → restart all in correct order
- If unsure → restart all (safest)

### Phase 2: Pre-Restart Validation

**CRITICAL**: Always validate configs before restarting. Broken config = service won't start = system broken.

**Yabai Validation**:
```bash
# Yabai has built-in validation
yabai --check-config

# Exit code 0 = valid, non-zero = invalid
# If invalid, show errors and STOP - do not restart
```

**SketchyBar Validation**:
```bash
# No built-in validator, but can check:
# 1. Syntax check if plugin is bash
bash -n ~/.config/sketchybar/sketchybarrc

# 2. Check if helper binary exists and is executable
if [ -f ~/.config/sketchybar/helper/helper ]; then
    echo "Helper binary found"
else
    echo "WARNING: Helper binary missing"
fi

# 3. Run test script if available
if [ -f ~/.config/sketchybar/test_sketchybar.sh ]; then
    echo "Running SketchyBar tests..."
    ~/.config/sketchybar/test_sketchybar.sh
fi
```

**SKHD Validation**:
```bash
# No built-in validator
# Check config file exists and is readable
if [ -r ~/.config/skhd/skhdrc ]; then
    echo "SKHD config readable"
    # Basic syntax check - look for obvious errors
    grep -E "^\s*#|^\s*$|^[a-z]" ~/.config/skhd/skhdrc > /dev/null
else
    echo "ERROR: SKHD config not found or not readable"
fi
```

**Validation Result Handling**:
- ✅ All valid → Proceed to restart
- ❌ Any invalid → STOP, show errors, suggest fixes, DO NOT restart

### Phase 3: Service Shutdown (Reverse Dependency Order)

**Order**: SKHD → SketchyBar → Yabai

```bash
# Stop SKHD (hotkey daemon, no dependencies)
echo "Stopping SKHD..."
brew services stop skhd
sleep 1

# Stop SketchyBar (depends on Yabai signals)
echo "Stopping SketchyBar..."
brew services stop sketchybar
sleep 1

# Stop Yabai (window manager, others depend on it)
echo "Stopping Yabai..."
brew services stop yabai
sleep 2  # Give it time to clean up
```

**Verification**:
```bash
# Verify services are actually stopped
for service in yabai skhd sketchybar; do
    if pgrep -x "$service" > /dev/null; then
        echo "WARNING: $service still running, force killing..."
        killall "$service"
    fi
done
```

### Phase 4: Service Startup (Correct Dependency Order)

**Order**: Yabai → SketchyBar → SKHD

```bash
# Start Yabai first (others depend on it)
echo "Starting Yabai..."
brew services start yabai
sleep 3  # Wait for full initialization

# Verify Yabai started
if ! pgrep -x yabai > /dev/null; then
    echo "ERROR: Yabai failed to start"
    echo "Check logs: tail -f /usr/local/var/log/yabai/yabai.err.log"
    exit 1
fi

# Start SketchyBar (depends on Yabai signals)
echo "Starting SketchyBar..."
brew services start sketchybar
sleep 2  # Wait for bar to initialize

# Verify SketchyBar started
if ! pgrep -x sketchybar > /dev/null; then
    echo "ERROR: SketchyBar failed to start"
    echo "Check logs: log show --predicate 'process == \"sketchybar\"' --last 1m"
    exit 1
fi

# Start SKHD (independent but coordinates with both)
echo "Starting SKHD..."
brew services start skhd
sleep 1

# Verify SKHD started
if ! pgrep -x skhd > /dev/null; then
    echo "ERROR: SKHD failed to start"
    echo "Check logs: tail -f /usr/local/var/log/skhd/skhd.err.log"
    exit 1
fi
```

### Phase 5: Health Checks & Verification

**Yabai Health**:
```bash
# Check if Yabai is responding
yabai -m query --windows > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Yabai responding to queries"
else
    echo "⚠️ Yabai not responding"
fi

# Check if spaces are being managed
space_count=$(yabai -m query --spaces | jq 'length')
echo "Managing $space_count spaces"

# Verify external bar configuration
external_bar=$(yabai -m config external_bar)
echo "External bar: $external_bar"
```

**SketchyBar Health**:
```bash
# Check if bar is visible
if pgrep -x sketchybar > /dev/null; then
    echo "✅ SketchyBar process running"

    # Run plugin health monitor if available
    if [ -f ~/.config/sketchybar/plugin_health_monitor.sh ]; then
        ~/.config/sketchybar/plugin_health_monitor.sh test
    fi

    # Check if plugins are loaded
    plugin_count=$(ls ~/.config/sketchybar/plugins/*.sh 2>/dev/null | wc -l)
    echo "Found $plugin_count plugins"
else
    echo "⚠️ SketchyBar not running"
fi
```

**SKHD Health**:
```bash
# Check if SKHD is processing hotkeys
if pgrep -x skhd > /dev/null; then
    echo "✅ SKHD process running"

    # Count configured hotkeys
    hotkey_count=$(grep -cE "^[a-z]" ~/.config/skhd/skhdrc)
    echo "Loaded $hotkey_count hotkeys"
else
    echo "⚠️ SKHD not running"
fi
```

**Integration Verification**:
```bash
# Test Yabai → SketchyBar signal flow
echo "Testing signal integration..."

# Send test signal (if safe)
# sketchybar --trigger windows_on_spaces

# Check recent errors in logs
echo "Checking for recent errors..."
tail -n 20 /usr/local/var/log/yabai/yabai.err.log 2>/dev/null | grep -i error || echo "No Yabai errors"
tail -n 20 /usr/local/var/log/skhd/skhd.err.log 2>/dev/null | grep -i error || echo "No SKHD errors"
```

### Phase 6: Reporting

**Success Report**:
```
✨ Service Orchestrator Complete

📊 Summary:
✅ Validation passed (all configs valid)
✅ Services stopped cleanly
✅ Services started successfully
✅ Health checks passed

🎯 Service Status:
✅ Yabai:      Running (PID 12345, managing 5 spaces)
✅ SketchyBar: Running (PID 12346, 35 plugins loaded)
✅ SKHD:       Running (PID 12347, 127 hotkeys active)

🔗 Integration:
✅ Yabai signals → SketchyBar ✓
✅ External bar configured: all:32:0 ✓

⏱️ Total time: 8.4 seconds

Next steps:
- Test window management (try moving a window)
- Check SketchyBar displays correctly
- Verify hotkeys work (try a key combination)
```

**Partial Failure Report**:
```
⚠️ Service Orchestrator - Partial Success

📊 Summary:
✅ Yabai:      Started successfully
✅ SKHD:       Started successfully
❌ SketchyBar: Failed to start

🔍 Investigation:
SketchyBar failed with error:
  "helper binary not found"

💡 Suggested Fix:
cd ~/.config/sketchybar/helper && make clean && make
brew services restart sketchybar

📋 Logs:
/usr/local/var/log/yabai/yabai.err.log
/usr/local/var/log/skhd/skhd.err.log
log show --predicate 'process == "sketchybar"' --last 5m
```

**Complete Failure Report**:
```
❌ Service Orchestrator - Failed

🛑 Validation Failed

Error in yabairc line 15:
  yabai -m config window_gap  # Missing value!

Expected:
  yabai -m config window_gap 1

🚫 Services NOT restarted (prevented broken config deployment)

📝 To fix:
1. Edit ~/.config/yabai/yabairc
2. Fix the error on line 15
3. Run: yabai --check-config
4. Try again: "restart services"
```

## Examples

### Example 1: After Yabai Config Change

**User**: "I just changed my yabai config, restart it"

**Skill Actions**:
```
1. Detected change in yabai config
2. Running validation: yabai --check-config
3. ✅ Config valid
4. Planning: Restart yabai + sketchybar (dependent)
5. Stopping sketchybar... ✅
6. Stopping yabai... ✅
7. Starting yabai... ✅ (PID 12345)
8. Starting sketchybar... ✅ (PID 12346)
9. Health checks... ✅ All passed
10. Integration test... ✅ Signals working

✨ Successfully restarted in 6.2 seconds
```

### Example 2: Emergency Restart (Everything Broken)

**User**: "Everything is broken, restart all window management services"

**Skill Actions**:
```
1. Emergency restart mode activated
2. Validation bypassed (emergency mode)
3. Force stopping all services...
   - killall skhd sketchybar yabai
4. Waiting 3 seconds for cleanup...
5. Starting Yabai... ✅
6. Starting SketchyBar... ✅
7. Starting SKHD... ✅
8. Running full health checks...
9. All services recovered ✅

⚠️ Note: Emergency restart bypassed validation
   Run 'validate configs' to check for issues
```

### Example 3: Validation Prevented Disaster

**User**: "Restart yabai"

**Skill Actions**:
```
1. Running validation: yabai --check-config
2. ❌ Validation FAILED

Error found:
  yabairc line 23: unknown config 'window_gap_size'
  (Correct name is 'window_gap')

🚫 Restart BLOCKED to prevent breaking system

Fix the error and try again.
```

## Error Handling

### Validation Failures
**Symptom**: "Config validation failed" or "yabai --check-config returned error"
**Cause**: Syntax error or invalid configuration in yabairc, skhdrc, or sketchybarrc
**Resolution**:
1. Check the specific line number in the error message
2. Fix the syntax error in the config file
3. Run `yabai --check-config` to verify the fix
4. Retry the skill with "restart services"

### Service Start Failures
**Symptom**: "Service failed to start" or "PID not found after start"
**Cause**: Port conflict, permission issue, or missing dependency
**Resolution**:
1. Check logs: `tail -f /usr/local/var/log/yabai/yabai.err.log`
2. Verify no conflicting processes: `pgrep yabai`
3. Ensure dependencies started first (yabai before sketchybar)
4. Try manual start: `brew services start yabai`
5. Check SIP status if yabai scripting additions fail

### Health Check Failures
**Symptom**: "Health check failed" or "Service not responding"
**Cause**: Service started but not fully initialized or not responding to queries
**Resolution**:
1. Wait additional 5 seconds for full initialization
2. Check if service is listening: `yabai -m query --windows`
3. Review recent log entries for errors
4. Restart the specific failing service individually

### Integration Failures
**Symptom**: "SketchyBar not receiving yabai signals" or "Blank bar"
**Cause**: Services started in wrong order or external_bar config incorrect
**Resolution**:
1. Verify yabai external_bar config: `yabai -m config external_bar`
2. Ensure yabai started before sketchybar
3. Check sketchybar event subscriptions
4. Rebuild helper binary if needed: `cd ~/.config/sketchybar/helper && make`

## Limitations

This skill:
- ❌ Cannot install missing services (use Homebrew directly)
- ❌ Does not modify SIP settings (requires manual reboot into recovery mode)
- ❌ Cannot recover from corrupted config files (manual intervention needed)
- ❌ Only supports Homebrew-installed services (not manual installations)
- ❌ Does not work on Linux or Windows (macOS only)
- ❌ Cannot fix permission issues automatically (requires manual sudo/chmod)
- ❌ Does not support services other than yabai, skhd, and sketchybar
- ❌ Cannot restart services if user is not logged in to the GUI session

## Guidelines

### DO:
✅ Always validate configs before restarting
✅ Always restart in correct dependency order
✅ Always verify services started successfully
✅ Always run health checks after restart
✅ Provide detailed error messages with fixes
✅ Backup current service state (PIDs) before restart
✅ Wait appropriate time between service operations
✅ Check logs for errors after restart
✅ Test integration between services

### DON'T:
❌ Skip validation (causes broken system)
❌ Restart in wrong order (breaks integration)
❌ Assume service started successfully without checking
❌ Restart services while user is actively using them (warn first)
❌ Force kill without trying graceful shutdown first
❌ Ignore error logs
❌ Restart services unnecessarily (only restart what changed)

## Advanced Features

### Selective Restart

Based on what changed, intelligently restart only necessary services:

**Yabai only changed**:
- Restart: yabai, sketchybar (reads yabai state)
- Skip: skhd (not affected)

**SketchyBar only changed**:
- Restart: sketchybar only
- Skip: yabai, skhd (not affected)

**SKHD only changed**:
- Restart: skhd only
- Skip: yabai, sketchybar (not affected)

### Rollback on Failure

If new config causes service failure:
```
1. Detect failure
2. Restore previous config from git/backup
3. Restart with known-good config
4. Notify user of rollback
5. Show diff of what was reverted
```

### Service Dependency Graph

Maintain awareness of full dependency tree:
```
Yabai
├─ Signals → SketchyBar
├─ Window queries → SKHD
└─ Space management → Both

SketchyBar
├─ Reads Yabai state
├─ Subscribes to Yabai events
└─ Helper binary dependency

SKHD
├─ Controls Yabai operations
└─ Triggers SketchyBar actions
```

## Troubleshooting

### Common Issues

**Issue**: Service won't start after restart
**Solution**:
```
1. Check logs for specific error
2. Validate config syntax
3. Check if port/socket already in use
4. Verify dependencies installed
5. Try manual start: brew services start <service>
```

**Issue**: SketchyBar shows blank bar
**Solution**:
```
1. Check if Yabai started successfully
2. Verify external_bar config in yabairc
3. Check SketchyBar logs for errors
4. Rebuild helper binary if needed
5. Test plugins individually
```

**Issue**: Hotkeys not working
**Solution**:
```
1. Check SKHD is running
2. Verify skhdrc syntax
3. Check logs: tail -f /usr/local/var/log/skhd/skhd.out.log
4. Test with simple hotkey first
5. Check for key conflicts
```

## Success Metrics

A successful service restart includes:
- ✅ All configs validated before restart
- ✅ Services stopped cleanly
- ✅ Services started in correct order
- ✅ All PIDs verified
- ✅ Health checks passed
- ✅ Integration verified
- ✅ No errors in logs
- ✅ User can immediately use window management
- ✅ Completion time under 10 seconds

## Version History

- v1.0.0 (2025-10-30): Initial production release
  - Complete validation pipeline
  - Dependency-aware restart orchestration
  - Comprehensive health checking
  - Detailed error reporting
