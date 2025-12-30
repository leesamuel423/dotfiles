#!/bin/bash
# Neovim Configuration Switcher
# Manages multiple nvim configurations with isolated data directories
#
# Usage:
#   nvim-switch.sh              # Interactive selection (uses fzf if available)
#   nvim-switch.sh list         # List available configurations
#   nvim-switch.sh current      # Show current active configuration
#   nvim-switch.sh <config>     # Switch to specified configuration
#   nvim-switch.sh add <name>   # Add current nvim config as a new profile

set -euo pipefail

# Configuration
CONFIGS_DIR="${HOME}/.config/nvim-configs"
NVIM_CONFIG="${HOME}/.config/nvim"
NVIM_DATA="${HOME}/.local/share/nvim"
NVIM_STATE="${HOME}/.local/state/nvim"
NVIM_CACHE="${HOME}/.cache/nvim"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Print colored output
info() { echo -e "${BLUE}ℹ${NC} $1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}⚠${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1"; }

# Ensure configs directory exists
ensure_configs_dir() {
    if [[ ! -d "$CONFIGS_DIR" ]]; then
        mkdir -p "$CONFIGS_DIR"
        info "Created configurations directory at $CONFIGS_DIR"
    fi
}

# Get list of available configurations
get_configs() {
    if [[ -d "$CONFIGS_DIR" ]]; then
        find "$CONFIGS_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null | sort
    fi
}

# Get current active configuration
get_current() {
    if [[ -L "$NVIM_CONFIG" ]]; then
        local target
        target=$(readlink "$NVIM_CONFIG")
        if [[ "$target" == "$CONFIGS_DIR"/* ]]; then
            basename "$target"
        elif [[ "$target" == *"dotfiles"* ]]; then
            echo "dotfiles (default)"
        else
            echo "custom: $target"
        fi
    elif [[ -d "$NVIM_CONFIG" ]]; then
        echo "local (not managed)"
    else
        echo "none"
    fi
}

# List all available configurations
list_configs() {
    ensure_configs_dir

    echo -e "\n${BOLD}Available Neovim Configurations:${NC}\n"

    local current
    current=$(get_current)
    local configs
    configs=$(get_configs)

    if [[ -z "$configs" ]]; then
        warn "No configurations found in $CONFIGS_DIR"
        echo ""
        echo "To add configurations:"
        echo "  1. Create directories in $CONFIGS_DIR/"
        echo "  2. Use: $0 add <name>  (to save current config)"
        echo ""
        echo "Example structure:"
        echo "  ~/.config/nvim-configs/"
        echo "    ├── lazyvim/"
        echo "    │   └── config/  (nvim config files)"
        echo "    ├── nvchad/"
        echo "    │   └── config/"
        echo "    └── minimal/"
        echo "        └── config/"
        return
    fi

    while IFS= read -r config; do
        local marker=" "
        local color=""
        if [[ "$current" == "$config" ]]; then
            marker="●"
            color="${GREEN}"
        fi

        # Check if config has associated data
        local has_data=""
        if [[ -d "$CONFIGS_DIR/$config/data" ]]; then
            has_data=" ${CYAN}(with data)${NC}"
        fi

        echo -e "  ${color}${marker} ${config}${NC}${has_data}"
    done <<< "$configs"

    echo ""
    echo -e "Current: ${BOLD}${current}${NC}"
    echo ""
}

# Switch to a configuration
switch_config() {
    local config_name="$1"
    local config_path="$CONFIGS_DIR/$config_name"

    if [[ ! -d "$config_path/config" ]]; then
        error "Configuration '$config_name' not found or invalid structure"
        echo "Expected: $config_path/config/"
        return 1
    fi

    # Save current config's data directories if they exist and aren't symlinks to configs dir
    save_current_data

    # Remove current symlinks
    [[ -L "$NVIM_CONFIG" ]] && rm "$NVIM_CONFIG"
    [[ -L "$NVIM_DATA" ]] && rm "$NVIM_DATA"
    [[ -L "$NVIM_STATE" ]] && rm "$NVIM_STATE"
    [[ -L "$NVIM_CACHE" ]] && rm "$NVIM_CACHE"

    # Create config symlink
    ln -s "$config_path/config" "$NVIM_CONFIG"

    # Create data directory symlinks if they exist for this config
    if [[ -d "$config_path/data" ]]; then
        ln -s "$config_path/data" "$NVIM_DATA"
    else
        mkdir -p "$config_path/data"
        ln -s "$config_path/data" "$NVIM_DATA"
    fi

    if [[ -d "$config_path/state" ]]; then
        ln -s "$config_path/state" "$NVIM_STATE"
    else
        mkdir -p "$config_path/state"
        ln -s "$config_path/state" "$NVIM_STATE"
    fi

    if [[ -d "$config_path/cache" ]]; then
        ln -s "$config_path/cache" "$NVIM_CACHE"
    else
        mkdir -p "$config_path/cache"
        ln -s "$config_path/cache" "$NVIM_CACHE"
    fi

    success "Switched to ${BOLD}$config_name${NC}"
}

# Save current data directories to current config
save_current_data() {
    if [[ -L "$NVIM_CONFIG" ]]; then
        local config_target
        config_target=$(readlink "$NVIM_CONFIG")

        # Only save if it points to our configs directory
        if [[ "$config_target" == "$CONFIGS_DIR"/* ]]; then
            local config_base
            config_base=$(dirname "$config_target")

            # Move data directories if they exist and aren't already symlinks
            if [[ -d "$NVIM_DATA" && ! -L "$NVIM_DATA" ]]; then
                info "Saving data directory..."
                mv "$NVIM_DATA" "$config_base/data"
            fi
            if [[ -d "$NVIM_STATE" && ! -L "$NVIM_STATE" ]]; then
                info "Saving state directory..."
                mv "$NVIM_STATE" "$config_base/state"
            fi
            if [[ -d "$NVIM_CACHE" && ! -L "$NVIM_CACHE" ]]; then
                info "Saving cache directory..."
                mv "$NVIM_CACHE" "$config_base/cache"
            fi
        fi
    fi
}

# Create a new empty configuration
new_config() {
    local name="$1"
    local target_dir="$CONFIGS_DIR/$name"

    if [[ -d "$target_dir" ]]; then
        error "Configuration '$name' already exists"
        return 1
    fi

    ensure_configs_dir
    mkdir -p "$target_dir"/{config,data,state,cache}

    # Create minimal init.lua so nvim doesn't error
    cat > "$target_dir/config/init.lua" << 'EOF'
-- Empty Neovim configuration
-- Add your config here or install a distribution

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
EOF

    success "Created empty config '$name'"
    echo "Location: $target_dir/config/"
    echo ""
    echo "Switch to it with:"
    echo "  nvim-switch.sh $name"
}

# Resolve symlink to absolute path (handles relative symlinks)
resolve_path() {
    local path="$1"
    if command -v realpath &> /dev/null; then
        realpath "$path"
    elif command -v greadlink &> /dev/null; then
        greadlink -f "$path"
    else
        # Fallback: cd to directory and pwd
        local dir base
        dir=$(cd "$(dirname "$path")" && pwd -P)
        base=$(basename "$path")
        echo "${dir}/${base}"
    fi
}

# Add current nvim config as a new profile
add_config() {
    local name="$1"
    local target_dir="$CONFIGS_DIR/$name"

    if [[ -d "$target_dir" ]]; then
        error "Configuration '$name' already exists"
        return 1
    fi

    ensure_configs_dir
    mkdir -p "$target_dir"

    # Copy current config (resolve symlinks to absolute paths)
    if [[ -L "$NVIM_CONFIG" ]]; then
        local source
        source=$(resolve_path "$NVIM_CONFIG")
        cp -r "$source" "$target_dir/config"
    elif [[ -d "$NVIM_CONFIG" ]]; then
        cp -r "$NVIM_CONFIG" "$target_dir/config"
    else
        error "No nvim config found to add"
        return 1
    fi

    # Copy data directories if they exist (resolve symlinks)
    if [[ -e "$NVIM_DATA" ]]; then
        local data_src="$NVIM_DATA"
        [[ -L "$NVIM_DATA" ]] && data_src=$(resolve_path "$NVIM_DATA")
        cp -r "$data_src" "$target_dir/data"
    fi
    if [[ -e "$NVIM_STATE" ]]; then
        local state_src="$NVIM_STATE"
        [[ -L "$NVIM_STATE" ]] && state_src=$(resolve_path "$NVIM_STATE")
        cp -r "$state_src" "$target_dir/state"
    fi
    if [[ -e "$NVIM_CACHE" ]]; then
        local cache_src="$NVIM_CACHE"
        [[ -L "$NVIM_CACHE" ]] && cache_src=$(resolve_path "$NVIM_CACHE")
        cp -r "$cache_src" "$target_dir/cache"
    fi

    success "Added current config as '$name'"
    echo "Location: $target_dir"
}

# Interactive selection using fzf or basic menu
interactive_select() {
    local configs
    configs=$(get_configs)

    if [[ -z "$configs" ]]; then
        list_configs
        return 1
    fi

    local current
    current=$(get_current)

    # Try fzf first
    if command -v fzf &> /dev/null; then
        local selected
        selected=$(echo "$configs" | fzf \
            --prompt="Select Neovim config: " \
            --header="Current: $current" \
            --preview="ls -la $CONFIGS_DIR/{}/config 2>/dev/null || echo 'No config directory'" \
            --preview-window=right:50%:wrap)

        if [[ -n "$selected" ]]; then
            switch_config "$selected"
        fi
    else
        # Fallback to numbered menu
        echo -e "\n${BOLD}Select Neovim Configuration:${NC}\n"

        local i=1
        local config_array=()
        while IFS= read -r config; do
            config_array+=("$config")
            local marker=" "
            [[ "$current" == "$config" ]] && marker="●"
            echo "  $i) $marker $config"
            ((i++))
        done <<< "$configs"

        echo ""
        echo -n "Enter number (or 'q' to quit): "
        read -r choice

        if [[ "$choice" == "q" ]]; then
            return 0
        fi

        if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#config_array[@]} )); then
            switch_config "${config_array[$((choice-1))]}"
        else
            error "Invalid selection"
            return 1
        fi
    fi
}

# Show help
show_help() {
    cat << EOF
${BOLD}Neovim Configuration Switcher${NC}

${BOLD}USAGE:${NC}
    nvim-switch.sh [COMMAND] [OPTIONS]

${BOLD}COMMANDS:${NC}
    (none)              Interactive selection (uses fzf if available)
    list                List all available configurations
    current             Show current active configuration
    <config-name>       Switch to the specified configuration
    new <name>          Create a new empty configuration
    add <name>          Save current nvim config as a new profile

${BOLD}DIRECTORY STRUCTURE:${NC}
    Each configuration in ~/.config/nvim-configs/ should have:

    ~/.config/nvim-configs/<name>/
        ├── config/     → symlinked to ~/.config/nvim
        ├── data/       → symlinked to ~/.local/share/nvim
        ├── state/      → symlinked to ~/.local/state/nvim
        └── cache/      → symlinked to ~/.cache/nvim

${BOLD}EXAMPLES:${NC}
    nvim-switch.sh                    # Interactive menu
    nvim-switch.sh list               # Show available configs
    nvim-switch.sh lazyvim            # Switch to lazyvim
    nvim-switch.sh add minimal        # Save current as 'minimal'

${BOLD}SETUP:${NC}
    1. Create a new config directory:
       mkdir -p ~/.config/nvim-configs/lazyvim/config

    2. Clone/copy a config into it:
       git clone https://github.com/LazyVim/starter ~/.config/nvim-configs/lazyvim/config

    3. Switch to it:
       nvim-switch.sh lazyvim

EOF
}

# Main entry point
main() {
    case "${1:-}" in
        "")
            interactive_select
            ;;
        "list"|"-l"|"--list")
            list_configs
            ;;
        "current"|"-c"|"--current")
            echo "Current: $(get_current)"
            ;;
        "add"|"-a"|"--add")
            if [[ -z "${2:-}" ]]; then
                error "Please specify a name for the configuration"
                echo "Usage: $0 add <name>"
                exit 1
            fi
            add_config "$2"
            ;;
        "new"|"-n"|"--new")
            if [[ -z "${2:-}" ]]; then
                error "Please specify a name for the new configuration"
                echo "Usage: $0 new <name>"
                exit 1
            fi
            new_config "$2"
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            # Assume it's a config name
            switch_config "$1"
            ;;
    esac
}

main "$@"
