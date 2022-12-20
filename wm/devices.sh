#!/usr/bin/env bash

run_dmenu() {
    dmenu -i -fn 'JetBrainsMono Nerd Font:style:regular:size=11' -nb '#232634' -nf '#edeff1' -sb '#edeff1' -sf '#232634' -p "$1"
}

show_menu() {
    devices_list="$(lsblk -lp | awk '/part/ {print $1, "(" $4 ")"}')"
    options="$devices_list\n$divider\nexit" 
    chosen="$(echo -e "$options" | run_dmenu "$1")"
   case "$chosen" in
        "" | "$divider" | "exit") echo "No option chosen" ;;
        *) 
            device_path="$(echo "$chosen" | awk -F " " '{print $1}')" 
            device_name="$(echo "$device_path" | awk -F "/dev/" '{print $2}' | awk -F " " '{print $1}' | sed 's/ //')"
            echo "$device_path $device_name"
            show_submenu 
            ;;
    esac
}

show_submenu() {
    options="$device_path\n$divider\nmount\nunmount\nback" 
    chosen="$(echo -e "$options" | run_dmenu "$1")"
    
    case "$chosen" in
        "mount") mount_device ;;
        "unmount") unmount_device ;;
        "back") show_menu ;;
        *) echo "No option chosen" 
    esac
}

mount_device() {
    sudo mkdir -p "/media/$device_name"
    result_message=$(sudo mount "$device_path" "/media/$device_name" 2>&1)
    if [ $? -eq 0 ]; then
        # echo "error output = 0 and is therefore a success"
        output_message="Success, device successfully mounted at /media/$device_name"
    else 
        output_message="Failed to mount device - $result_message"
    fi
    
    options="$output_message $divider\nback\nexit" 
    chosen="$(echo -e "$options" | run_dmenu "$1")"
    case "$chosen" in
        "" | "$divider" | "exit") echo "No option chosen" ;;
        "back") show_submenu ;;
    esac
}

unmount_device() {
    result_message=$(sudo umount "/media/$device_name" 2>&1)
    if [ $? -eq 0 ]; then
        # echo "error output = 0 and is therefore a success"
        output_message="Success, device successfully unmounted from /media/$device_name"
        sudo rm -df "/media/$device_name" # remove an empty directory without prompts
    else 
        output_message="Failed to unmount device - $result_message"
    fi
    
    options="$output_message $divider\nback\nexit" 
    chosen="$(echo -e "$options" | run_dmenu "$1")"
    case "$chosen" in
        "" | "$divider" | "exit") echo "No option chosen" ;;
        "back") show_submenu ;;
    esac
}

divider="---------"
show_menu

