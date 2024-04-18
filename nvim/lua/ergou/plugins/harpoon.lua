return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    event = 'LazyFile',
    config = function()
      local harpoon = require('harpoon')

      local nmap = function(key, cmd, desc)
        vim.keymap.set('n', key, cmd, { noremap = true, silent = true, desc = desc })
      end

      nmap('<leader>ha', function()
        harpoon:list():add()
      end, 'Add current file to harpoon')

      nmap('<leader>hc', function()
        harpoon:list():clear()
      end, 'Clear harpoon list')

      nmap('<leader>hd', function()
        harpoon:list():remove()
      end, 'Remove current file from harpoon')

      nmap('<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, 'Toggle harpoon quick menu')

      nmap('<leader>fh', function()
        require('ergou.util.telescope').harpoon(harpoon:list())
      end, 'Open harpoon window with telescope')
    end,
  },
}
