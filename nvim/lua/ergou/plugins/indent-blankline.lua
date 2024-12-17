return {
  'lukas-reineke/indent-blankline.nvim',
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
}
