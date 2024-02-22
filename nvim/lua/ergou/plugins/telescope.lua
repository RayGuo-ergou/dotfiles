local Util = require('ergou.util')
return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-tree/nvim-web-devicons',
    {
      'nvim-telescope/telescope-live-grep-args.nvim',
      -- This will not install any breaking changes.
      -- For major updates, this must be adjusted manually.
      version = '^1.0.0',
    },
  },
  keys = {
    -- find
    {
      '<leader>,',
      '<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>',
      desc = 'Switch Buffer',
    },
    { '<leader>ff', Util.telescope('files'), desc = 'Find Files (root dir)' },
    { '<leader>fF', Util.telescope('files', { cwd = false }), desc = 'Find Files (cwd)' },
    { '<leader>gf', '<cmd>Telescope git_files<cr>', desc = 'Find Files (git-files)' },
    { '<leader>:', '<cmd>Telescope command_history<cr>', desc = 'Command History' },
    {
      '<leader><space>',
      '<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>',
      desc = 'Find Files (root dir)',
    },
    { '<leader>fc', Util.telescope.config_files(), desc = 'Find Config File' },
    { '<leader>fr', '<cmd>Telescope oldfiles<cr>', desc = 'Recent' },
    { '<leader>fR', Util.telescope('oldfiles', { cwd = vim.loop.cwd() }), desc = 'Recent (cwd)' },
    -- git
    { '<leader>gc', '<cmd>Telescope git_commits<CR>', desc = 'commits' },
    { '<leader>gs', '<cmd>Telescope git_status<CR>', desc = 'status' },
    -- search
    { '<leader>s"', '<cmd>Telescope registers<cr>', desc = 'Registers' },
    { '<leader>sc', '<cmd>Telescope command_history<cr>', desc = 'Command History' },
    { '<leader>sC', '<cmd>Telescope commands<cr>', desc = 'Commands' },
    {
      '<leader>/',
      function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end,
      desc = 'Buffer',
    },
    { '<leader>sd', '<cmd>Telescope diagnostics bufnr=0<cr>', desc = 'Document diagnostics' },
    {
      '<leader>s/',
      Util.telescope('live_grep', { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }),
      desc = 'Search in opened files',
    },
    { '<leader>sD', '<cmd>Telescope diagnostics<cr>', desc = 'Workspace diagnostics' },
    { '<leader>sg', Util.telescope('live_grep'), desc = 'Grep (root dir)' },
    { '<leader>sG', Util.telescope('live_grep', { cwd = false }), desc = 'Grep (cwd)' },
    { '<leader>sh', '<cmd>Telescope help_tags<cr>', desc = 'Help Pages' },
    { '<leader>sH', '<cmd>Telescope highlights<cr>', desc = 'Search Highlight Groups' },
    { '<leader>sk', '<cmd>Telescope keymaps<cr>', desc = 'Key Maps' },
    { '<leader>sm', '<cmd>Telescope marks<cr>', desc = 'Jump to Mark' },
    { '<leader>sM', '<cmd>Telescope man_pages<cr>', desc = 'Man Pages' },
    { '<leader>so', '<cmd>Telescope vim_options<cr>', desc = 'Options' },
    { '<leader>sr', '<cmd>Telescope resume<cr>', desc = 'Resume' },
    { '<leader>sw', Util.telescope('grep_string', { word_match = '-w' }), desc = 'Word (root dir)' },
    { '<leader>sW', Util.telescope('grep_string', { cwd = false, word_match = '-w' }), desc = 'Word (cwd)' },
    { '<leader>sw', Util.telescope('grep_string'), mode = 'v', desc = 'Selection (root dir)' },
    { '<leader>sW', Util.telescope('grep_string', { cwd = false }), mode = 'v', desc = 'Selection (cwd)' },
    { '<leader>uC', Util.telescope('colorscheme', { enable_preview = true }), desc = 'Colorscheme with preview' },
    {
      '<leader>ss',
      function()
        require('telescope.builtin').lsp_document_symbols()
      end,
      desc = 'Goto Symbol',
    },
    {
      '<leader>sS',
      function()
        require('telescope.builtin').lsp_dynamic_workspace_symbols()
      end,
      desc = 'Goto Symbol (Workspace)',
    },
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
      Util.telescope('find_files', { no_ignore = true, default_text = line })()
    end
    local find_files_with_hidden = function()
      local action_state = require('telescope.actions.state')
      local line = action_state.get_current_line()
      Util.telescope('find_files', { hidden = true, default_text = line })()
    end

    telescope.setup({
      defaults = {
        prompt_prefix = ' ',
        selection_caret = ' ',
        path_display = { 'truncate' },
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
            ['<c-t>'] = open_with_trouble,
            ['<a-t>'] = open_selected_with_trouble,
            ['<a-i>'] = find_files_no_ignore,
            ['<a-h>'] = find_files_with_hidden,
            ['<C-Down>'] = actions.cycle_history_next,
            ['<C-Up>'] = actions.cycle_history_prev,
            ['<C-f>'] = actions.preview_scrolling_down,
            ['<C-b>'] = actions.preview_scrolling_up,
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
          },
          n = {
            ['q'] = actions.close,
          },
        },
      },
    })

    telescope.load_extension('fzf')
    telescope.load_extension('live_grep_args')
    telescope.load_extension('rest')

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
    -- To make telescope work with rest.nvim
    -- fd is required to be installed
    -- i have to link it via ln -s $(which fdfind) /usr/bin/fd
    -- as ubuntu 'fd' is taken in apt
    vim.keymap.set('n', '<leader>re', telescope.extensions.rest.select_env, { desc = '[R]eplace [E]nv' })
  end,
}
