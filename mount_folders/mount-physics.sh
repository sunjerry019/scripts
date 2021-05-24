#!/bin/bash

sudo mount -t cifs //z-sv-dfsroot.ad.physik.uni-muenchen.de/dfsextern/homes/Yudong.Sun /mnt/lrz/cip-home/ -o noperm,credentials=/home/sunyudong/.creds/.smbcredentials,uid=$(id -u),gid=$(id -g)

sudo mount -t cifs //z-sv-dfsroot.ad.physik.uni-muenchen.de/dfsextern/project/ag-pronin /mnt/lrz/ag-pronin/ -o noperm,credentials=/home/sunyudong/.creds/.smbcredentials,uid=$(id -u),gid=$(id -g)

# sudo mount -t cifs //z-sv-dfsroot.ad.physik.uni-muenchen.de/dfsextern/ /mnt/lrz/dfsextern/ -o noperm,credentials=/home/sunyudong/.creds/.smbcredentials,uid=$(id -u),gid=$(id -g)
