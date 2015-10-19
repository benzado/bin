# To "install" this script, add `source ~/bin/bash_profile.sh` to ~/.profile.

# The Environment

export PATH=$HOME/bin:$PATH

# I want an $EDITOR that reminds me how to quit it. So sue me.
export EDITOR=`which nano`

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

# Enable color output from `ls` and `grep`, like a civilized person.
export CLICOLOR=1
export GREP_OPTIONS=--color=auto

# I am not yet brave enough to override the default color scheme.
# export LSCOLORS=ehfhchdhbhegedabagacad

# Sets the prompt using a random color. I like to do this to make different
# terminal windows more easily recognizable.

# 0: Black        1: Red          2: Green        3: Yellow
# 4: Blue         5: Magenta      6: Cyan         7: White

# Hat Tip: The Bash $PS1 Generator <http://www.kirsle.net/wizards/ps1.html>

PS_COLOR=$(tput setaf $((RANDOM % 5 + 1)))
PS_BEGIN="\[$(tput bold)${PS_COLOR}\]"
PS_END="\[$(tput sgr0)\]"

export PS1="$PS_BEGIN[\u:\W]\\$ $PS_END"
export PS2="$PS_BEGIN> $PS_END"

unset PS_COLOR PS_BEGIN PS_END

if [ -e /opt/local/share/git/git-prompt.sh ]; then
  source /opt/local/share/git/git-prompt.sh

  GIT_PS1=$PS1
  GIT_FORMAT="$(tput setaf 7)git: %s\n"

  function prompt_command {
    update_terminal_cwd;

    local GIT_PS1_SHOWDIRTYSTATE=1
    local GIT_PS1_SHOWCOLORHINTS=1
    __git_ps1 '' "$GIT_PS1" "$GIT_FORMAT"
  }

  # Don't export this since subshells won't have the prompt_command function.
  PROMPT_COMMAND='prompt_command;'

  # Technically, we CAN also export the prompt_command function, but then we
  # also need to export __git_ps1 and everything it depends on, which isn't
  # really feasible.
fi

# Useful aliases

alias ..='cd ..'
alias bx='bundle exec'
alias con='tail -40 -f /var/log/system.log'
alias gs='git status'
alias httpserver='python -m SimpleHTTPServer'
alias jsonlint='python -m json.tool'
alias ll='ls -lhO'
alias ls='ls -hO'
alias manp='~/bin/manpdf.sh'
alias shuf=gshuf

# Useful functions

function dotpdf {
  dot -Tpdf -o ${1%.dot}.pdf ${1}
}

function mkpasswd {
  dd count=1 bs=${1:-32} if=/dev/random 2> /dev/null | base64
}

function psc {
  local cmd='ps axo pid,ppid,user,command'
  if [ -z $1 ]; then
    $cmd
  else
    $cmd | grep "$1" | grep -v "grep $1"
  fi
}

function rails_test {
  local TEST_ARGS
  if [ -n "$1" ]; then
    TEST_ARGS="TEST=$1"
  fi
  RAILS_ENV=test bundle exec rake test $TEST_ARGS
}

function symbolicatecrash {
  local xcode=`xcode-select --print-path`

  echo "Invoking script in $xcode"
  export DEVELOPER_DIR="$xcode"
  "$xcode/../SharedFrameworks/DTDeviceKitBase.framework/Versions/A/Resources/symbolicatecrash" -v $*
}

function xyzzy {
  echo "Nothing happens."
}

# Load bash completion scripts

if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
	. /opt/local/etc/profile.d/bash_completion.sh
fi

if [ -f /opt/local/share/git/contrib/completion/git-completion.bash ]; then
  . /opt/local/share/git/contrib/completion/git-completion.bash
fi

# Calendar Reminder Service

if [ -f ~/calendar.txt ]; then
  calendar -f ~/calendar.txt
fi

source ~/bin/yak.sh
yak-peek
