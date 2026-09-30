-- TODO: use snacks toggle
vim.api.nvim_create_user_command('FormattingAutoToggle', function()
  vim.g.autoformat_enabled = not vim.g.autoformat_enabled
  local status = vim.g.autoformat_enabled and 'enabled' or 'disabled'
  vim.notify('Auto formatting ' .. status, vim.log.levels.INFO)
end, {})

vim.api.nvim_create_user_command('Explorer', function(opts)
  local function error(message)
    vim.notify(message, vim.log.levels.ERROR, { title = 'Explorer' })
  end

  local path = opts.fargs[1]
  if not path then
    path = vim.api.nvim_buf_get_name(0)
    if vim.bo.buftype ~= '' or path == '' then
      return error('Current buffer is not a file')
    end
  else
    path = vim.fn.expand(path)
  end
  path = vim.fn.fnamemodify(path, ':p')

  local stat = vim.uv.fs_stat(path)
  if not stat or (stat.type ~= 'file' and stat.type ~= 'directory') then
    return error('Not a file or directory: ' .. path)
  end
  if #opts.fargs == 0 and stat.type ~= 'file' then
    return error('Current buffer is not a file')
  end

  for _, executable in ipairs({ 'xdg-mime', 'gtk-launch' }) do
    if vim.fn.executable(executable) ~= 1 then
      return error('Missing executable: ' .. executable)
    end
  end

  local result = vim.system({ 'xdg-mime', 'query', 'default', 'inode/directory' }, { text = true }):wait()
  local desktop = vim.trim(result.stdout or '')
  if result.code ~= 0 or desktop == '' then
    return error('Could not find the XDG-default file manager')
  end

  vim.system({ 'gtk-launch', desktop, vim.uri_from_fname(path) }, { text = true }, function(launch)
    if launch.code ~= 0 then
      vim.schedule(function()
        error('Could not launch file manager: ' .. vim.trim(launch.stderr or ''))
      end)
    end
  end)
end, { nargs = '?', complete = 'file', desc = 'Open a file or directory in the XDG-default file manager' })
