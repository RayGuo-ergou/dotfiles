return {
  {
    enabled = false,
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      panel = {
        enabled = false,
        auto_refresh = true,
      },
      suggestion = {
        accept = false,
        enabled = false,
        auto_trigger = false,
      },
      filetypes = {
        markdown = true,
        gitrebase = true,
        yaml = true,
        ['grug-far'] = false,
      },
    },
    config = function(_, opts)
      require('copilot').setup(opts)
    end,
  },
  { 'AndreM222/copilot-lualine' },
}
