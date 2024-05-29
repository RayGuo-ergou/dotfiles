local Util = require('ergou.util')

return {
  {
    'nvim-neo-tree/neo-tree.nvim',
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
          require('neo-tree.command').execute({ toggle = true, dir = vim.uv.cwd() })
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
      vim.api.nvim_create_autocmd('BufEnter', {
        group = vim.api.nvim_create_augroup('Neotree_start_directory', { clear = true }),
        desc = 'Start Neo-tree with directory',
        once = true,
        callback = function()
          if package.loaded['neo-tree'] then
            return
          else
            local stats = vim.uv.fs_stat(vim.fn.argv(0))
            if stats and stats.type == 'directory' then
              require('neo-tree')
            end
          end
        end,
      })
    end,
    opts = {
      sources = { 'filesystem', 'buffers', 'git_status', 'document_symbols' },
      open_files_do_not_replace_types = { 'terminal', 'Trouble', 'trouble', 'qf', 'Outline' },
      enable_diagnostics = true,
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
          ['Y'] = {
            Util.neotree.copy_selector,
            desc = 'copy path/filename to clipboard',
          },
          ['s'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 's' } },
          ['sc'] = { 'order_by_created', nowait = false },
          ['sd'] = { 'order_by_diagnostics', nowait = false },
          ['sm'] = { 'order_by_modified', nowait = false },
          ['sn'] = { 'order_by_name', nowait = false },
          ['ss'] = { 'order_by_size', nowait = false },
          ['st'] = { 'order_by_type', nowait = false },
          ['h'] = Util.neotree.left_movement,
          ['l'] = Util.neotree.right_movement,
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
        git_status = {
          symbols = {
            deleted = ' ', -- this can only be used in the git_status source
          },
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
    opts = { hint = 'floating-big-letter' },
  },
}
