#!/usr/bin/env bash

col_white=#edeff1
col_sapphire=#85c1dc
col_red=#e78284
col_maroon=#ea999c
col_lavender=#babbf1
col_blue=#8caaee

base=$col_white
col_internet_wifi=$col_sapphire
col_internet_wifi_down=$col_red
col_internet_wifi_off=$col_maroon
col_internet_ethernet=$col_lavender
col_internet_ethernet_down=$col_red
col_internet_vpn=$col_blue 

network() {
  # https://github.com/LukeSmithxyz/voidrice/tree/master/.local/bin/statusbar
  # Show wifi 󰤨 and percent strength or 󰤭 if none.
  # Show 󰈁 if connected to ethernet or 󰈂 if none.
  # Show 󰌆 if a vpn connection is active

  if grep -xq 'up' /sys/class/net/[wm]*/operstate 2>/dev/null ; then
    # echo "network up"
    # measure wifi strength
    # https://stackoverflow.com/questions/53416728/iwconfig-proc-net-wireless-does-not-exist
    # https://unix.stackexchange.com/questions/407775/how-is-proc-net-wireless-a-clone-of-proc-net-dev
    case "$(ip -br l | awk '$1 !~ "lo|vir" { print $1}')" in
        "mlan0") val_internet="$(awk '/^\s*w*m/ {print int($3 * 100 / 70)}' /proc/net/wireless)" ;;
        "wlp2s0") val_internet="$(awk '/^\s*w/ {print int($3 * 100 / 70)}' /proc/net/wireless)" ;;
        *) echo "unknown network interface name"    
    esac


    icon="^c$col_internet_wifi^󰤨"
  elif grep -xq 'down' /sys/class/net/[wm]*/operstate 2>/dev/null ; then
    grep -xq '0x1003' /sys/class/net/[wm]*/flags && icon="^c$col_internet_wifi_down^󰤭" || icon="^c$col_internet_wifi_off^󰀝"
  fi

  printf "%s ^c$base^%s%%%s%s" "$icon" "$val_internet" "$(sed "s/down/[^c$col_internet_ethernet_down^󰈂]/;s/up/[^c$col_internet_ethernet^󰈁]/" /sys/class/net/e*/operstate 2>/dev/null)" "$(sed "s/.*/[^c$col_internet_vpn^󰌆]/" /sys/class/net/tun*/operstate 2>/dev/null)"
}

while true; do
    sleep 1 && xsetroot -name "| $(network) " 
done
