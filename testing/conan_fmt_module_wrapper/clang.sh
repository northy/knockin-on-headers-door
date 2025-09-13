#!/usr/bin/env sh

export CC=/usr/bin/clang
export CXX=/usr/bin/clang++

conan profile detect || exit
conan install . --output-folder=build --build=missing || exit
rm CMakeUserPresets.json
cmake -S . -B build -GNinja -DCMAKE_BUILD_TYPE=Release || exit
cmake --build build -- -v || exit
