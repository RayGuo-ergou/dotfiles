local enabled = false
return {
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'LspAttach',
    enabled = enabled,
    opts = {
      transparent_bg = true,
      options = {
        overflow = {
          mode = 'oneline',
        },
        severity = {
          vim.diagnostic.severity.INFO,
          vim.diagnostic.severity.HINT,
        },
      },
    },
  },
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      if enabled then
        opts.diagnostics = vim.tbl_deep_extend('force', opts.diagnostics or {}, {
          virtual_text = {
            severity = {
              vim.diagnostic.severity.ERROR,
              vim.diagnostic.severity.WARN,
            },
          },
        })
      end
    end,
  },
}
