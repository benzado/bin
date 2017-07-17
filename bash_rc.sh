# If this is a top-level shell, customize the environment. Otherwise,
# let inheritance do its thing.

if [ $SHLVL -eq 1 ]; then
    source ~/bin/bash_environment.sh
fi

# Append to (don't overwite) the history file on shell exit

shopt -s histappend

# Bind up/down arrow keys to search history matching up to the cursor

bind '"\e[A"':history-search-backward
bind '"\e[B"':history-search-forward

# Useful aliases

alias ..='cd ..'
alias bx='bundle exec'
alias con='tail -40 -f /var/log/system.log'
alias gdc='git --no-pager diff --cached'
alias grep='grep --color=auto'
alias gs='git status'
alias httpserver='python -m SimpleHTTPServer'
alias jsonlint='python -m json.tool'
alias ll='ls -lhO'
alias ls='ls -hO'
alias manp='~/bin/manpdf.sh'
alias pbsort='pbpaste | sort | pbcopy'
alias plisttoxml='plutil -convert xml1 -o -'
alias plisttojson='plutil -convert json -r -o -'
alias shuf=gshuf
alias optipngall='ls -1 *.png | parallel optipng -o7'

# Useful functions

function dotpdf {
  dot -Tpdf -o ${1%.dot}.pdf ${1}
}

function dotpng {
  dot -Tpng -o ${1%.dot}.png ${1}
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

for script in /opt/local/etc/bash_completion.d/*; do
    source $script
done

# Git completions

if [ -f /opt/local/share/git/contrib/completion/git-completion.bash ]; then
  . /opt/local/share/git/contrib/completion/git-completion.bash
fi
