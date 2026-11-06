-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- Catch-all for any monitor not named below (projector, TV, borrowed screen).
-- "auto" lets Hyprland pick a scale per display.
local omarchy_monitor_scale = "auto"
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Laptop panel: BOE 2560x1600 @ 165Hz, 16-inch. Scale 2 = 1280x800 logical.
hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 2 })

-- Dell 27-inch 1080p on DP-1 (SE2717H or SE2719H). "highres" picks the best
-- refresh rate the plugged-in panel advertises: 75Hz on the SE2717H, 60Hz on the SE2719H.
hl.monitor({ output = "DP-1", mode = "highres", position = "auto", scale = 1.6 })

-- Keep each rule above on one line with a plain number for scale.
-- Super+Slash and Super+Alt+Slash edit the matching line in place and
-- leave anything fancier alone.

-- GDK_SCALE is session-wide and integer-only. It sizes X11/XWayland windows,
-- which Omarchy leaves unscaled by the compositor so they stay crisp.
-- Restart an app for a change to reach it.
local omarchy_gdk_scale = 2
hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

-- Use only the external monitor whenever one is plugged in.
--
-- Plug in:  Hyprland fires monitor.added for the new output. Turn the laptop
--           panel off through Omarchy's own toggle, the same thing
--           Super+Ctrl+Delete does, so the stock tooling knows about it.
-- Unplug:   nothing to do here. omarchy-hyprland-monitor-watch sees the
--           removal, finds no external display active, clears that toggle,
--           and the laptop panel comes back on its own.
-- Override: Super+Ctrl+Delete turns the laptop back on while docked. It
--           stays on until the next plug event.
local function is_internal(name)
  return name:match("^eDP%-") or name:match("^LVDS%-") or name:match("^DSI%-")
end

local function external_only()
  -- The sleep lets the new output finish coming up. The active check keeps
  -- this silent when there is no external display, such as login on the go.
  hl.exec_cmd("sleep 1; omarchy-hyprland-monitor-external-active && omarchy-hyprland-monitor-internal off")
end

hl.on("monitor.added", function(monitor)
  -- Re-enabling the laptop panel also fires monitor.added. Skip it, or the
  -- manual override would be undone the moment it was used.
  if monitor and not is_internal(monitor.name) then
    external_only()
  end
end)

-- Logging in with the monitor already connected.
hl.on("hyprland.start", external_only)
