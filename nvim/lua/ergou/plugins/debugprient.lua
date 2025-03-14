return {
  'andrewferrier/debugprint.nvim',
  cmd = { 'DeleteDebugPrints', 'ToggleCommentDebugPrints', 'ResetDebugPrintsCounter' },
  keys = {
    {
      'g?',
    },
  },
  opts = {
    print_tag = 'Debug',
    highlight_lines = false,
  },
}
