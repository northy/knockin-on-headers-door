#!/usr/bin/env sh

clang++ -std=c++23 -fmodule-header stdcpp.h
clang++ -std=c++23 -fmodule-file=stdcpp.pcm import_stdcpp.cpp
