#!/usr/bin/env sh

export CC=clang
export CXX=clang++

conan profile detect || exit
conan create fmt-bmi -pr=clang.profile.txt -pr:b=clang.profile.txt || exit
conan install . --output-folder=build -pr=clang.profile.txt -pr:b=clang.profile.txt || exit
rm CMakeUserPresets.json
cmake -S . -B build -GNinja -DCMAKE_BUILD_TYPE=Release || exit
cmake --build build || exit
