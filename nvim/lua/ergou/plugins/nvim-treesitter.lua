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
      TS.update(nil, { summary = true })
    end,
    cmd = { 'TSUpdate', 'TSInstall', 'TSLog', 'TSUninstall' },
    event = { 'LazyFile', 'VeryLazy' },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    opts_extend = { 'ensure_installed' },
    ---@class ergou.TSConfig: TSConfig
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
        -- 'jsonc', see https://github.com/nvim-treesitter/nvim-treesitter/commit/d2350758b39dce3593ffa8b058f863ea4cfa5b0e
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
        'make',
        'just',
      },
    },
    ---@param opts ergou.TSConfig
    config = function(_, opts)
      local TS = require('nvim-treesitter')

      -- some quick sanity checks
      if not TS.get_installed then
        return ergou.error('Please use `:Lazy` and update `nvim-treesitter`')
      elseif vim.fn.executable('tree-sitter') == 0 then
        return ergou.error({
          '**treesitter-main** requires the `tree-sitter` CLI executable to be installed.',
          'Run `:checkhealth nvim-treesitter` for more information.',
        })
      elseif type(opts.ensure_installed) ~= 'table' then
        return ergou.error('`nvim-treesitter` opts.ensure_installed must be a table')
      end

      -- setup treesitter
      TS.setup(opts)

      ergou.treesitter.get_installed(true) -- initialize the installed langs

      -- install missing parsers
      local install = vim.tbl_filter(function(lang)
        return not ergou.treesitter.have(lang)
      end, opts.ensure_installed or {})
      if #install > 0 then
        TS.install(install, { summary = true }):await(function()
          ergou.treesitter.get_installed(true) -- refresh the installed langs
        end)
      end

      -- treesitter highlighting
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('ergou_treesitter', { clear = true }),
        callback = function(ev)
          if not ergou.treesitter.have(ev.match) then
            return
          end
          pcall(vim.treesitter.start)
          if ergou.treesitter.have(ev.match, 'indents') then
            vim.opt_local.indentexpr = 'v:lua.ergou.treesitter.indentexpr()'
          end
          if ergou.treesitter.have(ev.match, 'folds') then
            vim.opt_local.foldmethod = 'expr'
            vim.opt_local.foldexpr = 'v:lua.ergou.treesitter.foldexpr()'
          end
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    event = 'VeryLazy',
    opts = {
      move = {
        set_jumps = true, -- whether to set jumps in the jumplist
        keys = {
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
        },
      },
      select = {
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keys = {
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
        },
      },
    },
    config = function(_, opts)
      ergou.repeatable_move.setup_diagnostic()
      local TS = require('nvim-treesitter-textobjects')
      if not TS.setup then
        ergou.error('Please use `:Lazy` and update `nvim-treesitter`')
        return
      end
      TS.setup(opts)

      local function attach(buf)
        local ft = vim.bo[buf].filetype
        if not ergou.treesitter.have(ft, 'textobjects') then
          return
        end
        ---@type table<string, table<string, string>>
        local moves = vim.tbl_get(opts, 'move', 'keys') or {}

        for method, keymaps in pairs(moves) do
          for key, query in pairs(keymaps) do
            local desc = query:gsub('@', ''):gsub('%..*', '')
            desc = desc:sub(1, 1):upper() .. desc:sub(2)
            desc = (key:sub(1, 1) == '[' and 'Prev ' or 'Next ') .. desc
            desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and ' End' or ' Start')
            if not (vim.wo.diff and key:find('[cC]')) then
              vim.keymap.set({ 'n', 'x', 'o' }, key, function()
                require('nvim-treesitter-textobjects.move')[method](query, 'textobjects')
              end, {
                buffer = buf,
                desc = desc,
                silent = true,
              })
            end
          end
        end

        ---@type table<string, table<string, string>>
        local selects = vim.tbl_get(opts, 'select', 'keys') or {}
        for key, config in pairs(selects) do
          vim.keymap.set({ 'x', 'o' }, key, function()
            require('nvim-treesitter-textobjects.select').select_textobject(config.query, 'textobjects')
          end, {
            buffer = buf,
            desc = config.desc,
            silent = true,
          })
        end
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('ergou_treesitter_textobjects', { clear = true }),
        callback = function(ev)
          attach(ev.buf)
        end,
      })

      vim.tbl_map(attach, vim.api.nvim_list_bufs())
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
