return {
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    enabled = false,
    event = 'LspAttach',
    opts = {
      options = {
        overflow = {
          mode = 'oneline',
        },
      },
    },
  },
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    opts = {
      diagnostics = {
        -- virtual_text = false,
      },
    },
  },
}
