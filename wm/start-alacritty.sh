#!/usr/bin/env bash

# change font size if there is an external monitor
monitor=$(xrandr --listactivemonitors | grep -m 1 'Monitors:' | awk '{print $2}')
# echo $monitor

case "$monitor" in
    "") echo "No option chosen" ;;
    "1") font_size="5.0" ;;
    "2") font_size="11.0" ;;
esac
# echo $font_size

$TERMINAL --working-directory /home/local/ -o font.size=$font_size -e tmux 
