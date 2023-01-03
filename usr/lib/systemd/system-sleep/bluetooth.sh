#!/bin/sh
#https://blog.christophersmart.com/2016/05/11/running-scripts-before-and-after-suspend-with-systemd/

if [ "${1}" == "pre" ]; then
	bluetoothctl show | grep "Powered: yes" > /dev/null 2>&1
	poweredOn=$?
	if [ $poweredOn -eq 0 ]; then
		# It is powered on
		bluetoothctl power off
	fi
	echo $poweredOn > /tmp/bluetoothstatus
elif [ "${1}" == "post" ]; then
	poweredOn=$(cat /tmp/bluetoothstatus)
	if [ $poweredOn -eq 0 ]; then
		# It was powered on
		bluetoothctl power on
	fi
	rm /tmp/bluetoothstatus
fi