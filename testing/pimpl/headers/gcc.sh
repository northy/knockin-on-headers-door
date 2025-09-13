#!/usr/bin/env sh

g++ -std=c++23 -Iprivate_dep UserFacing.cpp -c

g++ -std=c++23 main.cpp UserFacing.o -o main.o
