#!/usr/bin/env zsh
# shellcheck shell=bash
# shellcheck source=/dev/null
# init
set -euo pipefail
os=$(uname -s)
if [ -z "${HOMEBREW_PREFIX:-}" ]; then
  if [ "$os" = "Linux" ]; then
    export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
  else
    export HOMEBREW_PREFIX="/usr/local"
  fi
fi

# Check fast level
source "$DEVCONTAINER_SCRIPTS_ROOT/utils/updaterc.sh" "export PATH=\"$HOMEBREW_PREFIX/bin:\$PATH\""
if command -v brew >/dev/null 2>&1; then
  export BREW_FAST_LEVEL=${BREW_FAST_LEVEL:-${FAST_LEVEL:-0}}
else
  export BREW_FAST_LEVEL=0
fi

echo "BREW_FAST_LEVEL=$BREW_FAST_LEVEL"
# Setup Homebrew
sudo echo "sudo cached"
if [ "$BREW_FAST_LEVEL" -eq 0 ]; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# shellcheck disable=SC2016
source "$DEVCONTAINER_SCRIPTS_ROOT/utils/updaterc.sh" 'eval "$("$(brew --prefix)/bin/brew" shellenv)"'
if [ "$BREW_FAST_LEVEL" -eq 0 ]; then
  # Install taps
  brew tap microsoft/mssql-release https://github.com/Microsoft/homebrew-mssql-release
  # Repair and Update if needed
  brew update
  brew tap --repair
  # Install Homebrew packages
  # linux only brews
  if [ "$os" = "Linux" ]; then HOMEBREW_ACCEPT_EULA=Y brew install --include-test --force procps systemd wayland wayland-protocols; fi
  # These work on all brew platforms
  HOMEBREW_ACCEPT_EULA=Y brew install --include-test --force zsh bash antigen oh-my-posh
  # shellcheck disable=SC2016
  source "$DEVCONTAINER_SCRIPTS_ROOT/utils/updaterc.sh" 'source "$(brew --prefix)/share/antigen/antigen.zsh"' "$HOME/.zshrc"
  while ! (
    HOMEBREW_ACCEPT_EULA=Y brew install --include-test --force sevenzip p7zip awk ca-certificates file-formula gnu-sed coreutils grep curl wget bzip2 swig less lesspipe readline xz
    HOMEBREW_ACCEPT_EULA=Y brew install --include-test --force zlib zlib-ng buf protobuf grpc dos2unix git git-lfs sigstore/tap/gitsign-credential-cache sigstore/tap/gitsign gh asdf
    HOMEBREW_ACCEPT_EULA=Y brew install --include-test --force moreutils jq yq bash-completion@2 gcc make cmake cmake-docs z3 llvm dotnet dotnet@6 mono go rust python@3.9 python@3.10 python@3.11
    HOMEBREW_ACCEPT_EULA=Y brew install --include-test --force nss openssl openssl@1.1 openssl@3 openssh age nghttp2 mkcert shellcheck speedtest-cli mono-libgdiplus chezmoi sqlite sqlite-utils sqlite3 postgresql@15
    HOMEBREW_ACCEPT_EULA=Y brew install --include-test --force azure-cli awscli msodbcsql18 mssql-tools18 gedit kubernetes-cli helm minikube kind k3d argocd derailed/k9s/k9s kustomize skaffold vcluster
    HOMEBREW_ACCEPT_EULA=Y brew install --include-test --force terraform openjdk openjdk@8 openjdk@11 openjdk@17 maven groovy gradle scala sbt yarn pygobject3 gtk+3 gtk+4 libffi libyaml
    HOMEBREW_ACCEPT_EULA=Y brew install --include-test --force ffmpeg libsndfile libsoundio openmpi pyenv pyenv-virtualenv pipx virtualenv boost opencv openvino bats-core tcl-tk
  ); do echo "Retrying"; done

  # Upgrade all packages
  brew update
  brew upgrade
  # Setup post hombrew packages
  links=('dotnet@6' 'dotnet' 'openjdk@8' 'openjdk@11' 'openjdk@17' 'python@3.9' 'python@3.10' 'python@3.11' 'postgresql@15')
  if [ "$os" = "Linux" ]; then
    links+=('file-formula' 'readline' 'curl' 'bzip2' 'zlib' 'libffi' 'llvm' 'xz' 'tcl-tk' 'sqlite3' 'openssl' 'openssl@3')
    sudo chsh "$USERNAME" -s "$(which zsh)"
  fi

  for link in "${links[@]}"; do brew unlink "$link" || true; done
  for link in "${links[@]}"; do brew link --force --overwrite "$link"; done
fi

# shellcheck disable=SC2016
source "$DEVCONTAINER_SCRIPTS_ROOT/utils/updaterc.sh" '[[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] && source "$(brew --prefix)/etc/profile.d/bash_completion.sh"' "$HOME/.bashrc"
# shellcheck disable=SC2016
source "$DEVCONTAINER_SCRIPTS_ROOT/utils/updaterc.sh" 'export LESSOPEN="|$(brew --prefix)/bin/lesspipe.sh %s"'
# shellcheck disable=SC2016
source "$DEVCONTAINER_SCRIPTS_ROOT/utils/updaterc.sh" 'export MONO_GAC_PREFIX="$(brew --prefix)"'
# shellcheck disable=SC2016
source "$DEVCONTAINER_SCRIPTS_ROOT/utils/updaterc.sh" 'export GROOVY_HOME="$(brew --prefix)/opt/groovy/libexec"'
# shellcheck disable=SC2016
source "$DEVCONTAINER_SCRIPTS_ROOT/utils/updaterc.sh" 'export SCALA_HOME="$(brew --prefix)/opt/scala/idea"'
brews=('file-formula' 'gnu-sed' 'grep' 'make' 'coreutils' 'curl' 'bzip2' 'zlib' 'llvm' 'libffi' 'openjdk' 'sqlite' 'openssl@3' 'dotnet' 'python@3.11' 'postgresql@15')
for brew in "${brews[@]}"; do
  # shellcheck disable=SC2016
  brew_dir="\$(brew --prefix)/opt/$brew"
  brew_bin_dir="$brew_dir/bin"
  brew_include_dir="$brew_dir/include"
  brew_lib_dir="$brew_dir/lib"
  brew_pkgconfig_dir="$brew_lib_dir/pkgconfig"
  # shellcheck disable=SC2016
  brew_libexec_dir="\$(brew --prefix)/opt/$brew/libexec"
  brew_libexec_bin_dir="$brew_libexec_dir/bin"
  brew_gnubin_dir="$brew_libexec_dir/gnubin"
  brew_gnuman_dir="$brew_libexec_dir/gnuman"
  if [ -e "$(eval echo "$brew_bin_dir")" ]; then source "$DEVCONTAINER_SCRIPTS_ROOT/utils/updaterc.sh" "export PATH=\"$brew_bin_dir:\$PATH\""; fi
  if [ -e "$(eval echo "$brew_libexec_bin_dir")" ]; then source "$DEVCONTAINER_SCRIPTS_ROOT/utils/updaterc.sh" "export PATH=\"$brew_libexec_bin_dir:\$PATH\""; fi
  if [ -e "$(eval echo "$brew_gnubin_dir")" ]; then source "$DEVCONTAINER_SCRIPTS_ROOT/utils/updaterc.sh" "export PATH=\"$brew_gnubin_dir:\$PATH\""; fi
  if [ -e "$(eval echo "$brew_gnuman_dir")" ]; then source "$DEVCONTAINER_SCRIPTS_ROOT/utils/updaterc.sh" "export MANPATH=\"$brew_gnuman_dir\${MANPATH:+:}\$MANPATH\""; fi
  if [ -e "$(eval echo "$brew_include_dir")" ]; then source "$DEVCONTAINER_SCRIPTS_ROOT/utils/updaterc.sh" "export CPPFLAGS=\"-I$brew_include_dir\${CPPFLAGS:+ }\$CPPFLAGS\""; fi
  if [ -e "$(eval echo "$brew_lib_dir")" ]; then source "$DEVCONTAINER_SCRIPTS_ROOT/utils/updaterc.sh" "export LDFLAGS=\"-L$brew_lib_dir\${LDFLAGS:+ }\$LDFLAGS\""; fi
  if [ "$brew" = "llvm" ]; then source "$DEVCONTAINER_SCRIPTS_ROOT/utils/updaterc.sh" "export LDFLAGS=\"-L$brew_lib_dir/c++ -Wl,-rpath,$brew_lib_dir/c++\${LDFLAGS:+ }\$LDFLAGS\""; fi
  if [ -e "$(eval echo "$brew_pkgconfig_dir")" ]; then source "$DEVCONTAINER_SCRIPTS_ROOT/utils/updaterc.sh" "export PKG_CONFIG_PATH=\"$brew_pkgconfig_dir\${PKG_CONFIG_PATH:+:}\$PKG_CONFIG_PATH\""; fi
done

if [ "$BREW_FAST_LEVEL" -eq 0 ]; then
  # Run Homebrew post install
  if [ -n "$BREW_POST_INSTALL" ]; then
    while ! eval "$BREW_POST_INSTALL"; do echo "Retrying"; done
  fi

  # Run Homebrew cleanup and doctor to check for errors
  brew cleanup
  brew doctor || true
fi
