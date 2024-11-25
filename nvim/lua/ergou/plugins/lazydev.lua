return {
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'nvim-lspconfig/lua', words = { 'lsp' } },
        { path = 'markdown.nvim/lua/render-markdown', words = { 'render%.md' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
      },
    },
  },
}
