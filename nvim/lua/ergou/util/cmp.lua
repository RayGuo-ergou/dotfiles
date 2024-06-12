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

function M.cmp_sort()
  local types = require('cmp.types')
  local cmp = require('cmp')
  local default_config = require('cmp.config.default')
  -- Take from, Thank you!
  ---@see https://github.com/pysan3/dotfiles/blob/9d3ca30baecefaa2a6453d8d6d448d62b5614ff2/nvim/lua/plugins/70-nvim-cmp.lua
  ---@type table<integer, integer>
  local modified_priority = {
    [types.lsp.CompletionItemKind.Variable] = types.lsp.CompletionItemKind.Method,
    [types.lsp.CompletionItemKind.Function] = 0, -- top
    [types.lsp.CompletionItemKind.Keyword] = 0, -- top
    [types.lsp.CompletionItemKind.Text] = 100, -- bottom
  }
  local function modified_kind(kind)
    return modified_priority[kind] or kind
  end
  local function custom_kind(entry1, entry2) -- sort by compare kind (Variable, Function etc)
    local kind1 = modified_kind(entry1:get_kind())
    local kind2 = modified_kind(entry2:get_kind())
    if kind1 ~= kind2 then
      return kind1 - kind2 < 0
    end
  end

  return {
    priority_weight = default_config().sorting.priority_weight,
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.sort_text,
      -- cmp.config.compare.scopes,
      cmp.score,
      cmp.recently_used,
      cmp.locality,
      cmp.kind,
      cmp.length,
      cmp.order,
    },
  }
end

---@param entry cmp.Entry
---@param ctx cmp.Context
---For vue mostly
function M.cmp_lsp_entry_filter(entry, ctx)
  -- Check if the buffer type is 'vue'
  local filetype = vim.bo.filetype
  if filetype ~= 'vue' then
    return true
  end

  local cursor_before_line = ctx.cursor_before_line
  if cursor_before_line:sub(-1) == '@' then
    return entry.completion_item.label:match('^@')
  elseif cursor_before_line:sub(-1) == ':' then
    return entry.completion_item.label:match('^:') and not entry.completion_item.label:match('^:on-')
  else
    return true
  end
end

return M
