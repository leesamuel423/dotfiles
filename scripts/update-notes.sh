#!/bin/bash
# back up updates to notes directory every day
# - Replace `samuellee` with your username

# Make a cron job with following directions:
# - `crontab -e` and add the below lines
# # Task: Commit + Push updates to `notes/` EOD
# # Schedule: Daily @ 11:55 PM
# HOME=/Users/samuellee
# 55 23 * * * ~/scripts/update-notes.sh

NOTES_DIR="/Users/samuellee/notes"
LOG_DIR="/Users/samuellee"
LOG_FILE="$LOG_DIR/cron_logs.txt"

mkdir -p "$LOG_DIR"
exec 1>>"$LOG_FILE" 2>&1

echo "=== Starting notes commit process at $(date) ==="

if [ ! -d "$NOTES_DIR" ]; then
  echo "Error: Notes directory not found at $NOTES_DIR"
  exit 1
fi

cd "$NOTES_DIR" || exit 1

# Check if this is a git repository
if [ ! -d ".git" ]; then
  echo "Error: $NOTES_DIR is not a git repository"
  exit 1
fi

# Check for any changes
if [ "$(git status --porcelain)" != "" ]; then
  CURRENT_DATE=$(date "+%b %d, %Y")
  echo "Changes detected, proceeding with commit"
  git add .
  if git commit -m "update notes ${CURRENT_DATE}"; then
    echo "Successfully committed changes with date: ${CURRENT_DATE}"
    # Push changes
    if git push; then
      echo "Successfully pushed changes"
    else
      echo "Warning: Failed to push changes"
      exit 1
    fi
  else
    echo "Error: Failed to commit changes"
    exit 1
  fi
else
  echo "No changes to commit"
fi

echo "=== Notes commit process completed at $(date) ==="
echo "----------------------------------------"
