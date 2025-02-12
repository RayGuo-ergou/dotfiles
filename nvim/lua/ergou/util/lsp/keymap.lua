---@class ergou.util.lsp.keymap
local M = setmetatable({}, {
  __call = function(t, ...)
    return t.setup(...)
  end,
})
---@type LazyKeys[]|nil
M._keys = nil

function M.get()
  if M._keys then
    return M._keys
  end

  local keys = {
    -- Base LSP keymaps that don't depend on picker
    { 'K', vim.lsp.buf.hover, desc = 'Hover Documentation' },
    { '<leader>k', vim.lsp.buf.signature_help, desc = 'Signature Documentation' },
    { 'grA', ergou.lsp.action.source, desc = 'Source Action' },
    { 'grD', vim.lsp.buf.declaration, desc = 'Goto Declaration' },
  }

  -- Add picker-specific keymaps
  local picker_keys = {
    telescope = {
      {
        'gd',
        function()
          require('telescope.builtin').lsp_definitions({ reuse_win = true })
        end,
        desc = 'Goto Definition',
      },
      { 'grr', require('telescope.builtin').lsp_references, desc = 'Goto References' },
      {
        'gI',
        function()
          require('telescope.builtin').lsp_implementations({ reuse_win = true })
        end,
        desc = 'Goto Implementation',
      },
      {
        'gy',
        function()
          require('telescope.builtin').lsp_type_definitions({ reuse_win = true })
        end,
        desc = 'Goto Type',
      },
    },
    fzf = {
      { 'gd', '<cmd>FzfLua lsp_definitions jump1=true ignore_current_line=true<cr>', desc = 'Goto Definition' },
      { 'grr', '<cmd>FzfLua lsp_references jump1=true ignore_current_line=true<cr>', desc = 'Goto References' },
      { 'gI', '<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>', desc = 'Goto Implementation' },
      { 'gy', '<cmd>FzfLua lsp_typedefs jump1=true ignore_current_line=true<cr>', desc = 'Goto Type' },
    },
    snacks = {
      {
        'gd',
        function()
          Snacks.picker.lsp_definitions()
        end,
        desc = 'Goto Definition',
      },
      {
        'grr',
        function()
          Snacks.picker.lsp_references()
        end,
        desc = 'References',
      },
      {
        'gI',
        function()
          Snacks.picker.lsp_implementations()
        end,
        desc = 'Goto Implementation',
      },
      {
        'gy',
        function()
          Snacks.picker.lsp_type_definitions()
        end,
        desc = 'Goto T[y]pe Definition',
      },
    },
  }

  -- Add picker-specific keys based on current picker
  if picker_keys[ergou.pick.picker.name] then
    vim.list_extend(keys, picker_keys[ergou.pick.picker.name])
  end

  M._keys = keys
  return M._keys
end

---@param bufnr integer
---TODO: @see https://github.com/LazyVim/LazyVim/blob/45d94b3197eaf3f35754b8ecb7adebfcebe5160d/lua/lazyvim/plugins/lsp/keymaps.lua#L16
M.setup = function(bufnr)
  local nmap = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
  end

  -- TODO: add these keys in picker file for better management
  local keys = M.get()
  if keys == nil then
    return
  end
  for _, key in ipairs(keys) do
    nmap(key[1], key[2], key.desc)
  end
end

return M
