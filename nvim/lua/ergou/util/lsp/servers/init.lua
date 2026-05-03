---@class ergou.util.lsp.servers
local M = {}

local function load_servers(names)
  local result = {}
  for _, name in ipairs(names) do
    result[name] = require('ergou.util.lsp.servers.' .. name)
  end
  return result
end

M.get = function()
  return load_servers({
    'clangd',
    'rust_analyzer',
    'vtsls',
    'ts_ls',
    'html',
    'eslint',
    'vue_ls',
    'intelephense',
    'phpactor',
    'marksman',
    'lua_ls',
    'bashls',
    'tailwindcss',
    'unocss',
    'shopify_theme_ls',
    'prismals',
    'emmet_language_server',
    'jsonls',
    'yamlls',
    'cssls',
    'taplo',
    'nil_ls',
    'typos_lsp',
    'zls',
    'ts_query_ls',
    'hyprls',
    'laravel_ls',
  })
end

M.get_native = function()
  return load_servers({ 'ast_grep' })
end

return M
