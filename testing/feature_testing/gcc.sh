#!/usr/bin/env sh

export CC=/usr/bin/gcc
export CXX=/usr/bin/g++

ctest --build-and-test . build_gcc --build-generator Ninja --build-config Release --test-command ctest
