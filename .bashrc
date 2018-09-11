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


#set the upper bar title to user@host:dir
PS1="\[\e]0;\u@\h: \w\a\]$PS1"
 
# enable color support of ls and also add handy aliases
    eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

# some more ls aliases
alias ll='ls -AlF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


. ~/.bash_aliases

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

PATH=$PATH:/home/eric/bin

# fixes ls for (other writable) so i can read the damn font.
# Seriously! Who thinks blue on green is ok?!?!?!? 
BG_GREEN_FONT_RED="42;31"
LS_COLORS="${LS_COLORS}ow=${BG_GREEN_FONT_RED}:"; export LS_COLORS

# TODO edit more, bash subshell move things to more logical places

