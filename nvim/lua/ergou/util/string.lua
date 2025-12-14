---@class ergou.util.string
local M = {}

M.first_to_upper = function(str)
  return (str:gsub('^%l', string.upper))
end

M.str_split = function(inputstr, sep)
  if sep == nil then
    sep = '%s'
  end
  local t = {}
  for str in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
    table.insert(t, str)
  end
  return t
end

return M
