#!/bin/bash
set -o errexit
set -o nounset

TAG="cadvisor-factory"
CONTAINER="${TAG}-container"
DEPLOY_TO="/tmp"
COPY_TO="$(cd "$(dirname "$0")"; pwd)/build"

docker build -t "$TAG" .

docker rm -f "$CONTAINER" 2> /dev/null || true
docker run -it --name "$CONTAINER"  -e "DEPLOY_TO=${DEPLOY_TO}" "$TAG"
for f in cadvisor cadvisor.sha1sum; do
  docker cp "${CONTAINER}:${DEPLOY_TO}/${f}" "$COPY_TO"
done
docker rm "$CONTAINER"
