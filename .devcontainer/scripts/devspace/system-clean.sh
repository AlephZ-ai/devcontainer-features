#!/usr/bin/env bash
#shellcheck shell=bash
"$DEVCONTAINER_FEATURES_PROJECT_ROOT/run" -s devspace clean
docker system prune -a -f --volumes
