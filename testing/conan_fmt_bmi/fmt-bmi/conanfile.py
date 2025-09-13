from conan import ConanFile
from conan.tools.files import copy
from conan.tools.scm import Git
from conan.tools.cmake import CMake, cmake_layout
from conan.tools.build import check_min_cppstd

import os

class FmtBMI(ConanFile):
    name = "fmt-bmi"
    version="11.2.0"
    license = "MIT"
    url = "https://github.com/fmtlib/fmt"
    description = "Formatted output library for C++ with C++20 module support enabled"
    topics = ("fmt", "format", "cpp20", "modules")
    settings = "os", "compiler", "build_type", "arch"
    generators = "CMakeToolchain", "CMakeDeps"
    exports_sources = []  # Not packaging sources directly
    no_copy_source = True

    def layout(self):
        cmake_layout(self)
    
    def validate(self):
        check_min_cppstd(self, "20")

    def source(self):
        git = Git(self)
        git.clone(url="https://github.com/fmtlib/fmt.git", target="fmt")
        git.folder="fmt"
        self.folders.source = "fmt"

        git.checkout(self.version)

    def build(self):
        cmake = CMake(self)
        cmake.configure(
            variables={
                "FMT_MODULE": True,
            }
        )
        cmake.build(target="fmt")

    def package(self):
        cmake = CMake(self)
        cmake.install()

        copy(self, "fmt.pcm", src=".", dst=self.package_folder + "/res")
        copy(self, "src/fmt.cc", src="fmt", dst=self.package_folder + "/res")

        copy(self, "LICENSE.rst", src="fmt", dst=self.package_folder + "/licenses")

    def package_info(self):
        self.cpp_info.components["fmt-bmi"].libs = ["fmt"]
        self.cpp_info.components["fmt-bmi"].set_property("cmake_target_name", "fmt-bmi::fmt-bmi")
        self.cpp_info.components["fmt-bmi"].resdirs = ["res"]

        pcm_path = os.path.join(self.package_folder, "res/fmt.pcm")
        self.cpp_info.components["fmt-bmi"].cxxflags = [f"-fmodule-file=fmt={pcm_path}"]
