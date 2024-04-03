return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    plugins = { spelling = true },
    defaults = {
      mode = { 'n', 'v' },
      ['g'] = { name = '+goto' },
      ['z'] = { name = '+fold' },
      [']'] = { name = '+next' },
      ['['] = { name = '+prev' },
      ['<leader><tab>'] = { name = '+tabs' },
      ['<leader>b'] = { name = '+Buffer' },
      ['<leader>c'] = { name = '+Code' },
      ['<leader>d'] = { name = '+Debug/Diff' },
      ['<leader>f'] = { name = '+File/find' },
      ['<leader>q'] = { name = '+Quit/session' },
      ['<leader>s'] = { name = '+Search' },
      ['<leader>u'] = { name = '+Ui' },
      ['<leader>t'] = { name = '+Toggle' },
      ['<leader>x'] = { name = '+Diagnostics/Quickfix' },
      ['<leader>g'] = { name = '+Git' },
      ['<leader>gh'] = { name = '+Git Hunk' },
      ['<leader>r'] = { name = '+Rename/Replace' },
      ['<leader>w'] = { name = '+Window' },
      ['<leader>n'] = { name = '+Npm' },
    },
    triggers_blacklist = {
      n = { 'd', 'y' },
    },
  },
  config = function(_, opts)
    local wk = require('which-key')
    wk.setup(opts)
    wk.register(opts.defaults)
  end,
}
