#!/usr/bin/env bash
set -euo pipefail

echo "🔎 Recursively checking all git repos in $(pwd)..."
echo

# Find every .git directory and strip the / to get repo path
find . -type d -name ".git" | while read -r gitdir; do
  repo="$(dirname "$gitdir")"
  cd "$repo"

  output=""
  if [ -n "$(git status --porcelain)" ]; then
    output+="⚠️  Uncommitted changes  "
  fi

  if git rev-parse --abbrev-ref @{u} >/dev/null 2>&1; then
    if ! git diff --quiet @{u}; then
      output+="⬆️  Unpushed commits  "
    fi
  fi

  if [ -z "$output" ]; then
    echo "✅ $repo is clean"
  else
    echo "$repo → $output"
  fi

  cd - >/dev/null || exit
done