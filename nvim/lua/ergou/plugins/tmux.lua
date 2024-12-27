return {
  {
    'aserowy/tmux.nvim',
    opts = {
      copy_sync = {
        enable = false,
      },
      -- Disable default key bindings
      -- So can lazy load with keys
      resize = {
        enable_default_keybindings = false,
      },
      navigation = {
        enable_default_keybindings = false,
      },
    },
    keys = {
      {
        '<C-j>',
        mode = { 'n', 'i', 'x' },
        function()
          require('tmux').move_bottom()
        end,
      },
      {
        '<C-l>',
        mode = { 'n', 'i', 'x' },
        function()
          require('tmux').move_right()
        end,
      },
      {
        '<C-h>',
        mode = { 'n', 'i', 'x' },
        function()
          require('tmux').move_left()
        end,
      },
      {
        '<C-k>',
        mode = { 'n', 'i', 'x' },
        function()
          require('tmux').move_top()
        end,
      },
      {
        '<C-down>',
        mode = { 'n', 'i', 'x' },
        function()
          require('tmux').resize_bottom()
        end,
      },
      {
        '<C-up>',
        mode = { 'n', 'i', 'x' },
        function()
          require('tmux').resize_top()
        end,
      },
      {
        '<C-right>',
        mode = { 'n', 'i', 'x' },
        function()
          require('tmux').resize_right()
        end,
      },
      {
        '<C-left>',
        mode = { 'n', 'i', 'x' },
        function()
          require('tmux').resize_left()
        end,
      },
    },
  },
}
