---@class ergou.util.copy
local M = {}

function M.copy_filename()
  -- Get current buffer's full path
  local filepath = vim.fn.expand('%:p')
  -- Get just the filename
  local filename = vim.fn.expand('%:t')
  local line_number = vim.api.nvim_win_get_cursor(0)[1]
  local modify = vim.fn.fnamemodify
  local relative_cwd = modify(filepath, ':.')
  local relative_home = modify(filepath, ':~')
  local filename_no_extension = modify(filename, ':r')
  local extension = modify(filename, ':e')

  -- Skip if no file is open
  if filepath == '' then
    vim.notify('No file open in current buffer', vim.log.levels.WARN)
    return
  end

  local function add_line_number(str)
    return str .. ' +' .. line_number
  end

  local results = {
    relative_cwd,
    add_line_number(relative_cwd),
    relative_home,
    add_line_number(relative_home),
    filepath,
    filename,
    filename_no_extension,
    extension,
  }

  local items = {
    'Path relative to CWD: ' .. results[1],
    'Path relative to CWD with line number: ' .. results[2],
    'Path relative to HOME: ' .. results[3],
    'Path relative to HOME with line number: ' .. results[4],
    'Absolute path: ' .. results[5],
    'Filename: ' .. results[6],
    'Filename without extension: ' .. results[7],
    'Extension of the filename: ' .. results[8],
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

function M.copy_git_branch()
  -- Get Git branch names
  local function get_git_branches()
    local branches =
      vim.fn.systemlist([[git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short)']])
    if vim.v.shell_error ~= 0 then
      vim.notify('Not a Git repository', vim.log.levels.WARN)
      return nil -- Return nil if not in a Git repo
    end
    return branches
  end

  -- Get the current Git branch
  local current_branch = vim.fn.system('git branch --show-current'):gsub('\n', '')

  -- Fetch all branches
  local branches = get_git_branches()
  if not branches then
    vim.notify('No branch found', vim.log.levels.WARN)
    return
  end

  -- Prepare a table for branches with display names and actual values
  local items = {}

  -- Add current branch as the first option
  table.insert(items, current_branch)

  -- Add other branches
  for _, branch in ipairs(branches) do
    if branch ~= current_branch then
      table.insert(items, branch)
    end
  end

  -- Use vim.ui.select to choose a branch to copy
  vim.ui.select(items, {
    prompt = 'Choose a branch to copy to clipboard:',
  }, function(_, int)
    if int then
      local selected_branch = items[int]
      vim.fn.setreg('+', selected_branch)
      vim.notify('Copied: ' .. selected_branch)
    else
      vim.notify('Selection cancelled', vim.log.levels.INFO)
    end
  end)
end

return M
