---
layout: default
---

### Appendix A - VCPKG: Module wrapper

<div class="inset-5 grid grid-cols-2 gap-x-4 items-center">

<div>

<!-- Snippet from @/testing/vcpkg_fmt_module_wrapper/vcpkg.json -->
```json [vcpkg.json]
{
    "dependencies": [
        "fmt"
    ]
}
```

<v-click>

<!-- Snippet from @/testing/conan_fmt_module_wrapper/CMakeLists.txt -->
```cmake [CMakeLists.txt ~i-vscode-icons:file-type-cmake~]
find_package(fmt REQUIRED CONFIG)

add_library(fmt-module)
target_sources(
    fmt-module
    PUBLIC
    FILE_SET modules
    TYPE CXX_MODULESFILES "fmt.cppm")

target_link_libraries(
    fmt-module
    PRIVATE
    fmt::fmt-header-only)
```

</v-click>

</div>

<div>

<v-click>

<!-- Snippet from @/testing/conan_fmt_module_wrapper/fmt.cppm -->
```cpp [fmt.cppm ~i-vscode-icons:file-type-cpp2~]
module;

#include <fmt/core.h>

export module fmt;

export namespace fmt
{
    using ::fmt::print;
    using ::fmt::println;
    using ::fmt::format;
    // ...
}
```

</v-click>

<br>

<v-click>

<!-- Snippet from @/testing/conan_fmt_module_wrapper/main.cpp -->
```cpp [main.cpp ~i-vscode-icons:file-type-cpp~]
import fmt;

// ...
```

</v-click>

</div>

</div>

---
layout: default
---

### Appendix B - Conan: Module wrapper

<div class="grid grid-cols-2 gap-x-4 items-center">

<div>

<!-- Snippet from @/testing/conan_fmt_module_wrapper/conanfile.txt -->
```ini [conanfile.txt ~i-vscode-icons:file-type-conan~]
[requires]
fmt/11.2.0

[options]
fmt/*:header_only=True
```

<!-- Snippet from @/testing/conan_fmt_module_wrapper/CMakeLists.txt -->
```cmake [CMakeLists.txt ~i-vscode-icons:file-type-cmake~]{hide|*|1|3-8|10-13|*}
find_package(fmt REQUIRED CONFIG)

add_library(fmt-module)
target_sources(
    fmt-module
    PUBLIC
    FILE_SET modules TYPE CXX_MODULES
    FILES "fmt.cppm")

target_link_libraries(
    fmt-module
    PRIVATE
    fmt::fmt-header-only)
```

</div>

<div>

<!-- Snippet from @/testing/conan_fmt_module_wrapper/fmt.cppm -->
```cpp [fmt.cppm ~i-vscode-icons:file-type-cpp2~]{hide|*|1-5|7-13|*}
module;

#include <fmt/core.h>

export module fmt;

export namespace fmt
{
    using ::fmt::print;
    using ::fmt::println;
    using ::fmt::format;
    // ...
}
```

<br>

<!-- Snippet from @/testing/conan_fmt_module_wrapper/main.cpp -->
```cpp [main.cpp ~i-vscode-icons:file-type-cpp~]{hide|*}
import fmt;

// ...
```

</div>

</div>

---
layout: default
---

### Appendix C - Conan: Packaging BMIs

<br>

<!-- Snippet from @/testing/conan_fmt_bmi/fmt-bmi/conanfile.py -->
````md magic-move[conanfile.py ~i-vscode-icons:file-type-conan~]

```py
class FmtBMI(ConanFile):
    name = "fmt-bmi"
    version="11.2.0"
    url = "https://github.com/fmtlib/fmt"
    settings = "os", "compiler", "build_type", "arch"
    generators = "CMakeToolchain", "CMakeDeps"
    exports_sources = []
    no_copy_source = True

# ...
```

```py
class FmtBMI(ConanFile):
    # ...
    
    def source(self):
        git = Git(self)
        git.clone(url="https://github.com/fmtlib/fmt.git", target="fmt")
        git.folder="fmt"
        self.folders.source = "fmt"

        git.checkout(self.version)

    # ...
```

```py {*|6-10}
class FmtBMI(ConanFile):
    # ...

    def build(self):
        cmake = CMake(self)
        cmake.configure(
            variables={
                "FMT_MODULE": True,
            }
        )
        cmake.build(target="fmt")

    # ...
```

```py {*|8}
class FmtBMI(ConanFile):
    # ...

    def package(self):
        cmake = CMake(self)
        cmake.install()

        copy(self, "fmt.pcm", src=".", dst=self.package_folder + "/res")
        copy(self, "src/fmt.cc", src="fmt", dst=self.package_folder + "/res")

        copy(self, "LICENSE.rst", src="fmt", dst=self.package_folder + "/licenses")

    # ...
```

```py {*|9-10}
class FmtBMI(ConanFile):
    # ...

    def package_info(self):
        self.cpp_info.components["fmt-bmi"].libs = ["fmt"]
        self.cpp_info.components["fmt-bmi"].set_property("cmake_target_name", "fmt-bmi::fmt-bmi")
        self.cpp_info.components["fmt-bmi"].resdirs = ["res"]

        pcm_path = os.path.join(self.package_folder, "res/fmt.pcm")
        self.cpp_info.components["fmt-bmi"].cxxflags = [f"-fmodule-file=fmt={pcm_path}"]
```

````

<br>

<v-clicks>

* Platform-specific
* Difficult to maintain
* Error-prone

</v-clicks>
