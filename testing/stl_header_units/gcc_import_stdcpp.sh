#!/usr/bin/env sh

g++ -std=c++23 -fmodules-ts -fmodule-header stdcpp.h
g++ -std=c++23 -fmodules-ts import_stdcpp.cpp
