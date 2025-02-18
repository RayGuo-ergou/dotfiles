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
    { '<M-Up>', '<cmd>Treewalker SwapUp<cr>', desc = 'Tree swap up' },
    { '<M-Down>', '<cmd>Treewalker SwapDown<cr>', desc = 'Tree swap down' },
    { '<M-Left>', '<cmd>Treewalker SwapLeft<cr>', desc = 'Tree swap left' },
    { '<M-Right>', '<cmd>Treewalker SwapRight<cr>', desc = 'Tree swap right' },
  },
}
