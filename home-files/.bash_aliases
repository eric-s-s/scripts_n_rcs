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
    main_branch="master"
    if [ -z "$(git branch | grep "${main_branch}")" ]; then
        main_branch="main"
    fi
    git diff "$(git merge-base ${main_branch} "${1}")" "${1}"
}

function diff-with-main {
    current_sha="$(git log -n 1 --format=%H)" 
    merge-base-diff "${current_sha}"
}


alias invoke-python='PYTHON_PATH="$(pwd)" python'

# random stuff
alias wide_view='printf "\033[8;40;160t"'
alias regular_view='printf "\033[8;40;120t"'
alias default_view='printf "\e[8;24;88t"'
alias long_view='printf "\e[8;24;140t"'

alias latest-bje='kubectl get pods -A | grep bje |tail -1 | awk "{print \"-n \" \$1, \$2 }"'

alias edit_eric_sudo='sudo visudo -f /etc/sudoers.d/eric'

alias clip="xclip -selection c"

function gp_portal() {
        echo "dr-prismaaccess.gpcloudservice.com" | clip
}

function convert-to-ip-addr {
   echo "${1}" | sed -E "s/-/./g"
}

alias report-disk-usage="du -ha ~/. | sort -rh > ~/usage.txt"

function eval-mongo() {
    uri=$1
    db=$2
    cmd=$3
    mongo $uri --eval "JSON.stringify(db.getSiblingDB('${db}').${cmd})" | grep "^{" | jq .
}


