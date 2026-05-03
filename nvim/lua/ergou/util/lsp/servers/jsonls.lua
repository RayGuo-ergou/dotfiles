---@type lspconfig.Config
return {
  capabilities = {
    textDocument = {
      ---@diagnostic disable-next-line: assign-type-mismatch if assign nil for some reason it does not work
      formatting = false,
    },
  },
  settings = {
    json = {
      schemas = require('schemastore').json.schemas({
        extra = {
          {
            description = 'TypeScript compiler configuration file for vue',
            fileMatch = { 'tsconfig*.json' },
            name = 'vue-tsconfig.json',
            url = 'https://raw.githubusercontent.com/vuejs/language-tools/refs/heads/master/extensions/vscode/schemas/vue-tsconfig.schema.json',
          },
        },
      }),
      validate = { enable = true },
    },
  },
}
