---@class ergou.util.lsp.typescript
local M = {}

M.inlay_hints = {
  includeInlayEnumMemberValueHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayParameterNameHints = 'all',
  includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayVariableTypeHints = true,
}
M.filetypes = {
  'javascript',
  'javascriptreact',
  'javascript.jsx',
  'typescript',
  'typescriptreact',
  'typescript.tsx',
  'vue',
}
M.servers = { 'vtsls', 'ts_ls' }
M.server_to_use = 'vtsls'
M.vtsls_typescript_javascript_config = {
  updateImportsOnFileMove = { enabled = 'always' },
  suggest = {
    completeFunctionCalls = true,
  },
  inlayHints = {
    enumMemberValues = { enabled = true },
    functionLikeReturnTypes = { enabled = true },
    parameterNames = { enabled = 'all' },
    parameterTypes = { enabled = true },
    propertyDeclarationTypes = { enabled = true },
    variableTypes = { enabled = false },
  },
  tsserver = {
    maxTsServerMemory = 8192,
  },
}
M.handlers = {
  ---@param _ lsp.ResponseError
  ---@param result lsp.PublishDiagnosticsParams
  ['textDocument/publishDiagnostics'] = function(_, result, ...)
    if result.diagnostics == nil then
      return
    end

    -- ignore some tsserver diagnostics
    local idx = 1
    while idx <= #result.diagnostics do
      local entry = result.diagnostics[idx]

      local formatter = ergou.lsp.tsformat[entry.code]
      entry.message = formatter and formatter(entry.message) or entry.message

      -- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
      if entry.code == 80001 then
        -- { message = "File is a CommonJS module; it may be converted to an ES module.", }
        table.remove(result.diagnostics, idx)
      else
        idx = idx + 1
      end
    end

    vim.lsp.diagnostic.on_publish_diagnostics(_, result, ...)
  end,
}

M.get_vue_plugin = function()
  local vue_plugin = {}
  local has_mason, mason_registry = pcall(require, 'mason-registry')

  if has_mason then
    local has_vue_lsp = pcall(mason_registry.get_package, 'vue-language-server')
    if has_vue_lsp then
      local vue_ts_plugin_path = vim.fn.expand('$MASON/packages/vue-language-server/node_modules/@vue/language-server')
      vue_plugin = {
        name = '@vue/typescript-plugin',
        -- Maybe a function to get the location of the plugin is better?
        -- e.g. pnpm fallback to nvm fallback to default node path
        location = vue_ts_plugin_path,
        languages = { 'vue' },
        configNamespace = 'typescript',
        enableForWorkspaceTypeScriptVersions = true,
      }
    end
  end

  return vue_plugin
end

---@param client vim.lsp.Client
M.update_capabilities = function(client)
  local existing_capabilities = client.server_capabilities

  if existing_capabilities == nil then
    return
  end

  existing_capabilities.documentFormattingProvider = nil

  if client.name == 'vtsls' then
    local existing_filters = existing_capabilities.workspace.fileOperations.didRename.filters or {}
    local new_glob = '**/*.{ts,cts,mts,tsx,js,cjs,mjs,jsx,vue}'

    for _, filter in ipairs(existing_filters) do
      if filter.pattern and filter.pattern.matches == 'file' then
        filter.pattern.glob = new_glob
        break
      end
    end

    existing_capabilities.workspace.fileOperations.didRename.filters = existing_filters
  end

  -- vue 3.0.3
  if vim.bo.filetype == 'vue' then
    existing_capabilities.semanticTokensProvider.full = false
  else
    existing_capabilities.semanticTokensProvider.full = true
  end
  return existing_capabilities
end

---@type vim.lsp.client.on_attach_cb
M.on_attach = function(client, bufnr)
  if package.loaded['twoslash-queries'] then
    require('twoslash-queries').attach(client, bufnr)
  end

  M.update_capabilities(client)
end

return M
