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
      float = {
        transparent = true,
      },
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
        local O = require('catppuccin').options
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

          -- HACK: Wait for the semetic token fix
          ['@variable.member'] = { fg = C.lavender }, -- For fields.
          ['@module'] = { fg = C.lavender, style = O.styles.miscs or { 'italic' } }, -- For identifiers referring to modules and namespaces.
          ['@string.special.url'] = { fg = C.rosewater, style = { 'italic', 'underline' } }, -- urls, links and emails
          ['@type.builtin'] = { fg = C.yellow, style = O.styles.properties or { 'italic' } }, -- For builtin types.
          ['@property'] = { fg = C.lavender, style = O.styles.properties or {} }, -- Same as TSField.
          ['@constructor'] = { fg = C.sapphire }, -- For constructor calls and definitions: = { } in Lua, and Java constructors.
          ['@keyword.operator'] = { link = 'Operator' }, -- For new keyword operator
          ['@keyword.export'] = { fg = C.sky, style = O.styles.keywords },
          ['@markup.strong'] = { fg = C.maroon, style = { 'bold' } }, -- bold
          ['@markup.italic'] = { fg = C.maroon, style = { 'italic' } }, -- italic
          ['@markup.heading'] = { fg = C.blue, style = { 'bold' } }, -- titles like: # Example
          ['@markup.quote'] = { fg = C.maroon, style = { 'bold' } }, -- block quotes
          ['@markup.link'] = { link = 'Tag' }, -- text references, footnotes, citations, etc.
          ['@markup.link.label'] = { link = 'Label' }, -- link, reference descriptions
          ['@markup.link.url'] = { fg = C.rosewater, style = { 'italic', 'underline' } }, -- urls, links and emails
          ['@markup.raw'] = { fg = C.teal }, -- used for inline code in markdown and for doc in python (""")
          ['@markup.list'] = { link = 'Special' },
          ['@tag'] = { fg = C.mauve }, -- Tags like html tag names.
          ['@tag.attribute'] = { fg = C.teal, style = O.styles.miscs or { 'italic' } }, -- Tags like html tag names.
          ['@tag.delimiter'] = { fg = C.sky }, -- Tag delimiter like < > /
          ['@property.css'] = { fg = C.lavender },
          ['@property.id.css'] = { fg = C.blue },
          ['@type.tag.css'] = { fg = C.mauve },
          ['@string.plain.css'] = { fg = C.peach },
          ['@constructor.lua'] = { fg = C.flamingo }, -- For constructor calls and definitions: = { } in Lua.
          -- typescript
          ['@property.typescript'] = { fg = C.lavender, style = O.styles.properties or {} },
          ['@constructor.typescript'] = { fg = C.lavender },
          -- TSX (Typescript React)
          ['@constructor.tsx'] = { fg = C.lavender },
          ['@tag.attribute.tsx'] = { fg = C.teal, style = O.styles.miscs or { 'italic' } },
          ['@type.builtin.c'] = { fg = C.yellow, style = {} },
          ['@type.builtin.cpp'] = { fg = C.yellow, style = {} },

          -- lsp
          ['@lsp.type.component'] = { link = '@function' },
        }
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
