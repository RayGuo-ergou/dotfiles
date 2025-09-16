return {
  'folke/todo-comments.nvim',
  event = 'LazyFile',
  cmd = { 'TodoTrouble', 'TodoTelescope' },
  config = function(_, opts)
    local repeatable_move = require('ergou.util.repeatable_move')
    local todo = require('todo-comments')
    local todo_next, todo_prev = repeatable_move.create_repeatable_move_pair(todo.jump_next, todo.jump_prev)
    local map = vim.keymap.set

    map('n', ']t', function()
      todo_next()
    end, { desc = 'Next todo comment' })
    map('n', '[t', function()
      todo_prev()
    end, { desc = 'Previous todo comment' })
    require('todo-comments').setup(opts)
  end,
  keys = {
    { ']t', desc = 'Next todo comment' },
    { '[t', desc = 'Previous todo comment' },
  },
}
