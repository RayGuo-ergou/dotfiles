local lsp_util = require('ergou.util.lsp')
return {
  {
    'nvimtools/none-ls.nvim',
    event = 'LazyFile',
    enabled = not lsp_util.PHP.working_large_file,
    dependencies = { 'davidmh/cspell.nvim' },
    config = function()
      local null_ls = require('null-ls')
      local cspell = require('cspell')
      local util = require('ergou.util')

      local cspellConfig = {
        find_json = function()
          for _, file in ipairs(util.lsp.CSPELL_CONFIG_FILES) do
            local dotfiles_path = os.getenv('DOTFILES')
            if dotfiles_path then
              local path = util.root.find_file(file, dotfiles_path .. '/cspell')
              if path then
                return path
              end
            end
          end
          return nil
        end,
      }

      null_ls.setup({
        sources = {
          cspell.diagnostics.with({
            config = cspellConfig,
            diagnostics_postprocess = function(diagnostic)
              diagnostic.severity = vim.diagnostic.severity['HINT']
            end,
          }),
          cspell.code_actions.with({ config = cspellConfig }),
          null_ls.builtins.diagnostics.phpcs.with({
            extra_args = { '--standard=vendor/php-cs/ruleset.xml' },
          }),
          null_ls.builtins.diagnostics.zsh,
        },
      })
    end,
  },
}
