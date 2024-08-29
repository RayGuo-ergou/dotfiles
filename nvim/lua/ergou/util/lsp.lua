--- @class ergou.util.lsp
local M = {}

--- @type string[]
M.cspell_config_files = {
  'cspell.json',
  '.cspell.json',
  'cSpell.json',
  '.cSpell.json',
  '.cspell.config.json',
}
-- PHP
M.PHP = {}
M.PHP.working_large_file = false

-- TYPESCRIPT
M.TYPESCRIPT = {}
M.TYPESCRIPT.inlay_hints = {
  includeInlayEnumMemberValueHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayParameterNameHints = 'all',
  includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayVariableTypeHints = true,
}
M.TYPESCRIPT.filetypes = {
  'javascript',
  'javascriptreact',
  'javascript.jsx',
  'typescript',
  'typescriptreact',
  'typescript.tsx',
  'vue',
}
M.TYPESCRIPT.servers = { 'vtsls', 'tsserver' }
M.TYPESCRIPT.server_to_use = 'vtsls'
M.TYPESCRIPT.vtsls_typescript_javascript_config = {
  updateImportsOnFileMove = { enabled = 'always' },
  suggest = {
    completeFunctionCalls = true,
  },
  inlayHints = {
    enumMemberValues = { enabled = true },
    functionLikeReturnTypes = { enabled = true },
    parameterNames = { enabled = 'all' },
    parameterTypes = { enabled = true },
    propertyDeclarationTypes = { enabled = true },
    variableTypes = { enabled = false },
  },
  tsserver = {
    maxTsServerMemory = 8192,
  },
}
M.TYPESCRIPT.handlers = {
  ['textDocument/publishDiagnostics'] = function(_, result, ctx, config)
    if result.diagnostics == nil then
      return
    end

    -- ignore some tsserver diagnostics
    local idx = 1
    while idx <= #result.diagnostics do
      local entry = result.diagnostics[idx]

      local formatter = ergou.tsformat[entry.code]
      entry.message = formatter and formatter(entry.message) or entry.message

      -- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
      if entry.code == 80001 then
        -- { message = "File is a CommonJS module; it may be converted to an ES module.", }
        table.remove(result.diagnostics, idx)
      else
        idx = idx + 1
      end
    end

    vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
  end,
}
---@param client vim.lsp.Client
---@param _ integer
M.TYPESCRIPT.on_attach = function(client, _)
  local existing_capabilities = vim.deepcopy(client.server_capabilities)

  if existing_capabilities == nil then
    return
  end

  existing_capabilities.documentFormattingProvider = nil

  if client.name == 'vtsls' then
    local existing_filters = existing_capabilities.workspace.fileOperations.didRename.filters or {}
    local new_glob = '**/*.{ts,cts,mts,tsx,js,cjs,mjs,jsx,vue}'

    for _, filter in ipairs(existing_filters) do
      if filter.pattern and filter.pattern.matches == 'file' then
        filter.pattern.glob = new_glob
        break
      end
    end

    existing_capabilities.workspace.fileOperations.didRename.filters = existing_filters
  end

  client.server_capabilities = existing_capabilities
end

-- ESLINT
M.ESLINT = {}
M.ESLINT.customizations = {
  { rule = 'style/*', severity = 'off', fixable = true },
  { rule = 'format/*', severity = 'off', fixable = true },
  { rule = '*-indent', severity = 'off', fixable = true },
  { rule = '*-spacing', severity = 'off', fixable = true },
  { rule = '*-spaces', severity = 'off', fixable = true },
  { rule = '*-order', severity = 'off', fixable = true },
  { rule = '*-dangle', severity = 'off', fixable = true },
  { rule = '*-newline', severity = 'off', fixable = true },
  { rule = '*quotes', severity = 'off', fixable = true },
  { rule = '*semi', severity = 'off', fixable = true },
}
M.ESLINT.filetypes = {
  'javascript',
  'javascriptreact',
  'typescript',
  'typescriptreact',
  'vue',
  'html',
  'markdown',
  'json',
  'jsonc',
  'yaml',
  'toml',
  'xml',
  'gql',
  'graphql',
  'astro',
  'css',
  'less',
  'scss',
  'pcss',
  'postcss',
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
  local old = assert(ergou.root.realpath(vim.api.nvim_buf_get_name(buf)))
  local root = assert(ergou.root.realpath(ergou.root.get({ normalize = true })))
  assert(old:find(root, 1, true) == 1, 'File not in project root')

  local extra = old:sub(#root + 2)

  vim.ui.input({
    prompt = 'New File Name: ',
    default = extra,
    completion = 'file',
  }, function(new)
    if not new or new == '' or new == extra then
      return
    end
    new = ergou.norm(root .. '/' .. new)
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
          not (file_type == 'vue' and vim.list_contains(M.TYPESCRIPT.servers, client_name))
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
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI', 'CursorMoved', 'CursorMovedI', 'ModeChanged' }, {
            group = vim.api.nvim_create_augroup('lsp_word_' .. bufnr, { clear = true }),
            buffer = bufnr,
            callback = function(ev)
              if not M.words.at() then
                if ev.event:find('CursorMoved') then
                  vim.lsp.buf.clear_references()
                elseif not ergou.cmp.visible() then
                  local ok = pcall(vim.lsp.buf.document_highlight)
                  if not ok then
                    vim.notify('Document Highlight failed', vim.log.levels.WARN)
                  end
                end
              end

              -- Clear reference on mode change
              -- So in visible mode it's clear of the selected parts
              if ev.event:find('ModeChanged') then
                vim.lsp.buf.clear_references()
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
          nmap('<leader>cR', ergou.lsp.rename_file, 'Rename File')
        end
      end

      nmap('<leader>rn', vim.lsp.buf.rename, 'Rename')
      -- nmap('<leader>rn', ':IncRename ', 'Rename')
      nmap('<leader>ca', vim.lsp.buf.code_action, 'Code Action')

      -- map for toggle inlay hint
      nmap('<leader>ih', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, 'Toggle Inlay Hint')

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
        nmap(
          'gd',
          '<cmd>FzfLua lsp_definitions     jump_to_single_result=true ignore_current_line=true<cr>',
          'Goto Definition'
        )
        nmap(
          'grr',
          '<cmd>FzfLua lsp_references      jump_to_single_result=true ignore_current_line=true<cr>',
          'Goto References'
        )
        nmap(
          'gI',
          '<cmd>FzfLua lsp_implementations jump_to_single_result=true ignore_current_line=true<cr>',
          'Goto Implementation'
        )
        nmap(
          'gy',
          '<cmd>FzfLua lsp_typedefs        jump_to_single_result=true ignore_current_line=true<cr>',
          'Goto Type'
        )
      end
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
  -- Define vue plugin
  local mason_registry = require('mason-registry')
  local has_volar, volar = pcall(mason_registry.get_package, 'vue-language-server')
  local vue_ts_plugin_path = volar:get_install_path() .. '/node_modules/@vue/language-server'
  local vue_plugin = {}
  if has_volar then
    vue_plugin = {
      name = '@vue/typescript-plugin',
      -- Maybe a function to get the location of the plugin is better?
      -- e.g. pnpm fallback to nvm fallback to default node path
      location = vue_ts_plugin_path,
      languages = { 'vue' },
      configNamespace = 'typescript',
      enableForWorkspaceTypeScriptVersions = true,
    }
  end

  --- @type table<string, lspconfig.Config>
  local servers = {
    clangd = { cmd = {
      'clangd',
      '--offset-encoding=utf-16',
    } },
    -- gopls = {},
    -- pyright = {},
    rust_analyzer = {},
    vtsls = {
      handlers = M.TYPESCRIPT.handlers,
      enabled = M.TYPESCRIPT.server_to_use == 'vtsls',
      filetypes = M.TYPESCRIPT.filetypes,
      settings = {
        complete_function_calls = true,
        vtsls = {
          enableMoveToFileCodeAction = true,
          autoUseWorkspaceTsdk = true,
          experimental = {
            completion = {
              enableServerSideFuzzyMatch = true,
            },
          },
          tsserver = {
            globalPlugins = {
              vue_plugin,
            },
          },
        },
        typescript = M.TYPESCRIPT.vtsls_typescript_javascript_config,
        javascript = M.TYPESCRIPT.vtsls_typescript_javascript_config,
      },
      on_attach = M.TYPESCRIPT.on_attach,
    },
    tsserver = {
      handlers = M.TYPESCRIPT.handlers,
      enabled = M.TYPESCRIPT.server_to_use == 'tsserver',
      -- taken from https://github.com/typescript-language-server/typescript-language-server#workspacedidchangeconfiguration
      init_options = {
        plugins = {
          vue_plugin,
        },
      },
      filetypes = M.TYPESCRIPT.filetypes,
      settings = {
        javascript = {
          inlayHints = M.TYPESCRIPT.inlay_hints,
        },
        typescript = {
          inlayHints = M.TYPESCRIPT.inlay_hints,
        },
      },
      on_attach = M.TYPESCRIPT.on_attach,
    },
    html = { filetypes = { 'html', 'twig', 'hbs', 'blade' } },
    eslint = {
      filetypes = M.ESLINT.filetypes,
      settings = {
        rulesCustomizations = M.ESLINT.customizations,
      },
    },
    volar = {
      init_options = {
        vue = {
          hybridMode = true,
        },
      },
      on_attach = function(client, _)
        client.server_capabilities.documentFormattingProvider = nil
      end,
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
          diagnostics = {
            globals = { 'vim', 'ergou' },
          },
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
              ---@see https://github.com/RayGuo-ergou/tailwind-intellisense-regex-list?tab=readme-ov-file#plain-javascript-object
              ---All javascript object, only enable when needed e.g. long object
              -- ':\\s*?["\'`]([^"\'`]*).*?,',
              '\\/\\*\\s*tw\\s*\\*\\/\\s*[`\'"](.*)[`\'"];?',
              '@tw\\s\\*/\\s+["\'`]([^"\'`]*)',
              { '(?:twMerge|twJoin)\\(([^\\);]*)[\\);]', '[`\'"]([^\'"`,;]*)[`\'"]' },
              'twc\\`(.*)\\`;?',
              '(?:clsx|cva|cn)[`]([\\s\\S][^`]*)[`]',
              { '(?:clsx|cva|cn)\\(([^)]*)\\)', '(?:\'|"|`)([^\']*)(?:\'|"|`)' },
              { 'ui:\\s*{([^)]*)\\s*}', '["\'`]([^"\'`]*).*?["\'`]' },
              { '/\\*\\s?ui\\s?\\*/\\s*{([^;]*)}', ':\\s*["\'`]([^"\'`]*).*?["\'`]' },
              'class\\s*:\\s*["\'`]([^"\'`]*)["\'`]',
              ---@see https://github.com/RayGuo-ergou/tailwind-intellisense-regex-list?tab=readme-ov-file#dom
              { 'classList.(?:add|remove)\\(([^)]*)\\)', '(?:\'|"|`)([^"\'`]*)(?:\'|"|`)' },
              ---@see https://github.com/RayGuo-ergou/tailwind-intellisense-regex-list?tab=readme-ov-file#typescript-or-javascript-variables-strings-or-arrays-with-keyword
              { 'Styles\\s*(?::\\s*[^=]+)?\\s*=\\s*([^;]*);', '[\'"`]([^\'"`]*)[\'"`]' },
              ---@see https://github.com/RayGuo-ergou/tailwind-intellisense-regex-list?tab=readme-ov-file#headlessui-transition-react
              '(?:enter|leave)(?:From|To)?=\\s*(?:"|\'|{`)([^(?:"|\'|`})]*)',
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
    shopify_theme_ls = {},
    prismals = {},
    -- jdtls = {},
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
        'php',
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
    cssls = {
      settings = {
        css = {
          lint = {
            unknownAtRules = 'ignore',
          },
        },
      },
    },
    taplo = {},
  }

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
