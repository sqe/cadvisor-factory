#!/bin/bash
set -o errexit
set -o nounset

# Will not run without:
# - BUILD_HOME
# - DEPLOY_TO

# shellcheck source=helper.inc
. "${BUILD_HOME}/helper.inc"

# Check out what we're building, and apply our patch series
cd "${GOPATH}/src/${CADVISOR}"
git checkout "$CADVISOR_BASE_VERSION"

for patchfile in "${BUILD_HOME}/patches/"*.patch; do
  echo "Applying ${patchfile}"
  patch -p1 -d . < "$patchfile"
done

make

mkdir -p "$DEPLOY_TO"
mv cadvisor "$DEPLOY_TO"
