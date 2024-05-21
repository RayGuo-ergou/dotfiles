return {
  'hrsh7th/nvim-cmp',
  event = 'LazyFile',
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
  },
  config = function()
    local cmp = require('cmp')

    local luasnip = require('luasnip')

    local cmp_select_next_item = function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end

    local cmp_select_prev_item = function(fallback)
      if cmp.visible() then
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
          -- Test the below later
          -- if cmp.core.view:visible() or vim.fn.pumvisible() == 1 then
          if cmp.visible() then
            Ergou.create_undo()
            if cmp.confirm({ select = false }) then
              return
            end
          end
          return fallback()
        end,
        ['<Tab>'] = cmp.mapping(function(fallback)
          if require('copilot.suggestion').is_visible() then
            require('copilot.suggestion').accept()
          else
            cmp_select_next_item(fallback)
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(cmp_select_prev_item),
      }),
      -- sources for autocompletion
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'path' }, -- file system paths
        { name = 'luasnip' }, -- snippets
        { name = 'buffer' }, -- text within current buffer
        { name = 'calc' }, -- simple calculator
      }),
      -- configure lspkind for vs-code like pictograms in completion menu
      formatting = {
        -- Keep the default formatting fields and expandable_indicator
        fields = { 'abbr', 'kind', 'menu' },
        expandable_indicator = true,
        format = Ergou.cmp.cmp_format,
      },
    })
    cmp.event:on('confirm_done', function(event)
      Ergou.cmp.auto_brackets(event.entry)
    end)

    -- seems I already got the documentation for snippets
    -- cmp.event:on('menu_opened', function(event)
    --   Ergou.cmp.add_missing_snippet_docs(event.window)
    -- end)

    local cmd_kepmap = {
      ['<C-j>'] = {
        c = function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end,
      },
      ['<C-k>'] = {
        c = function(fallback)
          if cmp.visible() then
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
      sources = {
        { name = 'buffer' },
      },
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
}
