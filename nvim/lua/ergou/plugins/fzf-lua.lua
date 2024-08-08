local Util = require('ergou.util')
return {
  'ibhagwan/fzf-lua',
  opts = function(_, opts)
    local config = require('fzf-lua.config')
    local actions = require('fzf-lua.actions')

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
    config.set_action_helpstr(config.defaults.actions.files['ctrl-r'], 'toggle-root-dir')

    -- use the same prompt for all
    local defaults = require('fzf-lua.profiles.default-title')
    local function fix(t)
      t.prompt = t.prompt ~= nil and ' ' or nil
      for _, v in pairs(t) do
        if type(v) == 'table' then
          fix(v)
        end
      end
    end
    fix(defaults)

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

    return vim.tbl_deep_extend('force', defaults, {
      fzf_colors = true,
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
          },
          ueberzug_scaler = 'fit_contain',
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
            height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 2) + 0.5) + 16,
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
        width = 0.85,
        height = 0.85,
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
    })
  end,
  config = function(_, opts)
    require('fzf-lua').setup(opts)
  end,
  init = function()
    local ergou = require('ergou.util')
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
  keys = function()
    if Util.pick.picker.name ~= 'fzf' then
      return {}
    end

    return {
      -- find
      {
        '<leader>,',
        '<cmd>Telescope buffers sort_mru=true<cr>',
        desc = 'Switch Buffer',
      },
      { '<leader>ff', Util.pick('files'), desc = 'Find Files (root dir)' },
      { '<leader>fF', Util.pick('files', { root = false }), desc = 'Find Files (cwd)' },
      { '<leader>gf', '<cmd>FzfLua git_files<cr>', desc = 'Find Files (git-files)' },
      { '<leader>:', '<cmd>FzfLua command_history<cr>', desc = 'Command History' },
      {
        '<leader><space>',
        '<cmd>FzfLua buffers sort_mru=true<cr>',
        desc = 'Switch Buffer',
      },
      { '<leader>fc', Util.pick.config_files(), desc = 'Find Config File' },
      { '<leader>fr', '<cmd>FzfLua oldfiles<cr>', desc = 'Recent' },
      -- git
      { '<leader>gs', '<cmd>FzfLua git_status<CR>', desc = 'Status' },
      --search
      { '<leader>s"', '<cmd>FzfLua registers<cr>', desc = 'Registers' },
      { '<leader>sc', '<cmd>FzfLua command_history<cr>', desc = 'Command History' },
      { '<leader>sC', '<cmd>FzfLua commands<cr>', desc = 'Commands' },
      { '<leader>sd', '<cmd>FzfLua diagnostics_document<cr>', desc = 'Document Diagnostics' },
      { '<leader>sD', '<cmd>FzfLua diagnostics_workspace<cr>', desc = 'Workspace Diagnostics' },
      {
        '<leader>s/',
        Util.pick('live_grep', { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }),
        desc = 'Search in opened files',
      },
      { '<leader>sg', Util.pick('live_grep'), desc = 'Grep (root dir)' },
      { '<leader>sG', Util.pick('live_grep', { root = false }), desc = 'Grep (cwd)' },
      { '<leader>sh', '<cmd>FzfLua help_tags<cr>', desc = 'Help Pages' },
      { '<leader>sH', '<cmd>FzfLua highlights<cr>', desc = 'Search Highlight Groups' },
      { '<leader>sj', '<cmd>FzfLua jumps<cr>', desc = 'Jumplist' },
      { '<leader>sk', '<cmd>FzfLua keymaps<cr>', desc = 'Key Maps' },
      { '<leader>sl', '<cmd>FzfLua loclist<cr>', desc = 'Location List' },
      { '<leader>sM', '<cmd>FzfLua man_pages<cr>', desc = 'Man Pages' },
      { '<leader>sm', '<cmd>FzfLua marks<cr>', desc = 'Jump to Mark' },
      { '<leader>sr', '<cmd>FzfLua resume<cr>', desc = 'Resume' },
      { '<leader>sq', '<cmd>FzfLua quickfix<cr>', desc = 'Quickfix List' },
      { '<leader>sw', Util.pick('grep_cword'), desc = 'Word (Root Dir)' },
      { '<leader>sW', Util.pick('grep_cword', { root = false }), desc = 'Word (cwd)' },
      { '<leader>sw', Util.pick('grep_visual'), mode = 'v', desc = 'Selection (Root Dir)' },
      { '<leader>sW', Util.pick('grep_visual', { root = false }), mode = 'v', desc = 'Selection (cwd)' },
      { '<leader>uC', Util.pick('colorschemes'), desc = 'Colorscheme with Preview' },
      {
        '<leader>ss',
        '<cmd>FzfLua lsp_document_symbols<cr>',
        mode = { 'n' },
        desc = 'Find document symbols',
      },
      {
        '<leader>sS',
        '<cmd>FzfLua lsp_workspace_symbols<cr>',
        mode = { 'n' },
        desc = 'Find workspace symbols',
      },
    }
  end,
}
