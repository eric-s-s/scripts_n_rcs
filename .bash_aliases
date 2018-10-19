# from original .bashrc file
# some more ls aliases
alias ll='ls -AlF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


# silly stuff

alias mydate='date +%H:%M:%S\ --\ %a\ %d/%b/%Y'
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


alias clean_docker='docker rmi -f $(docker images -f "dangling=true" -q --no-trunc)'

# python 3.7 access
alias py37='python3.7'
alias pip37='python3.7 -m pip'
alias venv37='python3.7 -m venv'

alias wide_view='printf "\033[8;40;200t"'
alias regular_view='printf "\033[8;40;120t"'

# laptop input controls
function is_input_enabled {
    [ "$(xinput list $1 | grep disabled)" ] && echo disabled || echo enabled
}

function list_inputs {
    touch_screen="ELAN Touchscreen"
    touch_pad="Elantech Touchpad"
    key_board="AT Translated Set 2 keyboard"
    elements=("${touch_screen}" "${touch_pad}" "${key_board}")

    rjust=0

    for el in "${elements[@]}"; do
        let "new_rjust=${#el}+1"
        if [ ${new_rjust} -gt ${rjust} ]; then
            rjust=${new_rjust}
        fi
    done
        
    for el in "${elements[@]}"; do
        id="$(xinput | grep "${el}" | sed -e 's/\(.*id=\)\([0-9]\{,2\}\).*/\2/g')"
        state="$(is_input_enabled $id)"
        printf "%-${rjust}s : id: ${id} state: ${state}\n" "${el}"
    done
}

