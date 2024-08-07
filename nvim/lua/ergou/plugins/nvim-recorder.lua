return {
  'chrisgrieser/nvim-recorder',
  opts = {
    mapping = {
      -- I use c-q for visual block mode
      switchSlot = '<Nop>',
    },
    clear = true,
  }, -- required even with default settings, since it calls `setup()`
}
