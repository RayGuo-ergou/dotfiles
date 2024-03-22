return {
  {
    'rest-nvim/rest.nvim',
    -- Lazy load otherwise it will break tree sitter
    ft = 'http',
    dependencies = {
      -- If having issue with install lua-curl (curl.h not found)
      -- Use sudo ln -s /usr/include/x86_64-linux-gnu/curl /usr/include/curl
      {
        'vhyrro/luarocks.nvim',
        config = function()
          require('luarocks-nvim').setup({ rocks = { 'lua-curl', 'nvim-nio', 'mimetypes', 'xml2lua' } })
        end,
      },
    },
    config = function()
      require('rest-nvim').setup()
    end,
    keys = {
      {
        '<leader>cr',
        '<cmd>Rest run<CR>',
        mode = { 'n', 'x' },
        desc = '[C]url [R]equest',
      },
    },
  },
}
