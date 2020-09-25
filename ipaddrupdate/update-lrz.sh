#!/bin/bash

if ! ip link show tun0; then
	# Interface does not exist
	exit 1
fi

operstate=$(cat /sys/class/net/tun0/operstate)
if [[ $operstate == "down" ]]; then
	# Interface is down and not connected
	exit 1
fi

ipv4=$(ip addr show tun0 | grep inet | head -n 1 | awk '{print $2}')
ipv6=$(ip addr show tun0 | grep inet6 | head -n 1 | awk '{print $2}')
echo -e "$ipv4\n$ipv6" > ~/temp.ip
scp -i ~/.ssh/dev_ed25519 ~/temp.ip yudong@ssh.yudong.dev:~/SunYD-Arch.ip
rm ~/temp.ip
