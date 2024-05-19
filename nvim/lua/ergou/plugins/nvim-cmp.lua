return {
  'hrsh7th/nvim-cmp',
  event = 'LazyFile',
  dependencies = {
    'hrsh7th/cmp-buffer', -- source for text in buffer
    'hrsh7th/cmp-path', -- source for file system paths
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-cmdline',
    'L3MON4D3/LuaSnip', -- snippet engine
    'saadparwaiz1/cmp_luasnip', -- for autocompletion
    'rafamadriz/friendly-snippets', -- useful snippets
    'onsails/lspkind.nvim', -- vs-code like pictograms
  },
  config = function()
    local cmp = require('cmp')

    local luasnip = require('luasnip')

    local lspkind = require('lspkind')

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
            if cmp.confirm({ select = true }) then
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
      }),
      -- configure lspkind for vs-code like pictograms in completion menu
      formatting = {
        -- Keep the default formatting fields and expandable_indicator
        fields = { 'abbr', 'kind', 'menu' },
        expandable_indicator = true,
        format = function(entry, vim_item)
          local item_with_kind = lspkind.cmp_format({
            maxwidth = 50,
            ellipsis_char = '...',
            preset = 'codicons',
            show_labelDetails = true,
            menu = {
              buffer = '[Buffer]',
              nvim_lsp = '[LSP]',
              luasnip = '[LuaSnip]',
              nvim_lua = '[Lua]',
              latex_symbols = '[Latex]',
            },
          })(entry, vim_item)

          local completion_item = entry.completion_item
          local completion_context = completion_item.detail
            or completion_item.labelDetails and completion_item.labelDetails.description
            or nil
          if completion_context ~= nil and completion_context ~= '' then
            local truncated_context = string.sub(completion_context, 1, 30)
            if truncated_context ~= completion_context then
              truncated_context = truncated_context .. '...'
            end
            item_with_kind.menu = item_with_kind.menu .. ' ' .. truncated_context
          end
          return item_with_kind
        end,
      },
    })

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
