-- See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
-- See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules
-- watch -n 0.5 "hyprctl clients -j | jq -r '.[] | \"class: \\(.class), title: \\(.title), initialTitle: \\(.initialTitle), initialClass: \\(.initialClass)\"'"

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
	size = { "monitor_w*0.6", "monitor_h*0.6" },
	float = true,
})

hl.window_rule({
	name = "granblue-fantacy",
	match = { class = "^(chromium)$" },
	float = true,
	size = { 722, "monitor_h*0.6" },
	move = { "monitor_w*0", "monitor_h*0.2" },
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
