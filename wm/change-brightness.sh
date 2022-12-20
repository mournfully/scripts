#!/usr/bin/env bash
# https://github.com/ericmurphyxyz/dotfiles/blob/master/.local/bin/changebrightness

function send_notification() {
	brightness=$(printf "%.0f\n" "$(brillo -G)")
	dunstify -a "changebrightness" -u low -r 9991 -h int:value:"$brightness" -i "brightness-$1" "Brightness: $brightness%" -t 2000
}

case $1 in
up)
	brillo -e -A 2
	send_notification "$1" 
	;;
down)
	brillo -e -U 2 
	send_notification "$1"    
	;;
esac

# What each of the brillo flags mean:
# -G:  Get brightness value (default)
# -A VALUE: Increment brightness by given value
# -U VALUE: Decrement brightness by given value
# -e:  Operate on every controller available
# -q:  Exponential percentages

