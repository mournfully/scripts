#!/usr/bin/env bash

# dmenu alias for youtube
input="$@" 
$BROWSER "https://www.youtube.com/results?search_query=$(echo $input | sed 's/ /+/g')"
