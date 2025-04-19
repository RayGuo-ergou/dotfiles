return {
  enabled = false,
  'chrisgrieser/nvim-various-textobjs',
  event = 'LazyFile',
  opts = {
    keymaps = {
      useDefaults = true,
      disabledDefaults = {
        -- aI and iI are still set for indent
        'ai',
        'ii',

        'al',
        'il',
      },
    },
  },
}
