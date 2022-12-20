#!/usr/bin/env bash
 
# setup internal monitor as primary and shutdown display port
xrandr --output eDP-1 --primary --mode 2256x1504 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output HDMI-2 --off

# slow down mouse input to a usable level
xinput --set-prop $(xinput --list --short | grep -m 1 'Glorious Model O' | awk '{print $6}' | sed 's/id=//') "Coordinate Transformation Matrix" 0.6 0 0 0 0.6 0 0 0 2

xset r rate 200 25 # speed up repeat-key-delay from 660ms and keep repeat rate at 25s 

wall-d -d $XDG_DATA_HOME/wallpapers-2256x1504/ -f -n # set a random wallpaper

