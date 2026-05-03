local customizations = {
  { rule = 'style/*', severity = 'off', fixable = true },
  { rule = 'format/*', severity = 'off', fixable = true },
  { rule = '*-indent', severity = 'off', fixable = true },
  { rule = '*-spacing', severity = 'off', fixable = true },
  { rule = '*-spaces', severity = 'off', fixable = true },
  { rule = '*-order', severity = 'off', fixable = true },
  { rule = '*-dangle', severity = 'off', fixable = true },
  { rule = '*-newline', severity = 'off', fixable = true },
  { rule = '*quotes', severity = 'off', fixable = true },
  { rule = '*semi', severity = 'off', fixable = true },
}

local filetypes = {
  'javascript',
  'javascriptreact',
  'typescript',
  'typescriptreact',
  'vue',
  'html',
  'markdown',
  'json',
  'jsonc',
  'yaml',
  'toml',
  'xml',
  'gql',
  'graphql',
  'astro',
  'css',
  'less',
  'scss',
  'pcss',
  'postcss',
}

---@type lspconfig.Config
return {
  filetypes = filetypes,
  settings = {
    rulesCustomizations = customizations,
  },
}
