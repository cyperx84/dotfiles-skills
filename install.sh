#!/usr/bin/env bash

# Dotfiles Skills Installer
# Installs Claude Code skills to user or project level

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_SKILLS_DIR="$HOME/.claude/skills"
PROJECT_SKILLS_DIR=".claude/skills"

# Functions
print_header() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════╗"
    echo "║         Dotfiles Skills Installer v1.0.0            ║"
    echo "╚══════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --user              Install skills to user level (~/.claude/skills/)"
    echo "  --project           Install skills to project level (.claude/skills/)"
    echo "  --skill SKILL       Install only a specific skill"
    echo "  --link              Create symlinks instead of copying (for development)"
    echo "  --help              Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --user                                    # Install all skills for user"
    echo "  $0 --project                                 # Install all skills for project"
    echo "  $0 --user --skill service-orchestrator      # Install specific skill"
    echo "  $0 --user --link                             # Symlink for development"
}

install_skills() {
    local target_dir="$1"
    local mode="$2" # "copy" or "link"
    local specific_skill="$3"

    # Create target directory
    mkdir -p "$target_dir"

    local installed_count=0
    local failed_count=0

    # Find all skills
    local skill_dirs=()
    if [[ -n "$specific_skill" ]]; then
        # Install specific skill
        if [[ -d "$SCRIPT_DIR/dotfiles/$specific_skill" ]]; then
            skill_dirs+=("$SCRIPT_DIR/dotfiles/$specific_skill")
        elif [[ -d "$SCRIPT_DIR/general/$specific_skill" ]]; then
            skill_dirs+=("$SCRIPT_DIR/general/$specific_skill")
        else
            print_error "Skill '$specific_skill' not found"
            exit 1
        fi
    else
        # Install all skills
        while IFS= read -r -d '' skill; do
            skill_dirs+=("$skill")
        done < <(find "$SCRIPT_DIR/dotfiles" "$SCRIPT_DIR/general" -mindepth 1 -maxdepth 1 -type d -print0 2>/dev/null)
    fi

    if [[ ${#skill_dirs[@]} -eq 0 ]]; then
        print_warning "No skills found to install"
        return
    fi

    echo ""
    print_info "Installing ${#skill_dirs[@]} skill(s) to: $target_dir"
    echo ""

    for skill_path in "${skill_dirs[@]}"; do
        local skill_name=$(basename "$skill_path")
        local target_path="$target_dir/$skill_name"

        # Check if SKILL.md exists
        if [[ ! -f "$skill_path/SKILL.md" ]]; then
            print_warning "Skipping $skill_name (no SKILL.md found)"
            continue
        fi

        if [[ "$mode" == "link" ]]; then
            # Create symlink
            if [[ -e "$target_path" ]]; then
                rm -rf "$target_path"
            fi
            ln -s "$skill_path" "$target_path"
            print_success "Linked: $skill_name"
        else
            # Copy files
            if [[ -d "$target_path" ]]; then
                rm -rf "$target_path"
            fi
            cp -r "$skill_path" "$target_path"
            print_success "Installed: $skill_name"
        fi

        ((installed_count++))
    done

    echo ""
    if [[ $installed_count -gt 0 ]]; then
        print_success "Successfully installed $installed_count skill(s)"
    fi

    if [[ $failed_count -gt 0 ]]; then
        print_warning "$failed_count skill(s) failed to install"
    fi
}

verify_installation() {
    local target_dir="$1"

    echo ""
    print_info "Verifying installation..."
    echo ""

    local skills_found=0
    if [[ -d "$target_dir" ]]; then
        while IFS= read -r skill; do
            if [[ -f "$skill/SKILL.md" ]]; then
                local skill_name=$(basename "$skill")
                print_success "Found: $skill_name"
                ((skills_found++))
            fi
        done < <(find "$target_dir" -mindepth 1 -maxdepth 1 -type d 2>/dev/null)
    fi

    echo ""
    if [[ $skills_found -gt 0 ]]; then
        print_success "Verification complete: $skills_found skill(s) installed"
        echo ""
        print_info "Skills are ready to use in Claude Code!"
        print_info "Try asking: 'What skills are available?'"
    else
        print_warning "No skills found in $target_dir"
    fi
}

# Main script
main() {
    local install_level=""
    local install_mode="copy"
    local specific_skill=""

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --user)
                install_level="user"
                shift
                ;;
            --project)
                install_level="project"
                shift
                ;;
            --skill)
                specific_skill="$2"
                shift 2
                ;;
            --link)
                install_mode="link"
                shift
                ;;
            --help)
                print_header
                show_usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done

    print_header

    # Validate arguments
    if [[ -z "$install_level" ]]; then
        print_error "Please specify installation level: --user or --project"
        echo ""
        show_usage
        exit 1
    fi

    # Determine target directory
    local target_dir
    if [[ "$install_level" == "user" ]]; then
        target_dir="$USER_SKILLS_DIR"
        print_info "Installing to user level: $target_dir"
    else
        target_dir="$PROJECT_SKILLS_DIR"
        print_info "Installing to project level: $target_dir"
    fi

    if [[ "$install_mode" == "link" ]]; then
        print_info "Mode: Symlink (development mode)"
    else
        print_info "Mode: Copy"
    fi

    # Install skills
    install_skills "$target_dir" "$install_mode" "$specific_skill"

    # Verify installation
    verify_installation "$target_dir"

    echo ""
    print_success "Installation complete!"
    echo ""
}

# Run main function
main "$@"
