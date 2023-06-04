#!/usr/bin/env bash
# init
  set -ex
  # shellcheck source=/dev/null
  source /etc/bash.bashrc
  USERNAME=${USERNAME:-}
# Update apt-packages
  # shellcheck source=/dev/null
  source "$DEVCONTAINER_SCRIPTS_ROOT/setup/devspace/apt-install.sh"
# Install docker completions
  # shellcheck source=/dev/null
  source "$DEVCONTAINER_SCRIPTS_ROOT/setup/devspace/docker-completions.sh"
# Install Microsoft Edge
  # shellcheck source=/dev/null
  source "$DEVCONTAINER_SCRIPTS_ROOT/setup/devspace/edge-install.sh"
# Update apt-packages
  # shellcheck source=/dev/null
  source "$DEVCONTAINER_SCRIPTS_ROOT/setup/devspace/apt-update.sh"
# Cleanup apt-packages
  # shellcheck source=/dev/null
  source "$DEVCONTAINER_SCRIPTS_ROOT/setup/devspace/apt-cleanup.sh"
# Done
  echo "Please restart shell to get latest environment variables"
