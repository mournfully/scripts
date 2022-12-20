#!/usr/bin/env bash

# launch wallpaper-selector and set it to use 1920x1080 wallpapers 
# https://github.com/ronniedroid/Wall-d
monitor=$(xrandr --listactivemonitors | grep -m 1 'Monitors:' | awk '{print $2}')

case $monitor in 
    "1") wall-d -d $XDG_DATA_HOME/wallpapers-2256x1504/ -f ;;
    "2") wall-d -d $XDG_DATA_HOME/wallpapers-1920x1080/ -f ;;
    *) echo "something went wrong with the launch.wallpapers script"
esac
