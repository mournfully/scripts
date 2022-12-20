#!/bin/sh

pid_array=() && mapfile -t pid_array < <( ps aux | awk '{print $2}' | grep -v "PID")

# https://www.baeldung.com/linux/bash-script-counter
counter=0
for i in ${!pid_array[@]}; do
    # let counter++
    lsof -p ${pid_array[$i]} | grep -i "fonts" | grep -i "JetBrains" 
done

# echo "${pid_array[*]}"
# echo "there is" $counter "id's in the array"
