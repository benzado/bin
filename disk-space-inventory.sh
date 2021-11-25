#!/bin/sh

AVAIL=$(df -h / | ruby -ne 'print $_.split[3]')
TIMESTAMP=$(date +%Y%m%d-%H%M)
FILENAME=$HOME/Disk-Usage-${TIMESTAMP}-${AVAIL}.txt.gz

echo Gonna write to $FILENAME
sudo du -h -d 3 / | gzip -c > $FILENAME
