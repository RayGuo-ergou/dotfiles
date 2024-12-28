return {
  {
    'mg979/vim-visual-multi',
    event = 'LazyFile',
    init = function()
      vim.g.VM_default_mappings = 0
      vim.g.VM_set_statusline = 0
      vim.g.VM_leader = '\\'
      vim.g.VM_add_cursor_at_pos_no_mappings = 1

      --- @see wiki https://github.com/mg979/vim-visual-multi/wiki/Mappings
      vim.g.VM_maps = {
        -- Normal mode
        ['Find Under'] = '<leader>mt',
        ['Find Subword Under'] = '<leader>mt',
        ['Add Cursor Down'] = '<M-Down>',
        ['Add Cursor Up'] = '<M-Up>',
        ['Start Regex Search'] = '<leader>mr',
        ['Select All'] = '<leader>mA',
        ['Add Cursor At Pos'] = '<leader>ma',

        -- Visual mode
        ['Visual Add'] = '<leader>mt',
        ['Visual Regex'] = '<leader>mr',
        ['Visual All'] = '<leader>mA',
        ['Visual Find'] = '<leader>mf',
        ['Visual Cursors'] = '<leader>mc',

        -- Buffer mappings
        ['Goto Next'] = '}',
        ['Goto Prev'] = '{',
      }
      vim.g.VM_theme = 'codedark'

      local wk = require('which-key')

      --TODO: add descs
      wk.add({
        { '<leader>mt', desc = 'Toggle multi select current word' },
      })
    end,
  },
}
