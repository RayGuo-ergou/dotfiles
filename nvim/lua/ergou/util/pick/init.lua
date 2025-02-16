---@class ergou.util.pick
---@field public telescope ergou.util.pick.telescope
---@field public fzf ergou.util.pick.fzf
---@field public snacks ergou.util.pick.snacks
---@overload fun(command:string, opts?:ergou.util.pick.Opts): fun()
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.wrap(...)
  end,
  __index = function(t, k)
    ---@diagnostic disable-next-line: no-unknown
    t[k] = require('ergou.util.pick.' .. k)
    return t[k]
  end,
})
---@alias ErgouPickerName 'fzf'|'telescope'|'snacks'

---@class ergou.util.pick.picker
---@field picker ErgouPicker
---@field get fun(): LazyKeys[]

---@class ergou.util.pick.Opts: table<string, any>
---@field root? boolean
---@field cwd? string
---@field buf? number
---@field show_untracked? boolean

---@class ErgouPicker
---@field name ErgouPickerName
---@field open fun(command:string, opts?:ergou.util.pick.Opts)
---@field commands table<string, string>

---@type ErgouPicker?
M.picker = M.snacks.picker

---@param command? string
---@param opts? ergou.util.pick.Opts
function M.open(command, opts)
  if not M.picker then
    return Snacks.notify.error('ergou.pick: picker not set')
  end

  command = command ~= 'auto' and command or 'files'
  opts = opts or {}

  opts = vim.deepcopy(opts)

  if type(opts.cwd) == 'boolean' then
    Snacks.notify.warn('ergou.pick: opts.cwd should be a string or nil')
    opts.cwd = nil
  end

  if not opts.cwd and opts.root ~= false then
    opts.cwd = ergou.root({ buf = opts.buf })
  end

  command = M.picker.commands[command] or command
  M.picker.open(command, opts)
end

---@param command? string
---@param opts? ergou.util.pick.Opts
function M.wrap(command, opts)
  opts = opts or {}
  return function()
    ergou.pick.open(command, vim.deepcopy(opts))
  end
end

function M.config_files()
  return M.wrap('files', { cwd = vim.fn.stdpath('config') })
end

---@param count integer select menu item count
function M.select_height(count)
  return math.floor(math.min(vim.o.lines * 0.8 - 16, count + 2) + 0.5) + 16
end

---@param ks LazyKeys[]
---@param picker_name ErgouPickerName
function M.set_keymaps(ks, picker_name)
  local _keys = ks or {}

  if picker_name == M.picker.name then
    vim.list_extend(_keys, M[picker_name].get())
  end
  return _keys
end

return M
