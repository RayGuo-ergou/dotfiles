return {
  -- Detect tabstop and shiftwidth automatically
  {
    'tpope/vim-sleuth',
    event = 'LazyFile',
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    enabled = false,
    event = 'LazyFile',
    main = 'ibl',
    ---@module "ibl"
    ---@type ibl.config
    opts = {
      exclude = {
        filetypes = {
          'help',
          'alpha',
          'dashboard',
          'neo-tree',
          'Trouble',
          'trouble',
          'lazy',
          'mason',
          'notify',
          'toggleterm',
          'lazyterm',
          'snacks_dashboard',
        },
      },
    },
  },
}
