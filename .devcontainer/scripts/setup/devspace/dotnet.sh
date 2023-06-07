#!/usr/bin/env bash
# shellcheck shell=bash
# init
set -e
# shellcheck source=/dev/null
source "$HOME/.bashrc"
# Setup dotnet
preview="$(asdf list all dotnet-core 8)"
dotnet_latest_major_global='{ "sdk": { "rollForward": "latestmajor" } }'
# shellcheck source=/dev/null
source "$DEVCONTAINER_SCRIPTS_ROOT/utils/updaterc.sh" 'export DOTNET_ROLL_FORWARD=LatestMajor'
echo "$dotnet_latest_major_global" >"$HOME/global.json"
# Update rc files
# shellcheck source=/dev/null
source "$DEVCONTAINER_SCRIPTS_ROOT/utils/updaterc.sh" "export DOTNET_ROOT=\"\$HOME/.asdf/installs/dotnet-core/$preview\""
# shellcheck source=/dev/null
source "$DEVCONTAINER_SCRIPTS_ROOT/utils/updaterc.sh" "$HOME/.asdf/plugins/dotnet-core/set-dotnet-home.bash"
# Setup dotnet workloads
dotnet workload install --include-previews wasm-tools wasm-tools-net6 wasi-experimental android ios maccatalyst macos \
  maui maui-android maui-desktop maui-ios maui-maccatalyst maui-mobile maui-tizen tvos
# Clean, repair, and update
dotnet workload clean
dotnet workload update
dotnet workload repair
# Setup dotnet tools
# shellcheck source=/dev/null
# shellcheck disable=SC2016
source "$DEVCONTAINER_SCRIPTS_ROOT/utils/updaterc.sh" 'PATH="$HOME/.dotnet/tools:$PATH"'
mkdir -p "$HOME/.dotnet/tools"
echo "$dotnet_latest_major_global" >"$HOME/.dotnet/tools/global.json"
tools=('powershell' 'git-credential-manager' 'mlnet' 'Microsoft.Quantum.IQSharp' 'dotnet-ef' 'dotnet-try' 'cake.tool'
  'Microsoft.dotnet-httprepl' 'paket' 'BenchmarkDotNet.Tool' 'flubu' 'dotnet-gitversion' 'minver-cli' 'coverlet.console'
  'Scripty' 'microsoft.tye' 'dotnet-fdos' 'sourcelink' 'swashbuckle.aspnetcore.cli' 'Wyam.Tool' 'nbgv' 't-rex'
  'dotnet-bump' 'sharpen' 'dotnet-script' 'dotnet-interactive' 'dotnet-reportgenerator-globaltool' 'dotnet-outdated'
  'dotnet-depends' 'dotnet-sonarscanner' 'dotnet-format' 'dotnet-templating' 'dotnet-gcdump' 'dotnet-gcdump-analyzer'
  'dotnet-retire' 'dotnet-trace' 'dotnet-counters' 'dotnet-dump' 'dotnet-symbol' 'dotnet-monitor' 'dotnet-sos'
  'dotnet-sql-cache' 'dotnet-apidoc' 'dotnet-config' 'dotnet-credentials' 'dotnet-grpc' 'dotnet-dev-certs'
  'dotnet-user-secrets' 'dotnet-watch' 'dotnet-new' 'dotnet-test' 'dotnet-publish' 'dotnet-pack' 'dotnet-nuget'
  'dotnet-add-package' 'dotnet-add-reference' 'dotnet-remove-package' 'dotnet-remove-reference' 'dotnet-list-package'
  'dotnet-list-reference' 'dotnet-restore' 'dotnet-build' 'dotnet-run' 'dotnet-clean' 'dotnet-sln' 'dotnet-vstest'
  'dotnet-bundler' 'dotnet-lambda' 'dotnet-serve' 'dotnet-xdt' 'xunit.cli' 'NUnit.ConsoleRunner.Tool')
# shellcheck disable=SC2143
for tool in "${tools[@]}"; do
  installed_version=$(dotnet tool list -g | awk -v tool="$tool" '$1 == tool { print $2 }')
  latest_version=$(dotnet tool search "$tool" --prerelease | grep "$tool" | awk '{print $2}')
  if [[ -z "$installed_version" ]]; then
    echo "Installing $tool"
    dotnet tool install -g "$tool"
  elif [[ "$installed_version" != "$latest_version" ]]; then
    echo "Updating $tool from version $installed_version to version $latest_version"
    dotnet tool update -g "$tool"
  fi
done
