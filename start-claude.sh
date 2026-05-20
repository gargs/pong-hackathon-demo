#!/bin/bash
if [ -z "$GITHUB_TOKEN" ]; then
  if command -v gh &>/dev/null && gh auth status &>/dev/null 2>&1; then
    export GITHUB_TOKEN=$(gh auth token)
  else
    echo "ERROR: Not logged in to GitHub CLI."
    echo "Run 'gh auth login' first."
    exit 1
  fi
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec claude --system-prompt-file "$SCRIPT_DIR/system-prompt.md"
