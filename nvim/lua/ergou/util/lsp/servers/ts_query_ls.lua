---@type lspconfig.Config
return {
  settings = {
    parser_install_directories = {
      -- If using nvim-treesitter with lazy.nvim
      vim.fs.joinpath(vim.fn.stdpath('data'), '/site/parser/'),
    },
    -- E.g. zed support
    language_retrieval_patterns = {
      'languages/src/([^/]+)/[^/]+\\.scm$',
    },
  },
}
