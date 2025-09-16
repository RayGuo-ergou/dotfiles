return {
  'folke/todo-comments.nvim',
  event = 'LazyFile',
  cmd = { 'TodoTrouble', 'TodoTelescope' },
  config = function(_, opts)
    local todo = require('todo-comments')
    local todo_repeat = ergou.repeatable_move.create_repeatable_move(function(move_opts)
      if move_opts.forward then
        todo.jump_next()
      else
        todo.jump_prev()
      end
    end)
    local map = vim.keymap.set

    map('n', ']t', function()
      todo_repeat({ forward = true })
    end, { desc = 'Next todo comment' })
    map('n', '[t', function()
      todo_repeat({ forward = false })
    end, { desc = 'Previous todo comment' })
    require('todo-comments').setup(opts)
  end,
  keys = {
    { ']t', desc = 'Next todo comment' },
    { '[t', desc = 'Previous todo comment' },
  },
}
