
alias mydate='date +%H:%M:%S\ --\ %a\ %d/%b/%Y'

alias play_rftg='cd /home/eric/games/rftg-0.9.4;./rftg'

function new_script {
    touch $1;
    chmod 774 $1;
    vim $1;
}

function printer_ip {
    nmap -sn 192.168.1.0/24 | grep HP | sed -e 's/\(.*\)(\([^)]*\).*/\2/'
}

alias py37='python3.7'
alias pip37='python3.7 -m pip'
alias venv37='python3.7 -m venv'
