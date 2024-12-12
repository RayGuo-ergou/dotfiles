---@class ergou.util.file
local M = {}

function M.copy_filename()
  -- Get current buffer's full path
  local filepath = vim.fn.expand('%:p')
  -- Get just the filename
  local filename = vim.fn.expand('%:t')
  local modify = vim.fn.fnamemodify

  -- Skip if no file is open
  if filepath == '' then
    vim.notify('No file open in current buffer', vim.log.levels.WARN)
    return
  end

  local results = {
    modify(filepath, ':.'),
    modify(filepath, ':~'),
    filepath,
    filename,
    modify(filename, ':r'),
    modify(filename, ':e'),
  }

  local items = {
    'Path relative to CWD: ' .. results[1],
    'Path relative to HOME: ' .. results[2],
    'Absolute path: ' .. results[3],
    'Filename: ' .. results[4],
    'Filename without extension: ' .. results[5],
    'Extension of the filename: ' .. results[6],
  }

  vim.ui.select(items, {
    prompt = 'Choose to copy to clipboard:',
  }, function(_, int)
    if int then
      local result = results[int]
      vim.fn.setreg('+', result)
      vim.notify('Copied: ' .. result)
    else
      vim.notify('Selection cancelled', vim.log.levels.INFO)
    end
  end)
end

return M
