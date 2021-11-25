#!/bin/sh

env | sort

URL=$1

function open_in_safari { open -b com.apple.Safari $*; }
function open_in_chrome { open -b org.google.Chrome $*; }

case $URL in

  feed:*)
    open -a Safari "http://www.newsblur.com/?url=$URL"
    ;;

  *hulu.com*)
    open_in_chrome $URL
    ;;

  http:* | https:*)
    if [ $APP_org_google_Chrome == running ]; then
      open_in_chrome $URL
    else
      open_in_safari $URL
    fi
    ;;

  *)
    echo "Unexpected URL scheme: $URL"
    exit 1
    ;;

esac
exit 0
