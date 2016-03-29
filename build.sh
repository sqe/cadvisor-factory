#!/bin/bash
set -o errexit
set -o nounset

# Will not run without:
# - BUILD_HOME
# - DEPLOY_TO

CADVISOR_BASE_VERSION="v0.22.2"

GODIST="${BUILD_HOME}/godist"
export GOROOT="${GODIST}/go"
export GOPATH="${BUILD_HOME}/gopath"
export PATH="${GOPATH}/bin:${GOROOT}/bin:${PATH}"

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
CADVISOR="github.com/google/cadvisor"
go get -d "$CADVISOR" || true  # Usually an error about an expected import that doesn't matter..!
cd "${GOPATH}/src/${CADVISOR}"

# Check out what we're building, and apply our patch series
git checkout "$CADVISOR_BASE_VERSION"

for patchfile in "${BUILD_HOME}/patches/"*.patch; do
  echo "Applying ${patchfile}"
  patch -p1 -d . < "$patchfile"
done

make

# Output some informational data to stdout
ldd cadvisor || true
ls -lah cadvisor
./cadvisor --version

mkdir -p "$DEPLOY_TO"
mv cadvisor "$DEPLOY_TO"
