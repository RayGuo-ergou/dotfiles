local ls = require('luasnip')
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require('luasnip.util.events')
local ai = require('luasnip.nodes.absolute_indexer')
local extras = require('luasnip.extras')
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local conds = require('luasnip.extras.expand_conditions')
local postfix = require('luasnip.extras.postfix').postfix
local types = require('luasnip.util.types')
local parse = require('luasnip.util.parser').parse_snippet
local ms = ls.multi_snippet
local k = require('luasnip.nodes.key_indexer').new_key

--- @class ergou.util.snips
local M = {}
-- luasnip.lua

local function javascript()
  ls.add_snippets('javascript', {
    s('clg', {
      t('console.log('),
      i(0),
      t(')'),
    }),
  })
end

local function vue()
  ls.add_snippets('vue', {
    s(
      'vc',
      fmt(
        [[
<template>
  <div>{}</div>
</template>

<script setup lang="ts">
  {}
</script>
]],
        {
          i(1),
          i(0),
        }
      )
    ),
  })
end

function M.setup_snipes()
  ls.filetype_extend('vue', { 'javascript' })
  ls.filetype_extend('typescript', { 'javascript' })
  ls.filetype_extend('php', { 'javascript', 'html' })

  javascript()
  vue()
end

return M
