#!/bin/bash
set -ex
"$DEVCONTAINER_SCRIPTS_ROOT/uninstall/brew/brews.sh"
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
sudo rm -rf "$HOMEBREW_PREFIX/Caskroom"
sudo rm -rf "$HOMEBREW_PREFIX/Cellar"
sudo rm -rf "$HOMEBREW_PREFIX/Homebrew"
