#!/bin/bash
set -o errexit
set -o nounset

TAG="cadvisor-factory"
CONTAINER="${TAG}-container"
DEPLOY_TO="/tmp"

docker build -t "$TAG" .

docker rm -f "$CONTAINER" 2> /dev/null || true
docker run -it --name "$CONTAINER"  -e "DEPLOY_TO=${DEPLOY_TO}" "$TAG"
docker cp "${CONTAINER}:${DEPLOY_TO}/cadvisor" .
docker rm "$CONTAINER"
