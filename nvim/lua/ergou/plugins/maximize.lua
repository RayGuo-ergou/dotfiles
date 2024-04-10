return {
  'declancm/maximize.nvim',
  opts = {
    default_keymaps = false,
  },
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
