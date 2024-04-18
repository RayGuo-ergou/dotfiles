--- @class ergou.util.lsp
local M = {}

--- @type string[]
M.CSPELL_CONFIG_FILES = {
  'cspell.json',
  '.cspell.json',
  'cSpell.json',
  '.cSpell.json',
  '.cspell.config.json',
}

M.PHP = {
  working_large_file = false,
}

function M.get_clients(opts)
  local ret = {} ---@type vim.lsp.Client[]
  if vim.lsp.get_clients then
    ret = vim.lsp.get_clients(opts)
  else
    ---@diagnostic disable-next-line: deprecated
    ret = vim.lsp.get_active_clients(opts)
    if opts and opts.method then
      ---@param client vim.lsp.Client
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

M.get_servers = function()
  local mason_registry = require('mason-registry')
  --- @type table<string, lspconfig.Config>
  local servers = {
    clangd = { cmd = {
      'clangd',
      '--offset-encoding=utf-16',
    } },
    -- gopls = {},
    -- pyright = {},
    rust_analyzer = {},
    tsserver = {
      init_options = {
        plugins = {},
      },
      filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
        'vue',
      },
    },
    html = { filetypes = { 'html', 'twig', 'hbs' } },
    eslint = {
      filetypes = {
        'typescript',
        'javascript',
        'javascriptreact',
        'typescriptreact',
        'vue',
        'json',
        'jsonc',
        'markdown',
      },
    },
    volar = {
      init_options = {
        vue = {
          hybridMode = true,
        },
      },
    },
    -- intelephense is a node.js server, so it's pretty slow
    -- And can only running one thread
    -- Use phpactor instead for large files
    -- it's not as good as intelephense, but it's faster
    intelephense = {
      enabled = not M.PHP.working_large_file,
    },
    -- To install phpactor, need php8
    phpactor = {
      enabled = M.PHP.working_large_file,
    },
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
    tailwindcss = {},
    unocss = {},
    theme_check = {},
    prismals = {},
    jdtls = {},
    emmet_language_server = {},
    jsonls = {
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
    },
    yamlls = {
      settings = {
        yaml = {
          schemaStore = {
            -- You must disable built-in schemaStore support if you want to use
            -- this plugin and its advanced options like `ignore`.
            enable = false,
            -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
            url = '',
          },
          schemas = require('schemastore').yaml.schemas(),
        },
      },
    },
    cssls = {},
  }

  local has_volar, volar = pcall(mason_registry.get_package, 'vue-language-server')

  -- If server `volar` and `tsserver` exists, add `@vue/typescript-plugin` to `tsserver`
  if servers.volar ~= nil and servers.tsserver ~= nil and has_volar then
    local tsserver = servers.tsserver or {} -- Ensure tsserver is initialized
    tsserver.init_options = tsserver.init_options or {} -- Ensure init_options is initialized
    tsserver.init_options.plugins = tsserver.init_options.plugins or {} -- Ensure plugins is initialized

    local vue_ts_plugin_path = volar:get_install_path() .. '/node_modules/@vue/language-server'

    local vue_plugin = {
      name = '@vue/typescript-plugin',
      -- Maybe a function to get the location of the plugin is better?
      -- e.g. pnpm fallback to nvm fallback to default node path
      location = vue_ts_plugin_path,
      languages = { 'vue' },
    }

    -- Append the plugin to the `tsserver` server
    vim.list_extend(tsserver.init_options.plugins, { vue_plugin })

    servers.tsserver = tsserver
  end
  return servers
end

return M
