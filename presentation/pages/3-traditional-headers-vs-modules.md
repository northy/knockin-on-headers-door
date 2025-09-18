---
layout: section
---

# Traditional Headers vs. Modules

---
layout: statement
---

## Let's circle back to headers

<!-- ### Notes:
* Specifically, the problems with headers, and how modules can help solve that
-->

---
layout: default
---

## Built-in type definitions at namespace or global scope

```cpp [header.h ~i-vscode-icons:file-type-cheader~]
#pragma once

#include <cstdint>

#define int int64_t
```

```cpp [main.cpp ~i-vscode-icons:file-type-cpp~]
#include "header.h"

int main() // error: 'main' must return 'int'
{
   return 0;
}
```

---
layout: default
---

## Built-in type definitions at namespace or global scope

```cpp [module.cppm ~i-vscode-icons:file-type-cpp2~]
module;

#define int int64_t

export module myModule;
```

```cpp [main.cpp ~i-vscode-icons:file-type-cpp~]
import myModule;

int main()
{
   return 0;
}
```

---
layout: default
---

### Non-inline function definitions

<br>

```cpp [header.h ~i-vscode-icons:file-type-cheader~]
#pragma once

void doSomething()
{
    ...
}
```

---
layout: default
---

### Non-inline function definitions

<br>

```cpp [module.cppm ~i-vscode-icons:file-type-cpp2~]
export module myModule;

export void doSomething()
{
    ...
}
```

---
layout: default
---

### Non-const variable definitions

```cpp [header.h ~i-vscode-icons:file-type-cheader~]
#pragma once

int variable = 0;
```

---
layout: default
---

### Non-const variable definitions

```cpp [module.cppm ~i-vscode-icons:file-type-cpp2~]
export module myModule;

export int variable = 0;
```

---
layout: default
---

### Aggregate definitions

<br>

```cpp [header.h ~i-vscode-icons:file-type-cheader~]
#pragma once

int aggregate[] = {10, 20, 30};
```

---
layout: default
---

### Aggregate definitions

<br>

```cpp [module.cppm ~i-vscode-icons:file-type-cpp2~]
export module myModule;

export int aggregate[] = {10, 20, 30};
```

---
layout: default
---

### Unnamed namespaces

<br>

```cpp [header.h ~i-vscode-icons:file-type-cheader~]
#pragma once

namespace
{
    void doSomething() { ... }
}
```

---
layout: default
---

### Unnamed namespaces

<br>

````md magic-move[module.cppm ~i-vscode-icons:file-type-cpp2~]

```cpp
export module myModule;

namespace
{
    void doSomething() { ... }
}
```

```cpp
export module myModule;

namespace
{
    export void doSomething() { ... }
}
```

````

```txt {hide|hide|*}{at: 1, lines: false}
error C2294: cannot export symbol '`anonymous-namespace'::doSomething' because it has internal linkage
```

---
layout: default
---

### Using directives

<br>

```cpp [header.h ~i-vscode-icons:file-type-cheader~]
#pragma once

using namespace std;
```

---
layout: default
---

### Using directives

<br>

```cpp [module.cppm ~i-vscode-icons:file-type-cpp2~]
export module myModule;

using namespace std;
```

---
layout: default
---

## Encapsulation

<br>

```cpp [Private.h ~i-vscode-icons:file-type-cheader~]{*|1|4|none|none|none|none|*|none}
#define SECRET 42
namespace Private
{
    inline int secret() {  return SECRET; }
}
```

<div class="grid grid-cols-2 gap-x-3 items-center">

```cpp [UserFacing.h ~i-vscode-icons:file-type-cheader~]{hide|*|2-6|1,8-9|none}{at: 3}
using Pimpl = shared_ptr<struct UserFacingImpl>;
class UserFacing
{
public:
    UserFacing();
    int getNumber() const;

private:
    Pimpl m_pimpl;
};
```

```cpp [UserFacing.cpp ~i-vscode-icons:file-type-cpp~]{hide|*|2|7-8|4-5|10-11}{at: 6}
#include "UserFacing.h"
#include "Private.h"

struct UserFacingImpl
{ int number = Private::secret(); };

UserFacing::UserFacing()
    : m_pimpl(new UserFacingImpl()) {}

int UserFacing::getNumber() const
{ return m_pimpl->number; }
```

</div>

---
layout: default
---

## Encapsulation with modules

<div class="grid grid-cols-2 gap-x-3 items-center">

```cpp [Private.cppm ~i-vscode-icons:file-type-cpp2~]{*|3|2|5|none|none|*|none}
module;
#define SECRET 42
export module Private;
namespace Private {
    export inline int secret() {  return SECRET; }
}
```

```cpp [UserFacing.cppm ~i-vscode-icons:file-type-cpp2~]{hide|*|1|2|7-17|4-5,11,16,19-20}{at: 4}
export module UserFacing;
import Private;

struct UserFacingImpl
{ const int number = Private::secret(); };

export class UserFacing
{
public:
    UserFacing()
      : m_pimpl(std::make_shared<UserFacingImpl>())
    {}

    int getNumber() const
    {
        return m_pimpl->number;
    }

private:
    std::shared_ptr<UserFacingImpl> m_pimpl;
};
```

</div>

---
layout: default
---

## Encapsulation with modules (two units)

<br>

```cpp [Private.cppm ~i-vscode-icons:file-type-cpp2~]{none|none|none|none|*|none}
module;
#define SECRET 42
export module Private;
namespace Private {
    export inline int secret() {  return SECRET; }
}
```

<div class="grid grid-cols-2 gap-x-3 items-center">

```cpp [UserFacing.cppm ~i-vscode-icons:file-type-cpp2~]{*|1|3-11|none}{at: 1}
export module UserFacing;

using Pimpl = shared_ptr<struct UserFacingImpl>;
export class UserFacing
{
public:
    UserFacing();
    int getNumber() const;
private:
    Pimpl m_pimpl;
};
```

```cpp [UserFacing.impl.cpp ~i-vscode-icons:file-type-cpp~]{hide|*|2|4-5,8,11}{at: 3}
module UserFacing;
import Private;

struct UserFacingImpl
{ int number = Private::secret(); };

UserFacing::UserFacing()
    : m_pimpl(new UserFacingImpl()) {}

int UserFacing::getNumber() const
{ return m_pimpl->number; }
```

</div>

---
layout: default
---

## Compile-time performance

Let's compare compilation times:
* `hello_world.cpp`: Needs just `<iostream>`.
* `mix.cpp`: Requires including 9 standard headers.

<br>

Helpers:

- `all_std.h`: Includes all standard library headers

<!-- ### Notes:
- The timings are taken from [P2412](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2021/p2412r0.pdf): An Intel i-7 running windows
-->

---
layout: default
---

### `#include` necessary headers

<div class="fixed inset-5 grid grid-cols-2 gap-x-4 items-center h-full">

```cpp [hello_world.cpp ~i-vscode-icons:file-type-cpp2~]
#include <iostream>

...
```

```cpp [mix.cpp ~i-vscode-icons:file-type-cpp2~]
#include <iostream>
#include <map>
#include <vector>
#include <algorithm>
#include <chrono>
#include <random>
#include <memory>
#include <cmath>
#include <thread>

...
```

</div>

---
layout: fact
info: |
    https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2021/p2412r0.pdf
---

## Compile-time performance

|             | #include |
|:-----------:|:--------:|
| Hello world |   0.87s  |
| Mix         |   2.20s  |

---
layout: default
---

### `#include` all headers

<div class="fixed inset-5 grid grid-cols-2 gap-x-4 items-center h-full">

```cpp [hello_world.cpp ~i-vscode-icons:file-type-cpp2~]
#include "all_std.h"

...
```

```cpp [mix.cpp ~i-vscode-icons:file-type-cpp2~]
#include "all_std.h"

...
```

</div>

---
layout: fact
info: |
    https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2021/p2412r0.pdf
---

## Compile-time performance

|             | #include | #include all |
|-------------|:--------:|:------------:|
| Hello world |   0.87s  |     3.43s    |
| Mix         |   2.20s  |     3.53s    |

---
layout: default
---

### `import` necessary header units

<div class="fixed inset-5 grid grid-cols-2 gap-x-4 items-center h-full">

```cpp [hello_world.cpp ~i-vscode-icons:file-type-cpp2~]
import <iostream>;

...
```

```cpp [mix.cpp ~i-vscode-icons:file-type-cpp2~]
import <iostream>;
import <map>;
import <vector>;
import <algorithm>;
import <chrono>;
import <random>;
import <memory>;
import <cmath>;
import <thread>;

...
```

</div>

---
layout: fact
info: |
    https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2021/p2412r0.pdf
---

## Compile-time performance

|             | #include | #include all | import |
|-------------|:--------:|:------------:|:------:|
| Hello world |   0.87s  |     3.43s    |  0.32s |
| Mix         |   2.20s  |     3.53s    |  0.77s |

---
layout: default
---

### `import` all header units

<div class="fixed inset-5 grid grid-cols-2 gap-x-4 items-center h-full">

```cpp [hello_world.cpp ~i-vscode-icons:file-type-cpp2~]
import "all_std.h";

...
```

```cpp [mix.cpp ~i-vscode-icons:file-type-cpp2~]
import "all_std.h";

...
```

</div>

---
layout: fact
info: |
    https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2021/p2412r0.pdf
---

## Compile-time performance

|             | #include | #include all | import | import all |
|-------------|:--------:|:------------:|:------:|:----------:|
| Hello world |   0.87s  |     3.43s    |  0.32s |    0.62s   |
| Mix         |   2.20s  |     3.53s    |  0.77s |    0.99s   |

---
layout: default
---

### `import std;`

[C++23](https://en.cppreference.com/w/cpp/standard_library.html#Importing_modules) enables:

<div class="fixed inset-5 grid grid-cols-2 gap-x-4 items-center h-full">

```cpp [hello_world.cpp ~i-vscode-icons:file-type-cpp2~]
import std;

...
```

```cpp [mix.cpp ~i-vscode-icons:file-type-cpp2~]
import std;

...
```

</div>

---
layout: fact
info: |
    https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2021/p2412r0.pdf
---

## Compile-time performance

|             | #include | #include all | import | import all |            import std           |
|-------------|:--------:|:------------:|:------:|:----------:|:-------------------------------:|
| Hello world |   0.87s  |     3.43s    |  0.32s |    0.62s   | <span v-mark.red=1>0.08s</span> |
| Mix         |   2.20s  |     3.53s    |  0.77s |    0.99s   | <span v-mark.red=1>0.44s</span> |

---
layout: fact
---

## Compile-time performance (MSVC)

|            | #include | #include all |              import             | import all |          import std             |
|------------|:--------:|:------------:|:-------------------------------:|:----------:|:-------------------------------:|
| Helo world | 0.55s    | 1.68s        | <span v-mark.red=1>0.11s</span> | 0.12s      | 0.12s                           |
| Mix        | 1.03s    | 1.76s        | 0.33s                           | 0.26s      | <span v-mark.red=1>0.25s</span> |

---
layout: fact
---

## Compile-time performance (GCC)

|             | #include | #include all |              import             | import all |            import std           |
|-------------|:--------:|:------------:|:-------------------------------:|:----------:|:-------------------------------:|
| Hello world |   0.67s  |     1.63s    | <span v-mark.red=1>0.09s</span> |    0.28s   |              0.27s              |
| Mix         |   1.82s  |     2.60s    |              1.58s              |    1.26s   | <span v-mark.red=1>1.09s</span> |

---
layout: fact
---

## Compile-time performance (clang)

|             | #include | #include all | import |            import all           |            import std           |
|-------------|:--------:|:------------:|:------:|:-------------------------------:|:-------------------------------:|
| Hello world |   0.92s  |     2.02s    |  0.06s | <span v-mark.red=1>0.04s</span> |              0.07s              |
| Mix         |   1.62s  |     2.23s    |    -   |               0.49s             | <span v-mark.red=1>0.35s</span> |

---
layout: default
---

### A small note

"But I could achieve this before with XYZ!"

- Modules are standardized, and accessible by every C++ developer
- Every "getting started" guide can provide this
- Imports are a portable performance gain

---
layout: default
info: |
    Information sourced from [Microsoft Learn](https://learn.microsoft.com/en-us/cpp/cpp/modules-cpp?view=msvc-170)
---

## Problems solved

<br>

* Structured, semantic import mechanism
* Component interfaces compiled independently from the TUs that import them
* Processed only once, into an efficient binary representation (BMI)
* Modules provide strong isolation, no global polution
