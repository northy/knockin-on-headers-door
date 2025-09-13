#!/usr/bin/env sh

export CC=/usr/bin/clang
export CXX=/usr/bin/clang++

ctest --build-and-test . build_clang --build-generator Ninja --build-config Release --test-command ctest
