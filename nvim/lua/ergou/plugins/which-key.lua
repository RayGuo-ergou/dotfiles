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
      ['<leader>b'] = { name = '+[B]uffer' },
      ['<leader>f'] = { name = '+[F]ile/find' },
      ['<leader>q'] = { name = '+[Q]uit/session' },
      ['<leader>s'] = { name = '+[S]earch' },
      ['<leader>u'] = { name = '+[U]i' },
      ['<leader>x'] = { name = '+diagnostics/quickfix' },
    },
  },
  config = function(_, opts)
    local wk = require('which-key')
    wk.setup(opts)
    wk.register(opts.defaults)
  end,
}
