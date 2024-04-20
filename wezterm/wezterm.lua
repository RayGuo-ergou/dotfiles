local wezterm = require('wezterm')

local act = wezterm.action
local config = {}
config.keys = {
  -- paste from the clipboard
  { key = 'v', mods = 'CTRL', action = act.PasteFrom('Clipboard') },
}

config.font_size = 14
config.font = wezterm.font_with_fallback({
  { family = 'FiraCode Nerd Font', weight = 450 },
  { family = 'JetBrains Mono' },
})

config.color_scheme = 'Catppuccin Macchiato'

return config
