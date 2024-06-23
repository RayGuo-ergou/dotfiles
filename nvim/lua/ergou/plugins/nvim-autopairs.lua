return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  opts = {}, -- this is equalent to setup({}) function
  config = function(_, opts)
    local npairs = require('nvim-autopairs')
    local basic = require('nvim-autopairs.rules.basic')

    npairs.setup(opts)
    local config = vim.tbl_deep_extend('force', npairs.config, opts or {})

    local bracket = basic.bracket_creator(config)

    npairs.add_rules({
      bracket('<', '>'),
    })
  end,
}
