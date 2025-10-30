# Service Orchestrator Skill

**Intelligent macOS window management service restart automation**

## Quick Start

### Installation

```bash
# Install this skill
cp -r service-orchestrator ~/.claude/skills/

# Or use the repository installer
cd /path/to/dotfiles-skills
./install.sh --user --skill service-orchestrator
```

### Usage

Simply ask Claude Code:

```
"Restart my window management services"
"Reload yabai and sketchybar"
"Fix my window manager"
"Apply yabai config changes"
```

## What It Does

This skill automates the complex workflow of restarting macOS window management services (Yabai, SKHD, SketchyBar) with:

1. **Pre-restart Validation**
   - Validates all configs before applying
   - Prevents broken configs from breaking your system
   - Shows specific errors with fix suggestions

2. **Dependency-Aware Restart**
   - Stops services in reverse dependency order
   - Starts in correct order (Yabai → SketchyBar → SKHD)
   - Waits appropriate time between operations

3. **Health Verification**
   - Verifies each service started successfully
   - Tests integration between services
   - Checks for errors in logs

4. **Comprehensive Reporting**
   - Success: Shows PIDs, plugin counts, timing
   - Partial failure: Identifies problem, suggests fixes
   - Complete failure: Prevents restart, shows errors

## Why This Skill Exists

**The Problem**: Restarting window management services in the wrong order causes cascading failures:
- SketchyBar before Yabai = no window signals
- Services fail to start = broken system
- No validation = deploy broken configs
- Manual process = easy to forget steps

**The Solution**: Automated, validated, dependency-aware restart orchestration that just works.

## Features

### Smart Restart Planning
- Detects which configs changed
- Restarts only affected services
- Full restart when multiple configs changed

### Validation Pipeline
- Yabai: `yabai --check-config`
- SketchyBar: Plugin tests, syntax checks
- SKHD: Syntax validation, config checks

### Health Monitoring
- Process verification (PIDs)
- Plugin loading counts
- Signal integration tests
- Log error detection

### Error Prevention
- Blocks restart on validation failure
- Verifies clean shutdown
- Confirms successful startup
- Tests service integration

## Example Output

### Success

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

⏱️ Total time: 8.4 seconds
```

### Validation Prevented Disaster

```
❌ Validation Failed

Error in yabairc line 15:
  yabai -m config window_gap  # Missing value!

Expected:
  yabai -m config window_gap 1

🚫 Services NOT restarted (prevented broken config deployment)
```

## Dependencies

- **Homebrew**: For service management (`brew services`)
- **Yabai**: Window manager
- **SketchyBar**: Menu bar replacement
- **SKHD**: Hotkey daemon
- **jq**: JSON parsing (optional, for enhanced reporting)

## Configuration

No configuration needed - works out of the box with standard dotfiles setups.

### Custom Paths

If your configs are in non-standard locations, the skill will prompt for paths.

## Troubleshooting

### Skill doesn't activate

Ensure trigger words are used:
- "restart services"
- "reload window management"
- "fix yabai"

### Services won't start

Check logs shown in error output:
```bash
tail -f /usr/local/var/log/yabai/yabai.err.log
tail -f /usr/local/var/log/skhd/skhd.err.log
log show --predicate 'process == "sketchybar"' --last 1m
```

### Validation always fails

Run validation manually to see full error:
```bash
yabai --check-config
```

## Advanced Usage

### Emergency Restart

For when everything is broken:

```
"Emergency restart all services"
```

This bypasses validation and force-restarts everything.

### Selective Restart

```
"Restart only sketchybar"
"Reload just yabai"
```

The skill will restart only the requested service.

## Integration

Works seamlessly with other dotfiles skills:

- **Pre-Commit Guardian**: Validates before commit, this restarts after apply
- **Stow Health Manager**: Ensures configs are symlinked correctly before restart

## Contributing

Improvements welcome! See [CONTRIBUTING.md](../../docs/contributing.md)

### Ideas for Enhancement

- [ ] Support for additional window managers (Amethyst, Rectangle)
- [ ] Backup/restore service state
- [ ] Performance metrics tracking
- [ ] Integration with notification system
- [ ] Support for custom service dependency graphs

## License

MIT License - see [LICENSE](../../LICENSE)

## Version

**v1.0.0** - Production ready

## Changelog

### v1.0.0 (2025-10-30)
- Initial production release
- Complete validation pipeline
- Dependency-aware restart orchestration
- Comprehensive health checking
- Detailed error reporting
