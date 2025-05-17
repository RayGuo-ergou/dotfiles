return {
  {
    'catppuccin/nvim',
    lazy = false,
    enabled = true,
    name = 'catppuccin',
    priority = 1000,
    ---@type CatppuccinOptions
    opts = {
      -- no_italic = true,
      transparent_background = true,
      integrations = {
        aerial = true,
        diffview = true,
        neotree = true,
        mason = true,
        markview = true,
        neotest = true,
        noice = true,
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
        snacks = true,
      },
      custom_highlights = function(C)
        local U = require('catppuccin.utils.colors')
        local groups = {
          CmpItemKindNpm = { fg = C.red },
          TypeVirtualText = { fg = C.yellow },
          SnacksDashboardIcon = { fg = C.blue },

          SnacksIndentRed = { fg = C.red },
          SnacksIndentYellow = { fg = C.yellow },
          SnacksIndentBlue = { fg = C.blue },
          SnacksIndentOrange = { fg = C.peach },
          SnacksIndentGreen = { fg = C.green },
          SnacksIndentViolet = { fg = C.mauve },
          SnacksIndentCyan = { fg = C.teal },

          SnacksInputIcon = { fg = C.blue },
          SnacksInputTitle = { fg = C.subtext0 },
          SnacksInputBorder = { fg = C.blue },
          SnacksInputPrompt = { fg = C.blue },

          UgUndo = { bg = C.surface2 },
          UgRedo = { bg = C.surface2 },
        }
        local rainbow = {
          [0] = C.overlay2,
          [1] = C.red,
          [2] = C.peach,
          [3] = C.yellow,
          [4] = C.green,
          [5] = C.sapphire,
          [6] = C.lavender,
          [7] = C.mauve,
        }

        for i = 0, 7 do
          local color = rainbow[i]
          local bg = U.darken(color, 0.3, nil)
          groups['MarkviewPalette' .. i] = { fg = color, bg = bg }
          groups['MarkviewPalette' .. i .. 'Fg'] = { fg = color }
          groups['MarkviewPalette' .. i .. 'Bg'] = { bg = bg }
          groups['MarkviewIcon' .. i] = { fg = color, bg = C.mantle }
        end
        return groups
      end,
    },
    config = function(_, opts)
      require('catppuccin').setup(opts)
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
