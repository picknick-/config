#!/bin/bash

FLAGFILE="/tmp/hdmi"

if [ -e $FLAGFILE ]; then
    rm $FLAGFILE
    xrandr --output HDMI1 --mode 1920x1080 --rate 60
else
    touch $FLAGFILE
    xrandr --output HDMI1 --off
fi
