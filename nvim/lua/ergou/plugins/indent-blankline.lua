return {
  -- Detect tabstop and shiftwidth automatically
  {
    'tpope/vim-sleuth',
    event = 'LazyFile',
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'LazyFile',
    main = 'ibl',
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
