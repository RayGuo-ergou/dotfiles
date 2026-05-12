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
