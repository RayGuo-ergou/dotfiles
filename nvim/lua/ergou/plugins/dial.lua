local M = {}

---@param increment boolean
---@param g? boolean
function M.dial(increment, g)
  local mode = vim.fn.mode(true)
  -- Use visual commands for VISUAL 'v', VISUAL LINE 'V' and VISUAL BLOCK '\22'
  local is_visual = mode == 'v' or mode == 'V' or mode == '\22'
  local func = (increment and 'inc' or 'dec') .. (g and '_g' or '_') .. (is_visual and 'visual' or 'normal')
  local group = vim.g.dials_by_ft[vim.bo.filetype] or 'default'
  return require('dial.map')[func](group)
end

return {
  'monaqa/dial.nvim',
  desc = 'Increment and decrement numbers, dates, and more',
  -- stylua: ignore
  keys = {
    { "<C-a>", function() return M.dial(true) end, expr = true, desc = "Increment", mode = {"n", "v"} },
    { "<C-x>", function() return M.dial(false) end, expr = true, desc = "Decrement", mode = {"n", "v"} },
    { "g<C-a>", function() return M.dial(true, true) end, expr = true, desc = "Increment", mode = {"n", "v"} },
    { "g<C-x>", function() return M.dial(false, true) end, expr = true, desc = "Decrement", mode = {"n", "v"} },
  },
  opts = function()
    local augend = require('dial.augend')

    local logical_alias = augend.constant.new({
      elements = { '&&', '||' },
      word = false,
      cyclic = true,
    })

    local ordinal_numbers = augend.constant.new({
      -- elements through which we cycle. When we increment, we go down
      -- On decrement we go up
      elements = {
        'first',
        'second',
        'third',
        'fourth',
        'fifth',
        'sixth',
        'seventh',
        'eighth',
        'ninth',
        'tenth',
      },
      -- if true, it only matches strings with word boundary. firstDate wouldn't work for example
      word = false,
      -- do we cycle back and forth (tenth to first on increment, first to tenth on decrement).
      -- Otherwise nothing will happen when there are no further values
      cyclic = true,
    })

    local weekdays = augend.constant.new({
      elements = {
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      },
      word = true,
      cyclic = true,
    })

    local months = augend.constant.new({
      elements = {
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      },
      word = true,
      cyclic = true,
    })

    local capitalized_boolean = augend.constant.new({
      elements = {
        'True',
        'False',
      },
      word = true,
      cyclic = true,
    })

    local tailwind_color = augend.user.new({
      find = require('dial.augend.common').find_pattern('%a+%-%a+%-%d?%d%d'),
      add = function(text, addend, cursor)
        local _, _, prefix, color = string.find(text, '(%a+%-%a+%-)(%d?%d%d)')
        ---@type number
        ---@diagnostic disable-next-line: assign-type-mismatch
        color = tonumber(color)

        if addend > 0 then
          for _ = 1, addend do
            if color >= 950 then
              break
            end

            if color == 50 then
              color = 100
            elseif color == 900 then
              color = 950
            elseif math.fmod(color, 100) == 0 then
              color = color + 100
            end
          end
        elseif addend < 0 then
          for _ = 1, math.abs(addend) do
            if color <= 50 then
              break
            end

            if color == 100 then
              color = 50
            elseif color == 950 then
              color = 900
            elseif math.fmod(color, 100) == 0 then
              color = color - 100
            end
          end
        end
        text = prefix .. color
        cursor = #text
        ---@diagnostic disable-next-line: redundant-return-value
        return { text = text, cursor = cursor }
      end,
    })

    return {
      dials_by_ft = {
        css = 'css',
        vue = 'vue',
        javascript = 'typescript',
        typescript = 'typescript',
        typescriptreact = 'typescript',
        javascriptreact = 'typescript',
        json = 'json',
        lua = 'lua',
        markdown = 'markdown',
        sass = 'css',
        scss = 'css',
      },
      groups = {
        default = {
          augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
          augend.integer.alias.decimal_int, -- nonnegative and negative decimal number
          augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
          augend.date.alias['%Y/%m/%d'], -- date (2022/02/19, etc.)
          ordinal_numbers,
          weekdays,
          months,
          capitalized_boolean,
          augend.constant.alias.bool, -- boolean value (true <-> false)
          logical_alias,
        },
        vue = {
          augend.constant.new({ elements = { 'let', 'const' } }),
          augend.hexcolor.new({ case = 'lower' }),
          augend.hexcolor.new({ case = 'upper' }),
          tailwind_color,
        },
        typescript = {
          augend.constant.new({ elements = { 'let', 'const' } }),
          tailwind_color,
        },
        css = {
          augend.hexcolor.new({
            case = 'lower',
          }),
          augend.hexcolor.new({
            case = 'upper',
          }),
        },
        markdown = {
          augend.constant.new({
            elements = { '[ ]', '[x]' },
            word = false,
            cyclic = true,
          }),
          augend.misc.alias.markdown_header,
        },
        json = {
          augend.semver.alias.semver, -- versioning (v1.1.2)
        },
        lua = {
          augend.constant.new({
            elements = { 'and', 'or' },
            word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
            cyclic = true, -- "or" is incremented into "and".
          }),
        },
      },
    }
  end,
  config = function(_, opts)
    -- copy defaults to each group
    for name, group in pairs(opts.groups) do
      if name ~= 'default' then
        vim.list_extend(group, opts.groups.default)
      end
    end
    require('dial.config').augends:register_group(opts.groups)
    vim.g.dials_by_ft = opts.dials_by_ft
  end,
}
