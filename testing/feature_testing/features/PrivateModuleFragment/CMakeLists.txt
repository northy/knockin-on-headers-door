cmake_minimum_required(VERSION 3.28 FATAL_ERROR)

set(CMAKE_CXX_STANDARD 20)

project(PrivateModuleFragment CXX)

add_library(${PROJECT_NAME} STATIC)
target_sources(${PROJECT_NAME} PUBLIC FILE_SET modules TYPE CXX_MODULES FILES test.cppm)

add_subdirectory(test)
