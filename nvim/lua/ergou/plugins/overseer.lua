return {
  'stevearc/overseer.nvim',
  lazy = false, -- plugin is self-lazy-loading
  opts = {},
  cmd = {
    'OverseerOpen',
    'OverseerClose',
    'OverseerToggle',
    'OverseerRun',
    'OverseerTaskAction',
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
