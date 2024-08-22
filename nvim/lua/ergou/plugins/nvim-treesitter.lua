return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    -- event = { 'LazyFile', 'VeryLazy' },
    event = { 'LazyFile' },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
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
        'ini',
        'xml',
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
            [']a'] = '@assignment.outer',
            [']l'] = '@loop.outer',
            [']i'] = '@conditional.outer',
          },
          goto_next_end = {
            [']F'] = '@function.outer',
            [']C'] = '@call.outer',
            [']A'] = '@assignment.outer',
            [']L'] = '@loop.outer',
            [']I'] = '@conditional.outer',
          },
          goto_previous_start = {
            ['[f'] = '@function.outer',
            ['[c'] = '@call.outer',
            ['[a'] = '@assignment.outer',
            ['[l'] = '@loop.outer',
            ['[i'] = '@conditional.outer',
          },
          goto_previous_end = {
            ['[F'] = '@function.outer',
            ['[C'] = '@call.outer',
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

      vim.filetype.add({
        extension = {
          rasi = 'rasi',
          rofi = 'rasi',
          wofi = 'rasi',
          http = 'http',
        },
        filename = {
          ['vifmrc'] = 'vim',
        },
        pattern = {
          ['%.env%.[%w_.-]+'] = 'sh',
        },
      })

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

      -- Create forward and backward movement functions with severity
      local function create_diagnostic_move_pair(severity)
        return ts_repeat_move.make_repeatable_move_pair(function()
          vim.diagnostic.jump({ count = 1, severity = severity })
        end, function()
          vim.diagnostic.jump({ count = -1, severity = severity })
        end)
      end
      -- Default diagnostic navigation (without severity)
      local diagnostic_forward, diagnostic_backward = create_diagnostic_move_pair(nil)
      map({ 'n', 'x', 'o' }, ']d', diagnostic_forward, { desc = 'Next Diagnostic' })
      map({ 'n', 'x', 'o' }, '[d', diagnostic_backward, { desc = 'Prev Diagnostic' })

      -- Diagnostic navigation for specific severities
      local diagnostic_forward_error, diagnostic_backward_error =
        create_diagnostic_move_pair(vim.diagnostic.severity.ERROR)
      map({ 'n', 'x', 'o' }, ']e', diagnostic_forward_error, { desc = 'Next Error' })
      map({ 'n', 'x', 'o' }, '[e', diagnostic_backward_error, { desc = 'Prev Error' })

      local diagnostic_forward_warn, diagnostic_backward_warn =
        create_diagnostic_move_pair(vim.diagnostic.severity.WARN)
      map({ 'n', 'x', 'o' }, ']w', diagnostic_forward_warn, { desc = 'Next Warning' })
      map({ 'n', 'x', 'o' }, '[w', diagnostic_backward_warn, { desc = 'Prev Warning' })
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
          local tsc = require('treesitter-context')
          tsc.toggle()
          if ergou.inject.get_upvalue(tsc.toggle, 'enabled') then
            ergou.info('Enabled Treesitter Context', { title = 'Option' })
          else
            ergou.warn('Disabled Treesitter Context', { title = 'Option' })
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
    event = 'LazyFile',
  },
}
