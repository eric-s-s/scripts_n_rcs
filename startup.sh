
sudo apt update
sudo apt upgrade

# this seems to reset on startup
sudo update-alternatives --config x-cursor-theme


touch_screen="$(xinput | \
    grep 'ELAN Touchscreen' | \
    sed -e 's/\(.*id=\)\([0-9]\{,2\}\).*/\2/g')"

printf "\ndisabling touch screen\n\n"
xinput --disable $touch_screen
xinput list $touch_screen | head -2

