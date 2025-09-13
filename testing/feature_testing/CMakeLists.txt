cmake_minimum_required(VERSION 3.28 FATAL_ERROR)

project(FeatureTesting)

include(cmake/FeatureTesting.cmake)

add_feature_test(TEST_NAME GlobalModuleFragment)
add_feature_test(TEST_NAME HeaderUnit)
add_feature_test(TEST_NAME ImplementationUnit)
add_feature_test(TEST_NAME InternalPartitionUnit)
add_feature_test(TEST_NAME NamedModule)
add_feature_test(TEST_NAME PartitionInterfaceUnit)
add_feature_test(TEST_NAME PrivateModuleFragment)
