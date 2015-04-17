# To "install" this script, add `source ~/bin/bash_profile.sh` to ~/.profile.

# The Environment

# I want an $EDITOR that reminds me how to quit it. So sue me.

export EDITOR=/usr/bin/nano

# Regarding shell history,
# - commands starting with a space will not be recorded
# - duplicate commands will be removed from history
export HISTCONTROL=ignorespace:erasedups
export HISTSIZE=10000
# - append to (don't overwite) the history file on shell exit
shopt -s histappend
# - allow up/down arrow keys to search history matching up to the cursor
bind '"\e[A"':history-search-backward
bind '"\e[B"':history-search-forward

# Enable color output from `ls` like a civilized person.

export CLICOLOR=1

# I am not yet brave enough to override the default color scheme.
# export LSCOLORS=ehfhchdhbhegedabagacad

# Sets the prompt using a random color. I like to do this to make different
# terminal windows more easily recognizable.

# 0: Black        1: Red          2: Green        3: Yellow
# 4: Blue         5: Magenta      6: Cyan         7: White

# Hat Tip: The Bash $PS1 Generator <http://www.kirsle.net/wizards/ps1.html>

PS1_COLOR=$((RANDOM % 5 + 1))
export PS1="\[$(tput bold)$(tput setaf $PS1_COLOR)\][\W]\\$ \[$(tput sgr0)\]"

# Useful aliases

alias ..='cd ..'
alias bx='bundle exec'
alias gs='git status'
alias jsonlint='python -m json.tool'
alias ll='ls -lhO'
alias manp='~/bin/manpdf.sh'

# Useful functions

function dotpdf {
  dot -Tpdf -o ${1%.dot}.pdf ${1}
}

function mkpasswd {
  dd count=1 bs=${1:-32} if=/dev/random 2> /dev/null | base64
}

function xyzzy {
  echo "Nothing happens."
}

# Load bash completion scripts

if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
	. /opt/local/etc/profile.d/bash_completion.sh
fi
