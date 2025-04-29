return {
  'andrewferrier/debugprint.nvim',
  cmd = {
    'DeleteDebugPrints',
    'ToggleCommentDebugPrints',
    'ResetDebugPrintsCounter',
    'SearchDebugPrints',
    'DebugPrintQFList',
  },
  keys = {
    {
      'g?',
    },
  },
  opts = {
    highlight_lines = false,
  },
}
