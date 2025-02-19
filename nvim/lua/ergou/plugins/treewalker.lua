return {
  'aaronik/treewalker.nvim',
  opts = {},
  ---@type LazyKeys[]
  ---Finally the arrow keys have a good mapping
  keys = {
    -- movement
    { '<Up>', '<cmd>Treewalker Up<cr>', desc = 'Tree walk up', silent = true },
    { '<Down>', '<cmd>Treewalker Down<cr>', desc = 'Tree walk down', silent = true },
    { '<Left>', '<cmd>Treewalker Left<cr>', desc = 'Tree walk left', silent = true },
    { '<Right>', '<cmd>Treewalker Right<cr>', desc = 'Tree walk right', silent = true },

    -- swapping
    { '<M-Up>', '<cmd>Treewalker SwapUp<cr>', desc = 'Tree swap up', silent = true },
    { '<M-Down>', '<cmd>Treewalker SwapDown<cr>', desc = 'Tree swap down', silent = true },
    { '<M-Left>', '<cmd>Treewalker SwapLeft<cr>', desc = 'Tree swap left', silent = true },
    { '<M-Right>', '<cmd>Treewalker SwapRight<cr>', desc = 'Tree swap right', silent = true },
  },
}
