---@class ergou.util.pick
---@overload fun(command:string, opts?:ergou.util.pick.Opts): fun()
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.wrap(...)
  end,
})

---@class ergou.util.pick.Opts: table<string, any>
---@field root? boolean
---@field cwd? string
---@field buf? number
---@field show_untracked? boolean

---@class ErgouPicker
---@field name 'fzf'|'telescope'
---@field open fun(command:string, opts?:ergou.util.pick.Opts)
---@field commands table<string, string>

---@type ErgouPicker
local fzf_picker = {
  name = 'fzf',
  commands = {
    files = 'files',
  },

  ---@param command string
  ---@param opts? ergou.util.pick.Opts
  open = function(command, opts)
    opts = opts or {}
    if opts.cmd == nil and command == 'git_files' and opts.show_untracked then
      opts.cmd = 'git ls-files --exclude-standard --cached --others'
    end
    return require('fzf-lua')[command](opts)
  end,
}

---@type ErgouPicker
local telescope_picker = {
  name = 'telescope',
  commands = {
    files = 'find_files',
  },
  -- this will return a function that calls telescope.
  -- cwd will default to lazyvim.util.get_root
  -- for `files`, git_files or find_files will be chosen depending on .git
  ---@param builtin string
  ---@param opts? ergou.util.pick.Opts
  open = function(builtin, opts)
    opts = opts or {}
    opts.follow = opts.follow ~= false
    if opts.cwd and opts.cwd ~= vim.uv.cwd() then
      local function open_cwd_dir()
        local action_state = require('telescope.actions.state')
        local line = action_state.get_current_line()
        ergou.pick.open(
          builtin,
          vim.tbl_deep_extend('force', {}, opts or {}, {
            root = false,
            default_text = line,
          })
        )
      end
      ---@diagnostic disable-next-line: inject-field
      opts.attach_mappings = function(_, map)
        -- opts.desc is overridden by telescope, until it's changed there is this fix
        map('i', '<a-c>', open_cwd_dir, { desc = 'Open cwd Directory' })
        return true
      end
    end

    require('telescope.builtin')[builtin](opts)
  end,
}

---@type ErgouPicker?
M.picker = fzf_picker

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

return M
