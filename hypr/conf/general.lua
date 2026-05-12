local macchiato = require("themes.macchiato")

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 20,

		border_size = 4,

		col = {
			active_border = { colors = { macchiato.blue, macchiato.pink }, angle = 45 },
			inactive_border = macchiato.surface1,
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
			color = macchiato.base,
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
