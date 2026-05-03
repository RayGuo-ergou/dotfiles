---@type lspconfig.Config
return {
  settings = {
    yaml = {
      schemaStore = {
        -- You must disable built-in schemaStore support if you want to use
        -- this plugin and its advanced options like `ignore`.
        enable = false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = '',
      },
      schemas = require('schemastore').yaml.schemas(),
    },
  },
  capabilities = {
    textDocument = {
      ---@diagnostic disable-next-line: assign-type-mismatch if assign nil for some reason it does not work
      formatting = false,
    },
  },
  on_attach = function(client, _)
    -- FIXME: only disable if eslint attached
    client.server_capabilities.documentFormattingProvider = nil
  end,
}
