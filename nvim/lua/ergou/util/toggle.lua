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

function M.maximize()
  ---@type {k:string, v:any}[]?
  local maximized = nil
  local toggle = Snacks.toggle({
    name = 'Maximize',
    get = function()
      return maximized ~= nil
    end,
    set = function(state)
      if state then
        maximized = {}
        local function set(k, v)
          table.insert(maximized, 1, { k = k, v = vim.o[k] })
          vim.o[k] = v
        end
        set('winwidth', 999)
        set('winheight', 999)
        set('winminwidth', 10)
        set('winminheight', 4)
        vim.cmd('wincmd =')
      else
        for _, opt in ipairs(maximized) do
          vim.o[opt.k] = opt.v
        end
        maximized = nil
        vim.cmd('wincmd =')
      end
    end,
  })
  -- `QuitPre` seems to be executed even if we quit a normal window, so we don't want that
  -- `VimLeavePre` might be another consideration? Not sure about differences between the 2
  vim.api.nvim_create_autocmd('ExitPre', {
    group = vim.api.nvim_create_augroup('lazyvim_restore_max_exit_pre', { clear = true }),
    desc = 'Restore width/height when close Neovim while maximized',
    callback = function()
      if toggle:get() then
        toggle:set(false)
      end
    end,
  })
  return toggle
end

return M
