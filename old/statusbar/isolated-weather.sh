#!/bin/bash

# commands for restarting status-bar to test changes
# sudo kill -9 $(ps aux | grep /data/dwm/status-bar | grep -v grep | awk '{print $2}')
# exec /data/dwm/status-bar &

# load colors:
col_white=#edeff1
col_green=#a6d189

base=$col_white
col_weather_unknown=$col_white
col_weather=$col_green

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
      *) echo "either there was an error or icon was already replaced"
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

    printf "%s%s ^c$base^%s \n" "$icon_colour" "$icon" "$val_weather"
    # echo "end of function showweather()"
  }
  showweather 
}

while true; do
    sleep 1 && xsetroot -name "| $(weather) " 
done
