# Useful aliases.

alias ..='cd ..'
alias bx='bundle exec'
alias gs='git status'
alias jsonlint='python -m json.tool'
alias manp='~/bin/manpdf.sh'
alias xyzzy='echo "Nothing happens."'

if [ ! -f /opt/local/bin/ack ]; then
    # Previously, p5-app-ack installed the script as ack-X.YZ (where X.YZ was a
    # version number). It has since been replaced with a new package.
    echo "ack not found; consider \`sudo port install ack\` to remedy."
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

# Enable color output from `ls`

export CLICOLOR=1

# Sets the prompt using a random color.

# 0: Black        1: Red          2: Green        3: Yellow
# 4: Blue         5: Magenta      6: Cyan         7: White

# Hat Tip: The Bash $PS1 Generator <http://www.kirsle.net/wizards/ps1.html>

PS1_COLOR=$((RANDOM % 5 + 1))
export PS1="\[$(tput bold)$(tput setaf $PS1_COLOR)\][\W]\\$ \[$(tput sgr0)\]"

# Load bash completion scripts.
# see http://git-scm.com/book/en/Git-Basics-Tips-and-Tricks

for FILE in ~/etc/bash-completion.d/*; do
    test -r $FILE && source $FILE
done
