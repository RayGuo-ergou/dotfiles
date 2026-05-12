-- See https://wiki.hyprland.org/Configuring/Keywords/

local vars = require("conf.vars")
local mainMod = vars.mainMod
local terminal = vars.terminal
local fileManager = vars.fileManager
local menu = vars.menu
local browser = vars.browser

-- input
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("fcitx5-remote -t"))

-- Example binds
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + D", hl.dsp.window.center())
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("~/.config/hypr/scripts/lock1password; hyprlock"))
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(
	mainMod .. " + V",
	hl.dsp.exec_cmd("cliphist list | rofi -dmenu -i | cliphist decode | wl-copy && ydotool key 29:1 47:1 47:0 29:0")
)
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist delete"))
hl.bind(mainMod .. " + P", hl.dsp.window.pin())
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker --autocopy"))
hl.bind(
	mainMod .. " + period",
	hl.dsp.exec_cmd("rofi -modi emoji -show emoji -emoji-mode copy && ydotool key 29:1 47:1 47:0 29:0")
)
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("rofi -show window -show-icons"))
hl.bind("Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot"))
hl.bind("ALT + SPACE", hl.dsp.exec_cmd(menu))
hl.bind("CTRL + SHIFT + X", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle1password"))

-- Move focus with mainMod + hjkl
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic", follow = false }))

-- Scroll through workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
-- hl.bind(mainMod .. " + Tab",         hl.dsp.focus({ workspace = "e+1" }))
-- hl.bind(mainMod .. " + SHIFT + Tab",   hl.dsp.focus({ workspace = "e-1" }))

-- Move window with keyboard
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

-- Resize window (commented out)
-- hl.bind(mainMod .. " ALT + H", hl.dsp.window.resize({ x = -30, y = 0 }), { repeating = true })
-- hl.bind(mainMod .. " ALT + L", hl.dsp.window.resize({ x = 30,  y = 0 }), { repeating = true })
-- hl.bind(mainMod .. " ALT + K", hl.dsp.window.resize({ x = 0,   y = -30 }), { repeating = true })
-- hl.bind(mainMod .. " ALT + J", hl.dsp.window.resize({ x = 0,   y = 30 }), { repeating = true })

-- Submap: resize
-- XXX: If you get stuck inside a keymap, use `hyprctl dispatch submap reset` to go back.
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
	hl.bind(mainMod .. " + F", hl.dsp.window.resize({ x = 30, y = 0 }), { repeating = true })
	hl.bind(mainMod .. " + S", hl.dsp.window.resize({ x = -30, y = 0 }), { repeating = true })
	hl.bind(mainMod .. " + E", hl.dsp.window.resize({ x = 0, y = -30 }), { repeating = true })
	hl.bind(mainMod .. " + D", hl.dsp.window.resize({ x = 0, y = 30 }), { repeating = true })
	hl.bind(mainMod .. " + R", hl.dsp.submap("reset"))
	hl.bind("catchall", hl.dsp.submap("reset"))
end)
-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Cycle windows
hl.bind("ALT + Tab", hl.dsp.window.cycle_next())
hl.bind("ALT + Tab", hl.dsp.window.bring_to_top())

-- Most laptop monitor name is eDP-1, moved to machines.conf
-- hl.bind("switch:on:Lid Switch",  hl.dsp.exec_cmd([[hyprctl keyword monitor "eDP-1,disable"]]),            { locked = true })
-- hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd([[hyprctl keyword monitor "eDP-1,highrr,auto,1"]]),      { locked = true })
