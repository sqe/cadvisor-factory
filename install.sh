#!/bin/bash
set -o errexit
set -o nounset

# shellcheck source=helper.inc
. "${BUILD_HOME}/helper.inc"

GOLANG_VERSION=1.6
GOLANG_DOWNLOAD_URL="https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz"
GOLANG_DOWNLOAD_SHA256="5470eac05d273c74ff8bac7bef5bad0b5abbd1c4052efbdbc8db45332e836b0b"
GO_DEPS=(github.com/tools/godep)

curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz
echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c -

mkdir -p "$GODIST"
tar -C "$GODIST" -xzf golang.tar.gz
rm golang.tar.gz

# Get Go build dependencies
go get "${GO_DEPS[@]}"

# Get cadvisor
go get -d "$CADVISOR" || true  # Usually an error about an expected import that doesn't matter..!
