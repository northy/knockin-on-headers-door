cmake_minimum_required(VERSION 3.28 FATAL_ERROR)

set(CMAKE_CXX_STANDARD 23)

project(ModulesExample CXX)

add_library(Lib)
target_sources(Lib
    PUBLIC FILE_SET modules TYPE CXX_MODULES FILES lib.cppm
    PRIVATE lib.impl.cpp
)

add_executable(Main main.cpp)
target_link_libraries(Main PRIVATE Lib)
