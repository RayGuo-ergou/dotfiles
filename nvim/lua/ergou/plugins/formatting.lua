local timeout = 1500
---@type conform.FiletypeFormatter
local eslint_format = { 'eslint_d' }
---@type conform.FiletypeFormatter
local json_format = {
  formatters = { 'eslint_d', 'jq' },
  -- If eslint can format do not run jq
  stop_after_first = true,
}

return {
  {
    'stevearc/conform.nvim',
    event = 'LazyFile',
    cmd = 'ConformInfo',
    opts = {
      formatters = {
        phpcbf = {
          prepend_args = { '--standard=vendor/php-cs/ruleset.xml' },
        },
      },
      formatters_by_ft = {
        vue = eslint_format,
        javascript = eslint_format,
        typescript = eslint_format,
        javascriptreact = eslint_format,
        typescriptreact = eslint_format,
        css = eslint_format,
        scss = eslint_format,
        html = eslint_format,
        json = json_format,
        jsonc = json_format,
        json5 = json_format,
        yaml = eslint_format,
        markdown = eslint_format,
        graphql = eslint_format,
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
          if string.find(file_path, 'removify%-hq') then
            config.lsp_format = 'never'
          else
            config.lsp_format = 'first'
          end
        end

        -- do not format blade file with html lsp
        if ft == 'blade' then
          config.lsp_format = 'never'
        end

        return config
      end,
    },
    keys = {
      {
        '<leader>cF',
        function()
          require('conform').format({
            lsp_fallback = 'always',
            async = false,
            timeout_ms = timeout,
          })
        end,
        desc = 'Format file or range with LSP Formatter',
      },
      {
        '<leader>cf',
        function()
          require('conform').format({
            lsp_fallback = true,
            async = false,
            timeout_ms = timeout,
          })
        end,
        desc = 'Format file or range',
      },
    },
  },
}
