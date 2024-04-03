return {
  'rmagatti/goto-preview',
  config = true,
  keys = {
    {
      'gpd',
      function()
        require('goto-preview').goto_preview_definition({})
      end,
      mode = { 'n' },
      desc = 'Goto Preview Definition',
    },
    {
      'gpt',
      function()
        require('goto-preview').goto_preview_type_definition({})
      end,
      mode = { 'n' },
      desc = 'Goto Preview Type Definition',
    },
    {
      'gpi',
      function()
        require('goto-preview').goto_preview_implementation({})
      end,
      mode = { 'n' },
      desc = 'Goto Preview Type Implementation',
    },
    {
      'gpD',
      function()
        require('goto-preview').goto_preview_declaration({})
      end,
      mode = { 'n' },
      desc = 'Goto Preview Declaration',
    },
    {
      'gpr',
      function()
        require('goto-preview').goto_preview_references()
      end,
      mode = { 'n' },
      desc = 'Goto Preview References',
    },

    {
      'gP',
      function()
        require('goto-preview').close_all_win()
      end,
      mode = { 'n' },
      desc = 'Close all Goto Preview windows',
    },
  },
}
