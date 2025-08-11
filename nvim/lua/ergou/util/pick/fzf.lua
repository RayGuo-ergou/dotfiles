---@class ergou.util.pick.fzf: ergou.util.pick.picker
local M = {}

---@type ErgouPicker
M.picker = {
  name = 'fzf',
  commands = {
    files = 'files',
  },

  ---@param command string
  ---@param opts? ergou.util.pick.Opts
  open = function(command, opts)
    opts = opts or {}
    if opts.cmd == nil and command == 'git_files' and opts.show_untracked then
      opts.cmd = 'git ls-files --exclude-standard --cached --others'
    end
    return require('fzf-lua')[command](opts)
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
    { '<leader>gf', '<cmd>FzfLua git_files<cr>', desc = 'Find Files (git-files)' },
    { '<leader>ft', '<cmd>FzfLua treesitter<cr>', desc = 'Find Treesitter' },
    { '<leader>:', '<cmd>FzfLua command_history<cr>', desc = 'Command History' },
    {
      '<leader><space>',
      '<cmd>FzfLua buffers sort_mru=true<cr>',
      desc = 'Switch Buffer',
    },
    { '<leader>fc', ergou.pick.config_files(), desc = 'Find Config File' },
    { '<leader>fr', '<cmd>FzfLua oldfiles<cr>', desc = 'Recent' },
    { '<leader>/', '<cmd>FzfLua search_history<cr>', desc = 'Search History' },
    -- git
    { '<leader>gs', '<cmd>FzfLua git_status<CR>', desc = 'Git Status' },
    { '<leader>gS', '<cmd>FzfLua git_hunks<CR>', desc = 'Git Hunks' },
    --search
    { '<leader>s"', '<cmd>FzfLua registers<cr>', desc = 'Registers' },
    { '<leader>sc', '<cmd>FzfLua command_history<cr>', desc = 'Command History' },
    { '<leader>sC', '<cmd>FzfLua commands<cr>', desc = 'Commands' },
    { '<leader>sd', '<cmd>FzfLua diagnostics_document<cr>', desc = 'Document Diagnostics' },
    { '<leader>sD', '<cmd>FzfLua diagnostics_workspace<cr>', desc = 'Workspace Diagnostics' },
    { '<leader>sg', ergou.pick('live_grep_glob'), desc = 'Grep (root dir)' },
    { '<leader>sG', ergou.pick('live_grep_glob', { root = false }), desc = 'Grep (cwd)' },
    { '<leader>sh', '<cmd>FzfLua help_tags<cr>', desc = 'Help Pages' },
    { '<leader>sH', '<cmd>FzfLua highlights<cr>', desc = 'Search Highlight Groups' },
    { '<leader>sj', '<cmd>FzfLua jumps<cr>', desc = 'Jumplist' },
    { '<leader>sk', '<cmd>FzfLua keymaps<cr>', desc = 'Key Maps' },
    { '<leader>sl', '<cmd>FzfLua loclist<cr>', desc = 'Location List' },
    { '<leader>sM', '<cmd>FzfLua man_pages<cr>', desc = 'Man Pages' },
    { '<leader>sm', '<cmd>FzfLua marks<cr>', desc = 'Jump to Mark' },
    { '<leader>sr', '<cmd>FzfLua resume<cr>', desc = 'Resume' },
    { '<leader>sq', '<cmd>FzfLua quickfix<cr>', desc = 'Quickfix List' },
    { '<leader>sw', ergou.pick('grep_cword'), desc = 'Word (Root Dir)' },
    { '<leader>sW', ergou.pick('grep_cword', { root = false }), desc = 'Word (cwd)' },
    { '<leader>sw', ergou.pick('grep_visual'), mode = 'v', desc = 'Selection (Root Dir)' },
    { '<leader>sW', ergou.pick('grep_visual', { root = false }), mode = 'v', desc = 'Selection (cwd)' },
    {
      '<leader>ss',
      '<cmd>FzfLua lsp_document_symbols<cr>',
      mode = { 'n' },
      desc = 'Find document symbols',
    },
    {
      '<leader>sS',
      '<cmd>FzfLua lsp_workspace_symbols<cr>',
      mode = { 'n' },
      desc = 'Find workspace symbols',
    },
    -- UI
    { '<leader>uC', ergou.pick('colorschemes'), desc = 'Colorscheme with Preview' },
  }
end

return M
