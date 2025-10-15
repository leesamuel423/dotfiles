#!/bin/bash

# Fix Claude Code installation issues
# This script removes the old installation and reinstalls the latest version

set -e  # Exit on error

echo "Fixing Claude Code installation..."
echo ""

# Detect current node version
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version | sed 's/v//')
    echo "Detected Node.js version: $NODE_VERSION"
else
    echo "Error: Node.js not found"
    exit 1
fi

# Construct the path to claude-code
CLAUDE_CODE_PATH="$HOME/.nvm/versions/node/v${NODE_VERSION}/lib/node_modules/@anthropic-ai/claude-code"

# Check if the directory exists and remove it
if [ -d "$CLAUDE_CODE_PATH" ]; then
    echo "Removing old Claude Code installation..."
    echo "Path: $CLAUDE_CODE_PATH"
    rm -rf "$CLAUDE_CODE_PATH"
    echo "Old installation removed"
else
    echo "No existing installation found at:"
    echo "$CLAUDE_CODE_PATH"
fi

echo ""
echo "Installing latest Claude Code..."
npm install -g @anthropic-ai/claude-code@latest

echo ""
echo "Done! Claude Code has been reinstalled."
echo ""
echo "You can verify the installation with:"
echo "  claude --version"
