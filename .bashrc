# Useful aliases.

alias ..='cd ..'
alias bx='bundle install'
alias jsonlint='python -m json.tool'
alias manp='~/bin/manpdf.sh'
alias xyzzy='echo "Nothing happens."'

# Installing p5-app-ack via MacPorts doesn't create an `ack` binary...

if [ ! -f /opt/local/bin/ack ]; then
    if [ -f /opt/local/bin/ack-5.16 ]; then
        alias ack='ack-5.16'
    else
        echo ".bashrc: can't find ack or ack-5.16"
    fi
fi

# I want an $EDITOR that reminds me how to quit it. So sue me.

export EDITOR=/usr/bin/nano

# Enables the following shell history features:
# - commands starting with a space will not be recorded
# - duplicate commands will be removed from history
# - append to (don't overwite) the history file on shell exit
# - allow up/down arrow keys to search history matching up to the cursor

export HISTCONTROL=ignorespace:erasedups
export HISTSIZE=10000
shopt -s histappend
bind '"\e[A"':history-search-backward
bind '"\e[B"':history-search-forward

# Sets the prompt using a random color.

# 0: Black        1: Red          2: Green        3: Yellow
# 4: Blue         5: Magenta      6: Cyan         7: White

# Hat Tip: The Bash $PS1 Generator <http://www.kirsle.net/wizards/ps1.html>

PS1_COLOR=$(($RANDOM % 5 + 1))
export PS1="\[$(tput bold)\]\[$(tput setaf $PS1_COLOR)\][\W]\\$ \[$(tput sgr0)\]"
