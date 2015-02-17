#!/bin/bash

finish() {
    rm -f "$TMP"
    rm -f "/tmp/i3lock-scrot.lock"
    exit
}; trap finish EXIT INT TERM
TMP=`mktemp -t i3lock.XXXXXX.png --tmpdir=/tmp`

xwd -root | /home/mszulc1/pngblur/pngblur - $TMP 15
i3lock "$@" -i $TMP
