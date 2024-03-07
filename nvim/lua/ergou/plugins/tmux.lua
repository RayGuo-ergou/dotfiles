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
      { '<C-j>', mode = { 'n', 'i' }, '<cmd>lua require("tmux").move_bottom()<cr>' },
      { '<C-l>', mode = { 'n', 'i' }, '<cmd>lua require("tmux").move_right()<cr>' },
      { '<C-h>', mode = { 'n', 'i' }, '<cmd>lua require("tmux").move_left()<cr>' },
      { '<C-k>', mode = { 'n', 'i' }, '<cmd>lua require("tmux").move_top()<cr>' },
      { '<C-down>', mode = { 'n', 'i' }, '<cmd>lua require("tmux").resize_bottom()<cr>' },
      { '<C-up>', mode = { 'n', 'i' }, '<cmd>lua require("tmux").resize_top()<cr>' },
      { '<C-right>', mode = { 'n', 'i' }, '<cmd>lua require("tmux").resize_right()<cr>' },
      { '<C-left>', mode = { 'n', 'i' }, '<cmd>lua require("tmux").resize_left()<cr>' },
    },
  },
}
