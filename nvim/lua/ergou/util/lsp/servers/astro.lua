---@type lspconfig.Config
return {
  on_attach = function(client, _)
    client.server_capabilities.documentFormattingProvider = nil
    client.server_capabilities.documentRangeFormattingProvider = nil
  end,
}
