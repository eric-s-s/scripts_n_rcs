#! /bin/bash


function get_xinput_id {
    id="$(xinput | grep "${1}" | sed -e 's/.*id=\([0-9]\{,2\}\).*/\1/g')"
    echo "${id}"
}

function disable-middle-mouse() {
    mouse_id=$(xinput | grep "MOSART Semi. 2.4G Wireless Mouse  " | cut  -f2 | cut -d"=" -f2)
    echo "disabling button 2 for input-id: ${mouse_id}"
    xinput set-button-map $mouse_id 1 0 3
}



touch_pad="$(get_xinput_id 'SynPS/2 Synaptics TouchPad')"


printf "\ndisabling touch pad\n\n"
xinput --disable $touch_pad
xinput list $touch_pad | head -2

disable-middle-mouse


