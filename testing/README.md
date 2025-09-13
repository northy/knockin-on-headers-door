## Modules testing code

This directory contains code related to testing modules functionality.

The subdirectories are:

- `bazel_modules/`: Using modules with the `Bazel` build system
- `build2_modules/`: Using modules with the `build2` build system
- `cmake_import_std/`: CMake project enabling `import std;`
- `cmake_modules/`: CMake project using C++20 modules
- `conan_fmt_bmi/`: Exporting the built `fmt` module through `Conan`
- `conan_fmt_module_wrapper/`: Wrapping the `Conan`-sourced `fmt` library into a module
- `feature_testing/`: CTest project to test feature compatibility across compilers
- `pimpl/`: Demonstrating how the PImpl idiom works before and after modules
- `pragma_once_gotcha/`: Demostrating the potential problems with using `#pragma once`
- `stl_header_units`: Feature-testing STL header units (currently unsupported by CMake, so not there)
- `vcpkg_fmt_module_wrapper`: Wrapping the `VCPKG`-sourced `fmt` library into a module
