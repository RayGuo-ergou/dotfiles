return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = function()
      local TS = require('nvim-treesitter')
      if not TS.get_installed then
        ergou.error('Please restart Neovim and run `:TSUpdate` to use the `nvim-treesitter` **main** branch.')
        return
      end
      -- somehow when install it throws error
      pcall(vim.cmd.TSUpdate)
    end,
    cmd = { 'TSUpdate', 'TSInstall', 'TSLog', 'TSUninstall' },
    event = { 'LazyFile', 'VeryLazy' },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    ---@type TSConfig
    opts = {
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
        'liquid',
        'powershell',
        'nix',
        'zig',
        'blade',
        'hyprlang',
      },
    },
    ---@param plugin LazyPlugin
    ---@param opts TSConfig
    config = function(plugin, opts)
      if vim.fn.executable('tree-sitter') == 0 then
        ergou.error('**treesitter-main** requires the `tree-sitter` executable to be installed')
        return
      end
      if
        type(opts.ensure_installed --[[@as string[] ]]) ~= 'table'
      then
        ergou.error('`nvim-treesitter` opts.ensure_installed must be a table')
      end

      local TS = require('nvim-treesitter')
      if not TS.get_installed then
        ergou.error('Please use `:Lazy` and update `nvim-treesitter`')
        return
      end
      TS.setup(opts)

      local needed = ergou.dedup(opts.ensure_installed --[[@as string[] ]])
      ergou.ui.installed = TS.get_installed('parsers')

      local install = vim.tbl_filter(function(lang)
        return not ergou.ui.have(lang)
      end, needed)

      if #install > 0 then
        TS.install(install, { summary = true }):await(function()
          ergou.ui.installed = TS.get_installed('parsers')
        end)
      end

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(ev)
          if ergou.ui.have(ev.match) then
            pcall(vim.treesitter.start)
          end
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    event = 'VeryLazy',
    opts = {},
    keys = function()
      local moves = {
        goto_next_start = {
          [']f'] = '@function.outer',
          [']c'] = '@call.outer',
          [']a'] = '@parameter.outer',
          [']l'] = '@loop.outer',
          [']i'] = '@conditional.outer',
        },
        goto_next_end = {
          [']F'] = '@function.outer',
          [']C'] = '@call.outer',
          [']A'] = '@parameter.outer',
          [']L'] = '@loop.outer',
          [']I'] = '@conditional.outer',
        },
        goto_previous_start = {
          ['[f'] = '@function.outer',
          ['[c'] = '@call.outer',
          ['[a'] = '@parameter.outer',
          ['[l'] = '@loop.outer',
          ['[i'] = '@conditional.outer',
        },
        goto_previous_end = {
          ['[F'] = '@function.outer',
          ['[C'] = '@call.outer',
          ['[A'] = '@parameter.outer',
          ['[L'] = '@loop.outer',
          ['[I'] = '@conditional.outer',
        },
      }
      local ret = {} ---@type LazyKeysSpec[]
      for method, keymaps in pairs(moves) do
        for key, query in pairs(keymaps) do
          local desc = query:gsub('@', ''):gsub('%..*', '')
          desc = desc:sub(1, 1):upper() .. desc:sub(2)
          desc = (key:sub(1, 1) == '[' and 'Prev ' or 'Next ') .. desc
          desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and ' End' or ' Start')
          ret[#ret + 1] = {
            key,
            function()
              -- don't use treesitter if in diff mode and the key is one of the c/C keys
              if vim.wo.diff and key:find('[cC]') then
                return vim.cmd('normal! ' .. key)
              end
              require('nvim-treesitter-textobjects.move')[method](query, 'textobjects')
            end,
            desc = desc,
            mode = { 'n', 'x', 'o' },
            silent = true,
          }
        end
      end

      local textobjects = {
        ['aa'] = { query = '@parameter.outer', desc = 'Function params/array elements outer' },
        ['ia'] = { query = '@parameter.inner', desc = 'Function params/array elements inner' },
        ['aA'] = { query = '@assignment.outer', desc = 'Assignment outer' },
        ['iA'] = { query = '@assignment.inner', desc = 'Assignment inner' },
        ['af'] = { query = '@function.outer', desc = 'Function outer' },
        ['if'] = { query = '@function.inner', desc = 'Function inner' },
        ['ac'] = { query = '@call.outer', desc = 'Call outer' },
        ['ic'] = { query = '@call.inner', desc = 'Call inner' },
        ['al'] = { query = '@loop.outer', desc = 'Loop outer' },
        ['il'] = { query = '@loop.inner', desc = 'Loop inner' },
        ['ai'] = { query = '@conditional.outer', desc = 'Conditional outer' },
        ['ii'] = { query = '@conditional.inner', desc = 'Conditional inner' },
      }

      for key, config in pairs(textobjects) do
        ret[#ret + 1] = {
          key,
          function()
            require('nvim-treesitter-textobjects.select').select_textobject(config.query, 'textobjects')
          end,
          desc = config.desc,
          mode = { 'x', 'o' },
          silent = true,
        }
      end
      return ret
    end,
    config = function(_, opts)
      ergou.repeatable_move.setup_diagnostic()
      local TS = require('nvim-treesitter-textobjects')
      if not TS.setup then
        ergou.error('Please use `:Lazy` and update `nvim-treesitter`')
        return
      end
      TS.setup(opts)
    end,
  },
  -- Show context of the current function
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'LazyFile',
    opts = {
      mode = 'cursor',
      max_lines = 3,
      multiwindow = true,
    },
    keys = {
      {
        '<leader>ut',
        function()
          local tsc = require('treesitter-context')
          tsc.toggle()
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
