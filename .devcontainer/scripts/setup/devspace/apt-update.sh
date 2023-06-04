#!/usr/bin/env bash
# init
  set -ex
  # shellcheck source=/dev/null
  source /etc/bash.bashrc
# Update apt-packages
  apt install -y --install-recommends --fix-broken --fix-missing
  apt update
  apt upgrade -y
