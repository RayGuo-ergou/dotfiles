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
          require('luarocks').setup({ rocks = { 'lua-curl', 'nvim-nio', 'mimetypes', 'xml2lua' } })
        end,
      },
    },
    config = function()
      require('rest-nvim').setup()
    end,
    keys = {
      {
        '<leader>cr',
        '<Plug>RestNvim',
        mode = { 'n', 'x' },
        desc = '[C]url [R]equest',
      },
      {
        '<leader>cp',
        '<Plug>RestNvimPreview',
        mode = { 'n', 'x' },
        desc = '[C]url [P]review',
      },
    },
  },
}
