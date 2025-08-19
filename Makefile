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
	@echo "  nvim-switch       - Switch nvim configurations"
	@echo "  open-gh           - Open GitHub repository"
	@echo "  quartz-dev        - Start Quartz development server"
	@echo "  tmpdir            - Create and navigate to temporary directory"
	@echo "  update-notes      - Update notes"
	@echo "  sync-back         - Sync back repository"
	@echo "  sync-damon        - Sync damon repository"
	@echo "  sync-front        - Sync front repository"
	@echo "  sync-roast        - Sync roast repository"
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

.PHONY: nvim-switch
nvim-switch:
	@$(SCRIPTS_DIR)/nvim-switch.sh

.PHONY: open-gh
open-gh:
	@$(SCRIPTS_DIR)/open-gh.sh

.PHONY: quartz-dev
quartz-dev:
	@$(SCRIPTS_DIR)/quartz-dev-startup.sh

.PHONY: tmpdir
tmpdir:
	@$(SCRIPTS_DIR)/tmpdir.sh

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
