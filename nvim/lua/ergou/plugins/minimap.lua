return {
  {
    'gorbit99/codewindow.nvim',
    url = 'https://github.com/RayGuo-ergou/codewindow.nvim',
    keys = {
      {
        '<leader>tm',
        function()
          require('codewindow').toggle_minimap()
        end,
        desc = 'Toggle minimap',
      },
    },
    opts = {
      auto_enable = false,
      minimap_width = 20,
      width_multiplier = 2,
      screen_bounds = 'background',
      window_border = 'none',
      relative = 'win',
      exclude_filetypes = {
        'dashboard',
        'neo-tree',
        'lazy',
        'lazyterm',
        'mason',
        'help',
        'checkhealth',
        'lspinfo',
        'noice',
        'Trouble',
        'fish',
        'zsh',
      },
    },
  },
}
