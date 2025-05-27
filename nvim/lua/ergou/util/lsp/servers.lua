---@class ergou.util.lsp.servers
local M = {}

M.get = function()
  local vue_plugin = ergou.lsp.typescript.get_vue_plugin()

  if vim.tbl_isempty(vue_plugin) then
    vim.notify('Cannot find vue typescript plugin', vim.log.levels.ERROR)
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
      handlers = ergou.lsp.typescript.handlers,
      enabled = ergou.lsp.typescript.server_to_use == 'vtsls',
      filetypes = ergou.lsp.typescript.filetypes,
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
        typescript = ergou.lsp.typescript.vtsls_typescript_javascript_config,
        javascript = ergou.lsp.typescript.vtsls_typescript_javascript_config,
      },
      on_attach = ergou.lsp.typescript.on_attach,
    },
    ts_ls = {
      handlers = ergou.lsp.typescript.handlers,
      enabled = ergou.lsp.typescript.server_to_use == 'ts_ls',
      -- taken from https://github.com/typescript-language-server/typescript-language-server#workspacedidchangeconfiguration
      init_options = {
        plugins = {
          vue_plugin,
        },
      },
      filetypes = ergou.lsp.typescript.filetypes,
      settings = {
        javascript = {
          inlayHints = ergou.lsp.typescript.inlay_hints,
        },
        typescript = {
          inlayHints = ergou.lsp.typescript.inlay_hints,
        },
      },
      on_attach = ergou.lsp.typescript.on_attach,
    },
    html = { filetypes = { 'html', 'twig', 'hbs', 'blade' } },
    eslint = {
      filetypes = ergou.lsp.eslint.filetypes,
      settings = {
        rulesCustomizations = ergou.lsp.eslint.customizations,
      },
    },
    vue_ls = {
      -- For v3 Will manual start
      -- enabled = false,
      init_options = {
        vue = {
          hybridMode = true,
        },
        typescript = {
          tsserverRequestCommand = 'tsserverRequest',
        },
      },
      ---XXX: will block ui
      on_init = function(client)
        client.handlers['tsserverRequest'] = function(_, result, context)
          local clients = ergou.lsp.get_clients({ bufnr = context.bufnr, name = ergou.lsp.typescript.server_to_use })

          if #clients == 0 then
            return
          end
          local ts_client = clients[1]

          local params = {
            command = 'typescript.tsserverRequest',
            arguments = unpack(result),
          }

          -- need vtsls to start
          local max_retries = 5
          local retry_delay = 100

          for attempt = 1, max_retries do
            local res = ts_client:request_sync('workspace/executeCommand', params)

            if res ~= nil and res.result ~= nil and not res.err then
              return res.result.body
            end

            if attempt < max_retries then
              vim.wait(retry_delay)
            end
          end

          return nil
        end
      end,
      on_attach = function(client, _)
        client.server_capabilities.documentFormattingProvider = nil
      end,
    },
    -- intelephense is a node.js server, so it's pretty slow
    -- And can only running one thread
    -- Use phpactor instead for large files
    -- it's not as good as intelephense, but it's faster
    intelephense = {
      enabled = not ergou.lsp.php.working_large_file,
    },
    -- To install phpactor, need php8
    phpactor = {
      enabled = ergou.lsp.php.working_large_file,
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
              ---@see doc https://github.com/RayGuo-ergou/tailwind-intellisense-regex-list?tab=readme-ov-file#plain-javascript-object
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
              ---@see doc https://github.com/RayGuo-ergou/tailwind-intellisense-regex-list?tab=readme-ov-file#dom
              { 'classList.(?:add|remove)\\(([^)]*)\\)', '(?:\'|"|`)([^"\'`]*)(?:\'|"|`)' },
              ---@see doc https://github.com/RayGuo-ergou/tailwind-intellisense-regex-list?tab=readme-ov-file#typescript-or-javascript-variables-strings-or-arrays-with-keyword
              { 'Styles\\s*(?::\\s*[^=]+)?\\s*=\\s*([^;]*);', '[\'"`]([^\'"`]*)[\'"`]' },
              ---@see doc https://github.com/RayGuo-ergou/tailwind-intellisense-regex-list?tab=readme-ov-file#headlessui-transition-react
              '(?:enter|leave)(?:From|To)?=\\s*(?:"|\'|{`)([^(?:"|\'|`})]*)',
              ---@see doc https://github.com/RayGuo-ergou/tailwind-intellisense-regex-list/tree/main?tab=readme-ov-file#tagged-template-literals
              {
                '(tw`(?:(?:(?:[^`]*\\$\\{[^]*?\\})[^`]*)+|[^`]*`))',
                '((?:(?<=`)(?:[^"\'`]*)(?=\\${|`))|(?:(?<=\\})(?:[^"\'`]*)(?=\\${))|(?:(?<=\\})(?:[^"\'`]*)(?=`))|(?:(?<=\')(?:[^"\'`]*)(?=\'))|(?:(?<=")(?:[^"\'`]*)(?="))|(?:(?<=`)(?:[^"\'`]*)(?=`)))',
              },
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
    zls = {},
    ts_query_ls = {
      settings = {
        parser_install_directories = {
          -- If using nvim-treesitter with lazy.nvim
          vim.fs.joinpath(vim.fn.stdpath('data'), '/lazy/nvim-treesitter/parser/'),
        },
        -- E.g. zed support
        language_retrieval_patterns = {
          'languages/src/([^/]+)/[^/]+\\.scm$',
        },
      },
    },
    hyprls = {},
  }

  return servers
end

--- Servers that cannot be setup via lsp mason
M.get_native = function()
  --- @type table<string, lspconfig.Config>
  local servers = {}

  return servers
end

return M
