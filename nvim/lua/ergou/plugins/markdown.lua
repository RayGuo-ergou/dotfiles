return {
  {
    enabled = false,
    'OXY2DEV/markview.nvim',
    ft = 'markdown',
    keys = {
      {
        '<leader>mt',
        '<cmd>Markview toggleAll<cr>',
        desc = 'Toggle markview plugin',
      },
    },
  },
  {
    'MeanderingProgrammer/markdown.nvim',
    cmd = 'RenderMarkdown',
    ft = 'markdown',
    keys = {
      {
        '<leader>mt',
        '<cmd>RenderMarkdown toggle<cr>',
        desc = 'Toggle markdown plugin',
      },
    },
    ---@type render.md.UserConfig
    opts = {
      code = {
        width = 'block',
      },
    },
  },
}
