#!/usr/bin/env bash
set -e
for j in {1..5}; do
    containerid=$(docker container ls --all --quiet --filter name="$DEVCONTAINER_FEATURES_PROJECT_NAME-devspace")
    if [ -n "$containerid" ]; then
        docker rm -f "$containerid"
    fi

    docker volume rm -f vscode
    volumes=$(docker volume ls --quiet --filter name="${DEVCONTAINER_FEATURES_PROJECT_NAME}_devcontainer")
    if [ -n "$volumes" ]; then
        echo "$volumes" | xargs docker volume rm -f
    fi

    docker container prune -f
    docker image prune -a -f
    docker network prune -f
    docker volume prune -f
done
