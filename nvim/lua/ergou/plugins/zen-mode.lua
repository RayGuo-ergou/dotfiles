return -- Lua
{
  'folke/zen-mode.nvim',
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  keys = {
    -- default keymap to toggle the zen mode
    {
      '<Leader>tz',
      function()
        require('zen-mode').toggle({
          window = {
            width = 0.85, -- width will be 85% of the editor width
          },
        })
      end,
      desc = 'Toggle Zen Mode',
    },
  },
}
