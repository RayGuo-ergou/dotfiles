return {
  'derektata/lorem.nvim',
  cmd = { 'LoremIpsum' },
  config = function()
    require('lorem').opts({})
  end,
}
