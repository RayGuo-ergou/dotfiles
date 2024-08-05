return {
  'rmagatti/alternate-toggler',
  opts = {
    alternates = {
      ['=='] = '!=',
    },
  },
  keys = {
    {
      '<leader>ta',
      function()
        require('alternate-toggler').toggleAlternate()
      end,
      mode = { 'n' },
      desc = 'Toggle alternate',
    },
  },
}
