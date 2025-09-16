#!/usr/bin/env sh

clang++ -std=c++23 -stdlib=libc++ -O3 /usr/share/libc++/v1/std.cppm -Wno-reserved-module-identifier --precompile

clang++ -std=c++23 -stdlib=libc++ private_dep/Private.cppm -fmodule-output -c
ar q libPrivate.a Private.o

clang++ -std=c++23 -stdlib=libc++ -fmodule-file=std=std.pcm -fmodule-file=Private=private_dep/Private.pcm -fmodule-output UserFacing.cppm -c
ar q libUserFacing.a UserFacing.o

rm private_dep/Private.pcm

clang++ -std=c++23 -stdlib=libc++ -fmodule-file=std=std.pcm -fmodule-file=UserFacing=UserFacing.pcm main.cpp -L. -lUserFacing -lPrivate -o main.o
