return {
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        { path = 'nvim-lspconfig/lua', words = { 'lsp' } },
        { path = 'markdown.nvim/lua/render-markdown', words = { 'render%.md' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
      },
    },
  },
  {
    'Bilal2453/luvit-meta',
    lazy = true,
  }, -- optional `vim.uv` typings
}
