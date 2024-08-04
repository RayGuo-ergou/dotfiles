local wezterm = require('wezterm')

local color_scheme = 'Catppuccin Macchiato'
local color_scheme_colors = wezterm.color.get_builtin_schemes()[color_scheme]
local home_dir = os.getenv('HOME') or os.getenv('USERPROFILE')

local act = wezterm.action
local config = {}
config.keys = {
  -- paste from the clipboard
  { key = 'v', mods = 'CTRL', action = act.PasteFrom('Clipboard') },
}
config.color_scheme = color_scheme
config.window_padding = {

  bottom = 4,
}
config.background = {
  {
    source = {
      Color = color_scheme_colors.background,
    },
    width = '100%',
    height = '100%',
  },
  -- Change accordingly as cannot create symbol link between windows and wsl
  -- {
  --   source = {
  --     File = home_dir .. '\\OneDrive\\Image\\本机照片\\20231220_212608208_iOS.jpg',
  --   },
  --   opacity = 0.1,
  -- },
}

local font = wezterm.font({ family = 'FiraCode Nerd Font', weight = 450, stretch = 'Normal' })
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

config.font = font
config.window_decorations = 'RESIZE'
config.font_size = 14
config.hide_tab_bar_if_only_one_tab = true

return config
