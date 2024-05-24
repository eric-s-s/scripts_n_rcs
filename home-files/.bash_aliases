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

    if [ "${2}" = "--name-only"  ]; then
        git diff --name-only "$(git merge-base ${main_branch} "${1}")" "${1}";
    else
        git diff "$(git merge-base ${main_branch} "${1}")" "${1}";
    fi
}

function diff-with-main {
    current_sha="$(git log -n 1 --format=%H)" 
    merge-base-diff "${current_sha}" "${1}"
}


alias invoke-python='PYTHONPATH="$(pwd)" python'
function invoke-python-module {
    # use when main.py is not top-level. see
    # https://stackoverflow.com/a/65021331/7264269 in
    # https://stackoverflow.com/questions/50745094/modulenotfounderror-when-running-script-from-terminal
    python -m "$(sed -e 's/\//./g' -e 's/\.py$//' <<< $1)"
}

# random stuff
alias wide_view='printf "\033[8;40;160t"'
alias regular_view='printf "\033[8;40;120t"'
alias default_view='printf "\e[8;24;88t"'
alias long_view='printf "\e[8;24;140t"'
alias find-pointer-on='gsettings set org.gnome.desktop.interface locate-pointer true'
alias find-pointer-off='gsettings set org.gnome.desktop.interface locate-pointer false'

alias latest-bje='kubectl get pods -A | grep bje |tail -1 | awk "{print \"-n \" \$1, \$2 }"'

alias edit_eric_sudo='sudo visudo -f /etc/sudoers.d/eric'

alias clip="xclip -selection c"
alias clean-clipboard="xclip -select c -o | tr -cd '\11\12\15\40-\176' | xclip -select c -i"
alias poop-emoji="echo -n '💩' | xclip -selection c -i"
alias jira-to-clip="xclip -o -sel c | sed 's/.*\///' | xclip -i -sel c"

function branch-from-jira() {
    git checkout -b "eric-s-s/$(basename ${1})/${2}"
}

function gp_portal() {
        echo "dr-prismaaccess.gpcloudservice.com" | clip
}

function set-resolv() {
    cat /etc/resolv.conf
    if grep "nameserver 10\." /etc/resolv.conf; then
        echo "setting"
        sudo sed -i "s/^\(nameserver 192\)/#\1/" /etc/resolv.conf
    fi
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

function set-aws-profile() {
    export AWS_PROFILE=$1
    export KUBECONFIG="${HOME}/kubeconfigs/aws-${1}"
}

