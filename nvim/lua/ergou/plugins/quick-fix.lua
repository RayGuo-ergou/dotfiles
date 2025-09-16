return {
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    opts = {
      preview = {
        winblend = 0,
      },
    },
  },
  {
    'stevearc/qf_helper.nvim',
    ft = 'qf',
    opts = {
      quickfix = {
        default_bindings = false,
      },
      loclist = {
        default_bindings = false,
      },
    },
    config = function(_, opts)
      local map = vim.keymap.set
      local repeatable_move = require('ergou.util.repeatable_move')

      local qf_next = function()
        vim.cmd([[QNext]])
      end

      local qf_prev = function()
        vim.cmd([[QPrev]])
      end
      local qf_forward, qf_backward = repeatable_move.create_repeatable_move_pair(qf_next, qf_prev)

      map('n', '[Q', qf_backward, { desc = 'Previous quickfix item' })
      map('n', ']Q', qf_forward, { desc = 'Next quickfix item' })

      require('qf_helper').setup(opts)
    end,
    keys = {
      {
        '[Q',
        desc = 'Previous quickfix item',
      },
      {
        ']Q',
        desc = 'Next quickfix item',
      },
    },
  },
}
