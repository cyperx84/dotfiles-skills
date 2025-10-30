# Theme Switcher

**Safely switches themes across all dotfiles components with automatic validation, backup, and rollback.**

## Quick Start

```bash
# Install the skill
cd ~/dotfiles-skills
./install.sh --user --skill theme-switcher

# Use in Claude Code
"Switch to gruvbox dark theme"
"Change theme to catppuccin mocha"
"Apply nord theme"
"Preview available themes"
```

## What It Does

The Theme Switcher coordinates theme changes across your entire dotfiles setup:

1. **Detects available themes** across all components (Starship, Ghostty, Neovim, SketchyBar, Tmux)
2. **Creates safety backup** of current theme configuration
3. **Applies theme** to all components in correct order
4. **Reloads services** automatically (SketchyBar, Tmux, etc.)
5. **Verifies success** with visual confirmation
6. **Rolls back** automatically on any failure

## Why This Exists

Manually changing themes across multiple tools is:
- **Tedious**: Edit 6+ config files manually
- **Error-prone**: Easy to miss a component or make syntax errors
- **Inconsistent**: Hard to ensure visual cohesion
- **Risky**: No automatic backup or rollback
- **Slow**: Requires multiple service restarts

This skill makes theme switching:
- ✅ **One command**: "Switch to gruvbox dark"
- ✅ **Safe**: Automatic backup and rollback
- ✅ **Complete**: All components updated together
- ✅ **Fast**: ~5-10 seconds total
- ✅ **Validated**: Catches config errors before applying

## Key Features

### 🎨 Multi-Component Support
- **Starship** terminal prompt
- **Ghostty** terminal emulator
- **Neovim** editor colorschemes
- **SketchyBar** menu bar colors
- **Tmux** multiplexer themes
- **Future**: Easy to add more components

### 🛡️ Safety First
- Automatic backup before changes
- Config validation before applying
- Service health checks
- Automatic rollback on failure
- Backups preserved until confirmed

### 🔍 Smart Detection
- Scans for available themes
- Checks component compatibility
- Handles missing themes gracefully
- Supports partial theme switches
- Warns about incomplete themes

### ⚡ Automated Everything
- Updates all config files
- Reloads affected services
- No manual file editing
- No manual service restarts
- Handles symlinks and includes

## Example Output

### Complete Theme Switch
```
🎨 Switching to gruvbox-dark theme...

📦 Checking theme availability...
✅ Starship: gruvbox-dark.toml found
✅ Ghostty: gruvbox-dark.conf found
✅ Neovim: gruvbox installed
✅ SketchyBar: gruvbox-dark colors found
✅ Tmux: gruvbox.conf found

💾 Creating backup...
✅ Backup created: ~/.dotfiles-theme-backup-20251030-150000/

🔧 Applying theme...
✅ Starship config updated
✅ Ghostty config updated (auto-reloaded)
✅ Neovim colorscheme updated
✅ SketchyBar colors updated and reloaded
✅ Tmux theme updated and reloaded

🔍 Verifying changes...
✅ All components confirmed

✨ Theme Switch Complete!

📊 Summary:
✅ 5/5 components updated successfully
⏱️ Total time: 3.2 seconds

📝 Next Steps:
1. Reload shell: exec zsh
2. Restart Neovim sessions (or run :colorscheme gruvbox)

💾 Backup preserved: ~/.dotfiles-theme-backup-20251030-150000/
   (You can delete once you confirm everything looks good)

🎯 Enjoy your new theme!
```

### Theme Preview
```
📊 Available Themes

Current: gruvbox-dark

Theme Name           Starship  Ghostty  Neovim  SketchyBar  Tmux   Complete
────────────────────────────────────────────────────────────────────────────
gruvbox-dark            ✅       ✅       ✅        ✅        ✅       ✅
gruvbox-light           ✅       ✅       ✅        ✅        ✅       ✅
catppuccin-mocha        ✅       ✅       ✅        ✅        ✅       ✅
catppuccin-latte        ✅       ✅       ✅        ✅        ✅       ✅
nord                    ✅       ✅       ✅        ❌        ✅       ⚠️
tokyonight-night        ✅       ✅       ✅        ✅        ✅       ✅
tokyonight-day          ✅       ✅       ✅        ✅        ✅       ✅
dracula                 ✅       ❌       ✅        ✅        ✅       ⚠️

Legend:
✅ Complete theme (all components available)
⚠️ Partial theme (some components missing)
❌ Component theme not available

💡 Recommended: Use complete themes for consistent experience
💡 Partial themes will skip missing components

Which theme would you like to switch to?
```

### Partial Success (Missing Component)
```
⚠️ Theme Switch - Partially Successful

🎨 Applying catppuccin-mocha theme...

📦 Component Status:
✅ Starship: Updated
✅ Ghostty: Updated
❌ Neovim: Theme not installed
✅ SketchyBar: Updated
✅ Tmux: Updated

📊 Results:
✅ 4/5 components updated
⚠️ 1 component skipped (Neovim)

💡 To complete the theme:

Install catppuccin for Neovim:
1. Open Neovim
2. Run: :Lazy install catppuccin
3. Then rerun: "Switch to catppuccin mocha theme"

Or continue without Neovim theme (manual setup later)

💾 Backup: ~/.dotfiles-theme-backup-20251030-150000/

Would you like help installing the missing component?
```

### Automatic Rollback
```
❌ Theme Switch Failed - Rolling Back

🎨 Attempted: nord theme

📊 Progress:
✅ Starship: Updated successfully
✅ Ghostty: Updated successfully
❌ Neovim: Config syntax error detected

🛑 Error Details:
File: ~/.config/nvim/lua/custom/plugins/colorscheme.lua:5
Error: unexpected symbol near '}'

🔄 Automatic Rollback Initiated...
✅ Restored Starship config
✅ Restored Ghostty config
✅ Restored Neovim config
✅ Reloaded SketchyBar
✅ Reloaded Tmux

✅ Rollback Complete - Previous theme restored

💡 Troubleshooting:
1. Update Neovim theme plugin: :Lazy update
2. Check theme installation: :Lazy
3. Validate config: nvim --headless -c 'quit'

📁 Original backup preserved: ~/.dotfiles-theme-backup-20251030-150000/

Try a different theme or fix the Neovim theme issue first.
```

## Use Cases

### Daily Theme Changes
```
User: "I want a light theme for daytime coding"

Skill:
- Suggests light themes (gruvbox-light, catppuccin-latte, tokyonight-day)
- User selects catppuccin-latte
- Applies across all components
- Verifies visual consistency

Result: 10 seconds to complete, vs 5+ minutes manually
```

### Trying New Themes
```
User: "Show me available themes"

Skill:
- Lists all installed themes
- Shows compatibility matrix
- Highlights current theme
- User picks tokyonight-night to try
- Applies with backup for easy revert

Result: Safe experimentation without fear of breaking config
```

### Presentation Mode
```
User: "Switch to high contrast theme for presentation"

Skill:
- Applies presentation-friendly theme
- Increases font sizes (if configured)
- Adjusts colors for projector
- After presentation: "Revert to previous theme"

Result: Professional presentation with one command
```

### New Machine Setup
```
User: "Apply my preferred theme"

Skill:
- Detects available theme files
- Applies user's default theme
- Ensures consistency across fresh install
- Documents theme choice

Result: Consistent experience across machines
```

## Dependencies

### Required
- **One or more** themed components:
  - Starship, Ghostty, Neovim, SketchyBar, or Tmux

### Highly Recommended

```bash
# Terminal prompt
brew install starship

# Terminal emulator
brew install --cask ghostty

# Editor
brew install neovim

# Menu bar (macOS)
brew install sketchybar

# Terminal multiplexer
brew install tmux
```

### Optional

```bash
# JSON parsing (for theme configs)
brew install jq

# Color preview tools
brew install imagemagick  # For color swatches
```

## Configuration

### Theme Directory Setup

Organize themes in standard locations:

```bash
# Create theme directories
mkdir -p ~/.config/starship
mkdir -p ~/.config/ghostty/themes
mkdir -p ~/.config/nvim/lua/custom/plugins
mkdir -p ~/.config/sketchybar/themes
mkdir -p ~/.config/tmux/themes
```

### Install Themes

**Starship Themes**:
```bash
# Download preset themes
cd ~/.config/starship
curl -O https://starship.rs/presets/gruvbox-dark.toml
mv gruvbox-dark.toml starship-gruvbox-dark.toml
```

**Ghostty Themes**:
```bash
# Many themes built-in, or add custom
cd ~/.config/ghostty/themes
curl -O https://github.com/ghostty/themes/raw/main/gruvbox-dark.conf
```

**Neovim Themes**:
```bash
# Install via plugin manager (Lazy.nvim example)
# Add to ~/.config/nvim/lua/plugins/themes.lua:
return {
  { "ellisonleao/gruvbox.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "folke/tokyonight.nvim" },
}
```

**SketchyBar Themes**:
```bash
# Create custom theme
mkdir -p ~/.config/sketchybar/themes/gruvbox-dark
cat > ~/.config/sketchybar/themes/gruvbox-dark/colors.lua << 'EOF'
return {
  bg = 0xff282828,
  fg = 0xffebdbb2,
  accent = 0xfffb4934,
  -- ... more colors
}
EOF
```

### Theme Mapping

Create `~/.dotfiles-theme-map.yml`:

```yaml
themes:
  gruvbox-dark:
    starship: "starship-gruvbox-dark.toml"
    ghostty: "gruvbox-dark"
    nvim: "gruvbox"
    sketchybar: "gruvbox-dark"
    tmux: "gruvbox"

  catppuccin-mocha:
    starship: "starship-catppuccin-mocha.toml"
    ghostty: "catppuccin-mocha"
    nvim: "catppuccin"
    sketchybar: "catppuccin-mocha"
    tmux: "catppuccin"

default: "gruvbox-dark"
```

### Automatic Theme Switching

**Time-based (day/night)**:
```bash
# Add to ~/.zshrc
auto_theme_switch() {
  local hour=$(date +%H)
  if [ $hour -ge 6 ] && [ $hour -lt 18 ]; then
    claude-code "switch to gruvbox light theme"
  else
    claude-code "switch to gruvbox dark theme"
  fi
}

# Run daily at 6 AM and 6 PM
# Add to crontab:
0 6,18 * * * auto_theme_switch
```

**Match macOS Dark Mode**:
```bash
# Monitor system appearance
alias theme-match-os='
  if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q "Dark"; then
    claude-code "switch to dark theme"
  else
    claude-code "switch to light theme"
  fi
'
```

## Advanced Features

### Custom Theme Creation
```bash
# Use Claude to create theme from color palette
"Create custom theme called 'ocean' using these colors: #0077be #00a8cc #ebf5fb #2c3e50"
```

### Theme Export/Import
```bash
# Export current theme setup
"Export my current theme configuration"
# Creates: ~/.dotfiles-theme-current.json

# Import on another machine
"Import theme from ~/.dotfiles-theme-current.json"
```

### Theme History
```bash
# View theme change history
"Show theme history"

# Revert to previous theme
"Switch to previous theme"

# Revert to theme from yesterday
"Restore theme from yesterday"
```

## Troubleshooting

### "Theme not found"
```bash
# List installed themes for each component
ls ~/.config/starship/starship-*.toml
ls ~/.config/ghostty/themes/*.conf
ls ~/.config/sketchybar/themes/

# Install missing theme (example for Neovim)
nvim -c ":Lazy install gruvbox" -c ":quit"
```

### "Theme looks broken"
```bash
# Verify terminal true color support
echo $COLORTERM  # Should show: truecolor

# Test colors
curl -s https://gist.githubusercontent.com/lifepillar/09a44b8cf0f9397465614e622979107f/raw/24-bit-color.sh | bash

# If colors wrong, check terminal settings
# Ghostty: ensure 'theme =' is set in config
```

### "Services didn't reload"
```bash
# Manual reload
sketchybar --reload
tmux source-file ~/.tmux.conf
exec zsh

# Force restart
brew services restart sketchybar
brew services restart yabai
```

### "Want to revert to old theme"
```bash
# Find backups
ls -lt ~/.dotfiles-theme-backup-*/

# Restore manually
BACKUP=$(ls -td ~/.dotfiles-theme-backup-* | head -1)
cp -r $BACKUP/* ~/.config/

# Or use skill
"Rollback to previous theme"
```

## Performance

- **Theme detection**: ~0.5 seconds
- **Backup creation**: ~0.3 seconds
- **Theme application**: ~2-4 seconds
- **Service reloads**: ~1-2 seconds
- **Total time**: ~5-10 seconds

Much faster than 5-10 minutes of manual editing!

## Success Metrics

This skill provides:
- **5-10 minutes saved** per theme switch
- **Zero broken configs** from manual editing errors
- **100% consistency** across all components
- **Instant rollback** capability
- **Experimentation friendly** - try themes without fear

## Related Skills

- **[Service Orchestrator](../service-orchestrator/)** - Manages service restarts for theme changes
- **[Pre-Commit Guardian](../pre-commit-guardian/)** - Validates theme configs before committing
- **[Stow Health Manager](../stow-health-manager/)** - Ensures theme symlinks are valid

### Complete Workflow

```bash
# 1. Try new theme
"Switch to catppuccin mocha"

# 2. Verify it works
# (Visual check in terminal/editor)

# 3. Validate configs
"Run pre-commit validation"

# 4. Check symlinks
"Check stow health"

# 5. Commit changes
git add .
git commit -m "Switch to catppuccin mocha theme"
# (Pre-Commit Guardian runs automatically)

# 6. Push to sync across machines
git push
```

## Contributing

Want to add support for more components (Alacritty, iTerm2, etc.)? See [Contributing Guide](../../docs/contributing.md).

## License

MIT License - See [LICENSE](../../LICENSE) for details.