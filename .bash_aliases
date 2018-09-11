
alias mydate='date +%H:%M:%S\ --\ %a\ %d/%b/%Y'

alias play_rftg='cd /home/eric/games/rftg-0.9.4;./rftg'

function new_script {
    touch $1;
    chmod 774 $1;
    vim $1;
}


alias py37='python3.7'
alias pip37='python3.7 -m pip'
alias venv37='python3.7 -m venv'
