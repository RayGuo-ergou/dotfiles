return {
  'rmagatti/alternate-toggler',
  opts = {
    alternates = {
      ['=='] = '!=',
    },
  },
  keys = {
    { '<leader>ta', ':ToggleAlternate<CR>', mode = { 'n' }, desc = 'Toggle alternate' },
  },
}
