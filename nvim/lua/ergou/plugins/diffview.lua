return {
  'sindrets/diffview.nvim',
  opts = function()
    local actions = require('diffview.actions')
    local scrollKeyMapping = {
      ['<c-b>'] = false,
      ['<c-f>'] = false,
      { 'n', '<c-u>', actions.scroll_view(-0.25), { desc = 'Scroll the view up' } },
      { 'n', '<c-d>', actions.scroll_view(0.25), { desc = 'Scroll the view down' } },
    }
    return {
      keymaps = {
        file_panel = scrollKeyMapping,
        file_history_panel = scrollKeyMapping,
      },
      enhanced_diff_hl = true,
      hooks = {}, -- See ':h diffview-config-hooks'
    }
  end,
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
  keys = {
    {
      '<leader>dv',
      function()
        if next(require('diffview.lib').views) == nil then
          vim.cmd('DiffviewOpen')
        else
          vim.cmd('DiffviewClose')
        end
      end,
      desc = 'Toggle Diffview',
    },
  },
}
