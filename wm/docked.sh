#!/usr/bin/env bash

# setup external monitor as primary
xrandr --output eDP-1 --mode 2256x1504 --pos 1920x0 --rotate normal --output DP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-1 --off --output DP-2 --off --output HDMI-2 --off

# slow down mouse input to a usable level
xinput --set-prop $(xinput --list --short | grep -m 1 'Glorious Model O' | awk '{print $6}' | sed 's/id=//') "Coordinate Transformation Matrix" 0.6 0 0 0 0.6 0 0 0 2

# speed up repeat-key-delay (in milliseconds w/ default 660) and repeat rate (w/ default 25) on keyboard
xset r rate 200 25 
 
# set wallpapers for both displays
wall-d -d $XDG_DATA_HOME/wallpapers-1920x1080/ -f -n

