return {
  'nvim-pack/nvim-spectre',
  build = 'bash build.sh',
  cmd = 'Spectre',
  opts = {
    open_cmd = 'noswapfile vnew',
    mapping = {
      ['resume_last_search'] = {
        map = '<leader>rs',
        cmd = '<cmd>lua require(\'spectre\').resume_last_search()<CR>',
        desc = 'repeat last search',
      },
    },
    default = {
      replace = {
        cmd = 'oxi',
      },
    },
  },
  keys = {
    {
      '<leader>sR',
      function()
        require('spectre').open()
      end,
      desc = 'Replace in files (Spectre)',
    },
  },
}
