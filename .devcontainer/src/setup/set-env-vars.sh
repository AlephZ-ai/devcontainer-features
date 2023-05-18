#!/usr/bin/env zsh
#shellcheck shell=bash
#shellcheck source=/dev/null
projectRoot="$(dirname "$(dirname "$(dirname "$(cd -- "$(dirname -- "${BASH_SOURCE-$0}")" &> /dev/null && pwd)")")")"
set -o allexport
source "$projectRoot/.devcontainer/.env"
set +o allexport
export PSHELL="pwsh"
export DEVCONTAINER_FEATURES_PROJECT_ROOT="$projectRoot"
export DEVCONTAINER_FEATURES_SOURCE_ROOT="$DEVCONTAINER_FEATURES_PROJECT_ROOT/src"
export DEVCONTAINER_FEATURES_TESTS_ROOT="$DEVCONTAINER_FEATURES_PROJECT_ROOT/tests"
export DEVCONTAINER_PROJECT_ROOT="$DEVCONTAINER_FEATURES_PROJECT_ROOT/.$DEVCONTAINER_PROJECT_NAME"
export DEVCONTAINER_SOURCE_ROOT="$DEVCONTAINER_PROJECT_ROOT/src"
export DEVCONTAINER_TESTS_ROOT="$$DEVCONTAINER_PROJECT_ROOT/tests"
