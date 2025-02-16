---@class ergou.util.pick.telescope: ergou.util.pick.picker
local M = {}

---@type ErgouPicker
M.picker = {
  name = 'telescope',
  commands = {
    files = 'find_files',
  },
  -- this will return a function that calls telescope.
  -- cwd will default to lazyvim.util.get_root
  -- for `files`, git_files or find_files will be chosen depending on .git
  ---@param builtin string
  ---@param opts? ergou.util.pick.Opts
  open = function(builtin, opts)
    opts = opts or {}
    opts.follow = opts.follow ~= false
    if opts.cwd and opts.cwd ~= vim.uv.cwd() then
      local function open_cwd_dir()
        local action_state = require('telescope.actions.state')
        local line = action_state.get_current_line()
        ergou.pick.open(
          builtin,
          vim.tbl_deep_extend('force', {}, opts or {}, {
            root = false,
            default_text = line,
          })
        )
      end
      ---@diagnostic disable-next-line: inject-field
      opts.attach_mappings = function(_, map)
        -- opts.desc is overridden by telescope, until it's changed there is this fix
        map('i', '<a-c>', open_cwd_dir, { desc = 'Open cwd Directory' })
        return true
      end
    end

    require('telescope.builtin')[builtin](opts)
  end,
}

M.get = function()
  return {
    -- find
    {
      '<leader>,',
      '<cmd>Telescope buffers sort_mru=true<cr>',
      desc = 'Switch Buffer',
    },
    { '<leader>ff', ergou.pick('files'), desc = 'Find Files (root dir)' },
    { '<leader>fF', ergou.pick('files', { root = false }), desc = 'Find Files (cwd)' },
    { '<leader>gf', '<cmd>Telescope git_files<cr>', desc = 'Find Files (git-files)' },
    { '<leader>:', '<cmd>Telescope command_history<cr>', desc = 'Command History' },
    {
      '<leader><space>',
      '<cmd>Telescope buffers sort_mru=true<cr>',
      desc = 'Switch buffer',
    },
    { '<leader>ft', '<cmd>Telescope treesitter<cr>', desc = 'Treesitter' },
    { '<leader>fc', ergou.pick.config_files(), desc = 'Find Config File' },
    { '<leader>fr', '<cmd>Telescope oldfiles<cr>', desc = 'Recent' },
    { '<leader>fR', ergou.pick('oldfiles', { cwd = vim.uv.cwd() }), desc = 'Recent (cwd)' },
    -- git
    { '<leader>gs', '<cmd>Telescope git_status<CR>', desc = 'status' },
    -- search
    { '<leader>s"', '<cmd>Telescope registers<cr>', desc = 'Registers' },
    { '<leader>sc', '<cmd>Telescope command_history<cr>', desc = 'Command History' },
    { '<leader>sC', '<cmd>Telescope commands<cr>', desc = 'Commands' },
    {
      '<leader>/',
      function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_ivy({
          previewer = false,
        }))
      end,
      desc = 'Buffer',
    },
    { '<leader>sd', '<cmd>Telescope diagnostics bufnr=0<cr>', desc = 'Document diagnostics' },
    { '<leader>sD', '<cmd>Telescope diagnostics<cr>', desc = 'Workspace diagnostics' },
    {
      '<leader>s/',
      ergou.pick('live_grep', { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }),
      desc = 'Search in opened files',
    },
    { '<leader>sg', ergou.pick('live_grep'), desc = 'Grep (root dir)' },
    { '<leader>sG', ergou.pick('live_grep', { root = false }), desc = 'Grep (cwd)' },
    { '<leader>sh', '<cmd>Telescope help_tags<cr>', desc = 'Help Pages' },
    { '<leader>sH', '<cmd>Telescope highlights<cr>', desc = 'Search Highlight Groups' },
    { '<leader>sk', '<cmd>Telescope keymaps<cr>', desc = 'Key Maps' },
    { '<leader>sm', '<cmd>Telescope marks<cr>', desc = 'Jump to Mark' },
    { '<leader>sM', '<cmd>Telescope man_pages<cr>', desc = 'Man Pages' },
    { '<leader>sr', '<cmd>Telescope resume<cr>', desc = 'Resume' },
    { '<leader>sw', ergou.pick('grep_string', { word_match = '-w' }), desc = 'Word (root dir)' },
    { '<leader>sW', ergou.pick('grep_string', { root = false, word_match = '-w' }), desc = 'Word (cwd)' },
    { '<leader>sw', ergou.pick('grep_string'), mode = 'v', desc = 'Selection (root dir)' },
    { '<leader>sW', ergou.pick('grep_string', { root = false }), mode = 'v', desc = 'Selection (cwd)' },
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
    -- UI
    { '<leader>uC', ergou.pick('colorscheme', { enable_preview = true }), desc = 'Colorscheme with preview' },
  }
end

return M
