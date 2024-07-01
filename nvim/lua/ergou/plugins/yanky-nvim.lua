return {
  'gbprod/yanky.nvim',
  dependencies = {
    { 'kkharji/sqlite.lua' },
  },
  opts = function()
    local utils = require('yanky.utils')
    local mapping = require('yanky.telescope.mapping')
    return {
      ring = { storage = 'sqlite' },
      picker = {
        telescope = {
          use_default_mappings = false,
          mappings = {
            default = mapping.put('p'),
            i = {
              ['<c-x>'] = mapping.delete(),
              ['<c-r>'] = mapping.set_register(utils.get_default_register()),
            },
            n = {
              p = mapping.put('p'),
              P = mapping.put('P'),
              d = mapping.delete(),
              r = mapping.set_register(utils.get_default_register()),
            },
          },
        },
      },
    }
  end,
  keys = {
    {
      '<leader>p',
      function()
        require('telescope').extensions.yank_history.yank_history({})
      end,
      desc = 'Open Yank History',
    },
    {
      '<C-p>',
      function()
        require('telescope').extensions.yank_history.yank_history({})
      end,
      desc = 'Open Yank History',
      mode = { 'i' },
    },
    -- Disable for speed, native y and p are faster
    -- {
    --   'y',
    --   '<Plug>(YankyYank)',
    --   mode = { 'n', 'x' },
    --   desc = 'Yank text',
    -- },
    -- {
    --   'p',
    --   '<Plug>(YankyPutAfter)',
    --   mode = { 'n', 'x' },
    --   desc = 'Put yanked text after cursor',
    -- },
    -- {
    --   'P',
    --   '<Plug>(YankyPutBefore)',
    --   mode = { 'n', 'x' },
    --   desc = 'Put yanked text before cursor',
    -- },
    {
      '<a-p>',
      '<Plug>(YankyPreviousEntry)',
      desc = 'Select previous entry through yank history',
    },
    {
      '<a-n>',
      '<Plug>(YankyNextEntry)',
      desc = 'Select next entry through yank history',
    },
    {
      ']p',
      '<Plug>(YankyPutIndentAfterLinewise)',
      desc = 'Put indented after cursor (linewise)',
    },
    {
      '[p',
      '<Plug>(YankyPutIndentBeforeLinewise)',
      desc = 'Put indented before cursor (linewise)',
    },
    {
      ']P',
      '<Plug>(YankyPutIndentAfterLinewise)',
      desc = 'Put indented after cursor (linewise)',
    },
    {
      '[P',
      '<Plug>(YankyPutIndentBeforeLinewise)',
      desc = 'Put indented before cursor (linewise)',
    },
    {
      '>p',
      '<Plug>(YankyPutIndentAfterShiftRight)',
      desc = 'Put and indent right',
    },
    {
      '<p',
      '<Plug>(YankyPutIndentAfterShiftLeft)',
      desc = 'Put and indent left',
    },
    {
      '>P',
      '<Plug>(YankyPutIndentBeforeShiftRight)',
      desc = 'Put before and indent right',
    },
    {
      '<P',
      '<Plug>(YankyPutIndentBeforeShiftLeft)',
      desc = 'Put before and indent left',
    },
    {
      '=p',
      '<Plug>(YankyPutAfterFilter)',
      desc = 'Put after applying a filter',
    },
    {
      '=P',
      '<Plug>(YankyPutBeforeFilter)',
      desc = 'Put before applying a filter',
    },
  },
}
