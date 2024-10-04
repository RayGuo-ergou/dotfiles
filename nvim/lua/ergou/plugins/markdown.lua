return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    cmd = 'RenderMarkdown',
    ft = { 'markdown', 'norg', 'rmd', 'org' },
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
        position = 'right',
      },
    },
  },
}
