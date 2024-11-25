return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  ---@type NoiceConfig
  opts = {
    lsp = {
      progress = { enabled = false },
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
      },
      hover = {
        silent = true,
      },
      documentation = {
        opts = {
          win_options = { conceallevel = 0 },
        },
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = true, -- add a border to hover docs and signature help
    },
    popupmenu = {
      backend = 'cmp',
    },
    cmdline = {
      format = {
        cmdline = { icon = ergou.icons.others.terminal },
      },
    },
  },
  keys = {
    {
      '<leader>sn',
      function()
        local picker = ergou.pick.picker.name
        if picker == 'fzf' then
          -- FIXME: seems fzf integration has an issue
          -- require('noice').cmd('fzf')
          require('noice').cmd('telescope')
        elseif picker == 'telescope' then
          require('noice').cmd('telescope')
        else
          Snacks.notify.error('No picker available', { title = 'Noice' })
        end
      end,
      desc = 'Notifications History',
    },
    {
      '<leader>sN',
      function()
        require('noice').cmd('history')
      end,
      desc = 'Notifications History',
    },
  },
}
