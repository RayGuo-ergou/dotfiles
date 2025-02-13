return {
  {
    'echasnovski/mini.splitjoin',
    keys = {
      {
        'gS',
        desc = 'Toggle split or join',
      },
    },
    opts = {},
  },
  {
    'echasnovski/mini.align',
    keys = {
      {
        'ga',
        desc = 'align start',
      },
      {
        'gA',
        desc = 'align preview start',
      },
    },
    opts = {},
  },
  {
    'echasnovski/mini.hipatterns',
    event = 'LazyFile',
    opts = function()
      local hi = require('mini.hipatterns')
      return {
        highlighters = {
          hex_color = hi.gen_highlighter.hex_color({ priority = 2000 }),
          shorthand = {
            pattern = '()#%x%x%x()%f[^%x%w]',
            group = function(_, _, data)
              ---@type string
              local match = data.full_match
              local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
              local hex_color = '#' .. r .. r .. g .. g .. b .. b

              return MiniHipatterns.compute_hex_color_group(hex_color, 'bg')
            end,
            extmark_opts = { priority = 2000 },
          },
        },
      }
    end,
  },
  {
    'echasnovski/mini.ai',
    opts = function()
      local ai = require('mini.ai')
      return {
        custom_textobjects = {
          -- HACK: for html tags, see: https://github.com/echasnovski/mini.nvim/issues/110#issuecomment-1212277863
          t = false,
          b = false,
          a = ai.gen_spec.treesitter({ a = '@parameter.outer', i = '@parameter.inner' }),
          A = ai.gen_spec.treesitter({ a = '@assignment.outer', i = '@assignment.inner' }),
          c = ai.gen_spec.treesitter({ a = '@call.outer', i = '@call.inner' }),
          o = ai.gen_spec.treesitter({ -- code block
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          }),
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = '[%w_]' }), -- without dot in function name
        },
      }
    end,
  },
}
