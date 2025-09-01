return {
  {
    'ibhagwan/fzf-lua',
    dependencies = {
      'MeanderingProgrammer/render-markdown.nvim',
      'nvim-treesitter/nvim-treesitter-context',
    },
    opts = function()
      local fzf = require('fzf-lua')
      local config = fzf.config
      local actions = fzf.actions

      -- Quickfix
      config.defaults.keymap.fzf['ctrl-q'] = 'select-all+accept'
      config.defaults.keymap.fzf['ctrl-x'] = 'jump'
      config.defaults.keymap.builtin['<c-d>'] = 'preview-half-page-down'
      config.defaults.keymap.builtin['<c-u>'] = 'preview-half-page-up'
      config.defaults.keymap.fzf['ctrl-d'] = 'preview-half-page-down'
      config.defaults.keymap.fzf['ctrl-u'] = 'preview-half-page-up'

      -- Trouble
      if ergou.has('trouble.nvim') then
        config.defaults.actions.files['ctrl-t'] = require('trouble.sources.fzf').actions.open
      end

      -- -- Toggle root dir / cwd
      config.defaults.actions.files['ctrl-r'] = function(_, ctx)
        local o = vim.deepcopy(ctx.__call_opts)
        o.root = o.root == false
        o.cwd = nil
        o.buf = ctx.__CTX.bufnr
        ergou.pick.open(ctx.__INFO.cmd, o)
      end
      config.defaults.actions.files['alt-c'] = config.defaults.actions.files['ctrl-r']
      -- ctrl-v is used for paste
      config.defaults.actions.files['alt-v'] = config.defaults.actions.files['ctrl-v']
      config.defaults.actions.files['alt-s'] = config.defaults.actions.files['ctrl-s']
      config.set_action_helpstr(config.defaults.actions.files['ctrl-r'], 'toggle-root-dir')

      local img_previewer ---@type string[]?
      for _, v in ipairs({
        { cmd = 'ueberzug', args = {} },
        { cmd = 'chafa', args = { '{file}', '--format=symbols' } },
        { cmd = 'viu', args = { '-b' } },
      }) do
        if vim.fn.executable(v.cmd) == 1 then
          img_previewer = vim.list_extend({ v.cmd }, v.args)
          break
        end
      end

      return {
        'default-title',
        fzf_opts = {
          ['--no-scrollbar'] = true,
          ['--cycle'] = true,
        },
        defaults = {
          -- formatter = "path.filename_first",
          formatter = 'path.dirname_first',
        },
        previewers = {
          builtin = {
            extensions = {
              ['png'] = img_previewer,
              ['jpg'] = img_previewer,
              ['jpeg'] = img_previewer,
              ['gif'] = img_previewer,
              ['webp'] = img_previewer,
              ['svg'] = { 'imgcat' },
            },
            ueberzug_scaler = 'fit_contain',
            treesitter = {
              context = true,
            },
          },
        },
        -- Custom ergou option to configure vim.ui.select
        ui_select = function(fzf_opts, items)
          return vim.tbl_deep_extend('force', fzf_opts, {
            prompt = ' ',
            winopts = {
              title = ' ' .. vim.trim((fzf_opts.prompt or 'Select'):gsub('%s*:%s*$', '')) .. ' ',
              title_pos = 'center',
            },
          }, fzf_opts.kind == 'codeaction' and {
            winopts = {
              layout = 'vertical',
              -- height is number of items minus 15 lines for the preview, with a max of 80% screen height
              height = ergou.pick.select_height(#items),
              width = 0.5,
              preview = not vim.tbl_isempty(ergou.lsp.get_clients({ bufnr = 0, name = 'vtsls' })) and {
                layout = 'vertical',
                vertical = 'down:15,border-top',
                hidden = 'hidden',
              } or {
                layout = 'vertical',
                vertical = 'down:15,border-top',
              },
            },
          } or {
            winopts = {
              width = 0.5,
              -- height is number of items, with a max of 80% screen height
              height = math.floor(math.min(vim.o.lines * 0.8, #items + 2) + 0.5),
            },
          })
        end,
        winopts = {
          width = 0.9,
          height = 0.9,
          row = 0.5,
          col = 0.5,
          preview = {
            scrollchars = { '┃', '' },
          },
        },
        files = {
          cwd_prompt = false,
          actions = {
            ['alt-i'] = { actions.toggle_ignore },
            ['alt-h'] = { actions.toggle_hidden },
          },
        },
        grep = {
          actions = {
            ['alt-i'] = { actions.toggle_ignore },
            ['alt-h'] = { actions.toggle_hidden },
          },
        },
        lsp = {
          symbols = {
            symbol_hl = function(s)
              return 'TroubleIcon' .. s
            end,
            symbol_fmt = function(s)
              return s:lower() .. '\t'
            end,
          },
          code_actions = {
            previewer = vim.fn.executable('delta') == 1 and 'codeaction_native' or nil,
          },
        },
      }
    end,
    config = function(_, opts)
      if opts[1] == 'default-title' then
        -- use the same prompt for all pickers for profile `default-title` and
        -- profiles that use `default-title` as base profile
        local function fix(t)
          t.prompt = t.prompt ~= nil and ' ' or nil
          for _, v in pairs(t) do
            if type(v) == 'table' then
              fix(v)
            end
          end
          return t
        end
        opts = vim.tbl_deep_extend('force', fix(require('fzf-lua.profiles.default-title')), opts)
        opts[1] = nil
      end
      require('fzf-lua').setup(opts)
    end,
    init = function()
      if ergou.pick.picker.name ~= 'fzf' then
        return
      end
      ergou.on_very_lazy(function()
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.ui.select = function(...)
          require('lazy').load({ plugins = { 'fzf-lua' } })
          local opts = ergou.opts('fzf-lua') or {}
          require('fzf-lua').register_ui_select(opts.ui_select or nil)
          return vim.ui.select(...)
        end
      end)
    end,
    cmd = { 'FzfLua' },
    keys = function(_, k)
      return ergou.pick.set_keymaps(k, 'fzf')
    end,
  },
  {
    'folke/todo-comments.nvim',
    keys = function(_, ks)
      local _keys = ks or {}
      if ergou.pick.picker.name == 'fzf' then
        vim.list_extend(_keys, {
          {
            '<leader>st',
            function()
              require('todo-comments.fzf').todo({ keywords = { 'TODO', 'FIX', 'FIXME' } })
            end,
            desc = 'Todo/Fix/Fixme',
          },
          {
            '<leader>sT',
            function()
              require('todo-comments.fzf').todo()
            end,
            desc = 'Todo',
          },
        })
      end
      return _keys
    end,
  },
  {
    'neovim/nvim-lspconfig',
    opts = function()
      local Keys = ergou.lsp.keymap.get()

      if ergou.pick.picker.name == 'fzf' then
        vim.list_extend(Keys, {
          { 'gd', '<cmd>FzfLua lsp_definitions jump1=true ignore_current_line=true<cr>', desc = 'Goto Definition' },
          { 'grr', '<cmd>FzfLua lsp_references jump1=true ignore_current_line=true<cr>', desc = 'Goto References' },
          {
            'gI',
            '<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>',
            desc = 'Goto Implementation',
          },
          { 'gy', '<cmd>FzfLua lsp_typedefs jump1=true ignore_current_line=true<cr>', desc = 'Goto Type' },
        })
      end
    end,
  },
}
