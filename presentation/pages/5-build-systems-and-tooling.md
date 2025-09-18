---
layout: section
---

# Build Systems and Tooling

---
layout: default
---

## Build ordering

Suppose we have the following components:

<v-clicks>

- `libGeometry`
    - `Point`
    - `Rectangle`
    - `Square`
    - `Circle`
- `Main`

</v-clicks>

<v-click>

And the following rules:

`libGeometry` &rarr; `Main`

</v-click>

---
layout: statement
title: Build ordering
zoom: 0.67
---

```mermaid
---
title: Build ordering
---

flowchart LR
    subgraph point.h
        point.h_icon@{ icon: "solar:file-text-outline" }
    end
    subgraph rectangle.h
        rectangle.h_icon@{ icon: "solar:file-text-outline" }
    end
    subgraph square.h
        square.h_icon@{ icon: "solar:file-text-outline" }
    end
    subgraph circle.h
        circle.h_icon@{ icon: "solar:file-text-outline" }
    end

    subgraph rectangle.cpp
        rectangle.cpp_icon@{ icon: "solar:file-text-bold" }
    end
    subgraph square.cpp
        square.cpp_icon@{ icon: "solar:file-text-bold" }
    end
    subgraph circle.cpp
        circle.cpp_icon@{ icon: "solar:file-text-bold" }
    end
    subgraph main.cpp
        main.cpp_icon@{ icon: "solar:file-text-bold" }
    end

    libgeometry.a:::rounded
    subgraph libgeometry.a
        libgeometry.a_icon@{ icon: "devicon-plain:linux" }
    end 
    main:::rounded
    subgraph main
        main_icon@{ icon: "devicon-plain:linux" }
    end

    point.h -.-> rectangle.h
    rectangle.h -.-> square.h
    point.h -.-> circle.h

    rectangle.h -.-> rectangle.cpp
    rectangle.h -.-> main.cpp
    square.h -.-> square.cpp
    square.h -.-> main.cpp
    circle.h -.-> circle.cpp
    circle.h -.-> main.cpp

    rectangle.cpp --> libgeometry.a
    circle.cpp --> libgeometry.a
    square.cpp --> libgeometry.a
    
    main.cpp --> main
    libgeometry.a --> main

    classDef rounded rx:15, ry:15
```

---
layout: statement
title: Build ordering
zoom: 0.67
---

```mermaid
---
title: Build ordering
---

flowchart LR
    subgraph headers
        subgraph point.h
            point.h_icon@{ icon: "solar:file-text-outline" }
        end
        subgraph rectangle.h
            rectangle.h_icon@{ icon: "solar:file-text-outline" }
        end
        subgraph square.h
            square.h_icon@{ icon: "solar:file-text-outline" }
        end
        subgraph circle.h
            circle.h_icon@{ icon: "solar:file-text-outline" }
        end
    end

    subgraph sources
        subgraph rectangle.cpp
            rectangle.cpp_icon@{ icon: "solar:file-text-bold" }
        end
        subgraph square.cpp
            square.cpp_icon@{ icon: "solar:file-text-bold" }
        end
        subgraph circle.cpp
            circle.cpp_icon@{ icon: "solar:file-text-bold" }
        end
        subgraph main.cpp
            main.cpp_icon@{ icon: "solar:file-text-bold" }
        end
    end

    subgraph binaries
        libgeometry.a:::rounded
        subgraph libgeometry.a
            libgeometry.a_icon@{ icon: "devicon-plain:linux" }
        end 
        main:::rounded
        subgraph main
            main_icon@{ icon: "devicon-plain:linux" }
        end
    end

    point.h -.-> rectangle.h
    rectangle.h -.-> square.h
    point.h -.-> circle.h

    rectangle.h -.-> rectangle.cpp
    rectangle.h -.-> main.cpp
    square.h -.-> square.cpp
    square.h -.-> main.cpp
    circle.h -.-> circle.cpp
    circle.h -.-> main.cpp

    rectangle.cpp --> libgeometry.a
    circle.cpp --> libgeometry.a
    square.cpp --> libgeometry.a
    
    main.cpp --> main
    libgeometry.a --> main

    classDef rounded rx:15, ry:15
```

<!-- ### Notes:
- This is what is called an "embarassingly parallel" build.
-->

---
layout: statement
title: Build ordering with modules
---

```mermaid
---
title: Build ordering with modules
---

flowchart LR
    subgraph point.cppm
        point.cppm_icon@{ icon: "solar:file-text-bold" }
    end
    subgraph rectangle.cppm
        rectangle.cppm_icon@{ icon: "solar:file-text-bold" }
    end
    subgraph square.cppm
        square.cppm_icon@{ icon: "solar:file-text-bold" }
    end
    subgraph circle.cppm
        circle.cppm_icon@{ icon: "solar:file-text-bold" }
    end
    subgraph geometry.cppm
        geometry.cppm_icon@{ icon: "solar:file-text-bold" }
    end
    subgraph main.cpp
        main.cpp_icon@{ icon: "solar:file-text-bold" }
    end

    point.cppm --> rectangle.cppm
    rectangle.cppm --> square.cppm
    point.cppm --> circle.cppm

    rectangle.cppm --> geometry.cppm
    square.cppm --> geometry.cppm
    circle.cppm --> geometry.cppm

    geometry.cppm --> main.cpp
```

---
layout: default
info: |
    https://cmake.org/cmake/help/latest/manual/cmake-cxxmodules.7.html
    
---

## Dependency scanning

<div class="grid grid-cols-2 gap-x-4 items-center">

<div>
Things are more complicated:

```cpp [square.cppm ~i-vscode-icons:file-type-cpp2~]{*|none|1|3}{at: 2}
export module square;

export import rectangle;
```
</div>

<div>
<v-click at=1>

We can "scan" the dependencies:

<!-- Format determined by [P1689](https://wg21.link/P1689R5) -->

```json [square.cppm.ddi ~i-vscode-icons:file-type-json~]{hide|*|2|3-6|7-9}{at: 1}
{
    "primary-output": "square.o",
    "provides": [{
        "compiled-module-path": "square.pcm",
        "logical-name": "square"
    }],
    "requires": [{
        "logical-name": "rectangle"
    }]
}
```

</v-click>
</div>

</div>

---
layout: default
---

## Modules support in CMake

[CMake 3.28](https://cmake.org/cmake/help/latest/manual/cmake-cxxmodules.7.html): Native support* for named modules (not header units)

<!-- Snippet from @/testing/cmake_modules/CMakeLists.txt -->
```cmake [CMakeLists.txt ~i-vscode-icons:file-type-cmake~]{*|1|3-5|7-11|13-14}
cmake_minimum_required(VERSION 3.28 FATAL_ERROR)

set(CMAKE_CXX_STANDARD 20)

project(ModulesExample CXX)

add_library(Lib)
target_sources(Lib
    PUBLIC FILE_SET modules TYPE CXX_MODULES FILES lib.cppm
    PRIVATE lib.impl.cpp
)

add_executable(Main main.cpp)
target_link_libraries(Main PRIVATE Lib)
```

\* Supported on the `Ninja` and `Visual Studio` generators

---
layout: default
---

## Modules support in CMake

```sh {*}{lines: false}
$ cmake .. -GNinja -DCMAKE_BUILD_TYPE=Release && ninja
```

```txt {*|1-3|4-5|6-8|9-10}{lines: false}
[1/10] Scanning lib.cppm for CXX dependencies
[2/10] Scanning main.cpp for CXX dependencies
[3/10] Scanning lib.impl.cpp for CXX dependencies
[4/10] Generating CXX dyndep file CMakeFiles/Lib.dir/CXX.dd
[5/10] Generating CXX dyndep file CMakeFiles/Main.dir/CXX.dd
[6/10] Building CXX object CMakeFiles/Lib.dir/lib.cppm.o
[7/10] Building CXX object CMakeFiles/Lib.dir/lib.impl.cpp.o
[8/10] Building CXX object CMakeFiles/Main.dir/main.cpp.o
[9/10] Linking CXX static library libLib.a
[10/10] Linking CXX executable Main
```

---
layout: default
---

## Modules support in CMake: STL module

[CMake 3.30](https://www.kitware.com/import-std-in-cmake-3-30/): Experimental support for `import std;`

<!-- Snippet from @/testing/cmake_import_std/CMakeLists.txt -->
```cmake [CMakeLists.txt ~i-vscode-icons:file-type-cmake~]{*|4-5|9}
cmake_minimum_required(VERSION 3.30 FATAL_ERROR)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "0e5b6991-d74f-4b3d-a41c-cf096e0b2508")
set(CMAKE_CXX_MODULE_STD ON)

project(ImportStd LANGUAGES CXX)

add_executable(main main.cpp)
```

---
layout: default
---

## Modules support in CMake: STL module

```sh {*}{lines: false}
$ cmake .. -GNinja -DCMAKE_BUILD_TYPE=Release && ninja
```

```txt {*|1-2,4,6-8|3,5,9-10}{lines: false}
[1/10] Scanning std.compat.ixx for CXX dependencies
[2/10] Scanning std.ixx for CXX dependencies
[3/10] Scanning main.cpp for CXX dependencies
[4/10] Generating CXX dyndep file CMakeFiles\__cmake_cxx23.dir\CXX.dd
[5/10] Generating CXX dyndep file CMakeFiles\main.dir\CXX.dd
[6/10] Building CXX object std.ixx.obj
[7/10] Building CXX object std.compat.ixx.obj
[8/10] Linking CXX static library __cmake_cxx23.lib
[9/10] Building CXX object CMakeFiles\main.dir\main.cpp.obj
[10/10] Linking CXX executable main.exe
```

---
layout: default
---

## Dependency managers

Dependency managers perform:

- Automated retrieval
- Transitive dependency handling
- <span v-mark.red=1>Cross-platform consistency</span>
- <span v-mark.red=1>Build integration</span>
- <span v-mark.red=1>Binary caching</span>

<!-- ### Notes:
- Automated retrieval: Fetch and integrate libraries from remote repositories.
- Transitive dependency handling: Automatically pull in dependencies of dependencies.
- Cross-platform consistency: Get the same set of libraries working across different operating systems / build systems.
- Build integration: Many tools hook directly into build systems, reducing boilerplate.
- Binary caching: Speed up builds by reusing prebuilt binaries when possible.
-->

---
layout: statement
title: Option 1- Wrap non-module library with a module adapter
---

```mermaid
---
title: Option 1- Wrap non-module library with a module adapter
---

flowchart LR
    subgraph Dependency manager
        A[Fetch <code>fmt</code> lib]
        B[Build <code>libfmt.a</code>]

        A --> B
    end
    subgraph Consumer
        C[Maintain <code>fmt.cppm</code>]
        D[Compile <code>fmt</code> module]
        E[<code>import fmt;</code>]

        C --> D
        D --> E
    end

    B --> C
```

---
layout: statement
title: Option 2- Ship module interface sources, consumer builds BMIs
---

```mermaid
---
title: Option 2- Ship module interface sources, consumer builds BMIs
---

flowchart LR
    subgraph Dependency manager
        A[Fetch <code>fmt</code> lib]
        B[Build <code>libfmt.a</code>]
        C[Expose <code>fmt.cppm</code>]

        A --> B
        B --> C
    end
    subgraph Consumer
        D[Compile <code>fmt</code> module]
        E[<code>import fmt;</code>]

        D --> E
    end

    C --> D
```

---
layout: statement
title: Option 3- Ship prebuilt BMIs with package
---

```mermaid
---
title: Option 3- Ship prebuilt BMIs with package
---

flowchart LR
    subgraph Dependency manager
        A[Fetch <code>fmt</code> lib]
        B[Compile <code>fmt</code> module]

        A --> B
    end
    subgraph Consumer
        C[<code>import fmt;</code>]
    end

    B --> C
```

---
layout: default
---

## Dependency managers

The process can easily become:

- Platform-specific
- Difficult to maintain
- Error-prone

Better first-class support from tools is greatly awaited

---
layout: default
title: Dependency managers
preload: false # fixes overview pre-rendering
---

<br><br>

<DependencyManagersFrustrationOutcome/>
