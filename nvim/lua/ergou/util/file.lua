---@class ergou.util.file
local M = {}

function M.copy_selector()
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
    filepath,
    modify(filepath, ':.'),
    modify(filepath, ':~'),
    filename,
    modify(filename, ':r'),
    modify(filename, ':e'),
  }

  local items = {
    '1. Absolute path: ' .. results[1],
    '2. Path relative to CWD: ' .. results[2],
    '3. Path relative to HOME: ' .. results[3],
    '4. Filename: ' .. results[4],
    '5. Filename without extension: ' .. results[5],
    '6. Extension of the filename: ' .. results[6],
  }

  vim.ui.select(items, {
    prompt = 'Choose to copy to clipboard:',
  }, function(choice)
    if choice then
      local i = tonumber(choice:sub(1, 1))
      if i then
        local result = results[i]
        vim.fn.setreg('+', result)
        vim.notify('Copied: ' .. result)
      else
        vim.notify('Invalid selection', vim.log.levels.WARN)
      end
    else
      vim.notify('Selection cancelled', vim.log.levels.INFO)
    end
  end)
end

return M
