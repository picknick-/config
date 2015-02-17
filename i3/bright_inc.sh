#!/bin/zsh
xbacklight -inc 10 -time 0
VALUE=`xbacklight -get`
java -jar ~/.i3/notify.jar $VALUE
