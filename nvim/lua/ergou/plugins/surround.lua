return {
  {
    'kylechui/nvim-surround',
    event = 'LazyFile',
    config = function()
      require('nvim-surround').setup()
    end,
  },
}
