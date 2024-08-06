return {
  'folke/todo-comments.nvim',
  cmd = { 'TodoTrouble', 'TodoTelescope' },
  event = 'LazyFile',
  config = true,
  keys = function()
    local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')
    local todo = require('todo-comments')
    local todo_next, todo_prev = ts_repeat_move.make_repeatable_move_pair(todo.jump_next, todo.jump_prev)
    local Util = require('ergou.util')

    local picker_keys = function()
      if Util.pick.picker.name == 'telescope' then
        return {
          { '<leader>st', '<cmd>TodoTelescope<cr>', desc = 'Todo' },
          { '<leader>sT', '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>', desc = 'Todo/Fix/Fixme' },
        }
      end
      if Util.pick.picker.name == 'fzf' then
        return {
          {
            '<leader>st',
            function()
              require('todo-comments.fzf').todo()
            end,
            desc = 'Todo',
          },
          {
            '<leader>sT',
            function()
              require('todo-comments.fzf').todo({ keywords = { 'TODO', 'FIX', 'FIXME' } })
            end,
            desc = 'Todo/Fix/Fixme',
          },
        }
      end

      return {}
    end

    return vim.list_extend(picker_keys(), {
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
    })
  end,
}
