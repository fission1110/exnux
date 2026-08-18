#!/bin/bash
# This loops through all the submodules in the current directory and runs git fetch and rebase on each one.
# This script converts all to a shallow clone with depth 1 to save space and speed up future pulls.
# Runs git gc to clean up the repository after the rebase.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for dir in "$SCRIPT_DIR"/*/; do
    if [ -f "$dir/.git" ]; then
        echo "Updating submodule in $dir"
        cd "$dir"
git fetch --depth=1 || { echo 'Failed to fetch in $dir'; exit 1; }
current_branch=$(git rev-parse --abbrev-ref HEAD) || { echo 'Could not determine branch in $dir'; exit 1; };
if git show-ref --verify --quiet refs/remotes/origin/$current_branch; then
    git rebase origin/$current_branch;
else
    echo 'Branch $current_branch does not exist on remote.';
    exit 1;
fi
        git gc
        cd "$SCRIPT_DIR"
    fi
done
