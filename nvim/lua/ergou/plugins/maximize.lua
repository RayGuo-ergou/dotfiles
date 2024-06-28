return {
  'declancm/maximize.nvim',
  opts = {},
  keys = {
    {
      '<leader>z',
      function()
        require('maximize').toggle()
      end,
      mode = { 'n' },
      desc = 'Maximize current window',
    },
  },
}
