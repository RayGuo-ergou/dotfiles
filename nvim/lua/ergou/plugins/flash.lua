return {
  'folke/flash.nvim',
  url = 'https://github.com/RayGuo-ergou/flash.nvim',
  ---@type Flash.Config
  opts = {
    modes = {
      treesitter = {
        -- Select and perform action, don't have to select
        labels = '',
      },
    },
  },
  keys = {
    {
      '<c-space>',
      mode = { 'n', 'o', 'x' },
      function()
        require('flash').treesitter({
          actions = {
            ['<c-space>'] = 'next',
            ['<BS>'] = 'prev',
          },
        })
      end,
      desc = 'Treesitter Incremental Selection',
    },
    {
      's',
      mode = { 'n', 'x' },
      function()
        require('flash').jump()
      end,
      desc = 'Flash',
    },
    {
      'S',
      mode = { 'n' },
      function()
        require('flash').treesitter()
      end,
      desc = 'Flash Treesitter',
    },
    {
      'r',
      mode = 'o',
      function()
        require('flash').remote()
      end,
      desc = 'Remote Flash',
    },
    {
      'R',
      mode = { 'o', 'x' },
      function()
        require('flash').treesitter_search()
      end,
      desc = 'Treesitter Search',
    },
    {
      '<c-s>',
      mode = { 'c' },
      function()
        require('flash').toggle()
      end,
      desc = 'Toggle Flash Search',
    },
    {
      '<leader>jj',
      mode = { 'n' },
      function()
        require('flash').jump({
          search = { mode = 'search', max_length = 0 },
          label = { after = { 0, 0 } },
          pattern = '^',
        })
      end,
      desc = 'Jump to a line',
    },
    {
      'f',
      mode = { 'n' },
      desc = 'Find next char',
    },
    {
      'F',
      mode = { 'n' },
      desc = 'Find prev char',
    },
    {
      't',
      mode = { 'n' },
      desc = 'Find next char (before target char)',
    },
    {
      'T',
      mode = { 'n' },
      desc = 'Find prev char (after target char)',
    },
  },
}
