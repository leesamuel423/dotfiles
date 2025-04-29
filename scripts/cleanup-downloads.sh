#!/bin/bash
# Remove files in Downloads folder older than 2 weeks
# Make a cron job with following directions:
# - Replace `leesamuel423` with your username
# - `crontab -e` and add the below lines
# # Task: Run clearing items older than 2 weeks from Downloads folder
# # Schedule: Weekly on Sunday at 3 AM
# # 0 3 * * 0 ~/.scripts/cleanup-downloads.sh # Adjust this section accordingly

DOWNLOADS_DIR="/Users/samuellee/Downloads"
LOG_DIR="/Users/samuellee"
LOG_FILE="$LOG_DIR/cron_logs.txt"

mkdir -p "$LOG_DIR"
exec 1>>"$LOG_FILE" 2>&1

echo "=== Starting cleanup at $(date) ==="

# Check if the downloads directory exists
if [ ! -d "$DOWNLOADS_DIR" ]; then
  echo "Error: Downloads directory not found at $DOWNLOADS_DIR"
  exit 1
fi

echo "Cleaning up Downloads folder..."

# Remove files older than 14 days, including installers
echo "Removing old files..."
if find "$DOWNLOADS_DIR" \( \
  -type f -o \
  -name "*.dmg" -o \
  -name "*.pkg" -o \
  -name "*.exe" -o \
  -name "*.msi" -o \
  -name "*.deb" -o \
  -name "*.rpm" \
  \) -mtime +14 -print -delete; then
  echo "File cleanup completed successfully"
else
  echo "Error during file cleanup"
  exit 1
fi

# Remove non-empty directories older than 14 days
echo "Removing old non-empty directories..."
find "$DOWNLOADS_DIR" -type d -mtime +14 -not -empty -not -path "$DOWNLOADS_DIR" -print0 | while IFS= read -r -d '' dir; do
  rm -rf "$dir"
  echo "Removed directory: $dir"
done

# Remove all empty directories regardless of age
echo "Removing empty directories..."
find "$DOWNLOADS_DIR" -type d -empty -not -path "$DOWNLOADS_DIR" -print -delete

echo "=== Cleanup completed at $(date) ==="
echo "----------------------------------------"
