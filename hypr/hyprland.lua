local terminal = "kitty"
local fileManager = "thunar"
local menu = "rofi -show drun -show-icons"
local browser = "zen-browser"

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
	output = "",
	mode = "highrr",
	position = "auto",
	scale = "auto",
})

-------------------
---- AUTOSTART ----
-------------------

-- use systemctl: systemctl --user enable swaync.service
-- exec-once = swaync
-- https://wiki.hypr.land/Hypr-Ecosystem/hyprpolkitagent/
-- exec-once = systemctl --user start hyprpolkitagent

hl.on("hyprland.start", function()
	hl.exec_cmd("wl-clip-persist --clipboard regular")
	hl.exec_cmd("wl-paste --watch ~/.config/hypr/scripts/clipboardstore")
	hl.exec_cmd("fcitx5 --replace -d")
	hl.exec_cmd("cliphist wipe") -- On start clear the clipboard
	-- Has to add to the input group
	-- sudo usermod -aG input $USER
	hl.exec_cmd("ydotoold")
	-- Just disable it
	-- hl.exec_cmd("~/.config/hypr/scripts/checkmonitor")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

local cursorSize = 24
local cursorTheme = "catppuccin-macchiato-dark-cursors"

hl.env("XCURSOR_SIZE", tostring(cursorSize))
hl.env("XCURSOR_THEME", cursorTheme) -- Maybe not take effect at all, but keep this here
hl.env("HYPRCURSOR_THEME", cursorTheme)
hl.env("HYPRCURSOR_SIZE", tostring(cursorSize))
-- hl.env("GTK_THEME", "Adwaita:dark")
hl.env("DATAGRIP_JDK", "/opt/datagrip/jbr")

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 20,

		border_size = 4,

		-- For now use plain text not variable can change later
		col = {
			active_border = { colors = { "rgb(8aadf4)", "rgb(f5bde6)" }, angle = 45 },
			inactive_border = "rgb(494d64)",
		},

		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},

	decoration = {
		rounding = 10,
		rounding_power = 2,

		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgb(24273a)",
		},

		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
	dwindle = {
		preserve_split = true, -- You probably want this
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
	master = {
		new_status = "master",
	},
})

hl.config({
	misc = {
		force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = false, -- If true disables the random hyprland logo / anime girl background. :(
	},
})

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		-- follow_mouse = 2,
		numlock_by_default = true,
		float_switch_override_focus = 0,

		sensitivity = -0.5,

		touchpad = {
			natural_scroll = false,
		},
	},
})

hl.device({
	name = "asustek-rog-gladius-iii-aimpoint-eva02",
	sensitivity = -0.5,
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Default springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

---------------------
---- KEYBINDINGS ----
---------------------

-- See https://wiki.hyprland.org/Configuring/Keywords/
local mainMod = "SUPER"

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
hl.bind(mainMod .. " SHIFT + F", hl.dsp.workspace.opt("allfloat"))
hl.bind(
	mainMod .. " + V",
	hl.dsp.exec_cmd("cliphist list | rofi -dmenu -i | cliphist decode | wl-copy && ydotool key 29:1 47:1 47:0 29:0")
)
hl.bind(mainMod .. " SHIFT + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist delete"))
hl.bind(mainMod .. " + P", hl.dsp.window.pin())
hl.bind(mainMod .. " SHIFT + C", hl.dsp.exec_cmd("hyprpicker --autocopy"))
hl.bind(
	mainMod .. " + period",
	hl.dsp.exec_cmd("rofi -modi emoji -show emoji -emoji-mode copy && ydotool key 29:1 47:1 47:0 29:0")
)
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("rofi -show window -show-icons"))
hl.bind("Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot"))
hl.bind("ALT + SPACE", hl.dsp.exec_cmd(menu))
hl.bind("CTRL SHIFT + X", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle1password"))

-- Move focus with mainMod + hjkl
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " SHIFT + " .. key, hl.dsp.window.move({ workspace = i, silent = true }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " SHIFT + S", hl.dsp.window.move({ workspace = "special:magic", silent = true }))

-- Scroll through workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
-- hl.bind(mainMod .. " + Tab",         hl.dsp.focus({ workspace = "e+1" }))
-- hl.bind(mainMod .. " SHIFT + Tab",   hl.dsp.focus({ workspace = "e-1" }))

-- Move window with keyboard
hl.bind(mainMod .. " SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " SHIFT + J", hl.dsp.window.move({ direction = "down" }))

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

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
-- See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules
-- watch -n 0.5 "hyprctl clients -j | jq -r '.[] | \"class: \(.class), title: \(.title), initialTitle: \(.initialTitle), initialClass: \(.initialClass)\"'"

-- Ignore maximize requests from apps. You'll probably like this.
hl.window_rule({
	name = "ignore-maximize-request",
	match = { class = ".*" },
	suppress_event = "maximize",
	persistent_size = true,
})

-- Fix some dragging issues with XWayland
hl.window_rule({
	name = "xwayland-fix",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

hl.window_rule({
	name = "steam",
	match = { class = "^(steam.*)$" },
	float = true,
})

hl.window_rule({
	name = "onePassword",
	match = { class = "^(1(P|p)assword.*)$" },
	float = true,
})

hl.window_rule({
	name = "granblue-fantacy",
	match = { class = "^(chromium)$" },
	float = true,
	size = { w = 722, h = "monitor_h*0.6" },
	move = { x = "monitor_w*0", y = "monitor_h*0.2" },
	pin = true,
})

hl.window_rule({
	name = "discord",
	match = { class = "^(discord)$" },
	float = true,
})

-- This rule might cause issues, if want to enable should also define minsize maybe?
-- hl.window_rule({ match = { class = ".*" }, max_size = { w = 3700, h = 2000 } })

-- workspace 4 used for gbf
-- hl.window_rule({ match = { workspace = 4 }, float = true })
-- hl.window_rule({ match = { workspace = 4 }, max_size = { w = 3100, h = 2000 } })

-- jetbrains
hl.window_rule({
	name = "datagrip",
	match = { class = "^jetbrains-datagrip", float = true },
	no_initial_focus = true,
})

hl.window_rule({
	name = "datagrip-window",
	match = { class = "^jetbrains-datagrip", float = true, title = "^win%d+$" },
	no_focus = true,
})

-- firefox/zen picture in picture video
hl.window_rule({
	name = "picture-in-picture",
	match = { title = "Picture-in-Picture" },
	pin = true,
	float = true,
})

hl.window_rule({
	name = "polkit-always-focus",
	match = { class = "hyprpolkitagent" },
	stay_focused = true,
})

hl.window_rule({
	name = "calibre-hide",
	match = { class = "^calibre.*" },
	float = true,
	no_screen_share = true,
})

hl.window_rule({
	name = "proton-plus",
	match = { title = "^ProtonPlus$" },
	float = true,
	no_screen_share = true,
})

hl.window_rule({
	name = "xdg-portal",
	match = { class = "^xdg-desktop-portal-gtk$" },
	float = true,
})

hl.window_rule({
	name = "Rename",
	match = { title = "^Rename.*" },
	float = true,
})
