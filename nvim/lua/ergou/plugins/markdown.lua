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
    lazy = false,

    -- For blink.cmp's completion
    -- source
    -- dependencies = {
    --     "saghen/blink.cmp"
    -- },
  },
}
