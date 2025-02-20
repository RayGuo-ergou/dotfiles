return {
  {
    'y3owk1n/undo-glow.nvim',
    ---@param _ any
    ---@param opts UndoGlow.Config
    opts = function(_, opts)
      local has_catppuccin, catppuccin = pcall(require, 'catppuccin.palettes')

      if has_catppuccin then
        ---@type CtpColors<string>
        local colors = catppuccin.get_palette()
        opts.undo_hl_color = { bg = colors.surface2 }
        opts.redo_hl_color = { bg = colors.surface2 }
      end
      opts.animation = false
    end,
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
