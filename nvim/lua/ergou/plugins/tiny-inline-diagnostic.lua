return {
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'VeryLazy',
    opts = {
      options = {
        overflow = {
          mode = 'none',
        },
      },
    },
  },
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    opts = {
      diagnostics = {
        virtual_text = false,
      },
    },
  },
}
