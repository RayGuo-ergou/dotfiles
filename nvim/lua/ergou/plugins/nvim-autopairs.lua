return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  opts = {}, -- this is equalent to setup({}) function
  config = function(_, opts)
    local npairs = require('nvim-autopairs')
    local basic = require('nvim-autopairs.rules.basic')
    local ts_conds = require('nvim-autopairs.ts-conds')
    local Rule = require('nvim-autopairs.rule')

    npairs.setup(opts)
    local config = vim.tbl_deep_extend('force', npairs.config, opts or {})

    local bracket = basic.bracket_creator(config)

    npairs.add_rules({
      bracket('<', '>'):with_pair(ts_conds.is_ts_node({ 'function', 'arguments' })),
    })

    -- For vue, e.g. v-if="a === ''"
    -- npairs.add_rules({
    --   Rule('\'', '\'', 'vue'):with_pair(ts_conds.is_ts_node({ 'program', 'attribute_value' })),
    -- })
  end,
}
