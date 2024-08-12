return {
  'mistweaverco/kulala.nvim',
  opts = {
    default_view = 'headers_body',
  },
  keys = {
    {
      '<leader>RR',
      function()
        require('kulala').run()
      end,
      desc = 'Curl request',
    },
  },
}
