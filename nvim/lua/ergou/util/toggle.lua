---@class ergou.util.toggle
local M = {}

M.quickfix = function()
  return Snacks.toggle({
    name = 'Quick Fix',
    get = function()
      for _, win in pairs(vim.fn.getwininfo()) do
        if win['quickfix'] == 1 then
          return true
        end
      end
      return false
    end,
    set = function(state)
      if state then
        vim.cmd('copen')
      else
        vim.cmd('cclose')
      end
    end,
  })
end

M.inlay_hints = function()
  return Snacks.toggle.inlay_hints()
end

M.wrap = function()
  return Snacks.toggle.option('wrap', { name = 'Wrap' })
end

M.diagnostics = function()
  return Snacks.toggle.diagnostics()
end

M.treesitter = function()
  return Snacks.toggle.treesitter()
end

M.spelling = function()
  return Snacks.toggle.option('spell', { name = 'Spelling' })
end

M.zen = function()
  return Snacks.toggle.zen()
end

M.zoom = function()
  return Snacks.toggle.zoom()
end

return M
