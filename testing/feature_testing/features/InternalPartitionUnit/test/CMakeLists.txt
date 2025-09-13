add_executable(${PROJECT_NAME}_test)
target_sources(${PROJECT_NAME}_test
    PRIVATE test.cpp
)
target_link_libraries(${PROJECT_NAME}_test PRIVATE ${PROJECT_NAME})

include(CTest)
add_test(NAME ${PROJECT_NAME}_test COMMAND ${PROJECT_NAME}_test)
