return {
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    opts = {
      preview = {
        winblend = 0,
      },
    },
  },
  {
    'stevearc/qf_helper.nvim',
    ft = 'qf',
    opts = {
      quickfix = {
        default_bindings = false,
      },
      loclist = {
        default_bindings = false,
      },
    },
  },
  {
    'stevearc/quicker.nvim',
    event = 'LazyFile',
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
  },
}
