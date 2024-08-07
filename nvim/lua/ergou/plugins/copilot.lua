return {
  {
    enabled = false,
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
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
        gitrebase = true,
        yaml = true,
        ['grug-far'] = false,
      },
    },
    config = function(_, opts)
      require('copilot').setup(opts)
    end,
  },
  { 'AndreM222/copilot-lualine', enabled = false },
}
