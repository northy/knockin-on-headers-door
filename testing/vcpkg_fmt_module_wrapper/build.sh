#!/usr/bin/env sh

export VCPKG_DISABLE_METRICS

cmake --preset=default
cmake --build build
