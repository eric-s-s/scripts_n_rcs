# from original .bashrc file
# some more ls aliases
alias ll='ls -AlFtr'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


alias conflict_vim='vim "$(git status | grep "both added:" | sed -e "s/\s\+both added:\s\+//" | head -1)"'

# running env and creating .sh scripts
function new_script {
    touch $1;
    chmod 774 $1;
    vim $1;
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

function merge-base-diff {
    git diff "$(git merge-base master "${1}")" "${1}"
}

# venv access
function venv35 {
        virtualenv -p "$(which python3.5)" "${1}"
}

function venv37 {
        virtualenv -p "$(which python3.7)" "${1}"
}

function venv38 {
        virtualenv -p "$(which python3.8)" "${1}"
}

function venv27 {
        virtualenv -p "$(which python)" "${1}"
}

# python 3.7 access
alias py37='python3.7'

alias wide_view='printf "\033[8;40;160t"'
alias regular_view='printf "\033[8;40;120t"'
alias default_view='printf "\e[8;24;88t"'
alias long_view='printf "\e[8;24;140t"'


alias edit_eric_sudo='sudo visudo -f /etc/sudoers.d/eric'

function set-title {
    PS1="$(echo $PS1 | sed -e "s/\(\[\\\e\]0;\).*\(\\\a\)/\1${1}\2/") "
}

