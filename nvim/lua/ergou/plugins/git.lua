return {
  -- Open file on github
  {
    'tpope/vim-rhubarb',
    dependencies = {
      'tpope/vim-fugitive',
    },
    keys = {
      { '<leader>ghh', '<cmd>GBrowse<cr>', desc = 'Open current file on GitHub' },
    },
  },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = 'LazyFile',
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
      on_attach = function(bufnr)
        local git_util = require('ergou.util.git')
        local gitsigns = require('gitsigns')
        local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
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
        map('n', '<leader>ghu', gitsigns.undo_stage_hunk, 'undo stage hunk')
        map('n', '<leader>ghR', gitsigns.reset_buffer, 'git Reset buffer')
        map('n', '<leader>ghp', gitsigns.preview_hunk_inline, 'preview git hunk')
        map('n', '<leader>ghP', gitsigns.preview_hunk, 'preview git hunk')
        map('n', '<leader>ghb', function()
          gitsigns.blame_line({ full = false })
        end, 'git blame line')
        map('n', '<leader>ghd', gitsigns.diffthis, 'git diff against index')
        map('n', '<leader>ghD', function()
          gitsigns.diffthis('~')
        end, 'git diff against last commit')

        -- Toggles
        map('n', '<leader>gb', gitsigns.toggle_current_line_blame, 'toggle git blame line')
        map('n', '<leader>gd', gitsigns.toggle_deleted, 'toggle git show deleted')
        map('n', '<leader>gb', git_util.blame_line, 'Git Blame Line')

        -- Jump to next/prev hunk
        local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(function()
          gitsigns.nav_hunk('next')
        end, function()
          gitsigns.nav_hunk('prev')
        end)
        -- Jump to first/last hunk
        map('n', ']H', function()
          gitsigns.nav_hunk('last')
        end, 'jump to last git hunk')

        map('n', '[H', function()
          gitsigns.nav_hunk('first')
        end, 'jump to first git hunk')

        map({ 'n', 'x', 'o' }, ']h', next_hunk_repeat, 'jump to next git hunk')
        map({ 'n', 'x', 'o' }, '[h', prev_hunk_repeat, 'jump to prev git hunk')
        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'select git hunk')
      end,
    },
  },
  {
    'NeogitOrg/neogit',
    config = true,
    keys = {
      {
        '<leader>gn',
        function()
          local neogit = require('neogit')
          neogit.open()
        end,
        desc = 'Open Neogit',
      },
    },
  },
  {
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    keys = {
      { '<leader>gl', '<cmd>LazyGit<cr>', mode = { 'n' }, desc = 'Open lazygit' },
    },
  },
}
