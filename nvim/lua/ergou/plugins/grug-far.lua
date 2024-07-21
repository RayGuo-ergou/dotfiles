return {
  'MagicDuck/grug-far.nvim',
  cmd = 'GrugFar',
  opts = { headerMaxWidth = 80 },
  keys = {
    {
      '<leader>rr',
      function()
        local is_visual = vim.fn.mode():lower():find('v')
        if is_visual then -- needed to make visual selection work
          vim.cmd([[normal! v]])
        end
        local grug = require('grug-far')
        local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
        local filesFilter = ext and ext ~= '' and '*.' .. ext or nil;
        (is_visual and grug.with_visual_selection or grug.grug_far)({
          prefills = { filesFilter = filesFilter },
        })
      end,
      mode = { 'n', 'v' },
      desc = 'Search and Replace',
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
