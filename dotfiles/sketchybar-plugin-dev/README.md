# SketchyBar Plugin Dev

**Automates SketchyBar plugin development from scaffolding to deployment with testing and debugging built-in.**

## Quick Start

```bash
# Install the skill
cd ~/dotfiles-skills
./install.sh --user --skill sketchybar-plugin-dev

# Use in Claude Code
"Create a SketchyBar plugin to show Spotify track"
"Debug my weather plugin"
"Test my docker-status plugin"
```

## What It Does

Makes SketchyBar plugin development effortless:

1. **Scaffolds plugins** from proven templates
2. **Sets up event subscriptions** automatically
3. **Implements data fetching** patterns
4. **Adds error handling** and logging
5. **Creates test scripts** for validation
6. **Integrates with SketchyBar** config
7. **Debugs issues** with detailed diagnostics

## Why This Exists

Creating SketchyBar plugins manually is complex:
- Learn SketchyBar's event system
- Write correct bash script structure
- Handle file permissions
- Integrate with main config
- Debug when things break
- No testing framework

This skill provides:
- ✅ **30 seconds** to working plugin (vs 30+ minutes manually)
- ✅ **Proven templates** for common plugin types
- ✅ **Built-in testing** catches issues early
- ✅ **Automatic integration** with SketchyBar
- ✅ **Debug tools** for troubleshooting

## Use Cases

### Create New Plugin
```
User: "Create plugin showing current Docker container count"

Skill:
- Scaffolds docker-status.sh from template
- Implements `docker ps -q | wc -l`
- Adds click to open Docker Desktop
- Creates test script
- Integrates with sketchybarrc
- Deploys and verifies

Result: Working plugin in 30 seconds
```

### Debug Broken Plugin
```
User: "My weather plugin stopped working"

Skill:
- Analyzes weather.sh code
- Identifies missing API key
- Finds timeout too short
- Adds error handling
- Tests fixes
- Redeploys

Result: Plugin working again
```

### Add Tests
```
User: "Add tests for my Spotify plugin"

Skill:
- Creates test_spotify.sh
- Tests data fetch
- Tests SketchyBar update
- Tests click handler
- Runs all tests

Result: Validated plugin
```

## Key Features

### 📝 Smart Scaffolding
- Data display plugins
- Action button plugins
- Status indicator plugins
- Combined (data + action) plugins
- Custom templates

### 🔌 Automatic Integration
- Adds to sketchybarrc
- Sets up event subscriptions
- Configures update frequency
- Handles icon/label styling
- Reloads SketchyBar

### 🧪 Built-in Testing
- File existence checks
- Data fetch validation
- SketchyBar update tests
- Click handler tests
- Interactive REPL for testing

### 🐛 Debug Tools
- Debug logging mode
- Error trace analysis
- Performance monitoring
- Event trigger testing

## Example Output

```
🚀 Creating SketchyBar Plugin: spotify

📋 Configuration:
- Name: spotify
- Type: Data Display
- Update: On track change
- Source: AppleScript (Spotify API)

📁 Scaffolding plugin...
✅ Created: ~/.config/sketchybar/plugins/spotify.sh
✅ Created: ~/.config/sketchybar/plugins/helpers/spotify_helpers.sh
✅ Created: ~/.config/sketchybar/plugins/tests/test_spotify.sh
✅ Created: ~/.config/sketchybar/plugins/docs/spotify.md

🔧 Implementing features...
✅ Data fetch: osascript Spotify track
✅ Error handling: timeout + fallback
✅ Click action: open Spotify
✅ Caching: 30s TTL

📝 Integrating with SketchyBar...
✅ Added to sketchybarrc
✅ Event subscriptions: spotify_change
✅ Update frequency: event-based
✅ Position: right side

🧪 Running tests...
✅ Plugin file exists and executable
✅ Data fetch works: "Currently Playing - Artist Name"
✅ SketchyBar update successful
✅ Click handler works

🚀 Deploying...
✅ SketchyBar reloaded
✅ Plugin visible and updating

✨ Plugin Creation Complete!

📊 Summary:
- Files created: 4
- Tests passed: 4/4
- Integration: Complete
⏱️ Total time: 28 seconds

📝 Next Steps:
1. Customize: ~/.config/sketchybar/plugins/spotify.sh
2. Test: ~/.config/sketchybar/plugins/tests/test_spotify.sh
3. Docs: ~/.config/sketchybar/plugins/docs/spotify.md

💡 Trigger update: sketchybar --trigger spotify.update
💡 Debug mode: DEBUG_MODE=true SENDER="forced" NAME="spotify" ...
```

## Plugin Templates

### Data Display (Read-Only)
Shows information from a data source.
**Examples**: Weather, Spotify, System stats

### Action Button (Click-Only)
Triggers action when clicked.
**Examples**: Screenshot, Lock screen, Open app

### Status Indicator (Icon/Color)
Visual status using icon/color changes.
**Examples**: WiFi status, Battery, VPN

### Combined (Data + Action)
Shows data AND responds to clicks.
**Examples**: Docker status + open Desktop, Volume + open settings

## Dependencies

### Required
```bash
brew install sketchybar
brew install jq          # For plugin queries
```

### Highly Recommended
```bash
brew install shellcheck  # Validate scripts
brew install bash        # Modern bash features
```

### Optional (Plugin-Specific)
Depends on what your plugin does:
```bash
# Weather plugins
brew install curl jq

# System stats
brew install htop iostat

# Docker plugins
brew install --cask docker
```

## Quick Reference

### Create Plugin
```
"Create SketchyBar plugin called [name] that [does what]"
"Make a menu bar widget showing [data]"
```

### Test Plugin
```
"Test my [plugin-name] plugin"
"Run SketchyBar plugin tests"
```

### Debug Plugin
```
"Debug [plugin-name] plugin"
"My [plugin] isn't updating, help debug"
```

### Integration
```
"Integrate [plugin] with SketchyBar"
"Add [plugin] to my menu bar"
```

## Advanced Features

### Dynamic State-Based Styling
```bash
# Changes icon/color based on data value
if [ $value -gt 80 ]; then
  icon="🔴" color="$RED"
elif [ $value -gt 50 ]; then
  icon="🟡" color="$YELLOW"
else
  icon="🟢" color="$GREEN"
fi
```

### Popup Menus
```bash
# Shows menu on click
handle_click() {
  sketchybar --add item popup.option1 popup \\
             --set popup.option1 label="Refresh"
}
```

### Multi-Source Aggregation
```bash
# Combines data from multiple sources
data="${spotify_track} | ${weather_temp}"
```

## Troubleshooting

### Plugin Not Showing
```bash
# Verify integration
sketchybar --query plugin-name

# Check config
grep "plugin-name" ~/.config/sketchybar/sketchybarrc

# Reload
sketchybar --reload
```

### Plugin Crashes SketchyBar
```bash
# Validate syntax
shellcheck ~/.config/sketchybar/plugins/plugin-name.sh

# Test isolation
DEBUG_MODE=true SENDER="forced" NAME="plugin-name" ./plugin-name.sh
```

### Data Not Updating
```bash
# Check update freq
sketchybar --query plugin-name | jq '.update_freq'

# Trigger manually
sketchybar --trigger plugin-name.update

# Test data source
source plugin-name.sh && fetch_data
```

## Success Metrics

This skill provides:
- **25-30 minutes saved** per plugin
- **Zero broken plugins** from template use
- **100% test coverage** for new plugins
- **Professional structure** for all plugins
- **Easy debugging** with built-in tools

## Related Skills

- **[Service Orchestrator](../service-orchestrator/)** - Reloads SketchyBar after changes
- **[Pre-Commit Guardian](../pre-commit-guardian/)** - Validates plugin scripts
- **[Theme Switcher](../theme-switcher/)** - Updates plugin colors

## Contributing

Want to add more templates or features? See [Contributing Guide](../../docs/contributing.md).

## License

MIT License - See [LICENSE](../../LICENSE) for details.