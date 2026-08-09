#!/bin/bash
set -e

# Finds and removes stale .lock files inside .git/ directories
# Usage: git-clean-locks.sh [-f] [directory]
#   -f          Force removal without confirmation
#   directory   Target directory to scan (default: current directory)

show_help() {
    echo "Usage: $(basename "$0") [-f] [-h] [directory]"
    echo ""
    echo "Find and remove stale .lock files inside .git/ directories."
    echo ""
    echo "Options:"
    echo "  -f    Force removal without confirmation"
    echo "  -h    Show this help message"
    echo ""
    echo "Arguments:"
    echo "  directory   Target directory to scan (default: current directory)"
    echo ""
    echo "Examples:"
    echo "  $(basename "$0")              # Scan current directory"
    echo "  $(basename "$0") ~/projects   # Scan ~/projects"
    echo "  $(basename "$0") -f .         # Force remove without prompting"
}

FORCE=0
TARGET_DIR=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -f) FORCE=1; shift ;;
        -h|--help) show_help; exit 0 ;;
        *)
            if [[ -z "$TARGET_DIR" ]]; then
                TARGET_DIR="$1"
            else
                echo "❌ Error: unexpected argument '$1'"
                show_help
                exit 1
            fi
            shift
            ;;
    esac
done

TARGET_DIR="${TARGET_DIR:-.}"

if [[ ! -d "$TARGET_DIR" ]]; then
    echo "❌ Error: '$TARGET_DIR' is not a directory"
    exit 1
fi

echo "========================================="
echo "    Git Lock File Cleanup               "
echo "========================================="
echo ""
echo "🔍 Scanning for .lock files in: $TARGET_DIR"
echo ""

# Check for running git processes
if pgrep -x git > /dev/null 2>&1; then
    echo "⚠️  Warning: git processes are currently running!"
    echo "   Active locks may be in use. Proceed with caution."
    echo ""
fi

# Find all .lock files inside .git directories
LOCK_FILES=()
while IFS= read -r -d '' f; do
    LOCK_FILES+=("$f")
done < <(find "$TARGET_DIR" -name "*.lock" -path "*/.git/*" -print0 2>/dev/null)

if [[ ${#LOCK_FILES[@]} -eq 0 ]]; then
    echo "✓  No .lock files found. Nothing to clean."
    exit 0
fi

echo "Found ${#LOCK_FILES[@]} lock file(s):"
echo "──────────────────────────────────────"
for f in "${LOCK_FILES[@]}"; do
    echo "  🔒 $f"
done
echo "──────────────────────────────────────"
echo ""

if [[ "$FORCE" -eq 0 ]]; then
    read -rp "Delete all ${#LOCK_FILES[@]} lock file(s)? (y/n): " CONFIRM
    if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
        echo "⏭️  Aborted."
        exit 0
    fi
    echo ""
fi

DELETED=0
FAILED=0

for f in "${LOCK_FILES[@]}"; do
    if rm "$f" 2>/dev/null; then
        echo "✅ Removed: $f"
        ((DELETED++))
    else
        echo "❌ Failed:  $f"
        ((FAILED++))
    fi
done

echo ""
echo "========================================="
echo "                Summary                  "
echo "========================================="
echo "✅ Removed: $DELETED"
if [[ "$FAILED" -gt 0 ]]; then
    echo "❌ Failed:  $FAILED"
fi
echo ""
echo "Done!"
