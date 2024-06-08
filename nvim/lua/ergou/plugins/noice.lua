return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  ---@type NoiceConfig
  opts = {
    lsp = {
      progress = { enabled = false },
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
      },
      hover = {
        silent = true,
      },
      documentation = {
        opts = {
          win_options = { conceallevel = 0 },
        },
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = true, -- add a border to hover docs and signature help
    },
    popupmenu = {
      backend = 'cmp',
    },
    cmdline = {
      format = {
        cmdline = { icon = require('ergou.util').icons.others.terminal },
      },
    },
  },
  dependencies = {
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    'rcarriga/nvim-notify',
  },
  keys = {
    {
      '<leader>sn',
      '<cmd>Noice telescope<CR>',
      desc = 'Notifications History',
    },
    {
      '<leader>nh',
      '<cmd>Noice History<CR>',
      desc = 'Noice History in Quick fix list',
    },
  },
}
