-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Numpad shortcuts (added 2026-10-22). Keycodes work with Num Lock on or off,
-- the same approach Omarchy's defaults use for the number row.
--   Super + digit          switch to workspace 1-10 (0 = 10)
--   Super + Shift + digit  move window to workspace 1-10
--   Super + Alt + digit    switch to tab 1-10 in the focused window group
--   Super + Enter          terminal
local numpad = { [1] = 87, [2] = 88, [3] = 89, [4] = 83, [5] = 84, [6] = 85, [7] = 79, [8] = 80, [9] = 81, [10] = 90 }
for hotkey_number, code in pairs(numpad) do
	local key = "code:" .. code
	o.bind(
		"SUPER + " .. key,
		"Switch to workspace " .. hotkey_number,
		hl.dsp.focus({ workspace = tostring(hotkey_number) })
	)
	o.bind(
		"SUPER + SHIFT + " .. key,
		"Move window to workspace " .. hotkey_number,
		hl.dsp.window.move({ workspace = tostring(hotkey_number) })
	)
	-- Guarded: Hyprland raises "Index out of range" when the tab does not exist,
	-- so only dispatch when the focused window is in a group with enough tabs.
	o.bind("SUPER + ALT + " .. key, "Switch to group window " .. hotkey_number, function()
		local window = hl.get_active_window()
		local group = window and window.group
		if group and hotkey_number <= group.size then
			hl.dispatch(hl.dsp.group.active({ index = hotkey_number }))
		end
	end)
end

o.bind("SUPER + CTRL + ALT + LEFT", "Move tab left in group", hl.dsp.group.move_window({ forward = false }))
o.bind("SUPER + CTRL + ALT + RIGHT", "Move tab right in group", hl.dsp.group.move_window({ forward = true }))
