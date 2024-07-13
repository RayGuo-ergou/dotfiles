return {
  'ibhagwan/fzf-lua',
  config = true,
  cmd = { 'FzfLua' },
  keys = {
    {
      '<leader>ss',
      '<cmd>FzfLua lsp_document_symbols<cr>',
      mode = { 'n' },
      desc = 'Find document symbols',
    },
    {
      '<leader>sS',
      '<cmd>FzfLua lsp_workspace_symbols<cr>',
      mode = { 'n' },
      desc = 'Find workspace symbols',
    },
  },
}
