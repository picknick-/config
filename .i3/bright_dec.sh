#!/bin/zsh
xbacklight -dec 10 -time 1
VALUE=`xbacklight -get`
    java -jar ~/.i3/notify.jar $VALUE
