return {
  {
    'snacks.nvim',
    opts = {
      picker = {
        win = {
          input = {
            keys = {
              ['<a-c>'] = {
                'toggle_cwd',
                mode = { 'n', 'i' },
              },
            },
          },
        },
        actions = {
          ---@param p snacks.Picker
          toggle_cwd = function(p)
            local root = ergou.root({ buf = p.input.filter.current_buf, normalize = true })
            local cwd = vim.fs.normalize((vim.uv or vim.loop).cwd() or '.')
            local current = p:cwd()
            p:set_cwd(current == root and cwd or root)
            p:find()
          end,
        },
      },
    },
    keys = function()
      if ergou.pick.picker.name ~= 'snacks' then
        return {}
      end

      return {
        -- find
        {
          '<leader>,',
          function()
            Snacks.picker.buffers()
          end,
          desc = 'Switch Buffer',
        },
        { '<leader>ff', ergou.pick('files'), desc = 'Find Files (root dir)' },
        { '<leader>fF', ergou.pick('files', { root = false }), desc = 'Find Files (cwd)' },
        {
          '<leader>gf',
          function()
            Snacks.picker.git_files()
          end,
          desc = 'Find Files (git-files)',
        },
        {
          '<leader>ft',
          function()
            Snacks.picker.treesitter()
          end,
          desc = 'Find Treesitter',
        },
        {
          '<leader>:',
          function()
            Snacks.picker.command_history()
          end,
          desc = 'Command History',
        },
        {
          '<leader><space>',
          function()
            Snacks.picker.buffers()
          end,
          desc = 'Switch Buffer',
        },
        { '<leader>fc', ergou.pick('oldfiles'), desc = 'Find Config File' },
        { '<leader>fr', ergou.pick('oldfiles'), desc = 'Recent' },
        {
          '<leader>fR',
          function()
            Snacks.picker.recent({ filter = { cwd = true } })
          end,
          desc = 'Recent (cwd)',
        },
        {
          '<leader>/',
          function()
            Snacks.picker.search_history()
          end,
          desc = 'Search History',
        },
        -- git
        {
          '<leader>gs',
          function()
            Snacks.picker.git_status()
          end,
          desc = 'Status',
        },
        --search
        {
          '<leader>s"',
          function()
            Snacks.picker.registers()
          end,
          desc = 'Registers',
        },
        {
          '<leader>sc',
          function()
            Snacks.picker.command_history()
          end,
          desc = 'Command History',
        },
        {
          '<leader>sC',
          function()
            Snacks.picker.commands()
          end,
          desc = 'Commands',
        },
        {
          '<leader>sd',
          function()
            Snacks.picker.diagnostics_buffer()
          end,
          desc = 'Document Diagnostics',
        },
        {
          '<leader>sD',
          function()
            Snacks.picker.diagnostics()
          end,
          desc = 'Workspace Diagnostics',
        },
        {
          '<leader>sg',
          ergou.pick('live_grep'),
          desc = 'Grep (root dir)',
        },
        { '<leader>sG', ergou.pick('live_grep', { root = false }), desc = 'Grep (cwd)' },
        {
          '<leader>sh',
          function()
            Snacks.picker.help()
          end,
          desc = 'Help Pages',
        },
        {
          '<leader>sH',
          function()
            Snacks.picker.highlights()
          end,
          desc = 'Search Highlight Groups',
        },
        {
          '<leader>sj',
          function()
            Snacks.picker.jumps()
          end,
          desc = 'Jumplist',
        },
        {
          '<leader>sk',
          function()
            Snacks.picker.keymaps()
          end,
          desc = 'Key Maps',
        },
        {
          '<leader>sl',
          function()
            Snacks.picker.loclist()
          end,
          desc = 'Location List',
        },
        {
          '<leader>sM',
          function()
            Snacks.picker.man()
          end,
          desc = 'Man Pages',
        },
        {
          '<leader>sm',
          function()
            Snacks.picker.marks()
          end,
          desc = 'Jump to Mark',
        },
        {
          '<leader>sr',
          function()
            Snacks.picker.resume()
          end,
          desc = 'Resume',
        },
        {
          '<leader>sq',
          function()
            Snacks.picker.qflist()
          end,
          desc = 'Quickfix List',
        },
        { '<leader>sw', ergou.pick('grep_word'), desc = 'Word (Root Dir)' },
        { '<leader>sW', ergou.pick('grep_word', { root = false }), desc = 'Word (cwd)' },
        {
          '<leader>uC',

          function()
            Snacks.picker.colorschemes()
          end,
          desc = 'Colorscheme with Preview',
        },
        {
          '<leader>ss',
          function()
            Snacks.picker.lsp_symbols()
          end,
          desc = 'LSP Symbols',
        },
        {
          '<leader>sS',
          function()
            Snacks.picker.lsp_workspace_symbols()
          end,
          desc = 'LSP Workspace Symbols',
        },
        {
          '<leader>su',
          function()
            Snacks.picker.undo()
          end,
          desc = 'Undotree',
        },
      }
    end,
  },
  {
    'folke/flash.nvim',
    specs = {
      {
        'folke/snacks.nvim',
        opts = {
          picker = {
            win = {
              input = {
                keys = {
                  ['<a-s>'] = { 'flash', mode = { 'n', 'i' } },
                  ['s'] = { 'flash' },
                  ['<c-u>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
                  ['<c-d>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
                  ['<c-f>'] = { 'list_scroll_down', mode = { 'i', 'n' } },
                  ['<c-b>'] = { 'list_scroll_up', mode = { 'i', 'n' } },
                },
              },
            },
            actions = {
              flash = function(picker)
                require('flash').jump({
                  pattern = '^',
                  label = { after = { 0, 0 } },
                  search = {
                    mode = 'search',
                    exclude = {
                      function(win)
                        return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'snacks_picker_list'
                      end,
                    },
                  },
                  action = function(match)
                    local idx = picker.list:row2idx(match.pos[1])
                    picker.list:_move(idx, true, true)
                  end,
                })
              end,
            },
          },
        },
      },
    },
  },
}
