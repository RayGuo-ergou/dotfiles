return {
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = 'LazyFile',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      { 'folke/neodev.nvim', config = true },
      {
        'utilyre/barbecue.nvim',
        name = 'barbecue',
        version = '*',
        dependencies = {
          {
            'SmiteshP/nvim-navic',
          },
        },
        opts = { attach_navic = false },
      },
    },
    config = function()
      local Util = require('ergou.util')
      local on_attach = Util.lsp.on_attach
      local servers = Util.lsp.servers
      local signs = Util.icons.signs
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      local mason_lspconfig = require('mason-lspconfig')
      Util.lsp.lsp_autocmd()

      mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(servers),
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
