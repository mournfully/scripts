#!/bin/sh

Xephyr -br -ac -reset -screen 1920x1080 :1 &
sleep 1s
export DISPLAY=:1

sxhkd -c $XDG_CONFIG_HOME/sxhkd/sxhkdrc & # hotkey daemon
# exec dwmblocks &
exec dwm & 
wall-d -d $XDG_DATA_HOME/wallpapers-1920x1080/ -f -n
# exec start-statusbar.sh 
