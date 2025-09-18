---
layout: fact
---

## Appendix A - Compile-time performance (MSVC)

|            | #include | #include all |              import             | import all |          import std             |
|------------|:--------:|:------------:|:-------------------------------:|:----------:|:-------------------------------:|
| Helo world | 0.55s    | 1.68s        | <span v-mark.red=1>0.11s</span> | 0.12s      | 0.12s                           |
| Mix        | 1.03s    | 1.76s        | 0.33s                           | 0.26s      | <span v-mark.red=1>0.25s</span> |

<!-- ### Notes:
- These timings come from benchmarking MSVC ourselves rather than using the timings from [P2412R0](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2021/p2412r0.pdf). Thanks Frontier789 for writing and running the benchmark scripts on windows!
-->

---
layout: default
---

### Appendix B - Modules support in Bazel

* [Experimental community rules](https://github.com/igormcoelho/rules_cpp23_modules) for modules

````md magic-move[BUILD ~i-vscode-icons:file-type-bazel~]

```py{*|1|3-8|5-6|10-16|12|13|*}
load("@rules_cpp23_modules//cc_module:defs.bzl", "cc_module", "cc_module_binary", "cc_compiled_module")

cc_module(
    name = "lib",
    src = "lib.cppm",
    impl_srcs = ["lib.impl.cpp",],
    copts = ["-std=c++23", "-stdlib=libc++"],
)

cc_module_binary(
    name = "main",
    srcs = ["main.cpp",],
    deps = [":lib"],
    copts = ["-std=c++23"],
    linkopts = ["-stdlib=libc++"],
)
```

<!-- Snippet from @/testing/bazel_modules/BUILD -->
```py{*|3|9-10,16-17|*}
load("@rules_cpp23_modules//cc_module:defs.bzl", "cc_module", "cc_module_binary", "cc_compiled_module")

cc_compiled_module(name="std", cmi="std.pcm")

cc_module(
    name = "lib",
    src = "lib.cppm",
    impl_srcs = ["lib.impl.cpp",],
    deps = [":std"],
    copts = ["-fmodule-file=std=std.pcm", "-std=c++23", "-stdlib=libc++"],
)

cc_module_binary(
    name = "main",
    srcs = ["main.cpp",],
    deps = [":lib", ":std"],
    copts = ["-fmodule-file=std=std.pcm", "-std=c++23"],
    linkopts = ["-stdlib=libc++"],
)
```

````

<!-- ### Notes:
- The `rules_cpp23_modules` package comes from [Igor Machado Coelho's experiments](https://igormcoelho.medium.com/experimenting-c-23-import-std-with-bazel-and-clang-1bec82779ac8)
- Bazel has two PRs ([#22553](https://github.com/bazelbuild/bazel/pull/22553), [#22555](https://github.com/bazelbuild/bazel/pull/22555))
that are open since May 2024 for supporting modules natively on Bazel.
-->

---
layout: default
---

### Appendix C - Modules support in Build2

<br>

<!-- Snippet from @/testing/build2_modules/buildfile -->
```txt [buildfile ~i-vscode-icons:default-file~]{*|2|6|6|7|*}
cxx.std = latest
cxx.features.modules=true

using cxx

./: libue{lib}: mxx{lib.cppm} cxx{lib.impl.cpp}
./: exe{main}: cxx{main.cpp} libue{lib}
```

<v-click at=2>

Glossary:

* `libue{x}`: utility library for an executable called `x`

</v-click>

<v-click at=3>

* `mxx{x.cppm}`: module source `x.cppm`
* `cxx{x.cppm}`: C++ source `x.cppm`

</v-click>

<v-click at=4>

* `exe{x}`: executable called `x`

</v-click>


---
layout: statement
---

### Appendix D - Sample code for fmt module adapter

<div class="text-left">

<!-- Snippet from @/testing/conan_fmt_module_wrapper/fmt.cppm -->
```cpp [fmt.cppm ~i-vscode-icons:file-type-cpp2~]{*|1-3|7-13}
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

</div>

---
layout: default
---

### Appendix E - VCPKG: Module wrapper

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

### Appendix F - Conan: Module wrapper

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

### Appendix G - Conan: Packaging BMIs

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
