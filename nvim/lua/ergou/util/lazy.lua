--- @class ergou.util.lazy
local M = {}

M.lazy_file_events = { 'BufReadPost', 'BufNewFile', 'BufWritePre' } -- Properly load file based plugins without blocking the UI

---@see https://github.com/LazyVim/LazyVim/blob/6ba62855e24861d0187556af601ed81643aef7c2/lua/lazyvim/util/plugin.lua#L58-L89
function M.lazy_file()
  -- This autocmd will only trigger when a file was loaded from the cmdline.
  -- It will render the file as quickly as possible.
  vim.api.nvim_create_autocmd('BufReadPost', {
    once = true,
    callback = function(event)
      -- Skip if we already entered vim
      if vim.v.vim_did_enter == 1 then
        return
      end

      -- Try to guess the filetype (may change later on during Neovim startup)
      local ft = vim.filetype.match({ buf = event.buf })
      if ft then
        -- Add treesitter highlights and fallback to syntax
        local lang = vim.treesitter.language.get_lang(ft)
        if not (lang and pcall(vim.treesitter.start, event.buf, lang)) then
          vim.bo[event.buf].syntax = ft
        end

        -- Trigger early redraw
        vim.cmd([[redraw]])
      end
    end,
  })

  -- Add support for the LazyFile event
  local Event = require('lazy.core.handler.event')

  Event.mappings.LazyFile = { id = 'LazyFile', event = M.lazy_file_events }
  Event.mappings['User LazyFile'] = Event.mappings.LazyFile
end

return M
