#!/usr/bin/env bash
#shellcheck shell=bash
# init
  # shellcheck source=/dev/null
  source "$HOME/.bashrc"
  current_user="$(whoami)"
  IS_WSL=${IS_WSL:=false}
  updaterc() { line="$1"; eval "$line"; echo "Updating ~/.bashrc and ~/.zshrc..."; rcs=("$HOME/.bashrc" "$HOME/.zshrc"); for rc in "${rcs[@]}"; do if [[ "$(cat "$rc")" != *"$line"* ]]; then echo "$line" >> "$rc"; fi; done }
# Update max open files
  sudo sh -c "ulimit -n 1048576"
    line="$current_user soft nofile 4096"
    file=/etc/security/limits.conf
    sudo grep -qxF "$line" "$file" || echo "$line" | sudo tee --append "$file"
    line="$current_user hard nofile 1048576"
    sudo grep -qxF "$line" "$file" || echo "$line" | sudo tee --append "$file"
# Run pre-build commands
  sudo -i USERNAME="$current_user" bash -l -c "$DEVCONTAINER_SCRIPTS_ROOT/setup/devspace/pre-build-sudo.sh"
# Run post-build commands
  source "$DEVCONTAINER_SCRIPTS_ROOT/setup/devspace/post-build-user.sh"
# Continue with devspace setup
  "$DEVCONTAINER_SCRIPTS_ROOT/setup/devspace.sh"
# Login to GitHub and Docker
  if [ "$IS_WSL" != "true" ]; then
    # shellcheck source=/dev/null
    source "$DEVCONTAINER_SCRIPTS_ROOT/utils/gh-login.sh"
    # shellcheck source=/dev/null
    source "$DEVCONTAINER_SCRIPTS_ROOT/utils/docker-login.sh"
  fi
# Done
  echo "Please restart shell to get latest environment variables"
