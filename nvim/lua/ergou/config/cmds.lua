-- TODO: use snacks toggle
vim.api.nvim_create_user_command('FormattingAutoToggle', function()
  vim.g.autoformat_enabled = not vim.g.autoformat_enabled
  local status = vim.g.autoformat_enabled and 'enabled' or 'disabled'
  vim.notify('Auto formatting ' .. status, vim.log.levels.INFO)
end, {})
