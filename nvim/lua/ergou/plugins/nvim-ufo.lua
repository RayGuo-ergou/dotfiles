return {
  'kevinhwang91/nvim-ufo',
  dependencies = { 'kevinhwang91/promise-async' },
  event = 'LazyFile',
  opts = {
    provider_selector = function()
      return { 'treesitter', 'indent' }
    end,
  },
  config = function(_, opts)
    require('ufo').setup(opts)

    vim.keymap.set('n', 'zk', function()
      local winid = require('ufo').peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end, { desc = 'Peek folded lines under cursor or show hover doc' })
  end,
}
