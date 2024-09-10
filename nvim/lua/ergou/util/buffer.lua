--- @class ergou.util.buffer
local M = {}

function M.diagnostics_symbol(_, _, diagnostics_dict, _)
  local s = ' '
  local icons = ergou.icons

  for e, n in pairs(diagnostics_dict) do
    local sym = e == 'error' and icons.diagnostics.Error
      or (
        e == 'warning' and icons.diagnostics.Warn or (e == 'info' and icons.diagnostics.Info or icons.diagnostics.Hint)
      )
    s = s .. n .. sym
  end
  return s
end

---@param buf number?
function M.bufremove(buf)
  buf = buf or 0
  buf = buf == 0 and vim.api.nvim_get_current_buf() or buf

  -- If kulala, just force remove the buffer to avoid result buffer cannot show in split view
  if vim.fn.bufname(buf) == 'kulala://ui' then
    pcall(vim.cmd, 'bdelete! ' .. buf)
    return
  end

  if vim.bo.modified then
    local choice = vim.fn.confirm(('Save changes to %q?'):format(vim.fn.bufname()), '&Yes\n&No\n&Cancel')
    if choice == 0 or choice == 3 then -- 0 for <Esc>/<C-c> and 3 for Cancel
      return
    end
    if choice == 1 then -- Yes
      vim.cmd.write()
    end
  end

  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_call(win, function()
      if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then
        return
      end
      -- Try using alternate buffer
      local alt = vim.fn.bufnr('#')
      if alt ~= buf and vim.fn.buflisted(alt) == 1 then
        vim.api.nvim_win_set_buf(win, alt)
        return
      end

      -- Try using previous buffer
      local has_previous = pcall(vim.cmd, 'bprevious')
      if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then
        return
      end

      -- Create new listed buffer
      local new_buf = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_win_set_buf(win, new_buf)
    end)
  end
  if vim.api.nvim_buf_is_valid(buf) then
    pcall(vim.cmd, 'bdelete! ' .. buf)
  end
end

return M
