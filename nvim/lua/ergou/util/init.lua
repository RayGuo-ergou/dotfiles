local LazyUtil = require('lazy.core.util')

local M = {}

setmetatable(M, {
  __index = function(t, k)
    if LazyUtil[k] then
      return LazyUtil[k]
    end
    ---@diagnostic disable-next-line: no-unknown
    t[k] = require('ergou.util.' .. k)
    return t[k]
  end,
})

return M
