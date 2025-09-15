---
layout: section
---

# Future and Current Outlook

---
layout: default
---

## Modules in 2025

<br>

- C++20 introduced modules
- C++23 enhanced modules with the standard library modules
- C++26 proposes further refinements to improve tooling support

<v-click>

... But we're still not quite there

</v-click>

---
layout: default
info: |
    https://clang.llvm.org/docs/StandardCPlusPlusModules.html#privacy-issue
    https://www.reddit.com/r/cpp/comments/1busseu/comment/kxux02i
---

## Built Module Interfaces

Current implementations are underwhelming:

* Difficult to utilize
* Not an information hiding mechanism
* Not portable
* Lack of ABI stability

<v-click>

That doesn't have to be forever:

* BMIs could be shipped
* Shared libraries could be type-safe and self-descriptive
* Potential cross-compiler adoption

</v-click>

<!-- ### Notes:
* Intermediate Format Components (IFCs) could allow DLLs to be type-safe and self-descriptive for dynamic linking, reflection, or Foreign Function Interfaces (FFIs), without requiring a C++ compiler.
-->

---
layout: default
info: |
    https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2019/p1103r3.pdf
    https://eel.is/c++draft/cpp.include#10
---

## Refactor-less improvements

The standard opens up possibilities:

[\[cpp.include\]](https://eel.is/c++draft/cpp.include#10): implementation <span v-mark.red>can</span> treat <span v-mark.red>_importable headers_</span>

```cpp {*}{lines: false}
#include "someheader.h"
```

as if it were
```cpp {*}{lines: false}
import "someheader.h";
```

<!-- ### Notes:
If the header identified by the header-name denotes an importable header ([module.import]), it is implementation-defined whether the #include preprocessing directive is instead replaced by an import directive ([cpp.import]) of the form

import header-name ; new-line

When a #include appears within non-modular code, if the named header file is known to correspond to
a header unit, the implementation treats the #include as an import of the corresponding header unit.
The mechanism for discovering this correspondence is left implementation-defined; there are multiple
viable strategies here (such as explicitly building header units and providing them as input to downstream
compilations, or introducing accompanying files describing the header unit structure) and we wish to encourage
exploration of this space. An implementation is also permitted to not provide any mapping mechanism, and
process each header unit independently
-->

---
layout: default
---

## Lack of ecosystem adoption

Source: [Are We Modules Yet?](https://arewemodulesyet.org)

<div class="absolute left-0 right-0 top-1/2 -translate-y-1/2 flex justify-center">

<LightOrDark>
<template #dark>
  
![Modules progress bar from https://arewemodulesyet.org](/arewemodulesyet_dark.png)

</template>
<template #light>

![Modules progress bar from https://arewemodulesyet.org](/arewemodulesyet_light.png)

</template>
</LightOrDark>

</div>

<!-- ### Notes:
- "Are We Modules Yet?" bases popularity and packages on the VCPKG ports
-->

---
layout: default
---

## New features and improvements

<br>

- [CWG#2732 (2023) DR](https://cplusplus.github.io/CWG/issues/2732.html): Preprocessor definitions don't affect importing headers
- [P3034](http://wg21.link/P3034R1): Forbids macro expansion in the name of module declarations
- [P3618](https://wg21.link/P3618R0): Clarifies `main` usage in named modules
- [P2577](http://wg21.link/P2577R2), [P2701](http://wg21.link/P2701R0), [P3286](http://wg21.link/P3286R0): Providing modules alongside prebuilt C++ libraries
