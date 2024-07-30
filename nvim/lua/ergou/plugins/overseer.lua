return {
  'stevearc/overseer.nvim',
  opts = {
    task_list = {
      bindings = {
        ['<C-l>'] = false,
        ['<C-h>'] = false,
      },
    },
  },
  cmd = {
    'OverseerOpen',
    'OverseerClose',
    'OverseerToggle',
    'OverseerSaveBundle',
    'OverseerLoadBundle',
    'OverseerDeleteBundle',
    'OverseerRunCmd',
    'OverseerRun',
    'OverseerInfo',
    'OverseerBuild',
    'OverseerQuickAction',
    'OverseerTaskAction',
    'OverseerClearCache',
  },
  keys = {
    {
      '<leader>to',
      '<cmd>OverseerToggle right<cr>',
      desc = 'Toggle Overseer',
    },
    {
      '<leader>ro',
      '<cmd>OverseerRun<cr>',
      desc = 'Run Overseer',
    },
  },
}
