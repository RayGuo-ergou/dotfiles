---@class ergou.util.lsp
---@field public typescript ergou.util.lsp.typescript
---@field public php ergou.util.lsp.php
---@field public eslint ergou.util.lsp.eslint
---@field public cspell ergou.util.lsp.cspell
---@field public tsformat ergou.util.lsp.tsformat
---@field public keymap ergou.util.lsp.keymap
---@field public servers ergou.util.lsp.servers
---@field public query ergou.util.lsp.query
local M = {}

---@class LspClientFilterOpts: vim.lsp.get_clients.Filter
---@field public filter fun(client: vim.lsp.Client):boolean

setmetatable(M, {
  __index = function(t, k)
    ---@diagnostic disable-next-line: no-unknown
    t[k] = require('ergou.util.lsp.' .. k)
    return t[k]
  end,
})

M.action = setmetatable({}, {
  __index = function(_, action)
    return function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { action },
          diagnostics = {},
        },
      })
    end
  end,
})

---@param opts? LspClientFilterOpts
function M.get_clients(opts)
  local ret = vim.lsp.get_clients(opts)
  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

function M.setup()
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
      local bufnr = event.buf
      local client = vim.lsp.get_client_by_id(event.data.client_id)

      ergou.lsp.keymap(bufnr)

      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
      end, { desc = 'Format current buffer with LSP' })

      if not client then
        return
      end

      local client_name = client.name
      local file_type = vim.bo[bufnr].filetype
      if
        not (file_type == 'vue' and vim.list_contains(M.typescript.servers, client_name))
        and client:supports_method('textDocument/documentSymbol')
      then
        require('nvim-navic').attach(client, bufnr)
      end

      if client:supports_method('textDocument/inlayHint') and vim.g.auto_inlay_hint then
        vim.lsp.inlay_hint.enable()
      end
    end,
  })
end

return M
