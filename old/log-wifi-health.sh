#!/bin/sh
 
# watch -n1 ./wifi-health 
# https://unix.stackexchange.com/questions/56093/output-of-watch-command-as-a-list/76080#76080
if [[ "$(ping -c 1 8.8.8.8 | grep '100% packet loss' )" != "" ]]; then
    echo "wifi is down - $(date +'%T.%3N %p')" >> wifi.log
    exit 1
else
    echo "wifi is up - $(date +'%T.%3N %p')"
    exit 0
fi
