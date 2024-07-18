return {
  {
    enabled = false,
    'mvllow/modes.nvim',
    opts = {
      set_cursor = false,
    },
  },
  {
    enabled = false,
    'svampkorg/moody.nvim',
    event = { 'ModeChanged', 'BufWinEnter', 'WinEnter' },
    dependencies = {
      'catppuccin/nvim',
    },
    opts = {},
  },
}
