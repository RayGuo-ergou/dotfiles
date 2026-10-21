local M = {}

-- Reapply the configured geometry only when the drawer is shown.
function M.reset()
	local monitor = hl.get_active_monitor()
	if
		not monitor
		or not monitor.active_special_workspace
		or monitor.active_special_workspace.name ~= "special:dropterm"
	then
		return
	end

	local dropterm = require("conf.window-rules")
	local width, height = monitor.size.width, monitor.size.height
	if monitor.transform % 2 == 1 then
		width, height = height, width
	end
	local env = { monitor_w = width / monitor.scale, monitor_h = height / monitor.scale }
	local function value(expression)
		if type(expression) == "number" then
			return expression
		end
		return assert(load("return " .. expression, "dropterm geometry", "t", env))()
	end

	local window = "class:^(com\\.dropterm\\.ghostty)$"
	hl.dispatch(hl.dsp.window.resize({
		window = window,
		x = value(dropterm.size[1]),
		y = value(dropterm.size[2]),
		relative = false,
	}))
	hl.dispatch(hl.dsp.window.move({
		window = window,
		x = monitor.position.x + value(dropterm.move[1]),
		y = monitor.position.y + value(dropterm.move[2]),
		relative = false,
	}))
end

return M
