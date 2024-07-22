local Util = require('ergou.util')
local signs = Util.icons.diagnostics
return {
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = 'LazyFile',
    dependencies = {
      ---@see lazyvim https://github.com/LazyVim/LazyVim/blob/6f91b406ddf2b298efe43f6467ca0a9103881a88/lua/lazyvim/plugins/lsp/init.lua#L259-L296
      {
        'williamboman/mason.nvim',
        cmd = 'Mason',
        keys = { { '<leader>cm', '<cmd>Mason<cr>', desc = 'Mason' } },
        build = ':MasonUpdate',
        opts_extend = { 'ensure_installed' },
        opts = {
          ensure_installed = {
            'stylua',
            'eslint_d',
            'phpcbf',
            'cspell',
            'phpcs',
            'prettierd',
          },
        },
        ---@param opts MasonSettings | {ensure_installed: string[]}
        config = function(_, opts)
          require('mason').setup(opts)
          local mr = require('mason-registry')
          mr:on('package:install:success', function()
            vim.defer_fn(function()
              -- trigger FileType event to possibly load this newly installed LSP server
              require('lazy.core.handler.event').trigger({
                event = 'FileType',
                buf = vim.api.nvim_get_current_buf(),
              })
            end, 100)
          end)

          mr.refresh(function()
            for _, tool in ipairs(opts.ensure_installed) do
              local p = mr.get_package(tool)
              if not p:is_installed() then
                p:install()
              end
            end
          end)
        end,
      },
      { 'williamboman/mason-lspconfig.nvim', config = function() end },
      {
        'utilyre/barbecue.nvim',
        name = 'barbecue',
        dependencies = {
          {
            'SmiteshP/nvim-navic',
          },
        },
        opts = { attach_navic = false },
      },
      { 'b0o/schemastore.nvim' },
    },
    ---@class PluginLspOpts
    opts = {
      ---@type vim.diagnostic.Opts
      inlay_hints = { enabled = true },
      -- Enable lsp cursor word highlighting
      document_highlight = {
        enabled = true,
      },
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = 'if_many',
          -- prefix = '●',
          -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
          -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
          prefix = function(diagnostic)
            if diagnostic.severity == vim.diagnostic.severity.ERROR then
              return signs.Error
            elseif diagnostic.severity == vim.diagnostic.severity.WARN then
              return signs.Warn
            elseif diagnostic.severity == vim.diagnostic.severity.HINT then
              return signs.Hint
            elseif diagnostic.severity == vim.diagnostic.severity.INFO then
              return signs.Info
            end
            return '●'
          end,
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = signs.Error,
            [vim.diagnostic.severity.WARN] = signs.Warn,
            [vim.diagnostic.severity.HINT] = '',
            [vim.diagnostic.severity.INFO] = signs.Info,
          },
        },
      },
    },
    ---@param opts PluginLspOpts
    config = function(_, opts)
      local servers = Util.lsp.get_servers()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local ensure_install_servers = vim.tbl_keys(servers)

      local mason_lspconfig = require('mason-lspconfig')
      Util.lsp.lsp_autocmd()

      mason_lspconfig.setup({
        ensure_installed = ensure_install_servers,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      })
    end,
  },
}
