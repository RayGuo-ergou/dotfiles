return {
  {
    'stevearc/dressing.nvim',
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require('lazy').load({ plugins = { 'dressing.nvim' } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require('lazy').load({ plugins = { 'dressing.nvim' } })
        return vim.ui.input(...)
      end
    end,
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
        },
        hover = {
          silent = true,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
      popupmenu = {
        backend = 'cmp',
      },
    },
    dependencies = {
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      'rcarriga/nvim-notify',
    },
  },
  {
    'rcarriga/nvim-notify',
    keys = {
      {
        '<leader>un',
        function()
          require('notify').dismiss({ silent = true, pending = true })
        end,
        desc = 'Dismiss all Notifications',
      },
      {
        '<leader>sn',
        '<cmd> Telescope notify<CR>',
        desc = 'Notifications History',
      },
    },
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
      render = 'compact',
      stages = 'static',
    },
  },
  {
    'stevearc/aerial.nvim',
    config = function()
      local aerial = require('aerial')
      local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')
      local aerial_forward, aerial_backward = ts_repeat_move.make_repeatable_move_pair(aerial.next, aerial.prev)
      aerial.setup()
      vim.keymap.set('n', ']]', aerial_forward)
      vim.keymap.set('n', '[[', aerial_backward)
    end,
    keys = {
      {
        '<leader>ua',
        '<cmd>AerialToggle!<CR>',
        desc = 'Toggle Aerial',
      },
      {
        '[[',
        desc = 'Previous Aerial',
      },
      {
        ']]',
        desc = 'Next Aerial',
      },
    },
  },
  {
    'mvllow/modes.nvim',
    opts = {
      set_cursor = false,
    },
  },
}
