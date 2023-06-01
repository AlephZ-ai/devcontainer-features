#!/usr/bin/env bash
#shellcheck shell=bash
#shellcheck source=/dev/null
projectRoot="$(dirname "$(dirname "$(dirname "$(cd -- "$(dirname -- "${BASH_SOURCE-$0}")" &> /dev/null && pwd)")")")"
set -o allexport
source "$projectRoot/.devcontainer/.env"
set +o allexport
export PSHELL="pwsh"
export DEVCONTAINER_FEATURES_PROJECT_ROOT="$projectRoot"
export DEVCONTAINER_FEATURES_SOURCE_ROOT="$DEVCONTAINER_FEATURES_PROJECT_ROOT/src"
export DEVCONTAINER_SCRIPTS_ROOT="$DEVCONTAINER_FEATURES_PROJECT_ROOT/.devcontainer/scripts"
# Check if GITHUB_TOKEN or GITHUB_USERNAME is not set
if [[ -z "${GITHUB_TOKEN}" ]] || [[ -z "${GITHUB_USERNAME}" ]]; then
  # Check GitHub authentication status
  if ! gh auth status >/dev/null 2>&1; then
    echo "You are not logged in to GitHub. Please login with 'gh auth login'."
    exit 1
  fi

  # Check if GITHUB_TOKEN is not set
  if [[ -z "${GITHUB_TOKEN}" ]]; then
    # Get the token using gh auth token
    GITHUB_TOKEN=$(gh auth token)
    export GITHUB_TOKEN
  fi

  # Check if GITHUB_USERNAME is not set
  if [[ -z "${GITHUB_USERNAME}" ]]; then
    # Get the username using gh api
    GITHUB_USERNAME=$(gh api user --jq .login)
    export GITHUB_USERNAME
  fi
fi
