#!/bin/bash

ipv4=$(ip addr show vpn0 | grep inet | head -n 1 | awk '{print $2}')
ipv6=$(ip addr show vpn0 | grep inet6 | head -n 1 | awk '{print $2}')
echo -e "$ipv4\n$ipv6" > temp.ip 
scp temp.ip yudong.dev:~/SunYD-Arch.ip
rm temp.ip
