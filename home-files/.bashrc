# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples


# export PYTHONPATH=$PYTHONPATH:/home/eric.shaw/workspace/DataRobot
# exporting pythonpath did a weird thing with my imports and venvs. 
# specifically: cd dr_workspace/jenkins-jobs;workon jjb;./builder testupdate THING

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# git branch display
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# set prompt to user:dir (git branch) $
NC="\[\033[00m\]"
BGREEN="\[\033[01;32m\]"
BCYAN="\[\033[01;36m\]"
BPURPLE="\[\033[01;35m\]"

PS1="${BGREEN}\u${NC}:${BCYAN}\w${NC}${BPURPLE}\$(parse_git_branch)${NC} $ "

#set the upper bar title to user:dir
PS1="\[\e]0;\u: \w\a\]$PS1"
 
# enable color support of ls and also add handy aliases
eval "$(dircolors -b)"
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
# fixes ls for (other writable) so i can read the damn font.
# Seriously! Who thinks blue on green is ok?!?!?!? 
BG_GREEN_FONT_RED="42;31"
LS_COLORS="${LS_COLORS}ow=${BG_GREEN_FONT_RED}:"; export LS_COLORS

# stops the damn alert if you hit tab with too many choices, etc
bind 'set bell-style none'


. ~/.bash_aliases

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -d $HOME/.bash.d ]; then
    for shfile in $HOME/.bash.d/*; do
        case $shfile in
            "$HOME/.bash.d/*") : ;;
            *) source $shfile;;
        esac
    done
fi


# kubectl bash completion
source <(kubectl completion bash)

[ -f ~/.quantumrc ] && source ~/.quantumrc

export WORKSPACE="$HOME/workspace"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/eric.shaw/.sdkman"
[[ -s "/home/eric.shaw/.sdkman/bin/sdkman-init.sh" ]] && source "/home/eric.shaw/.sdkman/bin/sdkman-init.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

