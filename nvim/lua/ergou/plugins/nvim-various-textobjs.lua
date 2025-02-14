return {
  'chrisgrieser/nvim-various-textobjs',
  opts = {
    keymaps = {
      useDefaults = false,
    },
  },
  keys = {
    {
      'ik',
      '<cmd>lua require("various-textobjs").key("inner")<cr>',
      mode = { 'o', 'x' },
    },
    {
      'ak',
      '<cmd>lua require("various-textobjs").key("outer")<cr>',
      mode = { 'o', 'x' },
    },
    {
      'iv',
      '<cmd>lua require("various-textobjs").value("inner")<cr>',
      mode = { 'o', 'x' },
    },
    {
      'av',
      '<cmd>lua require("various-textobjs").value("outer")<cr>',
      mode = { 'o', 'x' },
    },
  },
}
