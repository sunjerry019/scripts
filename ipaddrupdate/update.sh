#!/bin/bash

ip addr show tun0 | grep inet | head -n 1 | awk '{print $2}' > temp.ip
scp -P 2022 temp.ip arch.yudong.dev:~/SunYD-Arch.ip
rm temp.ip
