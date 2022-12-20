#!/usr/bin/env bash

# commands for restarting status-bar to test changes
# sudo kill -9 $(ps aux | grep /data/dwm/status-bar | grep -v grep | awk '{print $2}')
# exec /data/dwm/status-bar &

# load colors:
col_white=#edeff1
col_rosewater=#f2d5cf
col_flamingo=#eebebe
col_pink=#f4b8e4
col_mauve=#ca9ee6
col_red=#e78284
col_maroon=#ea999c
# col_peach=#ef9f76
# col_yellow=#e5c890
# col_green=#a6d189
col_teal=#81c8be
col_sky=#99d1db
col_sapphire=#85c1dc
col_blue=#8caaee
col_lavender=#babbf1
# col_text=#c6d0f5
# col_subtext1=#b5bfe2
# col_subtext0=#a5adce
# col_overlay2=#949cbb
# col_overlay1=#838ba7
# col_overlay0=#737994
# col_surface2=#626880
# col_surface1=#51576d
# col_surface0=#414559
# col_base=#303446
# col_mantle=#292c3c
# col_crust=#232634

base=$col_white

col_weather_unknown=$col_white
col_weather=$col_teal

# col_network_download=$col_sky
# col_network_upload=$col_teal

col_internet_wifi=$col_sapphire
col_internet_wifi_down=$col_red
col_internet_wifi_off=$col_maroon
col_internet_ethernet=$col_lavender
col_internet_ethernet_down=$col_red
col_internet_vpn=$col_blue 

col_volume_airpods=$col_blue
col_volume_high=$col_lavender
col_volume_medium=$col_lavender
col_volume_low=$col_lavender
col_volume_mute=$col_red
col_volume_unknown=$col_white

col_brightness=$col_mauve

col_battery_full=$col_pink
col_battery_discharging=$col_pink
col_battery_charging=$col_pink
col_battery_not_charging=$col_red
col_battery_unknown=$col_white

col_timestamp_time=$col_flamingo
col_timestamp_date=$col_rosewater

weather() {
  # https://www.youtube.com/watch?v=arLQA52Ieik
  # https://github.com/LukeSmithxyz/voidrice/blob/master/.local/bin/statusbar/sb-forecast
  # Print todays weather condition and temperature and an appropriate icon
  # If we have internet, get a weather report from wttr.in and store it locally, and add a timestamp
  LOCATION="whitchurch-stouffville" # if not set, use ip address instead
  FORMAT="%c+%C+%t\n"
  weatherreport="${XDG_CACHE_HOME:-$HOME/.cache}/weatherreport"
  getforecast() { 
    # weather condition textual name and actual temperature 
    # echo "fetching weather data..."
    curl -sf "wttr.in/$LOCATION?format=$FORMAT" > "$weatherreport" || exit 1 ;

    # echo "replacing original icon with material-design-icon..."
    case "$(awk 'NR==1 {print $1}' "${weatherreport}" 2>&1)" in
      "✨") sed -i 's/✨/󰋗/' $weatherreport ;; # Unknown
      "☁️") sed -i 's/☁️/󰖐/' $weatherreport ;; # Cloudy
      "🌫") sed -i 's/🌫/󰖑/' $weatherreport ;; # Fog
      "🌧") sed -i 's/🌧/󰖖/' $weatherreport ;; # HeavyRain
      "🌧") sed -i 's/🌧/󰖖/' $weatherreport ;; # HeavyShowers
      "❄️") sed -i 's/❄️/󰼶/' $weatherreport ;; # HeavySnow
      "❄️") sed -i 's/❄️/󰙿/' $weatherreport ;; # HeavySnowShowers
      "🌦") sed -i 's/🌦/󰼳/' $weatherreport ;; # LightRain
      "🌦") sed -i 's/🌦/󰼳/' $weatherreport ;; # LightShowers
      "🌧") sed -i 's/🌧/󰼵/' $weatherreport ;; # LightSleet
      "🌧") sed -i 's/🌧/󰼵/' $weatherreport ;; # LightSleetShowers
      "🌨") sed -i 's/🌨/󰼴/' $weatherreport ;; # LightSnow
      "🌨") sed -i 's/🌨/󰼴/' $weatherreport ;; # LightSnowShowers
      "⛅️") sed -i 's/⛅️/󰖕/' $weatherreport ;; # PartlyCloudy
      "☀️") sed -i 's/☀️/󰖙/' $weatherreport ;; # Sunny
      "🌩") sed -i 's/🌩/󰖓/' $weatherreport ;; # ThunderyHeavyRain
      "⛈") sed -i 's/⛈/󰙾/' $weatherreport ;; # ThunderyShowers
      "⛈") sed -i 's/⛈/󰙾/' $weatherreport ;; # ThunderySnowShowers
      "☁️") sed -i 's/☁️/󰖐/' $weatherreport ;; # VeryCloudy
    esac
    # echo "end of function getforecast()"
  }

  showweather() {
    if [[ -e $weatherreport ]]; then 
      # echo "cache file found"

      if [[ -z $(grep '[^[:space:]]' $weatherreport) ]] ; then
        # echo "cache file is empty"
        getforecast
      fi        

      current_system_time="$(date +%s)"
      file_created_time="$(stat -c %Y "$weatherreport")"
      file_age=$(echo $(( current_system_time - file_created_time )))
      if [[ $file_age -gt 1800 ]]; then 
        # echo "cache file is more than 30 minutes old"
        getforecast
      fi
    
    else 
      # echo "no cache file found"
      getforecast
    fi
    case "$(awk 'NR==1 {print $1}' "${weatherreport}" 2>&1)" in
        "󰋗") icon_colour="^c$col_weather_unknown^ " ;; # Unknown
        *) icon_colour="^c$col_weather^" ;; 
    esac
    icon=$(awk '{print $1}' $weatherreport)
    val_weather=$(awk '{sub($1 FS,"")}7' $weatherreport | sed 's/ //')

    printf "%s%s ^c$base^%s\n" "$icon_colour" "$icon" "$val_weather"
    # echo "end of function showweather()"
  }
  showweather 
}

# network_traffic() {
#   # https://github.com/LukeSmithxyz/voidrice/tree/master/.local/bin/statusbar
#   # Module showing network traffic. Shows how much data has been received (RX) or
#   # transmitted (TX) since the previous time this script ran. So if run every
#   # second, gives network traffic per second.
# 
#   update() {
#     sum=0
#     for arg; do
#         read -r i < "$arg"
#         sum=$(( sum + i ))
#     done
#     cache=/tmp/${1##*/}
#     [ -f "$cache" ] && read -r old < "$cache" || old=0
#     printf %d\\n "$sum" > "$cache"
#     printf %d\\n $(( sum - old ))
#   }
# 
#     rx=$(update /sys/class/net/[ewm]*/statistics/rx_bytes)
#     tx=$(update /sys/class/net/[ewm]*/statistics/tx_bytes)
#  printf "^c$col_network_download^󰄠 ^c$base^%4sB ^c$base^| ^c$col_network_upload^󰄝^c$base^ %4sB" "$(numfmt --to=iec $rx)" "$(numfmt --to=iec $tx)"
# }

# when we migrate to dwmblocks async - perhaps we should show network_traffic() on hover?
network() {
  # https://github.com/LukeSmithxyz/voidrice/tree/master/.local/bin/statusbar
  # Show wifi 󰤨 and percent strength or 󰤭 if none.
  # Show 󰈁 if connected to ethernet or 󰈂 if none.
  # Show 󰌆 if a vpn connection is active

  if grep -xq 'up' /sys/class/net/[wm]*/operstate 2>/dev/null ; then
    # measure wifi strength
    # https://stackoverflow.com/questions/53416728/iwconfig-proc-net-wireless-does-not-exist
    # https://unix.stackexchange.com/questions/407775/how-is-proc-net-wireless-a-clone-of-proc-net-dev
   
    case "$(ip -br l | awk '$1 !~ "lo|vir|xnet|vmnet,vboxnet|virbr|ifb|docker|veth|eth|wlan|vnet" {print $1}')" in
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

volume() {
  # https://github.com/LukeSmithxyz/voidrice/tree/master/.local/bin/statusbar
  # Prints the current volume or 󰖁 if muted.

  if [[ "$(pamixer --get-mute)" = "true" ]]; then
    # $(amixer sget master | awk -f\"[][]\" '/%/' | head -n1 | awk '{print $6}')" = "[off]"
    icon="󰖁"
    printf "^c$col_volume_mute^%s" "$icon"
  else
    val_volume="$(pamixer --get-volume)"  
    # "$(amixer sget Master | awk -F\"[][]\" '/%/' | head -n1 | awk '{print $5}' | sed 's/[[]//g' | sed 's/%]//g')"  

    if [[ "$val_volume" -gt "70" ]]; then 
      icon="^c$col_volume_high^󰕾";
    elif [[ "$val_volume" -gt "30" ]]; then 
      icon="^c$col_volume_medium^󰖀";
    elif [[ "$val_volume" -gt "0" ]]; then 
      icon="^c$col_volume_low^󰕿";
    else 
      icon="^c$col_volume_unknown^󰋗";
    fi

    current_sink="$(pactl info | sed -En 's/Default Sink: (.*)/\1/p')" 
    case $current_sink in
        "bluez_output.9C_28_B3_91_5C_DA.a2dp-sink") new_icon="^c$col_volume_airpods^󰂰" ;;
        *) new_icon="${icon}"
    esac
    
    printf "^c$base^%s ^c$base^%s%%" "$new_icon" "$val_volume"
  fi
} 

# brightness() {
#   val_brightness=$(echo $(( 100 * $(cat /sys/class/backlight/*/brightness) / $(cat /sys/class/backlight/*/max_brightness))))
#   printf "^c$col_brightness^󰖨  ^c$base^%s%%" "$val_brightness"    
# }

battery() {
  # https://github.com/LukeSmithxyz/voidrice/tree/master/.local/bin/statusbar
  # Prints all batteries, their percentage remaining and an emoji corresponding
  # to charge status ( for plugged in, 󰁿 for discharging on battery, etc.).

  # Loop through all attached batteries and format the info
  for battery in /sys/class/power_supply/BAT?*; do
    # If non-first battery, print a space separator.
    [ -n "${val_battery+x}" ] && printf " "
    # Sets up the status and capacity
    case "$(cat "$battery/status" 2>&1)" in
      "Full") status="^c$col_battery_full^󰂄" ;;
      "Discharging") status="^c$col_battery_discharging^󰁿" ;;
      "Charging") status="^c$col_battery_charging^󰚥" ;;
      "Not charging") status="^c$col_battery_not_charging^󰅜" ;;
      "Unknown") status="^c$col_battery_unknown^󰋗" ;;
      *) exit 1 ;;
    esac

    val_battery="$(cat "$battery/capacity" 2>&1)"
    # Will set variable to warn if discharging and low
    [ "$status" = "^c$yellow^󰁿" ] && [ "$val_battery" -le 25 ] && status="^c$col_battery_low_warning^󰂃"
    # Prints the info
    printf "^c$base^%s ^c$base^%s%%" "$status" "$val_battery"
  done && printf "\\n"
}

sb-date() {
  # Prints out time and date - https://devhints.io/datetime
  printf "^c$col_timestamp_date^󰃭 ^c$base^%s" "$(date '+%a %e %b %Y')" # Thu 13 May 2021
}

sb-time() {
    printf "^c$col_timestamp_time^󰥔 ^c$base^%s" "$(date '+%I:%M:%S %p %Z')" # 01:01 AM EDT
}

while true; do
    sleep 1 
    output="$(echo "             | $(weather) | $(network) | $(volume) | $(battery) | $(sb-date) | $(sb-time) " | sed "s/ | / ^c$base^| /g")"
    xsetroot -name "$output"
done
