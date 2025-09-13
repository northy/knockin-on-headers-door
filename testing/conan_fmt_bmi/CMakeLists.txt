cmake_minimum_required(VERSION 3.30 FATAL_ERROR)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_EXTENSIONS OFF)

project(KnockingOnHeadersDoor CXX)

set(CMAKE_PREFIX_PATH "${CMAKE_CURRENT_BINARY_DIR}")

find_package(fmt-bmi REQUIRED CONFIG)

add_executable(Main main.cpp)
target_link_libraries(Main PRIVATE fmt-bmi::fmt-bmi)
