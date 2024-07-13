return {
  'MagicDuck/grug-far.nvim',
  config = function(_, opts)
    require('grug-far').setup(opts)
  end,
  keys = {
    {
      '<leader>rr',
      function()
        require('grug-far').grug_far({})
      end,
      desc = 'open grug-far',
    },
    {
      '<leader>rw',
      function()
        require('grug-far').grug_far({ prefills = { search = vim.fn.expand('<cword>') } })
      end,
      desc = 'replace current cursor word',
    },
    {
      '<leader>rf',
      function()
        require('grug-far').grug_far({ prefills = { flags = vim.fn.expand('%') } })
      end,
      desc = 'replace with current file flag',
    },
  },
}
