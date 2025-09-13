function(_msvc_add_header_unit)
    cmake_parse_arguments(ARG "" "TARGET_NAME;HEADER_FILE" "" ${ARGN})

    set(BMI_NAME "${ARG_HEADER_FILE}.ifc")

    cmake_path(SET BMI_OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${BMI_NAME}")
    set(MSVC_HEADER_UNIT_FLAGS /headerName:quote /exportHeader /ifcOutput ${BMI_OUTPUT})
    set(STD_VERSION_FLAG "/std:c++latest")

    cmake_path(SET HEADER_FILE_PATH ${CMAKE_CURRENT_LIST_DIR}/${ARG_HEADER_FILE})
    add_custom_target(
        ${ARG_TARGET_NAME}_impl
        DEPENDS ${HEADER_FILE_PATH}
        BYPRODUCTS ${BMI_OUTPUT}
        COMMAND ${CMAKE_CXX_COMPILER}
            /nologo
            /EHsc
            /D_DLL
            ${STD_VERSION_FLAG}
            ${MSVC_HEADER_UNIT_FLAGS}
            ${HEADER_FILE_PATH}
        VERBATIM
        COMMENT "Building header unit for ${ARG_HEADER_FILE}"
    )

    add_library(${ARG_TARGET_NAME} INTERFACE)
    add_dependencies(${ARG_TARGET_NAME} ${ARG_TARGET_NAME}_impl)
    target_compile_options(${ARG_TARGET_NAME} INTERFACE /headerUnit:quote header.h=${BMI_OUTPUT})
endfunction()

function(_clang_add_header_unit)
    cmake_parse_arguments(ARG "" "TARGET_NAME;HEADER_FILE" "" ${ARGN})

    set(BMI_NAME "${ARG_HEADER_FILE}.pcm")

    cmake_path(SET BMI_OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${BMI_NAME}")
    set(CLANG_HEADER_UNIT_FLAGS -fmodule-header -o ${BMI_OUTPUT})
    set(STD_VERSION_FLAG "-std=c++23")

    cmake_path(SET HEADER_FILE_PATH ${CMAKE_CURRENT_LIST_DIR}/${ARG_HEADER_FILE})
    add_custom_target(
        ${ARG_TARGET_NAME}_impl
        DEPENDS ${HEADER_FILE_PATH}
        BYPRODUCTS ${BMI_OUTPUT}
        COMMAND ${CMAKE_CXX_COMPILER}
            ${STD_VERSION_FLAG}
            ${CLANG_HEADER_UNIT_FLAGS}
            ${HEADER_FILE_PATH}
        VERBATIM
        COMMENT "Building header unit for ${ARG_HEADER_FILE}"
    )

    add_library(${ARG_TARGET_NAME} INTERFACE)
    add_dependencies(${ARG_TARGET_NAME} ${ARG_TARGET_NAME}_impl)
    target_compile_options(${ARG_TARGET_NAME} INTERFACE -fmodule-file=${BMI_OUTPUT})
endfunction()

function(_gnu_add_header_unit)
    cmake_parse_arguments(ARG "" "TARGET_NAME;HEADER_FILE" "" ${ARGN})

    set(BMI_NAME "${ARG_HEADER_FILE}.gcm")

    cmake_path(SET HEADER_FILE_PATH ${CMAKE_CURRENT_LIST_DIR}/${ARG_HEADER_FILE})
    cmake_path(SET HEADER_FILE_BIN_PATH ${CMAKE_CURRENT_BINARY_DIR}/${ARG_HEADER_FILE})
    configure_file(
        "${HEADER_FILE_PATH}"
        "${HEADER_FILE_BIN_PATH}"
        COPYONLY
    )

    set(GNU_HEADER_UNIT_FLAGS -fmodule-header)
    set(STD_VERSION_FLAG "-std=c++23")

    cmake_path(SET BMI_OUTPUT1 "${CMAKE_CURRENT_BINARY_DIR}/gcm.cache/,/${BMI_NAME}")
    add_custom_target(
        ${ARG_TARGET_NAME}_impl1
        DEPENDS ${HEADER_FILE_PATH}
        BYPRODUCTS ${BMI_OUTPUT1}
        COMMAND ${CMAKE_CXX_COMPILER}
            ${STD_VERSION_FLAG}
            ${GNU_HEADER_UNIT_FLAGS}
            ${ARG_HEADER_FILE}
        VERBATIM
        COMMENT "Building header unit for ${ARG_HEADER_FILE}"
    )

    cmake_path(SET BMI_OUTPUT2 "${CMAKE_CURRENT_BINARY_DIR}/gcm.cache/${HEADER_FILE_PATH}.gcm")
    add_custom_target(
        ${ARG_TARGET_NAME}_impl2
        DEPENDS ${HEADER_FILE_PATH}
        BYPRODUCTS ${BMI_OUTPUT2}
        COMMAND ${CMAKE_CXX_COMPILER}
            ${STD_VERSION_FLAG}
            ${GNU_HEADER_UNIT_FLAGS}
            /${HEADER_FILE_PATH}
        VERBATIM
        COMMENT "Building header unit for ${ARG_HEADER_FILE}"
    )

    add_library(${ARG_TARGET_NAME} INTERFACE)
    add_dependencies(${ARG_TARGET_NAME} ${ARG_TARGET_NAME}_impl1 ${ARG_TARGET_NAME}_impl2)
endfunction()

macro(add_header_unit)
    if(CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
        _msvc_add_header_unit(${ARGN})
    elseif(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        _clang_add_header_unit(${ARGN})
    elseif(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
        _gnu_add_header_unit(${ARGN})
    else()
        message(FATAL_ERROR "Header units unsupported for ${CMAKE_CXX_COMPILER_ID}")
    endif()
endmacro()
