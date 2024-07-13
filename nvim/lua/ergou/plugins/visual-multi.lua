return {
  {
    'mg979/vim-visual-multi',
    event = 'LazyFile',
    init = function()
      vim.g.VM_default_mappings = 0
      vim.g.VM_maps = {
        ['Find Under'] = '<leader>ts',
      }
      vim.g.VM_theme = 'codedark'

      local wk = require('which-key')

      wk.add({
        { '<leader>ts', desc = 'Toggle multi select current word' },
      })
    end,
  },
}
