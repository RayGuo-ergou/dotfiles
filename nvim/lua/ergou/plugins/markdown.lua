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
      file_types = { 'markdown', 'norg', 'rmd', 'org' },
      code = {
        width = 'block',
        position = 'right',
      },
    },
  },
}
