local find_tsc_bin = function()
  local node_modules_vue_tsc_binary = vim.fn.findfile('node_modules/.bin/vue-tsc', '.;')
  local node_modules_tsc_binary = vim.fn.findfile('node_modules/.bin/tsc', '.;')

  if node_modules_vue_tsc_binary ~= '' then
    return node_modules_vue_tsc_binary
  end

  if node_modules_tsc_binary ~= '' then
    return node_modules_tsc_binary
  end

  return 'tsc'
end
return {
  -- NOTE: add tsx filetype if doing react
  { 'dmmulroy/ts-error-translator.nvim', opts = {}, ft = { 'typescript', 'vue' } },
  {
    'dmmulroy/tsc.nvim',
    opts = {
      bin_path = find_tsc_bin(),
    },
    cmd = { 'TSC' },
  },
  -- stable version
  {
    'OlegGulevskyy/better-ts-errors.nvim',
    url = 'https://github.com/RayGuo-ergou/better-ts-errors.nvim',
    cmd = { 'TsBetterError' },
    config = true,
  },
}
