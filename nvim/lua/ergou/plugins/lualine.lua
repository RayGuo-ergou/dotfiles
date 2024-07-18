return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'UIEnter',
    opts = function()
      local icons = require('ergou.util.icons')
      local ui = require('ergou.util.ui')

      return {
        options = {
          theme = 'catppuccin',
          globalstatus = true,
          disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'starter' } },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = {
            'branch',
            'diagnostics',
            {
              'windows',
            },
            -- {
            --   'buffers',
            --   symbols = icons.file.symbols,
            -- },
          },
          lualine_c = {},
          lualine_x = {
            {
              function()
                return require('tinygit.statusline').branchState()
              end,
            },
            {
              function()
                return require('tinygit.statusline').blame()
              end,
              color = ui.fg('Tag'),
            },
            {
              function()
                return vim.t.maximized and icons.others.maximize or ''
              end,
            },
            {
              function()
                return require('noice').api.status.search.get()
              end,
              cond = function()
                return package.loaded['noice'] and require('noice').api.status.search.has()
              end,
              color = ui.fg('PreProc'),
            },
            {
              function()
                return require('noice').api.status.command.get()
              end,
              cond = function()
                return package.loaded['noice'] and require('noice').api.status.command.has()
              end,
              color = ui.fg('Statement'),
            },
            {
              function()
                return require('noice').api.status.mode.get()
              end,
              cond = function()
                return package.loaded['noice'] and require('noice').api.status.mode.has()
              end,
              color = ui.fg('Constant'),
            },
            {
              function()
                return '  ' .. require('dap').status()
              end,
              cond = function()
                return package.loaded['dap'] and require('dap').status() ~= ''
              end,
              color = ui.fg('Debug'),
            },
            {
              require('lazy.status').updates,
              cond = require('lazy.status').has_updates,
              color = ui.fg('Special'),
            },
            {
              'copilot',
              cond = function()
                return package.loaded['copilot.suggestion']
              end,
            },
            {
              'diff',
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },
          lualine_y = {
            { 'progress', separator = ' ', padding = { left = 1, right = 1 } },
          },
        },
        extensions = { 'neo-tree', 'lazy' },
      }
    end,
  },
}
