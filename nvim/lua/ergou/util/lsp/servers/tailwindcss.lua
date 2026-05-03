---@type lspconfig.Config
return {
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          ---@see doc https://github.com/RayGuo-ergou/tailwind-intellisense-regex-list?tab=readme-ov-file#plain-javascript-object
          ---All javascript object, only enable when needed e.g. long object
          -- ':\\s*?["\'`]([^"\'`]*).*?,',
          '\\/\\*\\s*tw\\s*\\*\\/\\s*[`\'"](.*)[`\'"];?',
          '@tw\\s\\*/\\s+["\'`]([^"\'`]*)',
          'class\\s*:\\s*["\'`]([^"\'`]*)["\'`]',
          ---@see doc https://github.com/RayGuo-ergou/tailwind-intellisense-regex-list?tab=readme-ov-file#dom
          { 'classList.(?:add|remove)\\(([^)]*)\\)', '(?:\'|"|`)([^"\'`]*)(?:\'|"|`)' },
          ---@see doc https://github.com/RayGuo-ergou/tailwind-intellisense-regex-list?tab=readme-ov-file#typescript-or-javascript-variables-strings-or-arrays-with-keyword
          { 'Styles\\s*(?::\\s*[^=]+)?\\s*=\\s*([^;]*);', '[\'"`]([^\'"`]*)[\'"`]' },
          ---@see doc https://github.com/RayGuo-ergou/tailwind-intellisense-regex-list?tab=readme-ov-file#headlessui-transition-react
          '(?:enter|leave)(?:From|To)?=\\s*(?:"|\'|{`)([^(?:"|\'|`})]*)',
          ---@see doc https://github.com/RayGuo-ergou/tailwind-intellisense-regex-list/tree/main?tab=readme-ov-file#tagged-template-literals
          {
            '(tw`(?:(?:(?:[^`]*\\$\\{[^]*?\\})[^`]*)+|[^`]*`))',
            '((?:(?<=`)(?:[^"\'`]*)(?=\\${|`))|(?:(?<=\\})(?:[^"\'`]*)(?=\\${))|(?:(?<=\\})(?:[^"\'`]*)(?=`))|(?:(?<=\')(?:[^"\'`]*)(?=\'))|(?:(?<=")(?:[^"\'`]*)(?="))|(?:(?<=`)(?:[^"\'`]*)(?=`)))',
          },
          ---@see doc https://github.com/RayGuo-ergou/tailwind-intellisense-regex-list/tree/main?tab=readme-ov-file#laravel-blade-directives-and-component-attribute-functions
          { '@?class(?:es)?\\(([^)]*)\\)', '[\'|"]([^\'"]*)[\'|"]' },
          '(?:"|\')class(?:es)?(?:"|\')[\\s]*=>[\\s]*(?:"|\')([^"\']*)',
          { '(?:->(?:add|remove|merge|when|unless)\\s*\\(([^)]*)\\))+', '[\'"]([^\'"]+)[\'"]' },
        },
      },
      classFunctions = {
        'twc',
        'tw',
        'clsx',
        'cn',
        'tw\\.[a-z-]+',
        'twMerge',
        'twJoin',
      },
      classAttributes = {
        'class',
        'className',
        'class:list',
        'classList',
        'ngClass',
        'ui',
      },
    },
  },
}
