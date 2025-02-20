return {
  {
    'y3owk1n/undo-glow.nvim',
    ---@class UndoGlow.Config
    opts = {
      animation = false,
    },
    ---@param _ any
    ---@param opts UndoGlow.Config
    config = function(_, opts)
      local undo_glow = require('undo-glow')

      undo_glow.setup(opts)

      vim.keymap.set('n', 'u', undo_glow.undo, { noremap = true, silent = true })
      vim.keymap.set('n', '<c-r>', undo_glow.redo, { noremap = true, silent = true })
    end,
    keys = {
      { 'u', desc = 'Undo' },
      { '<c-r>', desc = 'Redo' },
    },
  },
}
