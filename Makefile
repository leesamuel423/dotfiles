# Makefile for home directory scripts
# Can be called from any child directory using: make -f ~/Makefile <target>

SHELL := /bin/bash
HOME_DIR := /Users/samuellee
SCRIPTS_DIR := $(HOME_DIR)/scripts

# Default target
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  commit            - Git commit with custom date (runs in current directory)"
	@echo "  push              - Push all unpushed commits across all branches"
	@echo "  nvim-switch       - Switch nvim configurations (interactive)"
	@echo "  nvim-list         - List available nvim configurations"
	@echo "  nvim-current      - Show current nvim configuration"
	@echo "  nvim-new NAME=x   - Create a new empty config 'x'"
	@echo "  nvim-add NAME=x   - Save current nvim config as profile 'x'"
	@echo "  open-gh           - Open GitHub repository"
	@echo "  quartz-dev        - Start Quartz development server"
	@echo "  tmpdir            - Create and navigate to temporary directory"
	@echo "  update-notes      - Update notes"
	@echo "  claude-update     - Fix and reinstall Claude Code"
	@echo "  sync-back         - Sync back repository"
	@echo "  sync-damon        - Sync damon repository"
	@echo "  sync-front        - Sync front repository"
	@echo "  sync-roast        - Sync roast repository"
	@echo "  class             - Attach to CIT595 docker container"
	@echo "  agent-links       - Create AGENTS.md and symlink CLAUDE.md/GEMINI.md to it"
	@echo "  cppbuild          - Compile all .cpp files in current directory (C++17)"
	@echo "  cppclean          - Remove compiled binary"
	@echo ""
	@echo "Usage from any directory: make -f ~/Makefile <target>"

# Git commit script - runs in current directory
.PHONY: commit
commit:
	@$(SCRIPTS_DIR)/commit.sh

# Git push script - pushes all unpushed commits
.PHONY: push
push:
	@$(SCRIPTS_DIR)/push.sh

# Neovim configuration management
.PHONY: nvim-switch
nvim-switch:
	@$(SCRIPTS_DIR)/nvim-switch.sh

.PHONY: nvim-list
nvim-list:
	@$(SCRIPTS_DIR)/nvim-switch.sh list

.PHONY: nvim-current
nvim-current:
	@$(SCRIPTS_DIR)/nvim-switch.sh current

.PHONY: nvim-new
nvim-new:
ifndef NAME
	@echo "Usage: make nvim-new NAME=<config-name>"
	@echo "Example: make nvim-new NAME=minimal"
else
	@$(SCRIPTS_DIR)/nvim-switch.sh new $(NAME)
endif

.PHONY: nvim-add
nvim-add:
ifndef NAME
	@echo "Usage: make nvim-add NAME=<config-name>"
	@echo "Example: make nvim-add NAME=lazyvim"
else
	@$(SCRIPTS_DIR)/nvim-switch.sh add $(NAME)
endif

.PHONY: open-gh
open-gh:
	@$(SCRIPTS_DIR)/open-gh.sh

.PHONY: quartz-dev
quartz-dev:
	@$(SCRIPTS_DIR)/quartz-dev-startup.sh

.PHONY: tmpdir
tmpdir:
	@$(SCRIPTS_DIR)/tmpdir.sh

.PHONY: claude-update
claude-update:
	@$(HOME_DIR)/dotfiles/scripts/fix-claude-code.sh

# Sync scripts from home directory
.PHONY: sync-back
sync-back:
	@$(HOME_DIR)/sync-back.sh

.PHONY: sync-damon
sync-damon:
	@$(HOME_DIR)/sync-damon.sh

.PHONY: sync-front
sync-front:
	@$(HOME_DIR)/sync-front.sh

.PHONY: sync-roast
sync-roast:
	@$(HOME_DIR)/sync-roast.sh

# Alias for common typo
.PHONY: sync-daemon
sync-daemon: sync-damon

# Create AGENTS.md and symlink CLAUDE.md/GEMINI.md to it
.PHONY: agent-links
agent-links:
	@if [ ! -f AGENTS.md ]; then \
		touch AGENTS.md; \
		echo "Created AGENTS.md"; \
	fi
	@[ -L CLAUDE.md ] || [ -f CLAUDE.md ] || (ln -s AGENTS.md CLAUDE.md && echo "Created CLAUDE.md -> AGENTS.md")
	@[ -L GEMINI.md ] || [ -f GEMINI.md ] || (ln -s AGENTS.md GEMINI.md && echo "Created GEMINI.md -> AGENTS.md")

# -- C++ Commands --
# Compile C++ files in current directory with warnings
CXX := g++
CXXFLAGS := -Wall -Wextra -Wpedantic -Wconversion -std=c++17
SRCS := $(wildcard *.cpp)
OBJS := $(SRCS:.cpp=.o)
TARGET := main

.PHONY: cppbuild
cppbuild: $(OBJS)
	$(CXX) $(CXXFLAGS) $(OBJS) -o $(TARGET)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

.PHONY: cppclean
cppclean:
	rm -f $(TARGET) $(OBJS)

# Alias for CIT Docker Container
.PHONY: class
class:
	@docker start cit595 2>/dev/null || true
	@docker attach cit595
