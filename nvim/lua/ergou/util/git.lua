--- @class ergou.util.git
local M = {}

---@param opts? {count?: number}|LazyCmdOptions
function M.blame_line(opts)
  opts = vim.tbl_deep_extend('force', {
    count = 3,
    filetype = 'git',
    size = {
      width = 0.6,
      height = 0.6,
    },
    border = 'rounded',
  }, opts or {})
  local cursor = vim.api.nvim_win_get_cursor(0)
  -- If there's none stashed code, the line number may not be correct
  local line = cursor[1]
  local file = vim.api.nvim_buf_get_name(0)
  local cmd = { 'git', 'log', '-n', opts.count, '-u', '-L', line .. ',+1:' .. file }
  return require('lazy.util').float_cmd(cmd, opts)
end

return M
