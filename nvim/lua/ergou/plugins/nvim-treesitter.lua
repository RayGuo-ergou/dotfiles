return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'LazyFile', 'VeryLazy' },
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treeitter** module to be loaded in time.
      -- Luckily, the only thins that those plugins need are the custom queries, which we make available
      -- during startup.
      require('lazy.core.loader').add_to_rtp(plugin)
      require('nvim-treesitter.query_predicates')
    end,
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        config = function()
          -- When in diff mode, we want to use the default
          -- vim text objects c & C instead of the treesitter ones.
          local move = require('nvim-treesitter.textobjects.move') ---@type table<string,fun(...)>
          local configs = require('nvim-treesitter.configs')
          for name, fn in pairs(move) do
            if name:find('goto') == 1 then
              move[name] = function(q, ...)
                if vim.wo.diff then
                  local config = configs.get_module('textobjects.move')[name] ---@type table<string,string>
                  for key, query in pairs(config or {}) do
                    if q == query and key:find('[%]%[][cC]') then
                      vim.cmd('normal! ' .. key)
                      return
                    end
                  end
                end
                return fn(q, ...)
              end
            end
          end
        end,
      },
    },
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    keys = {
      { '<c-space>', desc = 'Increment selection' },
      { '<bs>', desc = 'Decrement selection', mode = 'x' },
    },
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      highlight = { enable = true },
      -- For some reason, the indent act really weird with lua
      indent = { enable = true, disable = { 'lua' } },
      ensure_installed = {
        'c',
        'git_rebase',
        'gitcommit',
        'git_config',
        'gitattributes',
        'gitignore',
        'twig',
        'diff',
        'cpp',
        'go',
        'lua',
        'luadoc',
        'luap',
        'python',
        'rust',
        'tsx',
        'javascript',
        'typescript',
        'vimdoc',
        'vim',
        'bash',
        'html',
        'css',
        'scss',
        'vue',
        'php',
        'php_only',
        'phpdoc',
        'json',
        'jsonc',
        'json5',
        'jsdoc',
        'http',
        'regex',
        'toml',
        'yaml',
        'query',
        'sql',
        'prisma',
        'markdown',
        'markdown_inline',
        'java',
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@call.outer',
            ['ic'] = '@call.inner',
            ['ab'] = '@block.outer',
            ['ib'] = '@block.inner',
            ['al'] = '@loop.outer',
            ['il'] = '@loop.inner',
            ['ai'] = '@conditional.outer',
            ['ii'] = '@conditional.inner',
          },
        },
        move = {
          enable = true,
          goto_next_start = {
            [']f'] = '@function.outer',
            [']c'] = '@call.outer',
            [']b'] = '@block.outer',
            [']a'] = '@assignment.outer',
            [']l'] = '@loop.outer',
            [']i'] = '@conditional.outer',
          },
          goto_next_end = {
            [']F'] = '@function.outer',
            [']C'] = '@call.outer',
            [']B'] = '@block.outer',
            [']A'] = '@assignment.outer',
            [']L'] = '@loop.outer',
            [']I'] = '@conditional.outer',
          },
          goto_previous_start = {
            ['[f'] = '@function.outer',
            ['[c'] = '@call.outer',
            ['[b'] = '@block.outer',
            ['[a'] = '@assignment.outer',
            ['[l'] = '@loop.outer',
            ['[i'] = '@conditional.outer',
          },
          goto_previous_end = {
            ['[F'] = '@function.outer',
            ['[C'] = '@call.outer',
            ['[B'] = '@block.outer',
            ['[A'] = '@assignment.outer',
            ['[L'] = '@loop.outer',
            ['[I'] = '@conditional.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>ra'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>rA'] = '@parameter.inner',
          },
        },
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')
      local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
      local map = vim.keymap.set

      -- Has to add query
      -- @see https://github.com/EmranMR/tree-sitter-blade/discussions/19
      parser_config.blade = {
        install_info = {
          url = 'https://github.com/EmranMR/tree-sitter-blade',
          files = { 'src/parser.c' },
          branch = 'main',
        },
        filetype = 'blade',
      }
      parser_config.liquid = {
        install_info = {
          -- From https://github.com/hankthetank27/tree-sitter-liquid
          -- @see https://github.com/Shopify/tree-sitter-liquid/pull/11
          -- switch to shopify's tree-sitter-liquid after merged
          url = 'https://github.com/RayGuo-ergou/tree-sitter-liquid', -- local path or git repo
          files = {
            'src/parser.c',
            'src/scanner.c',
          },
          -- optional entries:
          branch = 'main', -- default branch in case of git repo if different from master
          generate_requires_npm = false, -- if stand-alone parser without npm dependencies
          requires_generate_from_grammar = true, -- if folder contains pre-generated src/parser.c
        },
        filetype = 'liquid', -- if filetype does not match the parser name
      }

      if type(opts.ensure_installed) == 'table' then
        ---@type table<string, boolean>
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then
            return false
          end
          added[lang] = true
          return true
        end, opts.ensure_installed)
      end
      require('nvim-treesitter.configs').setup(opts)

      -- Override the default text objects next and previous
      map({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next)
      map({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous)

      --diagnostic
      local diagnostic_forward, diagnostic_backward =
        ts_repeat_move.make_repeatable_move_pair(vim.diagnostic.goto_next, vim.diagnostic.goto_next)
      map({ 'n', 'x', 'o' }, ']d', diagnostic_forward, { desc = 'Next Diagnostic' })
      map({ 'n', 'x', 'o' }, '[d', diagnostic_backward, { desc = 'Prev Diagnostic' })
      map({ 'n', 'x', 'o' }, ']e', function()
        diagnostic_forward({ severity = vim.diagnostic.severity.ERROR })
      end, { desc = 'Next Error' })
      map({ 'n', 'x', 'o' }, '[e', function()
        diagnostic_backward({ severity = vim.diagnostic.severity.ERROR })
      end, { desc = 'Prev Error' })
      map({ 'n', 'x', 'o' }, ']w', function()
        diagnostic_forward({ severity = vim.diagnostic.severity.WARN })
      end, { desc = 'Next Warning' })
      map({ 'n', 'x', 'o' }, '[w', function()
        diagnostic_backward({ severity = vim.diagnostic.severity.WARN })
      end, { desc = 'Prev Warning' })

      -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
      map({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f)
      map({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F)
      map({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t)
      map({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T)
    end,
  },
  -- Show context of the current function
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'LazyFile',
    opts = { mode = 'cursor', max_lines = 3 },
    keys = {
      {
        '<leader>ut',
        function()
          local Util = require('ergou.util')
          local tsc = require('treesitter-context')
          tsc.toggle()
          if Util.inject.get_upvalue(tsc.toggle, 'enabled') then
            Util.info('Enabled Treesitter Context', { title = 'Option' })
          else
            Util.warn('Disabled Treesitter Context', { title = 'Option' })
          end
        end,
        desc = 'Toggle Treesitter Context',
      },
    },
  },

  -- Automatically add closing tags for HTML and JSX
  {
    'windwp/nvim-ts-autotag',
    event = 'LazyFile',
    opts = {},
  },
  -- { 'gbprod/php-enhanced-treesitter.nvim', ft = 'php' },
  {
    'ckolkey/ts-node-action',
    dependencies = { 'nvim-treesitter' },
    opts = {},
    event = { 'LazyFile', 'VeryLazy' },
  },
}
