return {
  {
    'tpope/vim-dadbod',
    cmd = 'DB',
  },
  {
    'kristijanhusak/vim-dadbod-completion',
    dependencies = 'vim-dadbod',
    ft = ergou.sql_ft,
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
    dependencies = {
      { 'eslam-allam/vim-dadbod-ssh' },
      'vim-dadbod',
    },
    keys = {
      {
        '<leader>D',
        function()
          vim.cmd('DBUIToggle')
        end,
        desc = 'Toggle DBUI',
      },
    },
    init = function()
      local data_path = vim.fn.stdpath('data')

      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_save_location = data_path .. '/dadbod_ui'
      vim.g.db_ui_show_database_icon = true
      vim.g.db_ui_tmp_query_location = data_path .. '/dadbod_ui/tmp'
      vim.g.db_ui_use_nerd_fonts = true
      vim.g.db_ui_use_nvim_notify = true

      -- NOTE: The default behavior of auto-execution of queries on save is disabled
      -- this is useful when you have a big query that you don't want to run every time
      -- you save the file running those queries can crash neovim to run use the
      -- default keymap: <leader>S
      vim.g.db_ui_execute_on_save = false

      ---@see https://github.com/kristijanhusak/vim-dadbod-ui?tab=readme-ov-file#databases
      vim.g.dbs = {
        { name = 'local', url = 'postgres://postgres:mysecretpassword@localhost:5432' },
        {
          name = 'removify-dev',
          url = function()
            return vim.fn.getenv('REMOVIFY_DEV_DB_URI')
          end,
        },
      }
    end,
  },
}
