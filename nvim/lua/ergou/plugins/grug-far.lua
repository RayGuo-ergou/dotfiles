---@note
---When replacing string the escape char is $ not \.
return {
  'MagicDuck/grug-far.nvim',
  cmd = 'GrugFar',
  ---@type GrugFarOptionsOverride
  opts = {
    headerMaxWidth = 80,
    -- engine = 'astgrep',
    folding = {
      foldcolumn = '0',
    },
  },
  keys = {
    {
      '<leader>rr',
      function()
        require('grug-far').open({
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
        grug.open({
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
        require('grug-far').open({
          transient = true,
          prefills = {
            paths = vim.fn.expand('%'),
          },
        })
      end,
      desc = 'replace with current file flag',
    },
    {
      '<leader>rF',
      function()
        local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
        require('grug-far').open({
          transient = true,
          prefills = {
            filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
          },
        })
      end,
      desc = 'replace with current file flag',
    },
  },
}
