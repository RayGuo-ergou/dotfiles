-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

local vars = require("conf.vars")

hl.env("XCURSOR_SIZE", tostring(vars.cursorSize))
hl.env("XCURSOR_THEME", vars.cursorTheme) -- Maybe not take effect at all, but keep this here
hl.env("HYPRCURSOR_THEME", vars.cursorTheme)
hl.env("HYPRCURSOR_SIZE", tostring(vars.cursorSize))
-- hl.env("GTK_THEME", "Adwaita:dark")
hl.env("DATAGRIP_JDK", "/opt/datagrip/jbr")
