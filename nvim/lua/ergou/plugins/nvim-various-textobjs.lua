return {
  'chrisgrieser/nvim-various-textobjs',
  events = 'LazyFile',
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
