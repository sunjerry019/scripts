#!/bin/sh
#https://blog.christophersmart.com/2016/05/11/running-scripts-before-and-after-suspend-with-systemd/

if [ "${1}" == "pre" ]; then
	bluetoothctl show | grep "Powered: yes" > /dev/null 2>&1
	poweredOn=$?
	if [ $poweredOn -eq 0 ]; then
		# It is powered on
		# we get any connected devices
		# bluetoothctl devices Connected | awk '{ print $2 }' > /tmp/connectedBTDevices
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

	# if [[ -f /tmp/connectedBTDevices ]]; then
	#     cat /tmp/connectedBTDevices | xargs -I {} bluetoothctl connect {}
	#     rm /tmp/connectedBTDevices
	# fi
fi