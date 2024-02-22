local icons = require('ergou.util.icons')

local M = {}

M.diagnostics_symbol = function(count, level, diagnostics_dict, context)
  local s = ' '
  for e, n in pairs(diagnostics_dict) do
    local sym = e == 'error' and icons.signs.Error or (e == 'warning' and icons.signs.Warn or icons.signs.Info)
    s = s .. n .. sym
  end
  return s
end
return M
