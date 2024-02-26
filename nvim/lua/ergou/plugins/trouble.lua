return {
  'folke/trouble.nvim',
  cmd = { 'TroubleToggle', 'Trouble' },
  opts = { use_diagnostic_signs = true },
  keys = function()
    local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')
    local trouble_next = function()
      if require('trouble').is_open() then
        require('trouble').previous({ skip_groups = true, jump = true })
      else
        local ok, err = pcall(vim.cmd.cprev)
        if not ok then
          vim.notify(err, vim.log.levels.ERROR)
        end
      end
    end

    local trouble_prev = function()
      if require('trouble').is_open() then
        require('trouble').next({ skip_groups = true, jump = true })
      else
        local ok, err = pcall(vim.cmd.cnext)
        if not ok then
          vim.notify(err, vim.log.levels.ERROR)
        end
      end
    end
    local trouble_forward, trouble_backward = ts_repeat_move.make_repeatable_move_pair(trouble_next, trouble_prev)
    return {
      { '<leader>xx', '<cmd>TroubleToggle document_diagnostics<cr>', desc = 'Document Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>TroubleToggle workspace_diagnostics<cr>', desc = 'Workspace Diagnostics (Trouble)' },
      { '<leader>xL', '<cmd>TroubleToggle loclist<cr>', desc = 'Location List (Trouble)' },
      { '<leader>xQ', '<cmd>TroubleToggle quickfix<cr>', desc = 'Quickfix List (Trouble)' },
      {
        '[q',
        trouble_forward,
        desc = 'Previous trouble/quickfix item',
      },
      {
        ']q',
        trouble_backward,
        desc = 'Next trouble/quickfix item',
      },
    }
  end,
}
