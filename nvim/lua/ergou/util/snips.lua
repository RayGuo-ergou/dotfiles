--- @class ergou.util.snips
local M = {}
-- luasnip.lua

function M.setupSnips()
  local ls = require('luasnip')
  local s = ls.snippet
  local t = ls.text_node
  local i = ls.insert_node
  local extras = require('luasnip.extras')
  local rep = extras.rep
  local fmt = require('luasnip.extras.fmt').fmt
  local c = ls.choice_node
  local f = ls.function_node
  local d = ls.dynamic_node
  local sn = ls.snippet_node
  ls.filetype_extend('vue', { 'javascript' })
  ls.filetype_extend('typescript', { 'javascript' })
  ls.filetype_extend('php', { 'javascript', 'html' })

  ls.add_snippets('javascript', {
    s('clg', {
      t('console.log('),
      i(1),
      t(')'),
    }),
  })
end

return M
