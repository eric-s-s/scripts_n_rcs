
alias mydate='date +%H:%M:%S\ --\ %a\ %d/%b/%Y'

alias play_rftg='cd /home/eric/games/rftg-0.9.4;./rftg'

function new_script {
    touch $1;
    chmod 774 $1;
    vim $1;
}

function start_env {
    source ~/work/environments/$1/bin/activate
}


alias clean_docker='docker rmi -f $(docker images -f "dangling=true" -q --no-trunc)'

alias phone_nums='cat ~/Documents/numbers.txt'

alias py37='python3.7'
alias pip37='python3.7 -m pip'
alias venv37='python3.7 -m venv'

alias wide_view='printf "\033[8;40;200t"'
alias regular_view='printf "\033[8;40;120t"'

