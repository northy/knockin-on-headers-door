cmake_minimum_required(VERSION 3.28 FATAL_ERROR)

set(CMAKE_CXX_STANDARD 20)

project(KnockingOnHeadersDoor CXX)

set(CMAKE_PREFIX_PATH "${CMAKE_CURRENT_BINARY_DIR}")

find_package(fmt REQUIRED CONFIG)

add_library(fmt-module)
target_sources(fmt-module PUBLIC FILE_SET modules TYPE CXX_MODULES FILES "fmt.cppm")
target_link_libraries(fmt-module PRIVATE fmt::fmt-header-only)

add_executable(Main main.cpp)
target_link_libraries(Main PRIVATE fmt-module)
set_target_properties(Main PROPERTIES CXX_SCAN_FOR_MODULES ON)
