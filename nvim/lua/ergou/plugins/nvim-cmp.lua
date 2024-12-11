return {
  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      'hrsh7th/cmp-buffer', -- source for text in buffer
      'hrsh7th/cmp-path', -- source for file system paths
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-calc',
      'L3MON4D3/LuaSnip', -- snippet engine
      'saadparwaiz1/cmp_luasnip', -- for autocompletion
      {
        'rafamadriz/friendly-snippets',
        config = function()
          -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
          require('luasnip.loaders.from_vscode').lazy_load()
          require('luasnip.loaders.from_vscode').lazy_load({ paths = { vim.fn.stdpath('config') .. '/snippets' } })
        end,
      },
      'onsails/lspkind.nvim', -- vs-code like pictograms
      'hrsh7th/cmp-nvim-lsp-document-symbol', -- source for document symbols
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local parse = require('cmp.utils.snippet').parse

      -- Snippet
      ergou.snips.setup_snipes()
      require('cmp.utils.snippet').parse = function(input)
        local ok, ret = pcall(parse, input)
        if ok then
          return ret
        end
        return ergou.cmp.snippet_preview(input)
      end

      cmp.setup({
        snippet = { -- configure how nvim-cmp interacts with snippet engine
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(), -- show completion suggestions
          ['<C-e>'] = cmp.mapping.abort(), -- close completion window
          ['<CR>'] = ergou.cmp.confirm({ select = false }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            local has_copilot, copilot = pcall(require, 'copilot.suggestion')
            if has_copilot then
              if copilot.is_visible() then
                copilot.accept()
              end
            elseif ergou.cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ['<C-p>'] = function(fallback)
            return fallback()
          end,
          ['<C-n>'] = function(fallback)
            if luasnip.expand_or_jumpable() then
              return luasnip.expand_or_jump()
            end
            return fallback()
          end,
        }),
        -- sources for autocompletion
        sources = cmp.config.sources({
          { name = 'npm', keyword_length = 4 },
          {
            name = 'nvim_lsp',
            entry_filter = ergou.cmp.cmp_lsp_entry_filter,
          },
          { name = 'path' }, -- file system paths
          { name = 'luasnip' }, -- snippets
          { name = 'buffer' }, -- text within current buffer
          { name = 'calc' }, -- simple calculator
          {
            name = 'lazydev',
            group_index = 0, -- set group index to 0 to skip loading LuaLS completions
          },
          { name = 'render-markdown' },
        }),
        -- configure lspkind for vs-code like pictograms in completion menu
        formatting = {
          -- Keep the default formatting fields and expandable_indicator
          fields = { 'abbr', 'kind', 'menu' },
          expandable_indicator = true,
          format = ergou.cmp.cmp_format,
        },
        sorting = ergou.cmp.cmp_sort(),
      })
      cmp.event:on('confirm_done', function(event)
        if vim.tbl_contains(ergou.cmp.AUTO_BRACKETS_FILETYPES, vim.bo.filetype) then
          ergou.cmp.auto_brackets(event.entry)
        end
      end)

      -- Add LSP snippet docs if exist
      cmp.event:on('menu_opened', function(event)
        ergou.cmp.add_missing_snippet_docs(event.window)
      end)

      -- Reset the cache at the start of each completion session
      cmp.event:on('menu_closed', function()
        local filetype = vim.bo.filetype

        if filetype == 'json' then
          ergou.cmp.json_filename = ''
        end

        if filetype == 'vue' then
          local bufnr = vim.api.nvim_get_current_buf()
          vim.b[bufnr]._vue_ts_cached_is_in_start_tag = nil
        end
      end)

      cmp.setup.filetype(ergou.sql_ft, {
        sources = {
          { name = 'vim-dadbod-completion' },
        },
      })

      local cmd_kepmap = {
        ['<C-j>'] = {
          c = function(fallback)
            if ergou.cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end,
        },
        ['<C-k>'] = {
          c = function(fallback)
            if ergou.cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end,
        },
      }
      -- `/` cmdline setup.
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(cmd_kepmap),
        sources = cmp.config.sources({
          { name = 'nvim_lsp_document_symbol' },
        }, {
          { name = 'buffer' },
        }),
      })
      -- `:` cmdline setup.
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(cmd_kepmap),
        sources = cmp.config.sources({
          { name = 'path' },
        }, {
          {
            name = 'cmdline',
            option = {
              ignore_cmds = { 'Man', '!' },
            },
          },
        }),
      })
    end,
  },
  {
    'David-Kunz/cmp-npm',
    url = 'https://github.com/RayGuo-ergou/cmp-npm',
    event = { 'BufRead package.json' },
    config = true,
  },
}
