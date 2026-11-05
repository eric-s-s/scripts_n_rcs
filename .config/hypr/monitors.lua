-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- Catch-all for any monitor not named below (projector, TV, borrowed screen).
-- "auto" lets Hyprland pick a scale per display.
local omarchy_monitor_scale = "auto"
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Laptop panel: BOE 2560x1600 @ 165Hz, 16-inch. Scale 2 = 1280x800 logical.
hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 2 })

-- Dell SE2717H, 27-inch 1080p on DP-1. "preferred" is 60Hz; the panel also does 75Hz.
hl.monitor({ output = "DP-1", mode = "1920x1080@74.97", position = "auto", scale = 1.6 })

-- Keep each rule above on one line with a plain number for scale.
-- Super+Slash and Super+Alt+Slash edit the matching line in place and
-- leave anything fancier alone.

-- GDK_SCALE is session-wide and integer-only. It sizes X11/XWayland windows,
-- which Omarchy leaves unscaled by the compositor so they stay crisp.
-- Restart an app for a change to reach it.
local omarchy_gdk_scale = 2
hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
