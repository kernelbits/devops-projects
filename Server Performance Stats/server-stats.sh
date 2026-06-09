#!/bin/bash

echo "SYSTEM MONITOR"
echo "---------------"
echo

CPU_USAGE_DATA=$(mpstat 1 1)


CPU_USAGE=$(echo "$CPU_USAGE_DATA" | awk '/all/ {
    gsub(",", ".", $NF)
    print "CPU Usage:", 100 - $NF
}')

echo "$CPU_USAGE"
echo "-------------"
echo

RAM_USAGE=$(echo "$RAM_USAGE_DATA" | awk 'NR==2 {
    total = $2
    used = $3
    free = $4

    printf "Total Ram: %s MB\n", total
    printf "Used Ram: %s MB (%.2f%%)\n", used, (used/total)*100
    printf "Free Ram: %s MB (%.2f%%)\n", free, (free/total)*100
}')

echo "$RAM_USAGE"
echo "-----------"
echo

DISK_USAGE=$(df -h / | awk 'NR==2 {
    printf "Disk Size: %s\n", $2
    printf "Used: %s (%s)\n", $3, $5
    printf "Free: %s\n", $4
}')

echo "$DISK_USAGE"
echo "------------"
echo

TOP_CPU=$(ps -eo comm,%cpu --sort=-%cpu | awk 'NR>=2 && NR<=6 {
    printf "%s (CPU: %s%%)\n", $1, $2
}')

TOP_RAM=$(ps -eo comm,%mem --sort=-%mem | awk 'NR>=2 && NR<=6 {
    printf "%s (RAM: %s%%)\n", $1, $2
}')

echo "TOP CPU PROCESS"
echo "$TOP_CPU"
echo "-----------"
echo

echo "TOP RAM PROCESS"
echo "$TOP_RAM"
