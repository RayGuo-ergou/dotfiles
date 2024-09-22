-- I have thought again, why not just hover?
-- Enable when need this
return {
  'marilari88/twoslash-queries.nvim',
  enabled = false,
  event = 'LazyFile',
  opts = {},
  keys = {
    {
      '<leader>tt',
      '<cmd>TwoslashQueriesInspect<cr>',
      desc = 'Inspect variable under the cursor',
    },
    {
      '<leader>rt',
      '<cmd>TwoslashQueriesRemove<cr>',
      desc = 'Remove all twoslash queries',
    },
  },
}
