---
title: Knockin' on Header's Door
author: Alexsandro Thomas
keywords: modules,includes,tooling,compiling,build systems,package management
info: |
  # Knockin' on Header's Door
  ## An Overview of C++ Modules

  C++20 modules introduce a major shift in how code is organized and built, aiming to solve long-standing issues with headers and improve both compile times and code encapsulation. This talk offers an overview of what modules are and how they differ from traditional header files. We will cover practical considerations for introducing modules into existing codebases and designing new projects with a module-first approach, while exploring the latest and upcoming advancements of this feature as of 2025.

  We'll walk through the differences in compilation, visibility, and dependency management compared to the preprocessor-based model. We'll also explore the current landscape of C++ module support across major compilers and briefly examine the state of tooling integration with build systems and package managers. In addition, we’ll discuss the limitations, ongoing ecosystem gaps, and trade-offs that developers should be aware of when adopting C++ modules today.

  By the end of this talk, attendees will have a clear understanding of how to begin integrating C++20 modules into their projects, recognizing both the advantages and the current challenges of this evolving feature.

  Note: This presentation runs better on chromium-based browsers. If you experience any problems, please switch your browser accordingly.

  The source code for the presentation, code snippets and feature testing can be found at the [git repository](https://github.com/northy/knockin-on-headers-door).

  [Knockin' on Header's Door: An Overview of C++ Modules (slides)](https://northy.github.io/knockin-on-headers-door) © 2025 by [Alexsandro Thomas](https://github.com/northy) is licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

titleTemplate: '%s'
exportFilename: knockin-on-headers-door
export:
  format: pdf
  dark: true
  withClicks: true
  withToc: false # Broken on CI for some reason
theme: default
addons: []
transition: fade
highlighter: shiki
css: unocss
twoslash: false
monaco: false
lineNumbers: true
mdc: true
download: true

# First slide's frontmatter
layout: cover
class: "text-center"
hide: true # `true` when exporting for CppCon
---

<script setup>
import TitleRenderer from '#slidev/title-renderer'
</script>

# <TitleRenderer/>
## An Overview of C++ Modules

<footer class="absolute bottom-[20%] left-0 right-0 text-center">Alexsandro Thomas</footer>

---
layout: cover
title: CppCon cover
hide: false # `false` when exporting for cppcon
---

<!-- the `background:` frontmatter option dims the image, so do it here instead -->
<style>
.slidev-layout.cover {
  background-image: url("/cppcon_2025_title_card.png") !important;
}
</style>

---
src: ./pages/0-information.md
---

<!-- imported -->

---
src: ./pages/1-why-modules.md
---

<!-- imported -->

---
src: ./pages/2-what-are-modules.md
---

<!-- imported -->

---
src: ./pages/3-traditional-headers-vs-modules.md
---

<!-- imported -->

---
src: ./pages/4-compiler-support-landscape.md
---

<!-- imported -->

---
src: ./pages/5-build-systems-and-tooling.md
---

<!-- imported -->

---
src: ./pages/6-adopting-modules-in-projects.md
---

<!-- imported -->

---
src: ./pages/7-future-and-current-outlook.md
---

<!-- imported -->

---
src: ./pages/8-conclusion.md
---

<!-- imported -->

---
layout: end
---

## Thank you!

---
src: ./pages/9-appendix.md
---

<!-- imported -->
