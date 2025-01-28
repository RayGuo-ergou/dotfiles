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

--- @class ergou.util.snippet
local M = {}
-- luasnip.lua

local function filename_dependent_snippet()
  return s(
    'fnf',
    fmt(
      [[
export function {}({}) {{
  {}
}}
]],
      {
        f(function()
          local filename = vim.fn.expand('%:t:r')
          if filename == 'index' then
            return vim.fn.expand('%:p:h:t')
          else
            return filename or 'defaultFunction'
          end
        end),
        i(1, 'args'),
        i(0),
      }
    )
  )
end

local function javascript()
  ls.add_snippets('javascript', {
    s('clg', {
      t('console.log('),
      i(0),
      t(')'),
    }),
    filename_dependent_snippet(),
  })
end

local function typescript()
  ---@see doc https://pinia.vuejs.org/cookbook/vscode-snippets.html#VS-Code-Snippets
  ls.add_snippets('typescript', {
    s(
      'pinia-setup',
      fmt(
        [[
import {{ defineStore, acceptHMRUpdate }} from 'pinia'

export const use{}Store = defineStore('{}', () => {{
  {}
  return {{}}
}})

if (import.meta.hot) {{
  import.meta.hot.accept(acceptHMRUpdate(use{}Store, import.meta.hot))
}}
]],
        {
          i(1, 'Store'),
          i(2, 'store'),
          i(3),
          rep(1),
        }
      )
    ),
  })
end

local function vue()
  ls.add_snippets('vue', {
    s(
      'vc',
      fmt(
        [[
<script setup lang="ts">
  {}
</script>

<template>
  <div>{}</div>
</template>
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
  ls.filetype_extend('javascript', { 'jsdoc' })
  ls.filetype_extend('typescript', { 'javascript', 'tsdoc' })
  ls.filetype_extend('vue', { 'javascript' })
  ls.filetype_extend('php', { 'javascript', 'html' })

  javascript()
  vue()
  typescript()
end

return M
