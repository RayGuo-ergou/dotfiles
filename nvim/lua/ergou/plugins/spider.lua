return {
  'chrisgrieser/nvim-spider',
  keys = {
    { 'gw', '<cmd>lua require(\'spider\').motion(\'w\')<CR>', mode = { 'n', 'o', 'x' } },
  },
}
