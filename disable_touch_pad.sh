#! /bin/bash


function get_xinput_id {
    id="$(xinput | grep "${1}" | sed -e 's/.*id=\([0-9]\{,2\}\).*/\1/g')"
    echo "${id}"
}

touch_pad="$(get_xinput_id 'SynPS/2 Synaptics TouchPad')"


printf "\ndisabling touch pad\n\n"
xinput --disable $touch_pad
xinput list $touch_pad | head -2




