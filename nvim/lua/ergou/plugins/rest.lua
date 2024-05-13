return {
  {
    'rest-nvim/rest.nvim',
    -- Lazy load otherwise it will break tree sitter
    ft = 'http',
    dependencies = {
      -- Perpare for lua-curl
      -- sudo apt install lua5.1 liblua5.1-0-dev
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
      require('ergou.util').on_load('telescope.nvim', function()
        require('telescope').load_extension('rest')
      end)
      require('rest-nvim').setup()
    end,
    keys = {
      {
        '<leader>rr',
        '<cmd>Rest run<CR>',
        mode = { 'n', 'x' },
        desc = '[R]est [R]equest',
      },
    },
  },
}
