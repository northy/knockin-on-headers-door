#!/usr/bin/env sh

clang++ -std=c++23 -Iprivate_dep UserFacing.cpp -c

clang++ -std=c++23 main.cpp UserFacing.o -o main.o
