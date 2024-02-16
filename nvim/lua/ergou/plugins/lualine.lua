return {
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        theme = 'catppuccin',
      },
      sections = {
        lualine_x = {
          {
            'rest',
            icon = '',
            fg = '#428890',
          },
          {
            'copilot',
          },
        },
      },
    },
  },
}
