return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  ---@type wk.Opts
  opts = {
    plugins = { spelling = true },
    defaults = {},
    ---@type wk.Spec
    spec = {
      {
        mode = { 'n', 'v' },
        -- Icons build in
        { '<leader><tab>', group = 'tabs' },
        { '<leader>b', group = 'buffer' },
        { '<leader>c', group = 'code' },
        { '<leader>d', group = 'debug' },
        { '<leader>f', group = 'file/find' },
        { '<leader>g', group = 'git' },
        { '<leader>gh', group = 'hunks' },
        { '<leader>q', group = 'quit/session' },
        { '<leader>s', group = 'search' },
        { '<leader>n', group = 'noice' },
        { '<leader>t', group = 'toggle' },
        { '<leader>u', group = 'ui' },
        { '<leader>w', group = 'windows' },
        { '<leader>x', group = 'diagnostics/quickfix' },
        { '[', group = 'prev' },
        { ']', group = 'next' },
        { 'g', group = 'goto' },
        { 'gx', desc = 'Open with system app' },
        { 'z', group = 'fold' },

        -- No icon
        { '<leader>r', group = 'rename/replace', icon = { icon = '󰬲 ', color = 'purple' } },
      },
    },
  },
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show({ global = false })
      end,
      desc = 'Buffer Local Keymaps (which-key)',
    },
  },
  config = function(_, opts)
    local wk = require('which-key')
    wk.setup(opts)
  end,
}
