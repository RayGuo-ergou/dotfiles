return {
  'sindrets/diffview.nvim',
  opts = {
    enhanced_diff_hl = true,
  },
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
