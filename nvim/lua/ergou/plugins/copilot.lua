return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup({
        panel = {
          enabled = true,
          auto_refresh = true,
        },
        suggestion = {
          accept = false,
          enabled = true,
          auto_trigger = true,
        },
        filetypes = {
          markdown = true,
          gitcommit = true,
          gitrebase = true,
        },
      })
    end,
  },
  { 'AndreM222/copilot-lualine' },
}
