---
layout: section
---

# Compiler Support Landscape

---
layout: default
---

## C++20 modules support

According to [cppreference.com](https://en.cppreference.com/w/cpp/compiler_support/20.html#cpp_modules_201907L):

|                 |                 GCC                |                Clang               |            MSVC            |
|-----------------|:----------------------------------:|:----------------------------------:|:--------------------------:|
| Modules support | <solar-check-circle-bold-duotone/> | <solar-check-circle-bold-duotone/> | <solar-check-circle-bold/> |

<v-click>
<br>

... But what does this mean?
</v-click>

<!-- ## Note:
30 March 2025 - Present: CppReference is in a temporary read-only mode
-->

---
layout: default
---

## Feature testing

|                                  |                GCC               |               Clang              |               MSVC               |
|----------------------------------|:--------------------------------:|:--------------------------------:|:--------------------------------:|
| Named modules                    | <solar-question-circle-outline/> | <solar-question-circle-outline/> | <solar-question-circle-outline/> |
| Header units                     | <solar-question-circle-outline/> | <solar-question-circle-outline/> | <solar-question-circle-outline/> |
| Global module fragments          | <solar-question-circle-outline/> | <solar-question-circle-outline/> | <solar-question-circle-outline/> |
| Private module fragments         | <solar-question-circle-outline/> | <solar-question-circle-outline/> | <solar-question-circle-outline/> |
| Module implementation units      | <solar-question-circle-outline/> | <solar-question-circle-outline/> | <solar-question-circle-outline/> |
| Module partition interface units | <solar-question-circle-outline/> | <solar-question-circle-outline/> | <solar-question-circle-outline/> |
| Internal module partition units  | <solar-question-circle-outline/> | <solar-question-circle-outline/> | <solar-question-circle-outline/> |

<footer class="absolute bottom-2 left-0 right-0 text-center">
<solar-check-circle-bold/>: Success | <solar-check-circle-bold-duotone/>: Success with warnings | <solar-close-circle-outline/>: Failure
</footer>

---
layout: default
---

### Feature testing

Using the following versions:

- `MSVC v143`
- `clang version 20.1.8`
- `g++ (GCC) 15.2.1 20250813`

---
layout: default
---

### Feature testing workflow

After defining a module:

1. Compile the code
  ```cpp
  int getAnswer()
  {
      return 42;
  }
  ```

<v-clicks>

2. Compile a simple test
3. Verify that `getAnswer() == 42`

</v-clicks>

---
layout: default
---

### Named modules

<!-- Snippet from @/testing/feature_testing/features/NamedModule/test.cppm -->
```cpp [test.cppm ~i-vscode-icons:file-type-cpp2~]
export module test;

export int getAnswer()
{
    return 42;
}
```

<v-click>

<br>
<hr>
<br>

|                GCC               |               Clang              |               MSVC               |
|:--------------------------------:|:--------------------------------:|:--------------------------------:|
|    <solar-check-circle-bold/>    |    <solar-check-circle-bold/>    |    <solar-check-circle-bold/>    |

<footer class="absolute bottom-2 left-0 right-0 text-center">
<solar-check-circle-bold/>: Success | <solar-check-circle-bold-duotone/>: Success with warnings | <solar-close-circle-outline/>: Failure
</footer>

</v-click>

---
layout: default
---

### Header units

<br>

<div class="grid grid-cols-2 gap-x-4 items-center">

<!-- Snippet from @/testing/feature_testing/features/HeaderUnit/header.h -->
```cpp [header.h ~i-vscode-icons:file-type-cheader~]
#pragma once

#define ANSWER 42
```

<!-- Snippet from @/testing/feature_testing/features/HeaderUnit/test.cppm -->
```cpp [test.cppm ~i-vscode-icons:file-type-cpp2~]
export module test;

import "header.h";

export int getAnswer()
{
    return ANSWER;
}
```

</div>

<v-click>

<br>
<hr>
<br>

|                GCC               |                Clang                |               MSVC               |
|:--------------------------------:|:-----------------------------------:|:--------------------------------:|
|    <solar-check-circle-bold/>    | <solar-check-circle-bold-duotone/>* |    <solar-check-circle-bold/>    |

\* `warning: the implementation of header units is in an experimental phase`

<footer class="absolute bottom-2 left-0 right-0 text-center">
<solar-check-circle-bold/>: Success | <solar-check-circle-bold-duotone/>: Success with warnings | <solar-close-circle-outline/>: Failure
</footer>

</v-click>

---
layout: default
---

### Global module fragments

<!-- Snippet from @/testing/feature_testing/features/GlobalModuleFragment/test.cppm -->
```cpp [test.cppm ~i-vscode-icons:file-type-cpp2~]
module;

#include <cmath>

export module test;

export int getAnswer()
{
    return std::sqrt(1764);
}
```

<v-click>

<br>
<hr>
<br>

|                GCC               |               Clang              |               MSVC               |
|:--------------------------------:|:--------------------------------:|:--------------------------------:|
|    <solar-check-circle-bold/>    |    <solar-check-circle-bold/>    |    <solar-check-circle-bold/>    |

<footer class="absolute bottom-2 left-0 right-0 text-center">
<solar-check-circle-bold/>: Success | <solar-check-circle-bold-duotone/>: Success with warnings | <solar-close-circle-outline/>: Failure
</footer>

</v-click>

---
layout: default
---

### Private module fragments

<!-- Snippet from @/testing/feature_testing/features/PrivateModuleFragment/test.cppm -->
```cpp [test.cppm ~i-vscode-icons:file-type-cpp2~]
export module test;

export int getAnswer();

module : private;

int getAnswer() {
    return 42;
}
```

<v-click>

<br>
<hr>
<br>

|                GCC               |                Clang               |               MSVC               |
|:--------------------------------:|:----------------------------------:|:--------------------------------:|
|   <solar-close-circle-outline/>* |     <solar-check-circle-bold/>     |    <solar-check-circle-bold/>    |

\* `sorry, unimplemented: private module fragment`

<footer class="absolute bottom-2 left-0 right-0 text-center">
<solar-check-circle-bold/>: Success | <solar-check-circle-bold-duotone/>: Success with warnings | <solar-close-circle-outline/>: Failure
</footer>

</v-click>

---
layout: default
---

### Module implementation units

<br>

<div class="inset-5 grid grid-cols-2 gap-x-4 items-center">

<!-- Snippet from @/testing/feature_testing/features/ImplementationUnit/test.cppm -->
```cpp [test.cppm ~i-vscode-icons:file-type-cpp2~]
export module test;

export int getAnswer();
```

<!-- Snippet from @/testing/feature_testing/features/ImplementationUnit/test.impl.cppm -->
```cpp [test.impl.cpp ~i-vscode-icons:file-type-cpp2~]
module test;

int getAnswer()
{
    return 42;
}
```

</div>

<v-click>

<br>
<hr>
<br>

|                GCC               |               Clang              |               MSVC               |
|:--------------------------------:|:--------------------------------:|:--------------------------------:|
|    <solar-check-circle-bold/>    |    <solar-check-circle-bold/>    |    <solar-check-circle-bold/>    |

<footer class="absolute bottom-2 left-0 right-0 text-center">
<solar-check-circle-bold/>: Success | <solar-check-circle-bold-duotone/>: Success with warnings | <solar-close-circle-outline/>: Failure
</footer>

</v-click>

---
layout: default
---

### Module partition interface units

<br>

<div class="inset-5 grid grid-cols-2 gap-x-4 items-center">

<!-- Snippet from @/testing/feature_testing/features/PartitionInterfaceUnit/test.cppm -->
```cpp [test.cppm ~i-vscode-icons:file-type-cpp2~]
export module test;

export import :pinterface;
```

<!-- Snippet from @/testing/feature_testing/features/PartitionInterfaceUnit/test_pinterface.cppm -->
```cpp [test_pinterface.cppm ~i-vscode-icons:file-type-cpp2~]
export module test:pinterface;

export int getAnswer()
{
    return 42;
}
```

</div>

<v-click>

<br>
<hr>
<br>

|                GCC               |               Clang              |               MSVC               |
|:--------------------------------:|:--------------------------------:|:--------------------------------:|
|    <solar-check-circle-bold/>    |    <solar-check-circle-bold/>    |    <solar-check-circle-bold/>    |

<footer class="absolute bottom-2 left-0 right-0 text-center">
<solar-check-circle-bold/>: Success | <solar-check-circle-bold-duotone/>: Success with warnings | <solar-close-circle-outline/>: Failure
</footer>

</v-click>

---
layout: default
---

### Internal module partition units

<br>

<div class="inset-5 grid grid-cols-2 gap-x-4 items-center">

<!-- Snippet from @/testing/feature_testing/features/InternalPartitionUnit/test.cppm -->
```cpp [test.cppm ~i-vscode-icons:file-type-cpp2~]
export module test;

import :answer;

export int getAnswer()
{
    return answer();
}
```

<!-- Snippet from @/testing/feature_testing/features/InternalPartitionUnit/test_answer.impl.cppm -->
```cpp [test_answer.impl.cppm ~i-vscode-icons:file-type-cpp2~]
module test:answer;

int answer()
{
    return 42;
}
```

</div>

<v-click>

<br>
<hr>
<br>

|                GCC               |               Clang              |               MSVC               |
|:--------------------------------:|:--------------------------------:|:--------------------------------:|
|    <solar-check-circle-bold/>    |    <solar-check-circle-bold/>    |    <solar-check-circle-bold/>    |

<footer class="absolute bottom-2 left-0 right-0 text-center">
<solar-check-circle-bold/>: Success | <solar-check-circle-bold-duotone/>: Success with warnings | <solar-close-circle-outline/>: Failure
</footer>

</v-click>

---
layout: default
---

## C++20 modules support

|                                  |              GCC              |                Clang               |            MSVC            |
|----------------------------------|:-----------------------------:|:----------------------------------:|:--------------------------:|
| Named modules                    |   <solar-check-circle-bold/>  |     <solar-check-circle-bold/>     | <solar-check-circle-bold/> |
| Header units                     |   <solar-check-circle-bold/>  | <solar-check-circle-bold-duotone/> | <solar-check-circle-bold/> |
| Global module fragments          |   <solar-check-circle-bold/>  |     <solar-check-circle-bold/>     | <solar-check-circle-bold/> |
| Private module fragments         | <solar-close-circle-outline/> |     <solar-check-circle-bold/>     | <solar-check-circle-bold/> |
| Module implementation units      |   <solar-check-circle-bold/>  |     <solar-check-circle-bold/>     | <solar-check-circle-bold/> |
| Module partition interface units |   <solar-check-circle-bold/>  |     <solar-check-circle-bold/>     | <solar-check-circle-bold/> |
| Internal module partition units  |   <solar-check-circle-bold/>  |     <solar-check-circle-bold/>     | <solar-check-circle-bold/> |

<footer class="absolute bottom-2 left-0 right-0 text-center">
<solar-check-circle-bold/>: Success | <solar-check-circle-bold-duotone/>: Success with warnings | <solar-close-circle-outline/>: Failure
</footer>

---
layout: default
info: |
    https://en.cppreference.com/w/cpp/compiler_support/20.html#cpp_modules_201907L
    https://en.cppreference.com/w/cpp/compiler_support/23.html#cpp_lib_modules_202207L
---

## Standard library modules

According to [cppreference.com](https://en.cppreference.com/w/cpp/compiler_support/23.html#cpp_lib_modules_202207L):

|                  |            GCC libstdc++           |            Clang libc++            |          MSVC STL          |
|------------------|:----------------------------------:|:----------------------------------:|:--------------------------:|
| STL header units | <solar-check-circle-bold-duotone/> |    <solar-close-circle-outline/>   | <solar-check-circle-bold/> |
| `std` module     | <solar-check-circle-bold-duotone/> | <solar-check-circle-bold-duotone/> | <solar-check-circle-bold/> |

<v-click>
<br>

... But what does this mean?
</v-click>

---
layout: default
---

### Feature testing

Using `mix.cpp`:

|                    |           GCC libstdc++          |           Clang libc++           |             MSVC STL             |
|--------------------|:--------------------------------:|:--------------------------------:|:--------------------------------:|
| stdc++ header unit | <solar-question-circle-outline/> | <solar-question-circle-outline/> | <solar-question-circle-outline/> |
| STL header units   | <solar-question-circle-outline/> | <solar-question-circle-outline/> | <solar-question-circle-outline/> |
| `std` module       | <solar-question-circle-outline/> | <solar-question-circle-outline/> | <solar-question-circle-outline/> |

<footer class="absolute bottom-2 left-0 right-0 text-center">
<solar-check-circle-bold/>: Success | <solar-check-circle-bold-duotone/>: Success with warnings | <solar-close-circle-outline/>: Failure
</footer>

<!-- ### Notes:

* `mix.cpp` uses 9 headers: iostream, map, vector, algorithm, chrono, random, memory, cmath, thread

Src: [P2412r0](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2021/p2412r0.pdf)
-->

---
layout: default
---

### stdc++ header unit

```cpp [stdcpp.h ~i-vscode-icons:file-type-cheader~]
#pragma once

#include <algorithm>
#include <any>
#include <array>
#include <atomic>
#include <barrier>
// ...
```

```cpp [mix.cpp ~i-vscode-icons:file-type-cpp~]
import "stdcpp.h"
// ...
```

<v-click>

<br>
<hr>

|        GCC libstdc++       |            Clang libc++            |          MSVC STL          |
|:--------------------------:|:----------------------------------:|:--------------------------:|
| <solar-check-circle-bold/> | <solar-check-circle-bold-duotone/> | <solar-check-circle-bold/> |

<footer class="absolute bottom-2 left-0 right-0 text-center">
<solar-check-circle-bold/>: Success | <solar-check-circle-bold-duotone/>: Success with warnings | <solar-close-circle-outline/>: Failure
</footer>

</v-click>

---
layout: default
---

### STL header units

Compiling every header unit one by one:

```cpp [mix.cpp ~i-vscode-icons:file-type-cpp~]
import <algorithm>;
import <any>;
import <array>;
import <atomic>;
import <barrier>;
// ...
```

<v-click>

<br>
<hr>
<br>

|        GCC libstdc++       |            Clang libc++            |          MSVC STL          |
|:--------------------------:|:----------------------------------:|:--------------------------:|
| <solar-check-circle-bold/> |    <solar-close-circle-outline/>*  | <solar-check-circle-bold/> |

\* `error: [...] is ambiguous`

<footer class="absolute bottom-2 left-0 right-0 text-center">
<solar-check-circle-bold/>: Success | <solar-check-circle-bold-duotone/>: Success with warnings | <solar-close-circle-outline/>: Failure
</footer>

</v-click>

---
layout: default
---

### `std` module

```cpp [mix.cpp ~i-vscode-icons:file-type-cpp~]
import std;
// ...
```

<v-click>

<br>
<hr>
<br>

|        GCC libstdc++       |            Clang libc++            |          MSVC STL          |
|:--------------------------:|:----------------------------------:|:--------------------------:|
| <solar-check-circle-bold/> |     <solar-check-circle-bold/>     | <solar-check-circle-bold/> |

<footer class="absolute bottom-2 left-0 right-0 text-center">
<solar-check-circle-bold/>: Success | <solar-check-circle-bold-duotone/>: Success with warnings | <solar-close-circle-outline/>: Failure
</footer>

</v-click>

---
layout: default
---

## Standard library modules

|                    |        GCC libstdc++       |            Clang libc++            |          MSVC STL          |
|--------------------|:--------------------------:|:----------------------------------:|:--------------------------:|
| stdc++ header unit | <solar-check-circle-bold/> | <solar-check-circle-bold-duotone/> | <solar-check-circle-bold/> |
| STL header units   | <solar-check-circle-bold/> |    <solar-close-circle-outline/>   | <solar-check-circle-bold/> |
| `std` module       | <solar-check-circle-bold/> |     <solar-check-circle-bold/>     | <solar-check-circle-bold/> |

<footer class="absolute bottom-2 left-0 right-0 text-center">
<solar-check-circle-bold/>: Success | <solar-check-circle-bold-duotone/>: Success with warnings | <solar-close-circle-outline/>: Failure
</footer>

---
layout: default
---

## Standard library modules

- Libraries provide the module definition files for `std` and `std.compat`
- Users need to build their own BMIs

<v-click>

````md magic-move {lines: false}

```sh
clang++ -std=c++23 -stdlib=libc++ /usr/share/libc++/v1/std.cppm -Wno-reserved-module-identifier --precompile
```

```sh
g++ -std=c++23 -fmodules -fsearch-include-path bits/std.cc -c
```

```sh
cl /EHsc /std:c++latest "%VCToolsInstallDir%\modules\std.ixx" /c
```

````

</v-click>

---
layout: default
---

## Compiler interoperability

There are variations among compiler implementations:

<v-clicks>

- Filenames:
    - MSVC: `.ixx` &rarr; `.ifc`
    - Clang: `.cppm` &rarr; `.pcm`
    - GCC: `.cpp` &rarr; `.gcm` 
- ABI:
    - ABI formats differ per compiler  
    - No cross-compiler reuse possible

</v-clicks>

<!-- ### Notes:
- Filenames are generally able to be overriden in the command line
- `.ifc`: Intermediate Format Components (IFCs)
- No standard BMI ABI: The formats, internal layouts, name mangling, metadata differ. This blocks interoperability of prebuilt modules across compiler vendors.
-->

---
layout: default
info: |
    https://clang.llvm.org/docs/StandardCPlusPlusModules.html#consistency-requirements
---

## Consistency requirements

Compilers perform very strict checking for consistency:

- Compiler options consistency
- Source Files Consistency
- Object definition consistency
