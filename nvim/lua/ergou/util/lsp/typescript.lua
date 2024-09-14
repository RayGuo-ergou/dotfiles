---@class ergou.util.lsp.typescript
local M = {}
M = {}
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
  ---@param ctx lsp.HandlerContext
  ---@param config vim.diagnostic.Opts
  ['textDocument/publishDiagnostics'] = function(_, result, ctx, config)
    if result.diagnostics == nil then
      return
    end

    -- ignore some tsserver diagnostics
    local idx = 1
    while idx <= #result.diagnostics do
      local entry = result.diagnostics[idx]

      local formatter = ergou.tsformat[entry.code]
      entry.message = formatter and formatter(entry.message) or entry.message

      -- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
      if entry.code == 80001 then
        -- { message = "File is a CommonJS module; it may be converted to an ES module.", }
        table.remove(result.diagnostics, idx)
      else
        idx = idx + 1
      end
    end

    vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
  end,
}
---@param client vim.lsp.Client
---@param _ integer
M.on_attach = function(client, _)
  local existing_capabilities = vim.deepcopy(client.server_capabilities)

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

  client.server_capabilities = existing_capabilities
end

return M
