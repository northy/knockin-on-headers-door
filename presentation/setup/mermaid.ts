import { defineMermaidSetup } from '@slidev/types'

import mermaid from 'mermaid/dist/mermaid.esm.mjs'

mermaid.registerIconPacks([
  {
    name: 'devicon',
    loader: () => import('@iconify-json/devicon').then((module) => module.icons),
  },
  {
    name: 'devicon-plain',
    loader: () => import('@iconify-json/devicon-plain').then((module) => module.icons),
  },
  {
    name: 'solar',
    loader: () => import('@iconify-json/solar').then((module) => module.icons),
  },
  {
    name: 'vscode-icons',
    loader: () => import('@iconify-json/vscode-icons').then((module) => module.icons),
  },
])

export default defineMermaidSetup(() => {
  return {
    theme: 'neutral',
    colorSchema: 'light',
  }
})
