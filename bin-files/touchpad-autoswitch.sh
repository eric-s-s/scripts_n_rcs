#!/bin/bash
#
# touchpad-autoswitch.sh - turn the touchpad off while an external mouse is
# plugged in (USB or Bluetooth), and back on when it goes away.
#
# Hyprland has no "disable touchpad on external mouse" setting and its Lua API
# emits no device-added event, so this watches udev instead. The actual toggle
# goes through omarchy-toggle-touchpad, so it persists across Hyprland reloads
# and shows the usual OSD, exactly like the XF86TouchpadToggle key.
#
# Runs from ~/.config/systemd/user/touchpad-autoswitch.service.
#
#   touchpad-autoswitch.sh          watch forever (what the service runs)
#   touchpad-autoswitch.sh --once   apply the right state now and exit
#   touchpad-autoswitch.sh --check  print whether an external mouse is present

set -u

STATE_DIR="$HOME/.local/state/omarchy/toggles/hypr"
# Written by omarchy-toggle-touchpad while the touchpad is disabled.
NAME_FILE="$STATE_DIR/touchpad-disabled-name"
# Written by us, so we only ever re-enable a touchpad we disabled ourselves.
MARKER="$STATE_DIR/touchpad-auto-disabled"

external_mouse_present() {
  local dev props
  for dev in /sys/class/input/event*; do
    props=$(udevadm info -q property -p "$dev" 2>/dev/null) || continue
    grep -qx 'ID_INPUT_MOUSE=1' <<<"$props" || continue
    grep -qx 'ID_INPUT_TOUCHPAD=1' <<<"$props" && continue
    grep -qx 'ID_INPUT_POINTINGSTICK=1' <<<"$props" && continue
    grep -qxE 'ID_BUS=(usb|bluetooth)' <<<"$props" && return 0
  done
  return 1
}

sync_touchpad() {
  if external_mouse_present; then
    if [[ ! -f $NAME_FILE ]]; then
      omarchy-toggle-touchpad off && touch "$MARKER"
    fi
  elif [[ -f $MARKER ]]; then
    omarchy-toggle-touchpad on
    rm -f "$MARKER"
  fi
}

case "${1:-}" in
  --check)
    if external_mouse_present; then echo "external mouse: present"; else echo "external mouse: absent"; fi
    exit 0
    ;;
  --once)
    sync_touchpad
    exit 0
    ;;
esac

mkdir -p "$STATE_DIR"
sync_touchpad

# Lines look like: UDEV  [1234.567890] add      /devices/.../input/input9/event6 (input)
stdbuf -oL udevadm monitor --udev --subsystem-match=input |
  while read -r line; do
    [[ $line == *" add "* || $line == *" remove "* ]] || continue
    sleep 0.5 # let the rest of that device's events land before deciding
    sync_touchpad
  done
