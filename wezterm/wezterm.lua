local wezterm = require('wezterm')

local act = wezterm.action
local config = {}
config.keys = {
  -- paste from the clipboard
  { key = 'v', mods = 'CTRL', action = act.PasteFrom('Clipboard') },
}

local font = wezterm.font({ family = 'FiraCode Nerd Font', weight = 450, stretch = 'Normal' })

config.font = font
config.font_size = 14
config.font_rules = {
  {
    intensity = 'Bold',
    italic = false,
    font = font,
  },
  {
    intensity = 'Bold',
    italic = true,
    font = font,
  },
  {
    italic = true,
    intensity = 'Half',
    font = font,
  },
  {
    italic = false,
    intensity = 'Half',
    font = font,
  },
  {
    italic = true,
    intensity = 'Normal',
    font = font,
  },
}

config.color_scheme = 'Catppuccin Macchiato'

return config
