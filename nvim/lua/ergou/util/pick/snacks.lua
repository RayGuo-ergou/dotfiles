---@class ergou.util.pick.snacks: ergou.util.pick.picker
local M = {}

---@type ErgouPicker
M.picker = {
  name = 'snacks',
  commands = {
    files = 'files',
    live_grep = 'grep',
    oldfiles = 'recent',
  },
  ---@param source string
  ---@param opts? snacks.picker.Config
  open = function(source, opts)
    return Snacks.picker.pick(source, opts)
  end,
}

M.get = function()
  return {
    -- find
    {
      '<leader>,',
      function()
        Snacks.picker.buffers()
      end,
      desc = 'Switch Buffer',
    },
    { '<leader>ff', ergou.pick('files'), desc = 'Find Files (root dir)' },
    { '<leader>fF', ergou.pick('files', { root = false }), desc = 'Find Files (cwd)' },
    {
      '<leader>gf',
      function()
        Snacks.picker.git_files()
      end,
      desc = 'Find Files (git-files)',
    },
    {
      '<leader>ft',
      function()
        Snacks.picker.treesitter()
      end,
      desc = 'Find Treesitter',
    },
    {
      '<leader>:',
      function()
        Snacks.picker.command_history()
      end,
      desc = 'Command History',
    },
    {
      '<leader><space>',
      function()
        Snacks.picker.buffers()
      end,
      desc = 'Switch Buffer',
    },
    { '<leader>fc', ergou.pick('oldfiles'), desc = 'Find Config File' },
    { '<leader>fr', ergou.pick('oldfiles'), desc = 'Recent' },
    {
      '<leader>fR',
      function()
        Snacks.picker.recent({ filter = { cwd = true } })
      end,
      desc = 'Recent (cwd)',
    },
    {
      '<leader>/',
      function()
        Snacks.picker.search_history()
      end,
      desc = 'Search History',
    },
    -- git
    {
      '<leader>gs',
      function()
        Snacks.picker.git_status({
          win = {
            input = {
              keys = {
                ['<c-x>'] = { 'git_restore_no_confirm', mode = { 'n', 'i' }, nowait = false },
                ['<left>'] = { 'git_stage_only', mode = { 'n', 'i' } },
                ['<right>'] = { 'git_unstage_only', mode = { 'n', 'i' } },
              },
            },
          },
        })
      end,
      desc = 'Git Status',
    },
    {
      '<leader>gS',
      function()
        Snacks.picker.git_diff({
          win = {
            input = {
              keys = {
                ['<c-x>'] = { 'git_restore_no_confirm', mode = { 'n', 'i' }, nowait = false },
                ['<left>'] = { 'git_stage_only', mode = { 'n', 'i' } },
                ['<right>'] = { 'git_unstage_only', mode = { 'n', 'i' } },
              },
            },
          },
        })
      end,
      desc = 'Git Hunks',
    },
    --search
    {
      '<leader>s"',
      function()
        Snacks.picker.registers()
      end,
      desc = 'Registers',
    },
    {
      '<leader>sc',
      function()
        Snacks.picker.command_history()
      end,
      desc = 'Command History',
    },
    {
      '<leader>sC',
      function()
        Snacks.picker.commands()
      end,
      desc = 'Commands',
    },
    {
      '<leader>sd',
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = 'Document Diagnostics',
    },
    {
      '<leader>sD',
      function()
        Snacks.picker.diagnostics()
      end,
      desc = 'Workspace Diagnostics',
    },
    {
      '<leader>sg',
      ergou.pick('live_grep'),
      desc = 'Grep (root dir)',
    },
    { '<leader>sG', ergou.pick('live_grep', { root = false }), desc = 'Grep (cwd)' },
    {
      '<leader>sh',
      function()
        Snacks.picker.help()
      end,
      desc = 'Help Pages',
    },
    {
      '<leader>sH',
      function()
        Snacks.picker.highlights()
      end,
      desc = 'Search Highlight Groups',
    },
    {
      '<leader>sj',
      function()
        Snacks.picker.jumps()
      end,
      desc = 'Jumplist',
    },
    {
      '<leader>sk',
      function()
        Snacks.picker.keymaps()
      end,
      desc = 'Key Maps',
    },
    {
      '<leader>sl',
      function()
        Snacks.picker.loclist()
      end,
      desc = 'Location List',
    },
    {
      '<leader>sM',
      function()
        Snacks.picker.man()
      end,
      desc = 'Man Pages',
    },
    {
      '<leader>sm',
      function()
        Snacks.picker.marks()
      end,
      desc = 'Jump to Mark',
    },
    {
      '<leader>sr',
      function()
        Snacks.picker.resume()
      end,
      desc = 'Resume',
    },
    {
      '<leader>sq',
      function()
        Snacks.picker.qflist()
      end,
      desc = 'Quickfix List',
    },
    { '<leader>sw', ergou.pick('grep_word'), desc = 'Word (Root Dir)' },
    { '<leader>sW', ergou.pick('grep_word', { root = false }), desc = 'Word (cwd)' },
    {
      '<leader>uC',

      function()
        Snacks.picker.colorschemes()
      end,
      desc = 'Colorscheme with Preview',
    },
    {
      '<leader>ss',
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = 'LSP Symbols',
    },
    {
      '<leader>sS',
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = 'LSP Workspace Symbols',
    },
    {
      '<leader>su',
      function()
        Snacks.picker.undo()
      end,
      desc = 'Undotree',
    },
  }
end

return M
