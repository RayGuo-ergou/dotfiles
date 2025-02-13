---@class ergou.util.pick.fzf
local M = {}

---@type ErgouPicker
M.picker = {
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

return M
