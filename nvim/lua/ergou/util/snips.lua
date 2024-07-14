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
