---@type lspconfig.Config
return {
  settings = {
    css = {
      lint = {
        unknownAtRules = 'ignore',
      },
    },
  },
  on_attach = function(client, _)
    -- FIXME: only disable if eslint attached
    client.server_capabilities.documentFormattingProvider = nil
  end,
}
