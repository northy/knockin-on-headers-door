include(CTest)

function(add_feature_test)
    cmake_parse_arguments(ARG "" "TEST_NAME" "" ${ARGN})

    if(
        CMAKE_CXX_COMPILER_ID MATCHES "Clang" OR
        (CMAKE_CXX_COMPILER_ID MATCHES "GNU" AND NOT ARG_TEST_NAME MATCHES "HeaderUnit")
    )
        set(CHANGE_TEST_DIR --test-dir test)
    endif()

    add_test(
        NAME ${ARG_TEST_NAME}
        COMMAND ${CMAKE_CTEST_COMMAND}
                --build-and-test
                    ${CMAKE_CURRENT_LIST_DIR}/features/${ARG_TEST_NAME}
                    ${CMAKE_CURRENT_BINARY_DIR}/${ARG_TEST_NAME}
                --build-generator ${CMAKE_GENERATOR}
                --build-config $<CONFIGURATION>
                --test-command ${CMAKE_CTEST_COMMAND} ${CHANGE_TEST_DIR}
    )
endfunction()
