---@type lspconfig.Config
return {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim', 'ergou' },
      },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      window = {
        progressBar = false,
      },
      hint = { enable = true },
    },
  },
}
