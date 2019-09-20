
sudo apt update
sudo apt upgrade

# this seems to reset on startup
sudo update-alternatives --config x-cursor-theme

disable_inputs.sh
#
#touch_screen="$(get_xinput_id 'ELAN Touchscreen')"
#touch_pad="$(get_xinput_id 'Elantech Touchpad')"
#
#printf "\ndisabling touch screen\n\n"
#xinput --disable $touch_screen
#xinput list $touch_screen | head -2
#
#
#printf "\ndisabling touch pad\n\n"
#xinput --disable $touch_pad
#xinput list $touch_pad | head -2
#
#
#
