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

      local qf_next = function()
        vim.cmd([[QNext]])
      end

      local qf_prev = function()
        vim.cmd([[QPrev]])
      end
      local qf_repeat = ergou.repeatable_move.create_repeatable_move(function(opts)
        if opts.forward then
          qf_next()
        else
          qf_prev()
        end
      end)

      map('n', '[Q', function() qf_repeat({ forward = false }) end, { desc = 'Previous quickfix item' })
      map('n', ']Q', function() qf_repeat({ forward = true }) end, { desc = 'Next quickfix item' })

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
