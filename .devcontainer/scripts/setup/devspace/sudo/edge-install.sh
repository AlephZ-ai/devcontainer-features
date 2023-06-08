#!/usr/bin/env bash
# init
set -e
# Install Microsoft Edge
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >/tmp/microsoft.gpg
install -o root -g root -m 644 /tmp/microsoft.gpg /usr/share/keyrings/
sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list'
rm /tmp/microsoft.gpg
apt install -y --install-recommends microsoft-edge-stable
# rm -rf /etc/apt/sources.list.d/microsoft-edge.list
apt update
