#!/usr/bin/env bash
# init
  set -e
  # shellcheck source=/dev/null
  source /etc/bash.bashrc
  USERNAME=${USERNAME:-}
  os=$(uname -s)
# Disable needing password for sudo
  if [ "$os" == "Linux" ]; then
    line="$USERNAME ALL=(ALL:ALL) NOPASSWD: ALL"
    file="/etc/sudoers.d/$USERNAME"
    grep -qxF "$line" "$file" || echo "$line" >> "$file"
    chmod 440 "$file"
  fi
