#!/bin/bash

# Script to push all unpushed commits across all branches
# Only pushes if there are unpushed commits, doesn't create any new commits

echo "========================================="
echo "    Git Push All Unpushed Commits       "
echo "========================================="
echo ""

# Store the current branch to return to it later
ORIGINAL_BRANCH=$(git branch --show-current)

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: Not in a git repository"
    exit 1
fi

# Fetch latest remote information without merging
echo "📡 Fetching latest remote information..."
git fetch --all --quiet

echo ""
echo "🔍 Checking all branches for unpushed commits..."
echo ""

# Counter for branches with unpushed commits
BRANCHES_PUSHED=0
BRANCHES_WITH_ISSUES=0

# Get all local branches
for BRANCH in $(git branch --format='%(refname:short)'); do
    echo "──────────────────────────────────────"
    echo "Branch: $BRANCH"

    # Check if branch has an upstream
    UPSTREAM=$(git rev-parse --abbrev-ref $BRANCH@{upstream} 2>/dev/null)

    if [ -z "$UPSTREAM" ]; then
        echo "⚠️  No upstream set for branch '$BRANCH'"
        echo "   Would you like to set upstream to 'origin/$BRANCH'? (y/n/skip)"
        read -p "   Choice: " CHOICE

        if [ "$CHOICE" = "y" ] || [ "$CHOICE" = "Y" ]; then
            # Switch to branch and push with upstream
            git checkout "$BRANCH" --quiet 2>/dev/null
            if git push --set-upstream origin "$BRANCH"; then
                echo "✅ Pushed and set upstream for '$BRANCH'"
                ((BRANCHES_PUSHED++))
            else
                echo "❌ Failed to push '$BRANCH'"
                ((BRANCHES_WITH_ISSUES++))
            fi
        elif [ "$CHOICE" = "skip" ] || [ "$CHOICE" = "s" ]; then
            echo "⏭️  Skipping '$BRANCH'"
        else
            echo "⏭️  Skipping '$BRANCH'"
        fi
        continue
    fi

    # Check for unpushed commits
    UNPUSHED_COUNT=$(git rev-list --count $UPSTREAM..$BRANCH 2>/dev/null)

    if [ -z "$UNPUSHED_COUNT" ]; then
        echo "⚠️  Could not determine status for '$BRANCH'"
        ((BRANCHES_WITH_ISSUES++))
        continue
    fi

    if [ "$UNPUSHED_COUNT" -gt 0 ]; then
        echo "📤 Found $UNPUSHED_COUNT unpushed commit(s)"

        # Show the unpushed commits
        echo "   Commits to push:"
        git log $UPSTREAM..$BRANCH --oneline | sed 's/^/     /'

        # Push the branch
        echo "   Pushing to $UPSTREAM..."

        # Switch to the branch
        git checkout "$BRANCH" --quiet 2>/dev/null

        # Push the branch
        if git push; then
            echo "✅ Successfully pushed '$BRANCH'"
            ((BRANCHES_PUSHED++))
        else
            echo "❌ Failed to push '$BRANCH'"
            ((BRANCHES_WITH_ISSUES++))
        fi
    else
        echo "✓  Already up to date"
    fi
done

echo "──────────────────────────────────────"
echo ""

# Return to original branch
echo "↩️  Returning to original branch: $ORIGINAL_BRANCH"
git checkout "$ORIGINAL_BRANCH" --quiet 2>/dev/null

echo ""
echo "========================================="
echo "                Summary                  "
echo "========================================="
echo "✅ Branches pushed: $BRANCHES_PUSHED"

if [ "$BRANCHES_WITH_ISSUES" -gt 0 ]; then
    echo "⚠️  Branches with issues: $BRANCHES_WITH_ISSUES"
fi

echo ""
echo "Done! All branches have been checked."
