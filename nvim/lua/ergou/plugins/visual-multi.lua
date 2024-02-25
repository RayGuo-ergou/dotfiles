return {
  'mg979/vim-visual-multi',
  branch = 'master',
  event = 'LazyFile',
  init = function()
    vim.g.VM_default_mappings = 0
    vim.g.VM_maps = {
      ['Find Under'] = '<C-d>',
    }
  end,
}
