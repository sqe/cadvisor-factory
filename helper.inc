#!/bin/bash
export GODIST="${BUILD_HOME}/godist"
export GOROOT="${GODIST}/go"
export GOPATH="${BUILD_HOME}/gopath"

export PATH="${GOPATH}/bin:${GOROOT}/bin:${PATH}"

export CADVISOR="github.com/google/cadvisor"
export CADVISOR_BASE_VERSION="v0.23.0"
