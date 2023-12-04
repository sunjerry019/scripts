# Battery, run as root
cpupower frequency-set -g powersave
seq 4 15 | xargs -I {} sh -c "echo '0' > /sys/devices/system/cpu/cpu{}/online"

# plugged in, run as root
seq 4 15 | xargs -I {} sh -c "echo '1' > /sys/devices/system/cpu/cpu{}/online"
cpupower frequency-set -g schedutil