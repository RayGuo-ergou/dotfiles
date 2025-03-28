local function flash(prompt_bufnr)
  require('flash').jump({
    pattern = '^',
    label = { after = { 0, 0 } },
    search = {
      mode = 'search',
      exclude = {
        function(win)
          return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'TelescopeResults'
        end,
      },
    },
    action = function(match)
      local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
      picker:set_selection(match.pos[1] - 1)
    end,
  })
end
return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    keys = {
      {
        '<leader>su',
        '<cmd>Telescope undo<cr>',
        desc = 'undo history',
      },
      { '<leader>so', '<cmd>Telescope vim_options<cr>', desc = 'Options' },
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      local build_in = require('telescope.builtin')
      local open_with_trouble = function(...)
        return require('trouble.providers.telescope').open_with_trouble(...)
      end
      local open_selected_with_trouble = function(...)
        return require('trouble.providers.telescope').open_selected_with_trouble(...)
      end
      local find_files_no_ignore = function()
        local action_state = require('telescope.actions.state')
        local line = action_state.get_current_line()
        ergou.pick('find_files', { no_ignore = true, default_text = line })()
      end
      local find_files_with_hidden = function()
        local action_state = require('telescope.actions.state')
        local line = action_state.get_current_line()
        ergou.pick('find_files', { hidden = true, default_text = line })()
      end

      telescope.setup({
        defaults = {
          prompt_prefix = ' ',
          selection_caret = ' ',
          path_display = { 'truncate' },
          sorting_strategy = 'ascending', -- display results top->bottom
          layout_config = {
            prompt_position = 'top',
            width = 0.9,
            height = 0.9,
          },
          mappings = {
            i = {
              ['<c-t>'] = open_with_trouble,
              ['<a-t>'] = open_selected_with_trouble,
              ['<a-i>'] = find_files_no_ignore,
              ['<a-h>'] = find_files_with_hidden,
              ['<C-Down>'] = actions.cycle_history_next,
              ['<C-Up>'] = actions.cycle_history_prev,
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
              ['<c-x>'] = flash,
            },
            n = {
              ['q'] = actions.close,
            },
          },
        },
      })

      telescope.load_extension('fzf')

      -- Telescope live_grep in git root
      -- Function to find the git root directory based on the current buffer's path
      local function find_git_root()
        -- Use the current buffer's path as the starting point for the git search
        local current_file = vim.api.nvim_buf_get_name(0)
        local current_dir
        local cwd = vim.fn.getcwd()
        -- If the buffer is not associated with a file, return nil
        if current_file == '' then
          current_dir = cwd
        else
          -- Extract the directory from the current file's path
          current_dir = vim.fn.fnamemodify(current_file, ':h')
        end

        -- Find the Git root directory from the current file's path
        local git_root =
          vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
        if vim.v.shell_error ~= 0 then
          print('Not a git repository. Searching on current working directory')
          return cwd
        end
        return git_root
      end

      -- Custom live_grep function to search in git root
      local function live_grep_git_root()
        local git_root = find_git_root()
        if git_root then
          build_in.live_grep({
            search_dirs = { git_root },
          })
        end
      end
      vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

      vim.keymap.set('n', '<leader>fg', telescope.extensions.live_grep_args.live_grep_args, { desc = 'Live grep args' })
    end,
  },

  {
    'nvim-telescope/telescope.nvim',

    keys = function(_, k)
      return ergou.pick.set_keymaps(k, 'telescope')
    end,
  },
  {
    'debugloop/telescope-undo.nvim',
    event = 'LazyFile',
    config = function()
      ergou.on_load('telescope.nvim', function()
        require('telescope').load_extension('undo')
      end)
    end,
  },
  {
    'nvim-telescope/telescope-live-grep-args.nvim',
    event = 'LazyFile',
    -- This will not install any breaking changes.
    -- For major updates, this must be adjusted manually.
    config = function()
      ergou.on_load('telescope.nvim', function()
        require('telescope').load_extension('live_grep_args')
      end)
    end,
  },
  {
    'crispgm/telescope-heading.nvim',
    event = 'LazyFile',
    config = function()
      ergou.on_load('telescope.nvim', function()
        require('telescope').load_extension('heading')
      end)
    end,
  },
  {
    'folke/todo-comments.nvim',
    keys = function(_, ks)
      local _keys = ks or {}
      if ergou.pick.picker.name == 'telescope' then
        vim.list_extend(_keys, {
          {
            '<leader>st',
            '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>',
            desc = 'Todo/Fix/Fixme',
          },
          {
            '<leader>sT',
            '<cmd>TodoTelescope<cr>',
            desc = 'Todo',
          },
        })
      end
      return _keys
    end,
  },

  {
    'neovim/nvim-lspconfig',
    opts = function()
      local Keys = ergou.lsp.keymap.get()

      if ergou.pick.picker.name == 'telescope' then
        vim.list_extend(Keys, {
          {
            'gd',
            function()
              require('telescope.builtin').lsp_definitions({ reuse_win = true })
            end,
            desc = 'Goto Definition',
          },
          { 'grr', require('telescope.builtin').lsp_references, desc = 'Goto References' },
          {
            'gI',
            function()
              require('telescope.builtin').lsp_implementations({ reuse_win = true })
            end,
            desc = 'Goto Implementation',
          },
          {
            'gy',
            function()
              require('telescope.builtin').lsp_type_definitions({ reuse_win = true })
            end,
            desc = 'Goto Type',
          },
        })
      end
    end,
  },
}
