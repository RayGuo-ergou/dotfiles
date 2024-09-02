return {
  'kevinhwang91/nvim-ufo',
  url = 'https://github.com/RayGuo-ergou/nvim-ufo',
  branch = 'feature/nvim_11_ts_breaking_change',
  dependencies = { 'kevinhwang91/promise-async' },
  event = 'LazyFile',
  init = function()
    vim.o.foldcolumn = '0'
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
  opts = {
    provider_selector = function()
      return { 'treesitter', 'indent' }
    end,
  },
  keys = {
    {
      'zK',
      function()
        local winid = require('ufo').peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end,
      desc = 'Hover on fold or lsp',
    },
  },
}
