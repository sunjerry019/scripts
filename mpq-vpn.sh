#!/bin/bash

# https://confluence.jaytaala.com/display/TKB/Continuous+connection+to+Cisco+AnyConnect+VPN+with+linux+Openconnect

OPENCONNECT_PID=""
RUNNING=""

function checkOpenconnect {
    ps -p $OPENCONNECT_PID &> /dev/null
    RUNNING=$?
}

function startOpenConnect {
    # start here open connect with your params and grab its pid
    echo "27oskx7pbh" | sudo openconnect --protocol=anyconnect --user=suny --authgroup="AllUsers" --passwd-on-stdin vpn.mpcdf.mpg.de & OPENCONNECT_PID=$!
}

function exit_script {
	# Clear the lock
	rm /home/sunyudong/.mpqlock

    trap - SIGINT SIGTERM # clear the trap
    kill -- -$$ # Sends SIGTERM to child/sub processes
}

trap exit_script SIGINT SIGTERM

# Make a lock
touch /home/sunyudong/.mpqlock && chown sunyudong:sunyudong /home/sunyudong/.mpqlock

startOpenConnect

while true
do
    # sleep a bit of time
    sleep 10
    checkOpenconnect
    [ $RUNNING -ne 0 ] && startOpenConnect
done
