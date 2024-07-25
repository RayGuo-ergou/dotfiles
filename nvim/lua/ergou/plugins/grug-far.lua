return {
  'MagicDuck/grug-far.nvim',
  cmd = 'GrugFar',
  opts = { headerMaxWidth = 80 },
  keys = {
    {
      '<leader>rr',
      function()
        require('grug-far').grug_far({
          transient = true,
        })
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
          transient = true,
          prefills = {
            filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
          },
        })
      end,
      mode = { 'n', 'v' },
      desc = 'Search and Replace with current file type',
    },
    {
      '<leader>rf',
      function()
        require('grug-far').grug_far({
          transient = true,
          prefills = {
            flags = vim.fn.expand('%'),
          },
        })
      end,
      desc = 'replace with current file flag',
    },
    {
      '<leader>rF',
      function()
        local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
        require('grug-far').grug_far({
          transient = true,
          prefills = {
            flags = vim.fn.expand('%'),
            filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
          },
        })
      end,
      desc = 'replace with current file flag',
    },
  },
}
