#!/bin/bash
# swap nvim configs

NVIM_CONFIGS_DIR="$HOME/.config/nvim-configs"
NVIM_DIR="$HOME/.config/nvim"

# Function to list available configs
list_configs() {
  echo "Available configurations:"
  ls -1 "$NVIM_CONFIGS_DIR"
}

# Function to switch to a config
switch_config() {
  local config_name="$1"
  local config_path="$NVIM_CONFIGS_DIR/$config_name"

  if [ ! -d "$config_path" ]; then
    echo "Error: Configuration '$config_name' not found"
    list_configs
    exit 1
  fi

    # Backup current config if it's not already in configs directory
    if [ -d "$NVIM_DIR" ]; then
      local current_config=$(readlink -f "$NVIM_DIR")
      if [[ $current_config != $NVIM_CONFIGS_DIR/* ]]; then
        echo "Backing up current config to $NVIM_CONFIGS_DIR/backup"
        cp -r "$NVIM_DIR" "$NVIM_CONFIGS_DIR/backup"
      fi
      rm -rf "$NVIM_DIR"
    fi

    # Create symbolic link to the selected config
    ln -s "$config_path" "$NVIM_DIR"
    echo "Switched to $config_name configuration"
  }

# Main script
case "$1" in
  "list")
    list_configs
    ;;
  "switch")
    if [ -z "$2" ]; then
      echo "Error: Please specify a configuration name"
      list_configs
      exit 1
    fi
    switch_config "$2"
    ;;
  *)
    echo "Usage: $0 {list|switch <config_name>}"
    echo "Examples:"
    echo "  $0 list                 # List available configurations"
    echo "  $0 switch stable        # Switch to stable configuration"
    echo "  $0 switch experimental  # Switch to experimental configuration"
    exit 1
    ;;
esac
