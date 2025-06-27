local timeout = 1500
---@type conform.FiletypeFormatter
local eslintFormat = { 'eslint_d' }
-- local eslintFormat = { lsp_format = 'prefer' }
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
          vue = eslintFormat,
          javascript = eslintFormat,
          typescript = eslintFormat,
          javascriptreact = eslintFormat,
          typescriptreact = eslintFormat,
          css = eslintFormat,
          scss = eslintFormat,
          html = eslintFormat,
          json = eslintFormat,
          jsonc = eslintFormat,
          json5 = eslintFormat,
          yaml = eslintFormat,
          markdown = eslintFormat,
          graphql = eslintFormat,
          lua = { 'stylua' },
          python = { 'isort', 'black' },
          php = { 'pint', 'phpcbf', stop_after_first = true },
          zsh = { 'shfmt' },
          sh = { 'shfmt' },
          bash = { 'shfmt' },
          liquid = { 'prettierd' },
          blade = { 'blade-formatter' },
        },
        format_on_save = function()
          local win_cfg = vim.api.nvim_win_get_config(0)

          local win_title = vim.iter(win_cfg.title or {}):flatten():totable()

          if vim.tbl_contains(win_title, 'SnacksScratchTitle') then
            vim.notify('Floating window, skip formatting.', vim.log.levels.INFO, {
              id = '__conform_format_on_save_snack',
            })
            return nil
          end
          if not vim.g.autoformat_enabled then
            return nil
          end

          local ft = vim.bo.filetype

          -- Check if the file path includes 'templates'
          -- Only for tools templates
          local file_path = vim.fn.expand('%:p')
          if string.find(file_path, 'templates') and string.find(file_path, 'rmvfy%-tools') then
            return nil
          end

          ---@type conform.FormatOpts
          local config = {
            lsp_format = 'fallback',
            async = false,
            timeout_ms = timeout,
          }

          if ft == 'php' then
            config.lsp_format = 'first'
          end

          -- do not format blade file with html lsp
          if ft == 'blade' then
            config.lsp_format = 'never'
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
