return {
  'MagicDuck/grug-far.nvim',
  cmd = 'GrugFar',
  opts = { headerMaxWidth = 80 },
  keys = {
    {
      '<leader>rr',
      function()
        require('grug-far').grug_far({})
      end,
      mode = { 'n', 'v' },
      desc = 'Search and Replace',
    },
    {
      '<leader>rR',
      function()
        local grug = require('grug-far')
        local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
        grug.grug_far({
          prefills = {
            filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
          },
        })
      end,
      mode = { 'n', 'v' },
      desc = 'Search and Replace with current file type',
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
