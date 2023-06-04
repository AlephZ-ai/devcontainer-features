#!/usr/bin/env zsh
# shellcheck shell=bash
# shellcheck source=/dev/null
source "$HOME/.zshrc"
rm -f nohup.out
rm -f gcm-diagnose.log
if [[ $- == *i* ]]; then
  # Interactive commands...
  # Login to GitHub
  # shellcheck source=/dev/null
  source "$DEVCONTAINER_SCRIPTS_ROOT/utils/gh-login.sh"
  # Login to Docker
  # shellcheck source=/dev/null
  source "$DEVCONTAINER_SCRIPTS_ROOT/utils/docker-login.sh"
else
  # Non-interactive commands...
  echo "Running in a prebuild or in GitHub Codespaces. Ignore interactive commands."
fi

echo "Press Ctrl+Shift+~ to open a terminal in the current dev container"
