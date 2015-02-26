#!/bin/zsh
TIME=`date +"%F %T"`
xwd -root | convert xwd:- ~/printScreen/$TIME.png 
