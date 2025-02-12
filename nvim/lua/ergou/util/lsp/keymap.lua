---@class ergou.util.lsp.keymap
local M = setmetatable({}, {
  __call = function(t, ...)
    return t.setup(...)
  end,
})

---@param bufnr integer
M.setup = function(bufnr)
  local nmap = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
  end

  if ergou.pick.picker.name == 'telescope' then
    nmap('gd', function()
      require('telescope.builtin').lsp_definitions({ reuse_win = true })
    end, 'Goto Definition')
    nmap('grr', require('telescope.builtin').lsp_references, 'Goto References')
    nmap('gI', function()
      require('telescope.builtin').lsp_implementations({ reuse_win = true })
    end, 'Goto Implementation')
    nmap('gy', function()
      require('telescope.builtin').lsp_type_definitions({ reuse_win = true })
    end, 'Goto Type')
  elseif ergou.pick.picker.name == 'fzf' then
    nmap('gd', '<cmd>FzfLua lsp_definitions jump1=true ignore_current_line=true<cr>', 'Goto Definition')
    nmap('grr', '<cmd>FzfLua lsp_references jump1=true ignore_current_line=true<cr>', 'Goto References')
    nmap('gI', '<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>', 'Goto Implementation')
    nmap('gy', '<cmd>FzfLua lsp_typedefs jump1=true ignore_current_line=true<cr>', 'Goto Type')
  end
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<leader>k', vim.lsp.buf.signature_help, 'Signature Documentation')
  nmap('grA', ergou.lsp.action.source, 'Source Action')

  -- Lesser used LSP functionality
  nmap('grD', vim.lsp.buf.declaration, 'Goto Declaration')
end

return M
