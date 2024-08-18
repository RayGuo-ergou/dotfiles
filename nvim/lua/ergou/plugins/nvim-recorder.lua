return {
  'chrisgrieser/nvim-recorder',
  opts = {
    mapping = {
      -- I use c-q for visual block mode
      switchSlot = '<Nop>',
      startStopRecording = 'qq',
    },
    clear = true,
  }, -- required even with default settings, since it calls `setup()`
  keys = {
    -- these must match the keys in the mapping config below
    { 'q', desc = ' Start Recording' },
    { 'Q', desc = ' Play Recording' },
    { 'cq', desc = ' Edit Recording' },
    { 'dq', desc = ' Delete Recording' },
    { 'yq', desc = ' Yank Recording' },
  },
}
