---@class ergou.util.lsp.query
local M = {}

--- @return lspconfig.Config|nil
M.config = function()
  local has_mason, mason_registry = pcall(require, 'mason-registry')

  if not has_mason then
    vim.notify('Mason not installed for ts_query_ls.', vim.log.levels.ERROR)
    return
  end
  local has_ts_query = pcall(mason_registry.get_package, 'ts_query_ls')
  if not has_ts_query then
    vim.notify('ts_query_ls not installed from mason.', vim.log.levels.ERROR)
    return
  end
  local ts_query_exe_path = vim.fn.exepath('ts_query_ls')
  --- @type lspconfig.Config
  local server = {
    cmd = { ts_query_exe_path },
    settings = {
      parser_install_directories = {
        -- If using nvim-treesitter with lazy.nvim
        vim.fs.joinpath(vim.fn.stdpath('data'), '/lazy/nvim-treesitter/parser/'),
      },
      -- E.g. zed support
      language_retrieval_patterns = {
        'languages/src/([^/]+)/[^/]+\\.scm$',
      },
    },
  }
  return server
end

return M
