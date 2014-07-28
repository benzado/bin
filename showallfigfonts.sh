#!/bin/sh

# Like `showfigfonts`, but recursively searches subdirectories. This way I can
# drop in the `contributed` fonts folder without mixing it in with the stock
# figlet fonts.

FONT_ROOT=`figlet -I2`

if [ -z $1 ]; then
    SAMPLE='{}'
else
    SAMPLE=$1
fi

find $FONT_ROOT -name '*.[tf]lf' -print -execdir figlet -f '{}' $SAMPLE ';'
