#!/bin/bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi
# https://stackoverflow.com/a/21622456

if [ "$1" = "on" ]; then
    echo "2" > /sys/devices/platform/asus-nb-wmi/hwmon/hwmon5/pwm1_enable
	echo "0" > /sys/devices/platform/asus-nb-wmi/hwmon/hwmon5/pwm1_enable

	echo "2" > /sys/devices/platform/asus-nb-wmi/hwmon/hwmon5/pwm2_enable
	echo "0" > /sys/devices/platform/asus-nb-wmi/hwmon/hwmon5/pwm2_enable
elif [ "$1" = "off" ]; then
	echo "0" > /sys/devices/platform/asus-nb-wmi/hwmon/hwmon5/pwm1_enable
	echo "2" > /sys/devices/platform/asus-nb-wmi/hwmon/hwmon5/pwm1_enable

	echo "0" > /sys/devices/platform/asus-nb-wmi/hwmon/hwmon5/pwm2_enable
	echo "2" > /sys/devices/platform/asus-nb-wmi/hwmon/hwmon5/pwm2_enable
else
    echo "Enter option 'on' or 'off'"
fi


