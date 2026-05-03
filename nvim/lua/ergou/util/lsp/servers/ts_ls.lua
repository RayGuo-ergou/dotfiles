local vue_plugin = ergou.lsp.typescript.get_vue_plugin()

if vim.tbl_isempty(vue_plugin) then
  vim.notify('Cannot find vue typescript plugin', vim.log.levels.ERROR)
end

---@type lspconfig.Config
return {
  handlers = ergou.lsp.typescript.handlers,
  enabled = ergou.lsp.typescript.server_to_use == 'ts_ls',
  -- taken from https://github.com/typescript-language-server/typescript-language-server#workspacedidchangeconfiguration
  init_options = {
    plugins = {
      vue_plugin,
    },
  },
  filetypes = ergou.lsp.typescript.filetypes,
  settings = {
    javascript = {
      inlayHints = ergou.lsp.typescript.inlay_hints,
    },
    typescript = {
      inlayHints = ergou.lsp.typescript.inlay_hints,
    },
  },
  on_attach = ergou.lsp.typescript.on_attach,
}
