return {
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    dependencies = {
      { 'gonstoll/wezterm-types', lazy = true },
    },
    opts = {
      library = {
        { path = 'wezterm-types', mods = { 'wezterm' } },
        { path = 'nvim-lspconfig/lua', words = { 'lsp' } },
        { path = 'markdown.nvim/lua/render-markdown', words = { 'render%.md' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
        { path = 'lazy.nvim', words = { 'LazyVim', 'lazy' } },
      },
    },
  },
}
