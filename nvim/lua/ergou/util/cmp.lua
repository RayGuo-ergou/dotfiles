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
    symbol_map = { Npm = ergou.icons.others.npm },
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

M.json_filename = ''

function M.cmp_sort()
  local types = require('cmp.types')
  local cmp = require('cmp')
  local compare = require('cmp.config.compare')
  local default_config = require('cmp.config.default')
  -- Take from, Thank you!
  ---@see https://github.com/pysan3/dotfiles/blob/9d3ca30baecefaa2a6453d8d6d448d62b5614ff2/nvim/lua/plugins/70-nvim-cmp.lua
  ---@type table<integer, integer>
  local modified_priority = {
    [types.lsp.CompletionItemKind.Variable] = types.lsp.CompletionItemKind.Method,
    [types.lsp.CompletionItemKind.Text] = 100, -- bottom
  }
  local function modified_kind(kind)
    return modified_priority[kind] or kind
  end

  ---@param entry1 cmp.Entry
  ---@param entry2 cmp.Entry
  local function custom_kind(entry1, entry2) -- sort by compare kind (Variable, Function etc)
    local kind1 = modified_kind(entry1:get_kind())
    local kind2 = modified_kind(entry2:get_kind())
    if kind1 ~= kind2 then
      return kind1 - kind2 < 0
    end
  end

  local i = 1

  ---@param entry1 cmp.Entry
  ---@param entry2 cmp.Entry
  local function package_json_npm(entry1, entry2)
    local filetype = vim.bo.filetype
    if filetype ~= 'json' then
      return nil
    end

    if M.json_filename == '' then
      M.json_filename = vim.fn.expand('%:t')
    end

    if M.json_filename == 'package.json' then
      local source1 = entry1.source.name
      local source2 = entry2.source.name

      -- make source npm has higher priority
      if source1 == 'npm' and source2 ~= 'npm' then
        return true
      end

      if source1 ~= 'npm' and source2 == 'npm' then
        return false
      end

      -- if both source are npm, sort by version
      if source1 == 'npm' and source2 == 'npm' then
        local label1 = entry1.completion_item.label
        local label2 = entry2.completion_item.label
        local major1, minor1, patch1 = string.match(label1, '(%d+)%.(%d+)%.(%d+)')
        local major2, minor2, patch2 = string.match(label2, '(%d+)%.(%d+)%.(%d+)')
        if major1 ~= major2 then
          return tonumber(major1) > tonumber(major2)
        end
        if minor1 ~= minor2 then
          return tonumber(minor1) > tonumber(minor2)
        end
        if patch1 ~= patch2 then
          return tonumber(patch1) > tonumber(patch2)
        end
      end
    end

    return nil
  end

  return {
    priority_weight = default_config().sorting.priority_weight,
    comparators = {
      package_json_npm,
      compare.offset,
      compare.exact,
      -- custom_kind,
      -- compare.scopes,
      compare.score,
      compare.recently_used,
      compare.locality,
      compare.kind,
      compare.sort_text,
      compare.length,
      compare.order,
    },
  }
end

-- Function to check if the cursor is inside a start tag
-- Can be a global function? bue need refactoring for sure
local function is_in_start_tag()
  local ts_utils = require('nvim-treesitter.ts_utils')
  local node = ts_utils.get_node_at_cursor()
  if not node then
    return false
  end
  return node:type() == 'start_tag'
end

---@param entry cmp.Entry
---@param ctx cmp.Context
---For vue mostly
function M.cmp_lsp_entry_filter(entry, ctx)
  local types = require('cmp.types')
  -- Check if the buffer type is 'vue'
  if ctx.filetype ~= 'vue' then
    return true
  end

  -- Use a buffer-local variable to cache the result of the Treesitter check
  local bufnr = ctx.bufnr
  local cached_is_in_start_tag = vim.b[bufnr]._vue_ts_cached_is_in_start_tag
  if cached_is_in_start_tag == nil then
    vim.b[bufnr]._vue_ts_cached_is_in_start_tag = is_in_start_tag()
  end
  -- If not in start tag, return true
  if vim.b[bufnr]._vue_ts_cached_is_in_start_tag == false then
    return true
  end

  local cursor_before_line = ctx.cursor_before_line
  if cursor_before_line:sub(-1) == '@' then
    return entry.completion_item.label:match('^@')
  elseif cursor_before_line:sub(-1) == ':' then
    return entry.completion_item.label:match('^:') and not entry.completion_item.label:match('^:on-')
  -- For slot
  elseif cursor_before_line:sub(-1) == '#' then
    return entry.completion_item.kind == types.lsp.CompletionItemKind.Method
  else
    return true
  end
end

function M.visible()
  ---@module 'cmp'
  local cmp = package.loaded['cmp']
  return cmp and cmp.core.view:visible()
end

return M
