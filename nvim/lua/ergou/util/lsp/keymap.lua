---@class ergou.util.lsp.keymap
local M = setmetatable({}, {
  __call = function(t, ...)
    return t.setup(...)
  end,
})
---@type LazyKeys[]|nil
M._keys = nil

---@see https://github.com/LazyVim/LazyVim/blob/45d94b3197eaf3f35754b8ecb7adebfcebe5160d/lua/lazyvim/plugins/lsp/keymaps.lua#L16
---@return LazyKeys[]
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
    {
      '<leader>cl',
      function()
        Snacks.picker.lsp_config()
      end,
      desc = 'Lsp Info',
    },
  }

  M._keys = keys
  return M._keys
end

---@param bufnr integer
M.setup = function(bufnr)
  local nmap = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
  end

  local keys = M.get()
  if keys == nil then
    return
  end
  for _, key in ipairs(keys) do
    nmap(key[1], key[2], key.desc)
  end
end

return M
