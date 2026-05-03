local vue_plugin = ergou.lsp.typescript.get_vue_plugin()

if vim.tbl_isempty(vue_plugin) then
  vim.notify('Cannot find vue typescript plugin', vim.log.levels.ERROR)
end

---@type lspconfig.Config
return {
  handlers = ergou.lsp.typescript.handlers,
  enabled = ergou.lsp.typescript.server_to_use == 'vtsls',
  filetypes = ergou.lsp.typescript.filetypes,
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
    typescript = ergou.lsp.typescript.vtsls_typescript_javascript_config,
    javascript = ergou.lsp.typescript.vtsls_typescript_javascript_config,
  },
  on_attach = ergou.lsp.typescript.on_attach,
}
