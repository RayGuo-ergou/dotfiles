return {
  'aaronik/treewalker.nvim',
  opts = {},
  ---@type LazyKeys[]
  ---Finally the arrow keys have a good mapping
  keys = {
    -- movement
    { '<Up>', '<cmd>Treewalker Up<cr>', desc = 'Tree walk up' },
    { '<Down>', '<cmd>Treewalker Down<cr>', desc = 'Tree walk down' },
    { '<Left>', '<cmd>Treewalker Left<cr>', desc = 'Tree walk left' },
    { '<Right>', '<cmd>Treewalker Right<cr>', desc = 'Tree walk right' },

    -- swapping
    { '<C-Up>', '<cmd>Treewalker SwapUp<cr>', desc = 'Tree swap up' },
    { '<C-Down>', '<cmd>Treewalker SwapDown<cr>', desc = 'Tree swap down' },
    { '<C-Left>', '<cmd>Treewalker SwapLeft<cr>', desc = 'Tree swap left' },
    { '<C-Right>', '<cmd>Treewalker SwapRight<cr>', desc = 'Tree swap right' },
  },
}
