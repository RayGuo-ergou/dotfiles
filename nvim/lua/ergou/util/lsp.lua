local M = {}

function M.get_clients(opts)
  local ret = {} ---@type lsp.Client[]
  if vim.lsp.get_clients then
    ret = vim.lsp.get_clients(opts)
  else
    ---@diagnostic disable-next-line: deprecated
    ret = vim.lsp.get_active_clients(opts)
    if opts and opts.method then
      ---@param client lsp.Client
      ret = vim.tbl_filter(function(client)
        return client.supports_method(opts.method, { bufnr = opts.bufnr })
      end, ret)
    end
  end
  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

---@param from string
---@param to string
---@from https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/lsp.lua
function M.on_rename(from, to)
  local clients = M.get_clients()
  for _, client in ipairs(clients) do
    if client.supports_method('workspace/willRenameFiles') then
      ---@diagnostic disable-next-line: invisible
      local resp = client.request_sync('workspace/willRenameFiles', {
        files = {
          {
            oldUri = vim.uri_from_fname(from),
            newUri = vim.uri_from_fname(to),
          },
        },
      }, 1000, 0)
      if resp and resp.result ~= nil then
        vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
      end
    end
  end
end

function M.lsp_autocmd()
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
      local bufnr = event.buf
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client then
        local client_name = client.name
        local file_type = vim.bo[bufnr].filetype
        if
          not (file_type == 'vue' and client_name == 'tsserver')
          and client.server_capabilities['documentSymbolProvider']
        then
          require('nvim-navic').attach(client, bufnr)
        end
      end

      local nmap = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
      end

      nmap('<leader>rn', vim.lsp.buf.rename, 'Rename')
      nmap('<leader>ca', vim.lsp.buf.code_action, 'Code Action')

      nmap('gd', function()
        require('telescope.builtin').lsp_definitions({ reuse_win = true })
      end, 'Goto Definition')
      nmap('gr', require('telescope.builtin').lsp_references, 'Goto References')
      nmap('gI', function()
        require('telescope.builtin').lsp_implementations({ reuse_win = true })
      end, 'Goto Implementation')
      nmap('gy', function()
        require('telescope.builtin').lsp_type_definitions({ reuse_win = true })
      end, 'Goto Type')
      nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
      nmap('<leader>k', vim.lsp.buf.signature_help, 'Signature Documentation')

      -- Lesser used LSP functionality
      nmap('gD', vim.lsp.buf.declaration, 'Goto Declaration')

      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
      end, { desc = 'Format current buffer with LSP' })
    end,
  })
end

--- @type table<string, lspconfig.Config>
M.servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  rust_analyzer = {},
  tsserver = {
    init_options = {
      plugins = {
        {
          name = '@vue/typescript-plugin',
          -- Maybe a function to get the location of the plugin is better?
          -- e.g. pnpm fallback to nvm fallback to default node path
          location = os.getenv('PNPM_HOME') .. '/global/5/node_modules/@vue/typescript-plugin',
          languages = { 'typescript', 'vue', 'javascript' },
        },
      },
    },
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
  },
  html = { filetypes = { 'html', 'twig', 'hbs' } },
  eslint = {
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json', 'jsonc' },
  },
  volar = {},
  intelephense = {},
  marksman = {},
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
        window = {
          progressBar = false,
        },
      },
    },
  },
  bashls = { filetypes = { 'sh', 'bash', 'zsh' } },
  typos_lsp = {},
  tailwindcss = {},
}

return M
