#!/bin/bash                                                                      
 
sleep 0.1
scrot /tmp/screen.png
convert /tmp/screen.png -set colorspace Gray -separate -average /tmp/screen.png
 
if [[ -f $HOME/.config/screen-locker/screen-lock.png ]]
then
    # placement x/y
    PX=0
    PY=0
    # lockscreen image info
    R=$(file $HOME/.config/screen-locker/screen-lock.png -L | grep -o '[0-9]* x [0-9]*')
    RX=$(echo $R | cut -d' ' -f 1)
    RY=$(echo $R | cut -d' ' -f 3)
 
    SR=$(xrandr --query | grep ' connected' | sed 's/primary //' | cut -f3 -d' ')
    for RES in $SR
    do
        # monitor position/offset
        SRX=$(echo $RES | cut -d'x' -f 1)                   # x pos
        SRY=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 1)  # y pos
        SROX=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 2) # x offset
        SROY=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 3) # y offset
        PX=$(($SROX + $SRX/2 - $RX/2))
        PY=$(($SROY + $SRY/2 - $RY/2))
 
        convert /tmp/screen.png $HOME/.config/screen-locker/screen-lock.png -geometry +$PX+$PY -composite -matte  /tmp/screen.png
    done
fi
i3lock -n -i /tmp/screen.png -e -f -S=0
# i3lock -e -n -f -i /tmp/screen.png
