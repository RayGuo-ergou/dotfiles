---@type lspconfig.Config
return {
  enabled = ergou.lsp.php.server_to_use == 'intelephense',

  settings = {
    intelephense = {
      files = {
        exclude = {
          '**/.git/**',
          '**/.svn/**',
          '**/.hg/**',
          '**/CVS/**',
          '**/.DS_Store/**',
          '**/node_modules/**',
          '**/bower_components/**',
          '**/vendor/**/{Tests,tests}/**',
          '**/.history/**',
          '**/vendor/**/vendor/**',
          '**/storage/framework/testing/_pest.php',
        },
      },
    },
  },

  -- Temporarily clear the index when restarting the server.
  init_options = {
    clearCache = true,
  },
}
