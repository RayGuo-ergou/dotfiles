local signs = ergou.icons.diagnostics
return {
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
      'mason.nvim',
      { 'mason-org/mason-lspconfig.nvim', config = function() end },
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
      inlay_hints = { enabled = true },
      -- Enable lsp cursor word highlighting
      document_highlight = {
        enabled = true,
      },
      ---@type vim.diagnostic.Opts
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
            [vim.diagnostic.severity.HINT] = signs.Hint,
            [vim.diagnostic.severity.INFO] = signs.Info,
          },
        },
      },
    },
    ---@param opts PluginLspOpts
    config = function(_, opts)
      local servers = ergou.lsp.servers.get()
      local ensure_install_servers = vim.tbl_keys(servers)
      local disabled_servers = {}
      for server_name, server in pairs(servers) do
        if server.enabled == false then
          table.insert(disabled_servers, server_name)
        end
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local mason_lspconfig = require('mason-lspconfig')
      ergou.lsp.setup()

      mason_lspconfig.setup({
        ensure_installed = ensure_install_servers,
        automatic_enable = {
          exclude = disabled_servers,
        },
      })
    end,
  },
  {
    'yioneko/nvim-vtsls',
    event = 'LspAttach',
    enabled = ergou.lsp.typescript.server_to_use == 'vtsls',
    keys = {
      {
        'grR',
        '<cmd>VtsExec file_references<cr>',
        desc = 'Find file references',
      },
    },
  },
  {
    'dnlhc/glance.nvim',
    cmd = 'Glance',
    keys = {
      { 'gD', '<cmd>Glance definitions<cr>', desc = 'Find Definitions Glance' },
      { 'gR', '<cmd>Glance references<cr>', desc = 'Find References Glance' },
      { 'gY', '<cmd>Glance type_definitions<cr>', desc = 'Find Type Definitions Glance' },
      { 'gM', '<cmd>Glance implementations<cr>', desc = 'Find Implementations Glance' },
    },
    opts = function()
      local glance = require('glance')
      local actions = glance.actions
      return {
        border = {
          enable = true,
        },
        mappings = {
          list = {
            ['<leader>l'] = false,
            ['<C-h>'] = actions.enter_win('preview'), -- Focus preview window
            ['<C-l>'] = actions.enter_win('preview'), -- Focus preview window
          },
          preview = {
            ['<leader>l'] = false,
            ['<C-l>'] = actions.enter_win('list'), -- Focus list window
            ['<C-h>'] = actions.enter_win('list'), -- Focus list window
          },
        },
      }
    end,
  },
}
