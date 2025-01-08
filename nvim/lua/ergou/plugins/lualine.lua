return {
  {
    'nvim-lualine/lualine.nvim',
    -- event = 'UIEnter',
    -- When enter shows alpha dashboard no need for lualine
    event = 'LazyFile',
    opts = function()
      return {
        options = {
          theme = 'catppuccin',
          globalstatus = true,
          disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'starter', 'snacks_dashboard' } },
        },
        tabline = {
          lualine_a = {},
          lualine_b = {
            'diagnostics',
            {
              'diff',
              symbols = {
                added = ergou.icons.git.added,
                modified = ergou.icons.git.modified,
                removed = ergou.icons.git.removed,
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
            {
              -- marco state
              function()
                return require('noice').api.status.mode.get()
              end,
              cond = function()
                return package.loaded['noice'] and require('noice').api.status.mode.has()
              end,
              color = { fg = Snacks.util.color('Constant') },
            },
          },
          lualine_c = {},
          lualine_x = {},
          lualine_y = {
            {
              function()
                return require('tinygit.statusline').branchState()
              end,
            },
            {
              function()
                return require('tinygit.statusline').blame()
              end,
              color = { fg = Snacks.util.color('Tag') },
            },
          },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = {
            'branch',
            {
              'windows',
            },
          },
          lualine_c = {},
          lualine_x = {
            {
              function()
                return vim.t.maximized and ergou.icons.others.maximize or ''
              end,
            },
            {
              function()
                return require('noice').api.status.search.get()
              end,
              cond = function()
                return package.loaded['noice'] and require('noice').api.status.search.has()
              end,
              color = { fg = Snacks.util.color('PreProc') },
            },
            {
              function()
                return require('noice').api.status.command.get()
              end,
              cond = function()
                return package.loaded['noice'] and require('noice').api.status.command.has()
              end,
              color = { fg = Snacks.util.color('Statement') },
            },
            {
              function()
                return '  ' .. require('dap').status()
              end,
              cond = function()
                return package.loaded['dap'] and require('dap').status() ~= ''
              end,
              color = { fg = Snacks.util.color('Debug') },
            },
            {
              require('lazy.status').updates,
              cond = require('lazy.status').has_updates,
              color = { fg = Snacks.util.color('Special') },
            },
            {
              'copilot',
              cond = function()
                return package.loaded['copilot.suggestion']
              end,
            },
          },
          lualine_y = {
            { 'progress', separator = ' ', padding = { left = 1, right = 1 } },
          },
        },
        extensions = { 'neo-tree', 'lazy', 'fzf' },
      }
    end,
  },
}
