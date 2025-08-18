#!/bin/bash

# Git Time Travel Commit Script
# Allows you to make commits with custom dates

echo "========================================="
echo "       Git Time Travel Commit Tool       "
echo "========================================="
echo ""

# Detect if we're on macOS or Linux
if [[ "$OSTYPE" == "darwin"* ]]; then
    IS_MACOS=true
else
    IS_MACOS=false
fi

# Function to validate and format date based on OS
format_date() {
    local input_date="$1"

    if [ "$IS_MACOS" = true ]; then
        # macOS (BSD date) - try different formats
        # Try ISO format first
        if date -j -f "%Y-%m-%d %H:%M:%S" "$input_date" "+%Y-%m-%d %H:%M:%S %z" 2>/dev/null; then
            return 0
        fi
        # Try with just date
        if date -j -f "%Y-%m-%d" "$input_date" "+%Y-%m-%d %H:%M:%S %z" 2>/dev/null; then
            return 0
        fi
        # Try MM/DD/YYYY HH:MM:SS
        if date -j -f "%m/%d/%Y %H:%M:%S" "$input_date" "+%Y-%m-%d %H:%M:%S %z" 2>/dev/null; then
            return 0
        fi
        # Try MM/DD/YYYY
        if date -j -f "%m/%d/%Y" "$input_date" "+%Y-%m-%d %H:%M:%S %z" 2>/dev/null; then
            return 0
        fi
        # Try Unix timestamp
        if date -r "$input_date" "+%Y-%m-%d %H:%M:%S %z" 2>/dev/null; then
            return 0
        fi
        return 1
    else
        # Linux (GNU date)
        date -d "$input_date" '+%Y-%m-%d %H:%M:%S %z' 2>/dev/null
        return $?
    fi
}

# Keep prompting until valid date is entered
while true; do
    echo "Enter the date and time for the commit"

    if [ "$IS_MACOS" = true ]; then
        echo "Examples (macOS):"
        echo "  - 2025-08-18 14:00:00"
        echo "  - 2025-08-18 (defaults to 00:00:00)"
        echo "  - 08/18/2025 14:00:00"
        echo "  - 08/18/2025"
        echo "  - 1724184600 (Unix timestamp)"
    else
        echo "Examples (Linux):"
        echo "  - 2025-08-18 14:00:00"
        echo "  - tomorrow 2pm"
        echo "  - yesterday 3:30pm"
        echo "  - next monday 10am"
        echo "  - 2 days ago"
        echo "  - last friday 4pm"
    fi

    echo ""
    read -p "Date/Time: " commit_date

    # Validate that a date was entered
    if [ -z "$commit_date" ]; then
        echo ""
        echo "⚠ Error: No date entered. Please try again."
        echo ""
        continue
    fi

    # Try to format the date
    formatted_date=$(format_date "$commit_date")

    if [ $? -eq 0 ] && [ -n "$formatted_date" ]; then
        # Valid date, break the loop
        break
    else
        echo ""
        echo "⚠ Error: Invalid date format. Please try again."
        if [ "$IS_MACOS" = true ]; then
            echo "  Tip: On macOS, use formats like '2025-08-18 14:00:00' or '08/18/2025'"
        fi
        echo ""
    fi
done

echo ""
echo "Commit will be dated: $formatted_date"
echo ""

# Keep prompting until commit message is entered
while true; do
    read -p "Enter commit message: " commit_message

    if [ -z "$commit_message" ]; then
        echo "⚠ Error: No commit message entered. Please try again."
    else
        break
    fi
done

# Show what will be executed
echo ""
echo "========================================="
echo "Ready to create commit:"
echo "Date: $formatted_date"
echo "Message: $commit_message"
echo "========================================="
echo ""
read -p "Proceed with commit? (y/n): " confirm

if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "Commit cancelled."
    exit 0
fi

# Execute the commit
GIT_AUTHOR_DATE="$formatted_date" GIT_COMMITTER_DATE="$formatted_date" git commit -m "$commit_message"

# Check if commit was successful
if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Commit created successfully with date: $formatted_date"
    echo ""
    echo "Use 'git log --pretty=fuller -1' to see both author and committer dates"
else
    echo ""
    echo "✗ Commit failed. Make sure you have staged changes (git add) before committing."
fi
