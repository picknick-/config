#!/bin/zsh
amixer -q set Master 2- unmute
VALUE=`amixer get Master`
java -jar ~/.i3/notify.jar ${${VALUE#*\[}%%\%*} 
