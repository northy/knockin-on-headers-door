import { defineShikiSetup } from '@slidev/types'

export default defineShikiSetup(() => {
  return {
    themes: {
      dark: 'gruvbox-dark-hard',
      light: 'one-light',
    },
    langs: [
      'cpp',
      'cmake',
      'py',
      'sh',
      'ini',
      'json',
    ],
  }
})
