#!/usr/bin/env zsh
# shellcheck shell=bash
# shellcheck source=/dev/null
# init
set -euo pipefail
# tap casks
brew tap homebrew/cask-fonts
brew tap homebrew/cask-versions
# Install casks
while ! HOMEBREW_ACCEPT_EULA=Y brew install --cask font-inconsolata; do find "$HOME/Library/Fonts" -name 'Inconsolata*' -delete; done
while ! HOMEBREW_ACCEPT_EULA=Y brew install --cask iterm2; do sudo rm -rf '/Applications/iTerm.app'; done
while ! HOMEBREW_ACCEPT_EULA=Y brew install --cask github; do sudo rm -rf '/Applications/GitHub Desktop.app'; done
# TODO: Investigate why anaconda is hanging
HOMEBREW_ACCEPT_EULA=Y brew install --cask microsoft-openjdk powershell-preview microsoft-edge xquartz quarto miniconda google-cloud-sdk
# Upgrade all casks
brew update --cask
brew upgrade --cask
# Setup post hombrew packages
sudo ln -sfn "$HOMEBREW_PREFIX/opt/openjdk/libexec/openjdk.jdk" /Library/Java/JavaVirtualMachines/openjdk.jdk
sudo ln -sfn "$HOMEBREW_PREFIX/opt/openjdk@8/libexec/openjdk.jdk" /Library/Java/JavaVirtualMachines/openjdk-8.jdk
sudo ln -sfn "$HOMEBREW_PREFIX/opt/openjdk@11/libexec/openjdk.jdk" /Library/Java/JavaVirtualMachines/openjdk-11.jdk
sudo ln -sfn "$HOMEBREW_PREFIX/opt/openjdk@17/libexec/openjdk.jdk" /Library/Java/JavaVirtualMachines/openjdk-17.jdk
CLOUDSDK_CORE_DISABLE_PROMPTS=1 gcloud components update
# shellcheck disable=SC2016
"$DEVCONTAINER_SCRIPTS_ROOT/utils/updaterc.sh" 'source "$HOMEBREW_PREFIX/share/google-cloud-sdk/path.bash.inc"' "$HOME/.bashrc"
# shellcheck disable=SC2016
source "$DEVCONTAINER_SCRIPTS_ROOT/utils/updaterc.sh" 'source "$HOMEBREW_PREFIX/share/google-cloud-sdk/path.zsh.inc"' "$HOME/.zshrc"
# shellcheck disable=SC2016
source "$DEVCONTAINER_SCRIPTS_ROOT/utils/updaterc.sh" 'source "$HOMEBREW_PREFIX/share/google-cloud-sdk/completion.zsh.inc"' "$HOME/.zshrc"
