---@class ergou.util.pick.telescope
local M = {}

---@type ErgouPicker
M.picker = {
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

return M
