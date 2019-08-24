# from original .bashrc file
# some more ls aliases
alias ll='ls -AlFtr'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


# silly stuff

alias play_rftg='cd /home/eric/games/rftg-0.9.4;./rftg'
alias phone_nums='cat ~/Documents/numbers.txt'


# running env and creating .sh scripts
function new_script {
    touch $1;
    chmod 774 $1;
    vim $1;
}

function start_env {
    source ~/work/environments/$1/bin/activate
}

# shortcuts for various programs

alias clean_docker='docker rmi -f $(docker images -f "dangling=true" -q --no-trunc)'
function go_bin {
    "$(go env GOPATH)/bin/${1}"
}
function ltunify_access {
    location="/dev/hidraw${1}";
    sudo chgrp "${USER}" "${location}" && sudo chmod g+rw "${location}"
}

function remount_as_read_only {
    udisksctl unmount -b /dev/sdb1
    udisksctl mount -o ro -b /dev/sdb1
}

# python 3.7 access
alias py37='python3.7'
alias pip37='python3.7 -m pip'
alias venv37='python3.7 -m venv'

# alternate venv functions here as notes

# function venv35 {
#         virtualenv -p "$(which python3.5)" "{$1}"
# }
#
# function venv37 {
#         virtualenv -p "$(which python3.7)" "{$1}"
# }

alias wide_view='printf "\033[8;40;200t"'
alias regular_view='printf "\033[8;40;120t"'
alias default_view='printf "\e[8;24;88t"'


# laptop input controls
function is_input_enabled {
    [ "$(xinput list $1 | grep disabled)" ] && echo disabled || echo enabled
}

function get_xinput_id {
    id="$(xinput | grep "${1}" | sed -e 's/.*id=\([0-9]\{,2\}\).*/\1/g')"
    echo "${id}"
}

function list_inputs {
    touch_screen="ELAN Touchscreen"
    touch_pad="Elantech Touchpad"
    key_board="AT Translated Set 2 keyboard"
    elements=("${touch_screen}" "${touch_pad}" "${key_board}")

    rjust=0
    for el in "${elements[@]}"; do
        new_rjust="${#el}"
        [ ${new_rjust} -gt ${rjust} ] && rjust=${new_rjust} 
    done
        
    for el in "${elements[@]}"; do
        id="$(get_xinput_id ${el})"
        state="$(is_input_enabled $id)"
        printf "%-${rjust}s : id: ${id} state: ${state}\n" "${el}"
    done
}

