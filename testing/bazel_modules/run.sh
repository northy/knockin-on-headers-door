#!/usr/bin/env sh

export CC=/usr/bin/clang
export CXX=/usr/bin/clang++
clang++ -std=c++23 -stdlib=libc++ -O3 /usr/share/libc++/v1/std.cppm -Wno-reserved-module-identifier -fstack-protector --precompile
bazel run //:main
