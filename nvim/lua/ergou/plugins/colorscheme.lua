return {
  {
    'catppuccin/nvim',
    lazy = false,
    enabled = true,
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup({
        no_italic = true,
        dim_inactive = {
          enabled = true,
        },
        integrations = {
          aerial = true,
          diffview = true,
          neotree = true,
          mason = true,
          noice = true,
          notify = true,
          navic = {
            enabled = true,
          },
          which_key = true,
          lsp_trouble = true,
          native_lsp = {
            enabled = true,
            underlines = {
              errors = { 'undercurl' },
              hints = { 'undercurl' },
              warnings = { 'undercurl' },
              information = { 'undercurl' },
              ok = { 'undercurl' },
            },
          },
        },
        custom_highlights = function(colors)
          return {
            CmpItemKindNpm = { fg = colors.red },
          }
        end,
      })

      vim.cmd.colorscheme('catppuccin-macchiato')
    end,
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    enabled = false,
    name = 'tokyonight',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('tokyonight')
    end,
  },
}
