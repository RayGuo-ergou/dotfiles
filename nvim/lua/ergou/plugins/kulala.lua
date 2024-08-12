return {
  'mistweaverco/kulala.nvim',
  opts = {
    default_view = 'headers_body',
  },
  keys = {
    { '<leader>RR', require('kulala').run, desc = 'Curl request' },
  },
}
