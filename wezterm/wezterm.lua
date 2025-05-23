local wezterm = require('wezterm')

local color_scheme = 'Catppuccin Macchiato'
local color_scheme_colors = wezterm.color.get_builtin_schemes()[color_scheme]
local home_dir = os.getenv('HOME') or os.getenv('USERPROFILE')

local act = wezterm.action
local config = {}

-- Only for wsl
-- config.default_prog = { 'pwsh.exe', '-NoLogo' }

config.keys = {
  -- paste from the clipboard
  { key = 'v', mods = 'CTRL', action = act.PasteFrom('Clipboard') },
  { key = 'F11', mods = 'NONE', action = act.ToggleFullScreen },
}
config.color_scheme = color_scheme
config.window_padding = {
  left = 2,
  right = 2,
  top = 2,
  -- Bottom has tmux padding so set to 0
  bottom = 0,
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
config.underline_thickness = '1.5pt'
config.underline_position = '200%'
config.max_fps = 120
config.mouse_bindings = {
  -- Bind 'Up' event of CTRL-Click to open hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.OpenLinkAtMouseCursor,
  },
  -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.Nop,
  },
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'CTRL',
    action = act.Nop,
  },
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = wezterm.action_callback(function(window, pane)
      local has_selection = window:get_selection_text_for_pane(pane) ~= ''
      if has_selection then
        window:perform_action(act.CopyTo('ClipboardAndPrimarySelection'), pane)
        window:perform_action(act.ClearSelection, pane)
      else
        window:perform_action(act({ PasteFrom = 'Clipboard' }), pane)
      end
    end),
  },
}

config.bypass_mouse_reporting_modifiers = 'CTRL'
config.adjust_window_size_when_changing_font_size = false
config.audible_bell = 'Disabled'

return config
