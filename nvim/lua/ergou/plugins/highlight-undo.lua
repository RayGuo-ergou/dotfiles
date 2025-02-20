return {
  {
    'y3owk1n/undo-glow.nvim',
    url = 'https://github.com/RayGuo-ergou/undo-glow.nvim',
    ---@class UndoGlow.Config
    opts = {
      animation = false,
    },
    keys = {
      {
        'u',
        function()
          require('undo-glow').undo()
        end,
        desc = 'Undo',
      },
      {
        '<c-r>',
        function()
          require('undo-glow').redo()
        end,
        desc = 'Redo',
      },
    },
  },
}
