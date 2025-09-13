#!/usr/bin/env sh

g++ -std=c++23 -O3 -fmodules -fsearch-include-path bits/std.cc -c

g++ -std=c++23 -fmodules private_dep/Private.cppm -c
ar q libPrivate.a Private.o

g++ -std=c++23 -fmodules UserFacing.cppm -c
g++ -std=c++23 -fmodules UserFacing.impl.cpp -c
ar q libUserFacing.a UserFacing.o UserFacing.impl.o

rm gcm.cache/Private.gcm

g++ -std=c++23 -fmodules main.cpp -L. -lUserFacing -lPrivate -o main.o
