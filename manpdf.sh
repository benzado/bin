#!/bin/sh

# manpdf.sh
# Benjamin Ragheb <ben@benzado.com>

# This script is a wrapper around `man` which creates PDF files from manual
# pages and then opens them in your default PDF viewer. It caches the PDF
# in a specified directory and automatically deletes if they haven't been
# touched in a while.

PDF_CACHE_ROOT=$HOME/Library/Caches/com.benzado.manpdf.sh
PDF_CACHE_DELETE_AFTER=1w

# If invoked with no arguments, prompt the user for more information.
if [ -z $* ]; then
    echo "What manual page do you want (to open in PDF format)?"
    if [ -d $PDF_CACHE_ROOT ]; then
        echo "- Cached: \c"; du -h -s $PDF_CACHE_ROOT
    fi
    exit
fi

MANUAL_PAGE_PATH=`man --path $*`
if [ -z $MANUAL_PAGE_PATH ]; then
    exit $?
fi

PDF_PATH=${PDF_CACHE_ROOT}${MANUAL_PAGE_PATH}.pdf

# If we have an up-to-date cached PDF, touch it, otherwise generate one.

if [ $PDF_PATH -nt $MANUAL_PAGE_PATH ]; then
    touch $PDF_PATH # so it survives the cache cleanup
else
    echo "Creating PDF for ${MANUAL_PAGE_PATH}..."
    mkdir -p `dirname $PDF_PATH`
    man -t $* | pstopdf -i -o $PDF_PATH
fi

open $PDF_PATH

# Delete cached PDF files that haven't been touched in a while. I haven't found
# confirmation whether Mac OS X will do this automatically.

find $PDF_CACHE_ROOT -name '*.pdf' -mtime +$PDF_CACHE_DELETE_AFTER -delete
