#!/usr/bin/env bash

set_brightness=$1
restore_brightness=''
flag_restore='false'

set_internal() {
    find_brightness=xbacklight -get
    case $find_brightness in
        ""|*[!0-9]*) exit 1 ;;
        $set_brightness) exit 0 ;;
        *)
            xbacklight -set $set_brightness%
            restore_brightness=$find_brightness
            flag_restore="true"
            ;;
    esac
}

restore_internal() {
    [ $flag_restore == "false" ] || exit 0
    xbacklight -set $restore_brightness
    flag_restore="false"
}

set_external() {
    find_brightness=$(sudo ddcutil getvcp 10 -t | tail -n1 | awk '{print $4}')
    case $find_brightness in
        ""|*[!0-9]*) exit 1 ;; # if empty or not a number exit switch
        $set_brightness) exit 0 ;; # if brightness set equals brightness found
        *) 
            sudo ddcutil setvcp 10 $set_brightness
            restore_brightness=$find_brightness
            flag_restore="true"
            ;; 
    esac
}

restore_external() {
    [ $flag_restore == "false" ] && exit 0
    sudo ddcutil setvcp 10 $restore_brightness
    flag_restore="false"
}

A=0 B=0 C=0 D=0 E=0 F=0
[[ $flag_restore == "false" ]] && E=1 || E=0 # ignore
[[ $flag_restore == "true" ]] && F=1 || F=0 # restore brightness

[[ -z $find_chrome_webstore ]] && C=1 || C=0 # chrome webstore not open
[[ -n $find_chrome_webstore ]] && D=1 || D=0 # chrome webstore open


# oh dear, this language might not be able to keep up with what i want
# cause we don't want to block brightness controls, we just want to set it 
# to 40% when we find chrome-webstore open and then restore it to what it was
# previously
# $A = internal, $B = external, $C = found, $D = not found, $E = no restore, $F = restore  
case $A$B$C$D$E$F in
    1****1) echo "check internal monitor for chrome webstore" && restore_internal ;; 
    *1***1) echo "check external monitor for chrome webstore" && restore_internal ;; 
    1*1***) echo "set internal monitor to $1" && set_internal ;; 
    *11***) echo "set external monitor to $1" && set_external ;; 
    1**1*1) echo "restore internal monitor brightness" && restore_internal ;; 
    *1*1*1) echo "restore external monitor brightness" && restore_external ;; 
    *) echo "something went wrong somewhere" && exit 1 ;;
esac

# oh so this is why that dude wouldn't use bash if he had to use an
# if statment and would instead just use a real language...

---
# and this is why we don't design our solutions while coding them like an idiot
# should really get into the habit of using whatever coding language framework
# and tools that we have experience with and can think up their output, so
# we want to just write out umm pseudocode? but like not as stupidly as school tried to 
# so like ignore syntax just try to put concept into code that doesn't have to work
# FIGURE OUT WHERE YOU WANT TO GO BEFORE YOU START CODING

monitor="0"
brightness="0"
set_brightness="40" # what if we were able to change brightness just for the window and not the whole monitor :O
restore_after=false

# arduino format lul
setup(){
    # oh hey we should sync external monitor brightness to laptop's brightness keys
    monitor=$(xrandr --listactivemonitors | grep -m 1 'Monitors:' | awk '{print $2}')
}

loop(){
    if $brightness != $set_brightness {
        if $monitor = 1 {
            $brightness = xbacklight -get 
        } 
        if $monitor = 2 {
            $brightness = ddcutil getvcp 10
        }
    }
    
    webstore=$(wmctrl -l | grep -q "Chrome Web Store.*- Chromium")
    # ~~what if we did this with active-window instead of all windows :O although if still visible but not active we'd be in trouble :/~~
    if $webstore {
        if $monitor = 1 {
            xbacklight -set $set_brightness 
            restore_after = true
        } 
        if $monitor = 2 {
            ddcutil setvcp 10 $set_brightness
            restore_after = true
        }
    } else {
        if restore_after = true {
            restore_after = false
            restore()
        }
    } 
}

restore(){
    if $monitor = 1 {
        xbacklight -set $brightness 
    }
    if $monitor = 2 {
        ddcutil setvcp 10 $brightness
    } 
}


