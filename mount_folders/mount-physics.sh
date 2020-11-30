#!/bin/bash

sudo mount -t cifs //z-sv-dfsroot.ad.physik.uni-muenchen.de/dfsextern/homes/Yudong.Sun /mnt/physikhome/ -o noperm,credentials=/home/sunyudong/.creds/.smbcredentials
