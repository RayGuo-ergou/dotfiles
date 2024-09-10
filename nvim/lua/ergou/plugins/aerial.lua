return {
  'stevearc/aerial.nvim',
  opts = {
    lsp = {
      priority = {
        volar = 11,
      },
    },
  },
  config = function(_, opts)
    local aerial = require('aerial')
    -- local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')
    -- local aerial_forward, aerial_backward = ts_repeat_move.make_repeatable_move_pair(aerial.next, aerial.prev)
    aerial.setup(opts)
    -- vim.keymap.set('n', ']]', aerial_forward)
    -- vim.keymap.set('n', '[[', aerial_backward)
  end,
  keys = {
    {
      '<leader>ua',
      '<cmd>AerialToggle!<CR>',
      desc = 'Toggle Aerial',
    },
    -- {
    --   '[[',
    --   desc = 'Previous Aerial',
    -- },
    -- {
    --   ']]',
    --   desc = 'Next Aerial',
    -- },
  },
}
