return {
  {
    'chrisgrieser/nvim-rip-substitute',
    cmd = 'RipSubstitute',
    keys = {
      {
        '<leader>rv',
        function()
          require('rip-substitute').sub()
        end,
        mode = { 'n', 'x' },
        desc = 'rip substitute selected',
      },
    },
  },
}
