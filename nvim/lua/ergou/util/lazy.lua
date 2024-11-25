--- @class ergou.util.lazy
local M = {}

M.lazy_file_events = { 'BufReadPost', 'BufNewFile', 'BufWritePre' } -- Properly load file based plugins without blocking the UI

---@see https://github.com/LazyVim/LazyVim/blob/eb525c680d0423f5addb12e10f87ce5b81fc0d9e/lua/lazyvim/util/plugin.lua#L73-L79
function M.lazy_file()
  -- Add support for the LazyFile event
  local Event = require('lazy.core.handler.event')

  Event.mappings.LazyFile = { id = 'LazyFile', event = M.lazy_file_events }
  Event.mappings['User LazyFile'] = Event.mappings.LazyFile
end

return M
