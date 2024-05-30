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

M.TS_INLAY_HINTS = {
  includeInlayEnumMemberValueHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayParameterNameHints = 'all',
  includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayVariableTypeHints = true,
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

function M.rename_file()
  local buf = vim.api.nvim_get_current_buf()
  local old = assert(Ergou.root.realpath(vim.api.nvim_buf_get_name(buf)))
  local root = assert(Ergou.root.realpath(Ergou.root.get({ normalize = true })))
  assert(old:find(root, 1, true) == 1, 'File not in project root')

  local extra = old:sub(#root + 2)

  vim.ui.input({
    prompt = 'New File Name: ',
    default = extra,
  }, function(new)
    if not new or new == '' or new == extra then
      return
    end
    new = Ergou.norm(root .. '/' .. new)
    vim.fn.mkdir(vim.fs.dirname(new), 'p')
    M.on_rename(old, new, function()
      vim.fn.rename(old, new)
      vim.cmd.edit(new)
      vim.api.nvim_buf_delete(buf, { force = true })
      vim.fn.delete(old)
    end)
  end)
end

---@from https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/lsp.lua
---@param from string
---@param to string
---@param rename? fun()
function M.on_rename(from, to, rename)
  local changes = { files = { {
    oldUri = vim.uri_from_fname(from),
    newUri = vim.uri_from_fname(to),
  } } }

  local clients = M.get_clients()
  for _, client in ipairs(clients) do
    if client.supports_method('workspace/willRenameFiles') then
      local resp = client.request_sync('workspace/willRenameFiles', changes, 1000, 0)
      if resp and resp.result ~= nil then
        vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
      end
    end
  end

  if rename then
    rename()
  end

  for _, client in ipairs(clients) do
    if client.supports_method('workspace/didRenameFiles') then
      client.notify('workspace/didRenameFiles', changes)
    end
  end
end

function M.lsp_autocmd()
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
      local bufnr = event.buf

      local nmap = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
      end

      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client then
        local client_name = client.name
        local file_type = vim.bo[bufnr].filetype
        if
          not (file_type == 'vue' and client_name == 'tsserver')
          and client.supports_method('textDocument/documentSymbol')
        then
          require('nvim-navic').attach(client, bufnr)
        end

        -- If want to enable inlay hint on lsp attach
        -- if client.supports_method('textDocument/inlayHint') then
        --   vim.lsp.inlay_hint.enable()
        -- end

        -- Highlight references
        local handler = vim.lsp.handlers['textDocument/documentHighlight']
        vim.lsp.handlers['textDocument/documentHighlight'] = function(err, result, ctx, config)
          if not vim.api.nvim_buf_is_loaded(ctx.bufnr) then
            return
          end
          return handler(err, result, ctx, config)
        end

        -- lsp highlight references
        if client.supports_method('textDocument/documentHighlight') then
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI', 'CursorMoved', 'CursorMovedI' }, {
            group = vim.api.nvim_create_augroup('lsp_word_' .. bufnr, { clear = true }),
            buffer = bufnr,
            callback = function(ev)
              if not M.words.at() then
                if ev.event:find('CursorMoved') then
                  vim.lsp.buf.clear_references()
                else
                  vim.lsp.buf.document_highlight()
                end
              end
            end,
          })
          vim.keymap.set('n', ']]', function()
            M.words.jump(vim.v.count1)
          end, { buffer = bufnr, desc = 'Next reference' })
          vim.keymap.set('n', '[[', function()
            M.words.jump(-vim.v.count1)
          end, { buffer = bufnr, desc = 'Previous reference' })
        end

        -- Rename file
        if
          client.supports_method('workspace/didRenameFiles') or client.supports_method('workspace/willRenameFiles')
        then
          nmap('<leader>cR', Ergou.lsp.rename_file, 'Rename File')
        end
      end

      nmap('<leader>rn', vim.lsp.buf.rename, 'Rename')
      nmap('<leader>ca', vim.lsp.buf.code_action, 'Code Action')

      -- map for toggle inlay hint
      nmap('<leader>ih', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, 'Toggle Inlay Hint')

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
      -- taken from https://github.com/typescript-language-server/typescript-language-server#workspacedidchangeconfiguration
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
      settings = {
        javascript = {
          inlayHints = M.TS_INLAY_HINTS,
        },
        typescript = {
          inlayHints = M.TS_INLAY_HINTS,
        },
      },
    },
    html = { filetypes = { 'html', 'twig', 'hbs', 'blade' } },
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
        'yaml',
        'yaml.docker-compose',
        'yaml.gitlab',
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
          hint = { enable = true },
        },
      },
    },
    bashls = { filetypes = { 'sh', 'bash', 'zsh' } },
    tailwindcss = {
      settings = {
        tailwindCSS = {
          experimental = {
            classRegex = {
              '\\/\\*\\s*tw\\s*\\*\\/\\s*[`\'"](.*)[`\'"];?',
              { '(?:twMerge|twJoin)\\(([^\\);]*)[\\);]', '[`\'"]([^\'"`,;]*)[`\'"]' },
              'twc\\`(.*)\\`;?',
              'clsx[`]([\\s\\S][^`]*)[`]',
              { 'clsx\\(([^)]*)\\)', '(?:\'|"|`)([^\']*)(?:\'|"|`)' },
              'cva[`]([\\s\\S][^`]*)[`]',
              { 'cva\\(([^)]*)\\)', '(?:\'|"|`)([^\']*)(?:\'|"|`)' },
              { 'ui:\\s*{([^)]*)\\s*}', '["\'`]([^"\'`]*).*?["\'`]' },
              { '/\\*\\s?ui\\s?\\*/\\s*{([^;]*)}', ':\\s*["\'`]([^"\'`]*).*?["\'`]' },
            },
          },
          classAttributes = {
            'class',
            'className',
            'class:list',
            'classList',
            'ngClass',
            'ui',
          },
        },
      },
    },
    unocss = {},
    theme_check = {},
    prismals = {},
    jdtls = {},
    emmet_language_server = {
      filetypes = {
        'css',
        'eruby',
        'html',
        'htmldjango',
        'javascriptreact',
        'less',
        'pug',
        'sass',
        'scss',
        'typescriptreact',
        'blade',
      },
    },
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
    taplo = {},
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

---@alias LspWord {from:{[1]:number, [2]:number}, to:{[1]:number, [2]:number}, current?:boolean} 1-0 indexed
M.words = {}
M.words.ns = vim.api.nvim_create_namespace('vim_lsp_references')

---@return LspWord[]
function M.words.get()
  local cursor = vim.api.nvim_win_get_cursor(0)
  return vim.tbl_map(function(extmark)
    local ret = {
      from = { extmark[2] + 1, extmark[3] },
      to = { extmark[4].end_row + 1, extmark[4].end_col },
    }
    if cursor[1] >= ret.from[1] and cursor[1] <= ret.to[1] and cursor[2] >= ret.from[2] and cursor[2] <= ret.to[2] then
      ret.current = true
    end
    return ret
  end, vim.api.nvim_buf_get_extmarks(0, M.words.ns, 0, -1, { details = true }))
end

---@param words? LspWord[]
---@return LspWord?, number?
function M.words.at(words)
  for idx, word in ipairs(words or M.words.get()) do
    if word.current then
      return word, idx
    end
  end
end

function M.words.jump(count)
  local words = M.words.get()
  local _, idx = M.words.at(words)
  if not idx then
    return
  end
  local target = words[idx + count]
  if target then
    vim.api.nvim_win_set_cursor(0, target.from)
  end
end
return M
