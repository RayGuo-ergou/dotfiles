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
      'rafamadriz/friendly-snippets', -- useful snippets
      'onsails/lspkind.nvim', -- vs-code like pictograms
      'hrsh7th/cmp-nvim-lsp-document-symbol', -- source for document symbols
    },
    config = function()
      local auto_brackets_fts = { 'lua' }

      local cmp = require('cmp')

      local luasnip = require('luasnip')

      local cmp_select_next_item = function(fallback)
        if ergou.cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        else
          fallback()
        end
      end

      local cmp_select_prev_item = function(fallback)
        if ergou.cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        else
          fallback()
        end
      end

      -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
      require('luasnip.loaders.from_vscode').lazy_load()
      require('ergou.util.snips').setupSnips()

      cmp.setup({
        snippet = { -- configure how nvim-cmp interacts with snippet engine
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-k>'] = cmp.mapping(cmp_select_prev_item),
          ['<C-j>'] = cmp.mapping(cmp_select_next_item),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(), -- show completion suggestions
          ['<C-e>'] = cmp.mapping.abort(), -- close completion window
          ['<CR>'] = function(fallback)
            if ergou.cmp.visible() then
              ergou.create_undo()
              if cmp.confirm({ select = false }) then
                return
              end
            end
            return fallback()
          end,
          ['<Tab>'] = cmp.mapping(function(fallback)
            if ergou.has('copilot.suggestion') then
              if require('copilot.suggestion').is_visible() then
                require('copilot.suggestion').accept()
              end
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              cmp_select_next_item(fallback)
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(cmp_select_prev_item),
          ['<C-p>'] = function(fallback)
            return fallback()
          end,
          ['<C-n>'] = function(fallback)
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
        if vim.tbl_contains(auto_brackets_fts, vim.bo.filetype) then
          ergou.cmp.auto_brackets(event.entry)
        end
      end)

      -- seems I already got the documentation for snippets
      -- cmp.event:on('menu_opened', function(event)
      --   ergou.cmp.add_missing_snippet_docs(event.window)
      -- end)

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
