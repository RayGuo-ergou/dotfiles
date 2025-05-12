return {
  -- Drop this for now as it will override the noice lsp hover
  {
    'MeanderingProgrammer/render-markdown.nvim',
    cmd = 'RenderMarkdown',
    enabled = false,
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      code = {
        width = 'block',
        position = 'right',
        style = 'language',
      },
    },
  },
  -- TODO: https://github.com/catppuccin/nvim/pull/854
  {
    'OXY2DEV/markview.nvim',
    -- XXX: Even tho in the doc it says should not lazy load but I don't see any issue with event `VeryLazy`
    event = 'VeryLazy',
    opts = {
      preview = {
        hybrid_modes = { 'n' },
        debounce = 0,
      },
    },
  },
}
