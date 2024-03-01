return {
  {
    'catppuccin/nvim',
    lazy = false,
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup({
        no_italic = true, -- Force no italic
        integrations = {
          aerial = true,
          neotree = true,
          mason = true,
          noice = true,
          notify = true,
          navic = {
            enabled = true,
          },
          which_key = true,
          lsp_trouble = true,
        },
      })

      vim.cmd.colorscheme('catppuccin-macchiato')
    end,
  },
}
