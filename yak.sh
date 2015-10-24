#!/bin/sh

# Experimental To Do List thing: when you're doing something, then you need to
# stop and do something else, use yak-push to remember what it was you were
# doing, and yak-pop when you are done with the other thing.

# Plumbing

function yak-stack-path {
  local STACK=$HOME/.yak-stack
  if [ ! -e $STACK ]; then
    touch $STACK
  fi
  echo $STACK
}

function yak-history-path {
  echo $HOME/.yak-history
}

function yak-timestamp {
  date "+%l:%M%p %a %e-%b-%Y"
}

function yak-history-append {
  printf "%s (pushed: %s; popped: %s)\n" "$1" "$2" "$3"  >> $(yak-history-path)
}


# Porcelain

function yak-help {
  cat <<END_YAK_HELP
yak-push SOMETHING : pushes SOMETHING on the stack, so that yak can remember
                     it before you switch to doing something else
yak-list           : displays everything on the stack
yak-peek           : displays the top item item on the stack (what you were
                     doing before you were interrupted)
yak-pop            : pops the top item off the stack (your interruption is
                     over) and saves it in your history
yak-history        : displays everything in the history
yak-help           : display this message
END_YAK_HELP
}

function yak-push {
  if [ -z "$1" ]; then
    echo "example: yak-push researching cologne for yaks"
    return 1
  fi
  printf "%s: %s\n" "$(yak-timestamp)" "$*" >> $(yak-stack-path)
  echo "yak: Remembered!"
}

function yak-list {
  cat $(yak-stack-path)
}

function yak-peek {
  local STACK=$(yak-stack-path)
  local TOP=$(tail -n 1 $STACK)
  if [ -z "$TOP" ]; then
    echo "yak: stack is empty!"
    return 0
  fi
  echo "yak: top is $TOP"
}

function yak-pop {
  local STACK=$(yak-stack-path)
  local TEMP_STACK=$(mktemp -t yak-stack)
  local TOP=$(tail -n 1 "$STACK")

  if [ -z "$TOP" ]; then
    echo "yak: stack is empty!"
    return 0
  fi

  WHAT="${TOP/*: /}"
  PUSH_TIME="${TOP/: */}"
  POP_TIME=$(yak-timestamp)

  if sed '$ d' $STACK > $TEMP_STACK; then
    mv $TEMP_STACK $STACK
    yak-history-append "$WHAT" "$PUSH_TIME" "$POP_TIME"
    echo "yak: popped $TOP"
    yak-peek
  else
    echo 'yak: problem :-('
    return 1
  fi
}

function yak-history {
  cat $(yak-history-path)
}
