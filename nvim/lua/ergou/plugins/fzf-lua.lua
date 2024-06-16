return {
  'ibhagwan/fzf-lua',
  config = true,
  cmd = { 'FzfLua' },
  keys = {
    {
      '<C-e>',
      '<cmd>FzfLua<cr>',
      mode = { 'n' },
      desc = 'Open fzf-lua',
    },
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
