cmake_minimum_required(VERSION 3.28 FATAL_ERROR)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

project(HeaderUnit CXX)

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
    set(CMAKE_CXX_EXTENSIONS OFF)
endif()

include(../../cmake/HeaderUnits.cmake)

add_header_unit(
    TARGET_NAME Header
    HEADER_FILE header.h
)

if(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
    # Dependency scanning is broken for GNU with header units, so we have to use a simple executable.
    add_executable(${PROJECT_NAME} gcc_test.cpp)
    target_link_libraries(${PROJECT_NAME} PRIVATE Header)
    set_target_properties(${PROJECT_NAME} PROPERTIES CXX_SCAN_FOR_MODULES OFF)
    target_compile_options(${PROJECT_NAME} PRIVATE "-fmodules")

    include(CTest)
    add_test(NAME ${PROJECT_NAME}_test COMMAND ${PROJECT_NAME})
else()
    add_library(${PROJECT_NAME} STATIC)
    target_sources(${PROJECT_NAME} PUBLIC FILE_SET modules TYPE CXX_MODULES FILES test.cppm)
    target_link_libraries(${PROJECT_NAME} PRIVATE Header)
    
    add_subdirectory(test)
endif()
