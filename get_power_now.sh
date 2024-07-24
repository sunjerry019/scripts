#!/bin/bash

echo -e "CPU\t" $(sensors | grep PPT | awk '{print $2 " W"}')
echo -e "GPU\t" $(nvidia-smi | tail -n +2 | grep W | awk '{print $5}' | sed "s/W/ W/g")
echo -e "Batt\t" $(awk '{print $1*10^-6 " W"}' /sys/class/power_supply/BAT0/power_now)
