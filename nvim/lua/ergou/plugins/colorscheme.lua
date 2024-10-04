return {
  {
    'catppuccin/nvim',
    lazy = false,
    enabled = true,
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup({
        -- no_italic = true,
        transparent_background = true,
        integrations = {
          aerial = true,
          diffview = true,
          neotree = true,
          mason = true,
          neotest = true,
          noice = true,
          notify = true,
          grug_far = true,
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
            TypeVirtualText = { fg = colors.yellow },
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
