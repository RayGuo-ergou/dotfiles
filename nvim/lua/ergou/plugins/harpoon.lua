return {
  {
    'ThePrimeagen/harpoon',
    enabled = false,
    branch = 'harpoon2',
    event = 'LazyFile',
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true,
      },
    },
    keys = function()
      local keys = {
        {
          '<leader>ha',
          function()
            require('harpoon'):list():add()
          end,
          desc = 'Harpoon File',
        },
        {
          '<C-e>',
          function()
            local harpoon = require('harpoon')
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = 'Harpoon Quick Menu',
        },
        {
          '<leader>hc',
          function()
            require('harpoon'):list():clear()
          end,
          desc = 'Harpoon Clear List',
        },
        {
          '<leader>hd',
          function()
            require('harpoon'):list():remove()
          end,
          desc = 'Harpoon Remove File',
        },
      }

      -- for i = 1, 5 do
      --   table.insert(keys, {
      --     '<leader>h' .. i,
      --     function()
      --       require('harpoon'):list():select(i)
      --     end,
      --     desc = 'Harpoon to File ' .. i,
      --   })
      -- end
      return keys
    end,
  },
}
