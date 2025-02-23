return {
  {
    'nvimtools/none-ls.nvim',
    -- wait until https://github.com/nvimtools/none-ls.nvim/pull/248 merged
    url = 'https://github.com/RayGuo-ergou/none-ls.nvim',
    event = 'LazyFile',
    -- Without sql treesitter plugin seems fine with even 10k lines of code
    -- enabled = not ergou.lsp.PHP.working_large_file,
    dependencies = { 'davidmh/cspell.nvim' },
    config = function()
      local null_ls = require('null-ls')
      local cspell = require('cspell')

      local cspellConfig = {
        find_json = function()
          for _, file in ipairs(ergou.lsp.cspell.cspell_config_files) do
            local dotfiles_path = os.getenv('DOTFILES')
            if dotfiles_path then
              local path = ergou.root.find_file(file, dotfiles_path .. '/cspell')
              if path then
                return path
              end
            end
          end
          return nil
        end,
      }

      -- XXX: code actions stop working in neovim nightly
      null_ls.setup({
        sources = {
          -- cspell.diagnostics.with({
          --   config = cspellConfig,
          --   diagnostics_postprocess = function(diagnostic)
          --     diagnostic.severity = vim.diagnostic.severity['HINT']
          --   end,
          -- }),
          -- cspell.code_actions.with({ config = cspellConfig }),
          null_ls.builtins.diagnostics.phpcs.with({
            extra_args = { '--standard=vendor/php-cs/ruleset.xml' },
          }),
          null_ls.builtins.diagnostics.zsh,
          null_ls.builtins.code_actions.ts_node_action,
        },
      })
    end,
  },
}
