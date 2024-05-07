local timeout = 1000
return {
  {
    'stevearc/conform.nvim',
    event = 'LazyFile',
    cmd = 'ConformInfo',
    config = function()
      local conform = require('conform')

      conform.setup({
        formatters = {
          phpcbf = {
            prepend_args = { '--standard=vendor/php-cs/ruleset.xml' },
          },
        },
        formatters_by_ft = {
          vue = { 'eslint_d' },
          javascript = { 'eslint_d' },
          typescript = { 'eslint_d' },
          javascriptreact = { 'eslint_d' },
          typescriptreact = { 'eslint_d' },
          css = { 'eslint_d' },
          scss = { 'eslint_d' },
          html = { 'eslint_d' },
          json = { 'eslint_d' },
          jsonc = { 'eslint_d' },
          json5 = { 'eslint_d' },
          yaml = { 'eslint_d' },
          markdown = { 'eslint_d' },
          graphql = { 'eslint_d' },
          lua = { 'stylua' },
          python = { 'isort', 'black' },
          php = { { 'pint', 'phpcbf' } },
          zsh = { 'shfmt' },
          sh = { 'shfmt' },
          bash = { 'shfmt' },
          liquid = { 'prettierd' },
        },
        format_on_save = function()
          local ft = vim.bo.filetype

          local config = {
            lsp_fallback = true,
            async = false,
            timeout_ms = timeout,
          }

          if ft == 'php' then
            config.lsp_fallback = 'always'
          end
          return config
        end,
      })

      vim.keymap.set({ 'n', 'v' }, '<leader>cF', function()
        conform.format({
          lsp_fallback = 'always',
          async = false,
          timeout_ms = timeout,
        })
      end, { desc = 'Format file or range with LSP Formatter' })

      vim.keymap.set({ 'n', 'v' }, '<leader>cf', function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = timeout,
        })
      end, { desc = 'Format file or range' })
    end,
  },
}
