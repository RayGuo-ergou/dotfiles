local Util = require('ergou.util')

return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    cmd = 'Neotree',
    keys = {
      {
        '<leader>fe',
        function()
          require('neo-tree.command').execute({ toggle = true, dir = Util.root() })
        end,
        desc = 'Explorer NeoTree (root dir)',
      },
      {
        '<leader>fE',
        function()
          require('neo-tree.command').execute({ toggle = true, dir = vim.loop.cwd() })
        end,
        desc = 'Explorer NeoTree (cwd)',
      },
      { '<leader>e', '<leader>fe', desc = 'Explorer NeoTree (root dir)', remap = true },
      { '<leader>E', '<leader>fE', desc = 'Explorer NeoTree (cwd)', remap = true },
      {
        '<leader>ge',
        function()
          require('neo-tree.command').execute({ source = 'git_status', toggle = true })
        end,
        desc = 'Git explorer',
      },
      {
        '<leader>be',
        function()
          require('neo-tree.command').execute({ source = 'buffers', toggle = true })
        end,
        desc = 'Buffer explorer',
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      if vim.fn.argc(-1) == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == 'directory' then
          require('neo-tree')
        end
      end
    end,
    opts = {
      sources = { 'filesystem', 'buffers', 'git_status', 'document_symbols' },
      open_files_do_not_replace_types = { 'terminal', 'Trouble', 'trouble', 'qf', 'Outline' },
      enable_diagnostics = false,
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        commands = {
          copy_file_name = function(state)
            local node = state.tree:get_node()
            vim.fn.setreg('*', node.name, 'c')
          end,
        },
      },
      window = {
        mappings = {
          ['<space>'] = 'none',
          ['o'] = { 'open' },
          ['oc'] = 'none',
          ['od'] = 'none',
          ['og'] = 'none',
          ['om'] = 'none',
          ['on'] = 'none',
          ['os'] = 'none',
          ['ot'] = 'none',
          ['e'] = 'none',
          ['Y'] = Util.neotree.copy_selector,
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
      },
    },
    config = function(_, opts)
      local function on_move(data)
        Util.lsp.on_rename(data.source, data.destination)
      end

      local events = require('neo-tree.events')
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
      require('neo-tree').setup(opts)
      vim.api.nvim_create_autocmd('TermClose', {
        pattern = '*lazygit',
        callback = function()
          if package.loaded['neo-tree.sources.git_status'] then
            require('neo-tree.sources.git_status').refresh()
          end
        end,
      })
    end,
  },
  {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    event = 'VeryLazy',
    version = '2.*',
    opts = { hint = 'floating-big-letter' },
  },
}
