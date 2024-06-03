return {
  'folke/todo-comments.nvim',
  cmd = { 'TodoTrouble', 'TodoTelescope' },
  event = 'LazyFile',
  config = true,
  keys = function()
    local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')
    local todo = require('todo-comments')
    local todo_prev, todo_next = ts_repeat_move.make_repeatable_move_pair(todo.jump_prev, todo.jump_next)
    return {
      {
        ']t',
        function()
          todo_next()
        end,
        desc = 'Next todo comment',
      },
      {
        '[t',
        function()
          todo_prev()
        end,
        desc = 'Previous todo comment',
      },
      { '<leader>st', '<cmd>TodoTelescope<cr>', desc = 'Todo' },
      { '<leader>sT', '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>', desc = 'Todo/Fix/Fixme' },
    }
  end,
}
