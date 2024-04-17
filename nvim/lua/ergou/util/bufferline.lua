local icons = require('ergou.util.icons')

--- @class ergou.util.bufferline
local M = {}

M.diagnostics_symbol = function(count, level, diagnostics_dict, context)
  local s = ' '
  for e, n in pairs(diagnostics_dict) do
    local sym = e == 'error' and icons.diagnostics.Error
      or (
        e == 'warning' and icons.diagnostics.Warn or (e == 'info' and icons.diagnostics.Info or icons.diagnostics.Hint)
      )
    s = s .. n .. sym
  end
  return s
end
return M
