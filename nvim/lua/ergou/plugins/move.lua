return {
  'fedepujol/move.nvim',
  config = true,
  event = 'LazyFile',
  keys = {
    { '<M-j>', ':MoveLine(1)<CR>', mode = { 'n' }, noremap = true, silent = true, desc = 'Move line down' },
    { '<M-k>', ':MoveLine(-1)<CR>', mode = { 'n' }, noremap = true, silent = true, desc = 'Move line up' },
    { '<M-j>', ':MoveBlock(1)<CR>', mode = { 'v' }, noremap = true, silent = true, desc = 'Move block down' },
    { '<M-k>', ':MoveBlock(-1)<CR>', mode = { 'v' }, noremap = true, silent = true, desc = 'Move block up' },
  },
}
