return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    plugins = { spelling = true },
    defaults = {
      mode = { 'n', 'v' },
      ['g'] = { name = '+goto' },
      [']'] = { name = '+next' },
      ['['] = { name = '+prev' },
      ['<leader><tab>'] = { name = '+tabs' },
      ['<leader>b'] = { name = '+Buffer' },
      ['<leader>f'] = { name = '+File/find' },
      ['<leader>q'] = { name = '+Quit/session' },
      ['<leader>s'] = { name = '+Search' },
      ['<leader>u'] = { name = '+Ui' },
      ['<leader>x'] = { name = '+Diagnostics/Quickfix' },
      ['<leader>c'] = { name = '+Code' },
      ['<leader>d'] = { name = '+Document/Diff' },
      ['<leader>g'] = { name = '+Git' },
      ['<leader>gh'] = { name = '+Git Hunk' },
      ['<leader>r'] = { name = '+Rename/Replace' },
      ['<leader>w'] = { name = '+Window' },
      ['<leader>m'] = { name = '+mini.nvim' },
    },
  },
  config = function(_, opts)
    local wk = require('which-key')
    wk.setup(opts)
    wk.register(opts.defaults)
  end,
}
