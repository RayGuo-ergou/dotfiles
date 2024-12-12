-- TODO: Detect vitepress in root, if exist add vitepress support, for now manually add markdown to volar if need write vitepress doc

---@class ergou.util.lsp
---@field public typescript ergou.util.lsp.typescript
---@field public php ergou.util.lsp.php
---@field public eslint ergou.util.lsp.eslint
---@field public cspell ergou.util.lsp.cspell
---@field public tsformat ergou.util.lsp.tsformat
---@field public keymap ergou.util.lsp.keymap
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

function M.lsp_autocmd()
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
      handlers = M.typescript.handlers,
      enabled = M.typescript.server_to_use == 'vtsls',
      filetypes = M.typescript.filetypes,
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
        typescript = M.typescript.vtsls_typescript_javascript_config,
        javascript = M.typescript.vtsls_typescript_javascript_config,
      },
      on_attach = M.typescript.on_attach,
    },
    ts_ls = {
      handlers = M.typescript.handlers,
      enabled = M.typescript.server_to_use == 'ts_ls',
      -- taken from https://github.com/typescript-language-server/typescript-language-server#workspacedidchangeconfiguration
      init_options = {
        plugins = {
          vue_plugin,
        },
      },
      filetypes = M.typescript.filetypes,
      settings = {
        javascript = {
          inlayHints = M.typescript.inlay_hints,
        },
        typescript = {
          inlayHints = M.typescript.inlay_hints,
        },
      },
      on_attach = M.typescript.on_attach,
    },
    html = { filetypes = { 'html', 'twig', 'hbs', 'blade' } },
    eslint = {
      filetypes = M.eslint.filetypes,
      settings = {
        rulesCustomizations = M.eslint.customizations,
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
      enabled = not M.php.working_large_file,
    },
    -- To install phpactor, need php8
    phpactor = {
      enabled = M.php.working_large_file,
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
          schemas = require('schemastore').json.schemas({
            extra = {
              {
                description = 'TypeScript compiler configuration file for vue',
                fileMatch = { 'tsconfig*.json' },
                name = 'vue-tsconfig.json',
                url = 'https://raw.githubusercontent.com/vuejs/language-tools/master/packages/language-core/schemas/vue-tsconfig.schema.json',
              },
            },
          }),
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
    nil_ls = {},
    typos_lsp = {
      init_options = {
        diagnosticSeverity = 'Hint',
      },
    },
  }

  return servers
end

return M
