#!/bin/bash

# echo -e "CPU\t" $(sensors | grep PPT | awk '{print $2 " W"}')
# echo -e "GPU\t" $(nvidia-smi | tail -n +2 | grep W | awk '{print $5}' | sed "s/W/ W/g")
# echo -e "Batt\t" $(awk '{print $1*10^-6 " W"}' /sys/class/power_supply/BAT0/power_now)

# Capture CPU power and display
cpu=$(sensors | grep PPT | awk '{print $2}')
echo -e "CPU\t$cpu W"

# Capture GPU power and display
gpu=$(nvidia-smi | tail -n +2 | grep W | awk '{print $5}' | sed 's/W//')
echo -e "GPU\t$gpu W"

# Capture Battery power and display
batt=$(awk '{print $1*10^-6}' /sys/class/power_supply/BAT0/power_now)
echo -e "Batt\t$batt W"

# Calculate total power and display with two decimal places
total=$(echo "$cpu + $gpu + $batt" | bc)
echo ""
printf "Total\t%.2f W\n" "$total"
