#!/bin/sh
#https://blog.christophersmart.com/2016/05/11/running-scripts-before-and-after-suspend-with-systemd/
if [ "${1}" == "post" ]; then
	# autorandr --config | grep transform > /dev/null 2>&1
	# scaled=$?
	# echo $scaled > /tmp/scaled
	# if [ $scaled -eq 0 ]; then
	# 	# the display was scaled
	# 	autorandr --change
	# fi
	sh -c "sleep 5; autorandr --change" &
fi