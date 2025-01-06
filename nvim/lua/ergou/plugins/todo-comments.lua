return {
  'folke/todo-comments.nvim',
  event = 'LazyFile',
  cmd = { 'TodoTrouble', 'TodoTelescope' },
  config = function(_, opts)
    local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')
    local todo = require('todo-comments')
    local todo_next, todo_prev = ts_repeat_move.make_repeatable_move_pair(todo.jump_next, todo.jump_prev)
    local map = vim.keymap.set

    if ergou.pick.picker.name == 'telescope' then
      map('n', '<leader>st', '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>', { desc = 'Todo/Fix/Fixme' })
      map('n', '<leader>sT', '<cmd>TodoTelescope<cr>', { desc = 'Todo Comments' })
    end
    if ergou.pick.picker.name == 'fzf' then
      map('n', '<leader>st', function()
        require('todo-comments.fzf').todo({ keywords = { 'TODO', 'FIX', 'FIXME' } })
      end, { desc = 'Todo/Fix/Fixme' })
      map('n', '<leader>sT', function()
        require('todo-comments.fzf').todo()
      end, { desc = 'Todo Comments' })
    end
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
    { '<leader>st', 'Todo' },
    { '<leader>sT', 'Todo/Fix/FIxme' },
  },
}
