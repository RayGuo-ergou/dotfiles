local bufferline_util = require('ergou.util.buffer')
return {
  'akinsho/bufferline.nvim',
  event = 'VeryLazy',
  keys = {
    { '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Toggle pin' },
    { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete non-pinned buffers' },
    { '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', desc = 'Delete other buffers' },
    { '<leader>br', '<Cmd>BufferLineCloseRight<CR>', desc = 'Delete buffers to the right' },
    { '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Delete buffers to the left' },
    { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev buffer' },
    { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next buffer' },
  },
  ---@class bufferline.UserConfig
  opts = function()
    local macchiato = require('catppuccin.palettes').get_palette('macchiato')
    return {
      options = {
        close_command = function(n)
          ergou.buffer.bufremove(n)
        end,
        right_mouse_command = function(n)
          ergou.buffer.bufremove(n)
        end,
        diagnostics = 'nvim_lsp',
        diagnostics_indicator = bufferline_util.diagnostics_symbol,
        separator_style = 'slant',
        always_show_bufferline = false,
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'Neo-tree',
            highlight = 'Directory',
            text_align = 'left',
          },
        },
      },
      highlights = {
        separator = { fg = macchiato.crust },
        separator_visible = { fg = macchiato.crust },
        separator_selected = { fg = macchiato.crust },
      },
    }
  end,
  config = function(_, opts)
    require('bufferline').setup(opts)
    -- Fix bufferline when restoring a session
    vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
      callback = function()
        vim.schedule(function()
          pcall(nvim_bufferline)
        end)
      end,
    })
  end,
}
