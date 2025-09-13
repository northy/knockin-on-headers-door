---
layout: section
---

# Adopting Modules in Projects

---
layout: default
---

## Module-first greenfield designing

Starting out with modules is now recommended:

* [Clang](https://clang.llvm.org/docs/StandardCPlusPlusModules.html#transitioning-to-modules): "It is best for new code and libraries to use modules from the start if possible"
* [Microsoft learn](https://learn.microsoft.com/en-us/cpp/cpp/modules-cpp?view=msvc-170): "We recommend that you use modules in new projects rather than header files as much as possible"

<v-click>

And there are some real advantages:

* Adopting modules early minimizes transition cost
* Future improvements will be easily achievable
* Code can be structured for modules

</v-click>

---
layout: default
---

## Modules in existing projects

The choice is not always clear:

* Most projects will not rewrite everything at once
* Build system support increment is required
* Need for accustomed developers to learn new workflows

<v-click>

Other build-time strategies might be better-suited:

* Precompiled headers (PCH)
* Unity builds

</v-click>

---
layout: default
---

### Header units

Using header units can bridge legacy and modern code:

* Modern access to legacy headers
* No changes are required for legacy code

<v-click>

But there are some problems:

* Still experimental on some compilers
* Lack of build system support
* Macro-heavy headers will break

</v-click>

---
layout: default
---

### Incremental adoption

Moving step by step is often more practical:

* Start with utility libraries or self-contained components
* Gradually convert commonly used headers into modules
* Experiment with internal-only modules before exposing public ones
* Define strong code-guidelines for modules
* Regularly review build performance metrics
