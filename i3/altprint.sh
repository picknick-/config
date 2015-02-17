#!/bin/zsh
TIME=`date +"%F %T"`
xwd  | convert xwd:- ~/printScreen/$TIME.png 
