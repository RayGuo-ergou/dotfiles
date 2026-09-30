return {
  {
    'nvim-mini/mini.splitjoin',
    keys = {
      {
        'gS',
        desc = 'Toggle split or join',
      },
    },
    opts = {},
  },
  {
    'nvim-mini/mini.align',
    keys = {
      {
        'gA',
        desc = 'align start',
      },
    },
    opts = {
      mappings = {
        start = 'gA',
        start_with_preview = '',
      },
    },
  },
  {
    'nvim-mini/mini.hipatterns',
    event = 'LazyFile',
    opts = function()
      local hi = require('mini.hipatterns')
      return {
        highlighters = {
          hex_color = hi.gen_highlighter.hex_color({ priority = 2000 }),
          oklch_color = {
            pattern = '%f[%w]oklch%(%s*[^()]+%)',
            group = function(_, _, data)
              local components = data.full_match:match('^oklch%((.*)%)$')
              -- Highlight the opaque color when an alpha component is present.
              local color, alpha = components:match('^(.-)/%s*(.-)%s*$')
              local function number(value, percent_scale)
                local percent = value:match('^(.-)%%$')
                local result = tonumber(percent or value)
                if result == nil or result ~= result or math.abs(result) == math.huge then
                  return nil
                end
                return percent and result * percent_scale / 100 or result
              end
              if alpha and not number(alpha, 1) then
                return nil
              end

              local l, c, h = (color or components):match('^%s*(%S+)%s+(%S+)%s+(%S+)%s*$')
              if not l then
                return nil
              end
              -- CSS Color 4: 100% lightness = 1, 100% chroma = 0.4 (and 100% alpha = 1 above).
              -- https://www.w3.org/TR/css-color-4/#specifying-oklch
              l, c = number(l, 1), number(c, 0.4)
              local hue, unit = h:match('^(.-)(%a*)$')
              -- Convert to degrees: one turn = 360deg = 400grad = 2*pi radians.
              local hue_scale = ({ [''] = 1, deg = 1, grad = 0.9, rad = 180 / math.pi, turn = 360 })[unit]
              h = tonumber(hue)
              if not l or not c or not h or not hue_scale or h ~= h or math.abs(h) == math.huge then
                return nil
              end

              l, c, h = math.max(0, math.min(1, l)), math.max(0, c), math.rad(h * hue_scale % 360)
              local a, b = c * math.cos(h), c * math.sin(h)
              -- Inverse OKLab matrices from Björn Ottosson's reference implementation:
              -- https://bottosson.github.io/posts/oklab/#converting-from-linear-srgb-to-oklab
              -- These coefficients map OKLab to cube-root LMS; cubing undoes OKLab's nonlinearity.
              local ll = (l + 0.3963377774 * a + 0.2158037573 * b) ^ 3
              local mm = (l - 0.1055613458 * a - 0.0638541728 * b) ^ 3
              local ss = (l - 0.0894841775 * a - 1.2914855480 * b) ^ 3
              local function channel(value)
                value = math.max(0, math.min(1, value))
                -- Standard sRGB transfer function (linear RGB -> encoded sRGB):
                -- https://www.w3.org/TR/css-color-4/#color-conversion-code
                value = value <= 0.0031308 and 12.92 * value or 1.055 * value ^ (1 / 2.4) - 0.055
                -- Scale to an 8-bit channel (0..255), rounding to the nearest integer.
                return math.floor(value * 255 + 0.5)
              end
              -- Ottosson's inverse LMS -> linear sRGB matrix, then clip and gamma-encode each channel.
              local hex_color = string.format(
                '#%02x%02x%02x',
                channel(4.0767416621 * ll - 3.3077115913 * mm + 0.2309699292 * ss),
                channel(-1.2684380046 * ll + 2.6097574011 * mm - 0.3413193965 * ss),
                channel(-0.0041960863 * ll - 0.7034186147 * mm + 1.7076147010 * ss)
              )
              return hi.compute_hex_color_group(hex_color, 'bg')
            end,
            extmark_opts = { priority = 2000 },
          },
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
    'nvim-mini/mini.ai',
    event = 'VeryLazy',
    opts = function()
      local ai = require('mini.ai')
      return {
        custom_textobjects = {
          -- HACK: for html tags, see: https://github.com/nvim-mini/mini.nvim/issues/110#issuecomment-1212277863
          t = false,
          -- Brackets not very good when nested
          b = false,
          ['{'] = false,
          ['['] = false,
          ['<'] = false,
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
