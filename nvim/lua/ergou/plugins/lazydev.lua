return {
  {
    'folke/lazydev.nvim',
    enabled = false,
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        'luvit-meta/library',
      },
    },
  },
  {
    'Bilal2453/luvit-meta',
    enabled = false,
    lazy = true,
  }, -- optional `vim.uv` typings
}
