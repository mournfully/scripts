#!/usr/bin/env bash 

run_dmenu() {
    dmenu -i -fn 'JetBrainsMono Nerd Font:style:regular:size=11' -nb '#232634' -nf '#edeff1' -sb '#edeff1' -sf '#232634' -p "$1"
}


reload_sxhkd() {
    result_message=$(pkill -USR1 -x sxhkd)  # reload keyboard shortcuts
    if [ $? -eq 0 ]; then
        # echo "error output = 0 and is therefore a success"
        output_message="Successfully reloaded ~/.config/sxhkd/sxhkdrc"
        sudo rm -df "/media/$device_name" # remove an empty directory without prompts
    else 
        output_message="Failed to reload sxhkd - $result_message"
    fi
    
    options="$output_message $divider\nback\nexit" 
    chosen="$(echo -e "$options" | run_dmenu "$1")"
    case "$chosen" in
        "" | "$divider" | "exit") echo "No option chosen" ;;
        "back") show_menu ;;
    esac
}

reload_statusbar(){
    # kill statusbar script and relaunch
    for pid in $(ps aux | grep "start-statusbar.sh" | grep -i "bash" | awk '{print $2}'); do kill -9 $pid; done
    xsetroot -name ""  # clean statusbar of artificats
    start-statusbar.sh &
}

reload_tmux() {
    result_message=$(tmux source-file ~/.config/tmux/tmux.conf)  # reload tmux config
    if [ $? -eq 0 ]; then
        # echo "error output = 0 and is therefore a success"
        output_message="Successfully reloaded ~/.config/tmux/tmux.conf"
        sudo rm -df "/media/$device_name" # remove an empty directory without prompts
    else 
        output_message="Failed to reload tmux - $result_message"
    fi
    
    options="$output_message $divider\nback\nexit" 
    chosen="$(echo -e "$options" | run_dmenu "$1")"
    case "$chosen" in
        "" | "$divider" | "exit") echo "No option chosen" ;;
        "back") show_menu ;;
    esac
}

reload_dwm() {
    local dwmpid=$(ps aux | grep -i 'dwm' | grep -v 'grep\|start-dwm.sh' | awk '{print $2}')
    # echo $dwmpid
    kill -HUP $dwmpid    
}

show_menu() {
    options="sxhkd\nstatusbar\ntmux\ndwm\n$divider\nexit" 
    chosen="$(echo -e "$options" | run_dmenu "$1")"
    case "$chosen" in
        "sxhkd") reload_sxhkd ;;
        "statusbar") reload_statusbar ;;
        "tmux") reload_tmux ;;
        "dwm") reload_dwm ;;
        *) echo "No option chosen"
    esac
}

divider="---------"
show_menu
