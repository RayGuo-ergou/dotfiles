--- @see lazyvim https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/cmp.lua
--- @class ergou.util.cmp
local M = {}

---@param entry cmp.Entry
function M.auto_brackets(entry)
  local cmp = require('cmp')
  local Kind = cmp.lsp.CompletionItemKind
  local item = entry:get_completion_item()
  if vim.tbl_contains({ Kind.Function, Kind.Method }, item.kind) then
    local cursor = vim.api.nvim_win_get_cursor(0)
    local prev_char = vim.api.nvim_buf_get_text(0, cursor[1] - 1, cursor[2], cursor[1] - 1, cursor[2] + 1, {})[1]
    if prev_char ~= '(' and prev_char ~= ')' then
      local keys = vim.api.nvim_replace_termcodes('()<left>', false, false, true)
      vim.api.nvim_feedkeys(keys, 'i', true)
    end
  end
end

---@param snippet string
---@param fn fun(placeholder:Placeholder):string
---@return string
function M.snippet_replace(snippet, fn)
  return snippet:gsub('%$%b{}', function(m)
    local n, name = m:match('^%${(%d+):(.+)}$')
    return n and fn({ n = n, text = name }) or m
  end) or snippet
end

-- This function resolves nested placeholders in a snippet.
function M.snippet_resolve(snippet)
  return M.snippet_replace(snippet, function(placeholder)
    return M.snippet_resolve(placeholder.text)
  end):gsub('%$0', '')
end

-- This function replaces nested placeholders in a snippet with LSP placeholders.
function M.snippet_fix(snippet)
  return M.snippet_replace(snippet, function(placeholder)
    return '${' .. placeholder.n .. ':' .. M.snippet_resolve(placeholder.text) .. '}'
  end)
end

-- This function adds missing documentation to snippets.
-- The documentation is a preview of the snippet.
---@param window cmp.CustomEntriesView|cmp.NativeEntriesView
function M.add_missing_snippet_docs(window)
  local cmp = require('cmp')
  local Kind = cmp.lsp.CompletionItemKind
  local entries = window:get_entries()
  for _, entry in ipairs(entries) do
    if entry:get_kind() == Kind.Snippet then
      local item = entry:get_completion_item()
      if not item.documentation and item.insertText then
        item.documentation = {
          kind = cmp.lsp.MarkupKind.Markdown,
          value = string.format('```%s\n%s\n```', vim.bo.filetype, M.snippet_resolve(item.insertText)),
        }
      end
    end
  end
end

function M.cmp_format(entry, vim_item)
  local lspkind = require('lspkind')
  local item_with_kind = lspkind.cmp_format({
    maxwidth = 50,
    ellipsis_char = '...',
    preset = 'codicons',
    show_labelDetails = true,
    menu = {
      buffer = '[Buffer]',
      nvim_lsp = '[LSP]',
      luasnip = '[LuaSnip]',
      nvim_lua = '[Lua]',
      latex_symbols = '[Latex]',
      calc = '[Calc]',
    },
  })(entry, vim_item)

  local completion_item = entry.completion_item
  local completion_context = completion_item.detail
    or completion_item.labelDetails and completion_item.labelDetails.description
    or nil
  if completion_context ~= nil and completion_context ~= '' then
    local truncated_context = string.sub(completion_context, 1, 30)
    if truncated_context ~= completion_context then
      truncated_context = truncated_context .. '...'
    end
    item_with_kind.menu = item_with_kind.menu .. ' ' .. truncated_context
  end
  return item_with_kind
end

return M
