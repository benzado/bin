#!/bin/sh

let COLOR_COUNT=`tput colors`
echo "Your terminal ($TERM) supports $COLOR_COUNT colors."

function color_row {
    let START=$1
    let COUNT=$2
    let STEP=$3
    # printf "$(tput setaf 7)"
    for (( i = 0; i < COUNT; ++i )); do
        let COLOR=START+i*STEP
        printf "$(tput setaf $COLOR) %3d " $COLOR
    done
    printf "$(tput sgr0)"
    # printf "$(tput setaf 0)"
    for (( i = 0; i < COUNT; ++i )); do
        let COLOR=START+i*STEP
        printf "$(tput setab $COLOR) %3d " $COLOR
    done
    printf "$(tput sgr0)\n"
}

echo BASIC
color_row  0 8 1

if (( COLOR_COUNT >= 16 )); then
    echo ENHANCED
    color_row  8 8 1
fi

if (( COLOR_COUNT >= 256 )); then

    echo VGA
    let c=16
    while (( c < COLOR_COUNT )); do
        color_row c 6 1
        let c=c+6
    done

    echo "VGA (TRANSPOSED)"
    for i in {16..51}; do
        color_row $i 6 36
    done

fi
