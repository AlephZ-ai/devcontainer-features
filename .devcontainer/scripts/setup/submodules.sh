#!/usr/bin/env bash
# Update submodules
init_submodules="false"
submodule_path="$DEVCONTAINER_PROJECT_ROOT/dependencies/devcontainers/features"
if [ -d "$submodule_path" ]; then
  directory_info=$(ls -A "$submodule_path")
  if [ -z "$directory_info" ]; then
    init_submodules="true"
  fi
fi

pushd "$LEGACY_PROJECT_ROOT" 1>/dev/null || exit 1
if [ "$init_submodules" = "true" ]; then
  git submodule sync --recursive
  git submodule update --init --recursive
  git submodule foreach --recursive git checkout main
fi

git submodule foreach --recursive git pull
popd 1>/dev/null || exit
