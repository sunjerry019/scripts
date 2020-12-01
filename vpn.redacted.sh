#!/bin/bash

# https://confluence.jaytaala.com/display/TKB/Continuous+connection+to+Cisco+AnyConnect+VPN+with+linux+Openconnect

OPENCONNECT_PID=""
RUNNING=""

function checkOpenconnect {
    ps -p $OPENCONNECT_PID &> /dev/null
    RUNNING=$?
    update-lrz.sh
    #echo $RUNNING &>> reconnect.log
}

function startOpenConnect {
    # start here open connect with your params and grab its pid
    echo "<REDACTED>" | sudo openconnect --protocol=anyconnect --user=ru27xew --authgroup="AnyConnect+IPv6" --passwd-on-stdin asa-cluster.lrz.de & OPENCONNECT_PID=$!
}

function exit_script {
	# Clear the lock
	rm /home/sunyudong/.lrzlock

    trap - SIGINT SIGTERM # clear the trap
    kill -- -$$ # Sends SIGTERM to child/sub processes
}

trap exit_script SIGINT SIGTERM

# Make a lock
touch /home/sunyudong/.lrzlock && chown sunyudong:sunyudong /home/sunyudong/.lrzlock

startOpenConnect

while true
do
    # sleep a bit of time
    sleep 10
    checkOpenconnect
    [ $RUNNING -ne 0 ] && startOpenConnect
done
