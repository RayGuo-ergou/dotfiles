return {
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
      -- numhl enabled so can make diagnostic has high priority as will see both anyway
      -- sign_priority = 1000,
      numhl = true,
      signs_staged = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
      },
      attach_to_untracked = true,
      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')
        local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- Actions
        -- visual mode
        map('v', '<leader>ghs', function()
          gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, 'stage git hunk')
        map('v', '<leader>ghr', function()
          gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, 'reset git hunk')
        -- normal mode
        map('n', '<leader>ghs', gitsigns.stage_hunk, 'git stage hunk')
        map('n', '<leader>ghr', gitsigns.reset_hunk, 'git reset hunk')
        map('n', '<leader>ghS', gitsigns.stage_buffer, 'git Stage buffer')
        map('n', '<leader>ghR', gitsigns.reset_buffer, 'git Reset buffer')
        map('n', '<leader>ghp', gitsigns.preview_hunk_inline, 'preview git hunk')
        map('n', '<leader>ghP', gitsigns.preview_hunk, 'preview git hunk')
        map('n', '<leader>ghb', function()
          gitsigns.blame_line({ full = true })
        end, 'git blame line')
        map('n', '<leader>ghd', gitsigns.diffthis, 'git diff against index')
        map('n', '<leader>ghD', function()
          gitsigns.diffthis('~')
        end, 'git diff against last commit')

        -- Jump to next/prev hunk
        local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(function()
          gitsigns.nav_hunk('next')
        end, function()
          gitsigns.nav_hunk('prev')
        end)
        local last_hunk_repeat, first_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(function()
          gitsigns.nav_hunk('last')
        end, function()
          gitsigns.nav_hunk('first')
        end)
        -- Jump to first/last hunk
        map({ 'n', 'x', 'o' }, ']H', last_hunk_repeat, 'jump to last git hunk')
        map({ 'n', 'x', 'o' }, '[H', first_hunk_repeat, 'jump to first git hunk')
        map({ 'n', 'x', 'o' }, ']h', next_hunk_repeat, 'jump to next git hunk')
        map({ 'n', 'x', 'o' }, '[h', prev_hunk_repeat, 'jump to prev git hunk')
        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'select git hunk')
      end,
    },
  },
  {
    'gitsigns.nvim',
    opts = function()
      Snacks.toggle({
        name = 'Git Signs',
        get = function()
          return require('gitsigns.config').config.signcolumn
        end,
        set = function(state)
          require('gitsigns').toggle_signs(state)
        end,
      }):map('<leader>uG')

      -- This is broken, if the change contains delete, it will not show
      -- Snacks.toggle({
      --   name = 'Git Signs Diff',
      --   get = function()
      --     -- HACK: I seriously don't have a better way, so keep this for now. I guess?
      --     return require('gitsigns.config').config.linehl and require('gitsigns.config').config.show_deleted
      --   end,
      --   set = function(state)
      --     require('gitsigns').toggle_deleted(state)
      --     require('gitsigns').toggle_linehl(state)
      --   end,
      -- }):map('<leader>gd')

      Snacks.toggle({
        name = 'Git Signs Current Line Blame',
        get = function()
          return require('gitsigns.config').config.current_line_blame
        end,
        set = function(state)
          require('gitsigns').toggle_current_line_blame(state)
        end,
      }):map('<leader>gtb')
    end,
  },
  {
    'chrisgrieser/nvim-tinygit',
    ---@type Tinygit.Config
    opts = {
      statusline = {
        blame = {
          icon = ' ',
        },
        branchState = {
          icons = {
            ahead = '󰮭 ',
            behind = '󱙝 ',
            diverge = '󱚠 ',
          },
        },
      },
      appearance = {
        backdrop = {
          enabled = false,
        },
      },
    },
    keys = {
      {
        '<leader>gc',
        function()
          require('tinygit').smartCommit()
        end,
        desc = 'Git commit',
      },
      {
        '<leader>gC',
        function()
          require('tinygit').amendNoEdit()
        end,
        desc = 'Git commit',
      },
      {
        '<leader>gP',
        function()
          require('tinygit').push()
        end,
        desc = 'Git push',
      },
    },
  },
}
