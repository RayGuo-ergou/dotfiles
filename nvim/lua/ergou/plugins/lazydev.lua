return {
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'Bilal2453/luvit-meta',
    lazy = true,
  }, -- optional `vim.uv` typings
}
