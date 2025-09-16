return {
  {
    'folke/trouble.nvim',
    config = function(_, opts)
      local map = vim.keymap.set
      local trouble_next = function()
        if require('trouble').is_open() then
          ---@diagnostic disable-next-line: missing-fields, missing-parameter
          require('trouble').next({ jump = true })
        else
          local ok, err = pcall(vim.cmd.cnext)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end

      local trouble_prev = function()
        if require('trouble').is_open() then
          ---@diagnostic disable-next-line: missing-fields, missing-parameter
          require('trouble').prev({ jump = true })
        else
          local ok, err = pcall(vim.cmd.cprev)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end
      local trouble_forward, trouble_backward = ergou.repeatable_move.create_repeatable_move_pair(trouble_next, trouble_prev)

      map('n', '[q', trouble_backward, { desc = 'Previous trouble/quickfix item' })
      map('n', ']q', trouble_forward, { desc = 'Next trouble/quickfix item' })

      require('trouble').setup(opts)
    end,
    keys = {
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>xQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
      { '<leader>xt', '<cmd>Trouble todo toggle<cr>', desc = 'Todo (Trouble)' },
      { '<leader>xT', '<cmd>Trouble todo toggle keywords=TODO,FIX,FIXME<cr>', desc = 'Todo/Fix/Fixme (Trouble)' },
      {
        '[q',
        desc = 'Previous quickfix item',
      },
      {
        ']q',
        desc = 'Next quickfix item',
      },
    },
    opts = {}, -- for default options, refer to the configuration section for custom setup.
  },
}
