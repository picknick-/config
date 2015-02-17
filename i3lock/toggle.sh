#!/bin/bash

FLAGFILE="/tmp/xautolock"

if [ -e $FLAGFILE ]; then
    xset dpms
    xautolock -enable
    rm -f $FLAGFILE
    echo "" > /tmp/lockstat 
       
else
    touch $FLAGFILE
    xset -dpms
    xautolock -disable
    echo "" > /tmp/lockstat
fi
i3-msg restart
