#!/bin/bash

# "ping" a server by making a HTTP request once every 1-2 seconds. It waits
# for the server to stop responding, then prints the current time, then waits
# for the server to respond again, then prints the time and quits.

# I wrote this to measure downtime during a reboot against a server that did
# could not respond to ICMP (ping) messages.

URL=$1

CURL_OPTS="--silent --max-time 1 --output /dev/null --fail --head"

echo "Up"
while curl $CURL_OPTS $URL; do
  echo -n .
  sleep 1
done

echo "Down!"
date

while ! curl $CURL_OPTS $URL; do
  echo -n .
  sleep 1
done

echo "Back Up!"
date
